/* global $, document, console, createDataGridInstance, createPanel, parseUrl, GLOBAL_JSON, headerTemplate, loadJsonFile, updateUrlHash, getPageTemplate, hitsRenderer, urlParams, pageName, queryUrlParamsByPrefix, isValueAboveThreshold, isValueBelowThreshold, isValueInRange, isValueUndefined, isValueNa, isTogglesExtendedValueExcluded */
/* exported processScopesDbFile, processSummaryData, processTogglesData */

'use strict';

var startDate;
var dataObj = {};
var ScalarColumnDefs;
var EnumColumnDefs;
var IntColumnDefs;
var IntEnumColumnDefs;
var pageSize = 25;
var ScalarExist;
var EnumExist;
var IntExist;
var rowData = [];
var enumRowData = [];
var intRowData = [];
var tree;

var intUrlParams;
var scalarUrlParams;
var enumUrlParams;

var TOGGLES = {
    ARRAY: 't',
    EXTENDED: 'ext',
    NAME: 0,
    KIND: 1,
    FILE:2,
    LINE:3,
    ENUM: 0,
    INT: 1,
    REG_SCALAR: 4,
    REG_SCALAR_EXT: 5,
    SCALAR: 6,
    SCALAR_EXT: 7,
    REAL: 8,
    KEY: 0,
    VALUE: 1,
    THIT: 2,
    THIT_FILE_NUM: 0,
    THIT_SCOPE: 1,
    ENUM_ARRAY: 4,
    EXCLUSION_STATE: 5,
    EXCLUSION_COMMENT: 7,
    ENUM_EXCLUSION_COMMENT: 6
};

var TOGGLES_VALUES = {
    0: 'hToL',
    1: 'lToH',
    2: 'lToZ',
    3: 'hToZ',
    4: 'zToL',
    5: 'zToH'
};

var PREFIX = {
    INT: 'ti',
    SCALAR: 'tsca',
    ENUM: 'tenum'
};

var pageUrl = pageName.t;

/* main routine */
$(document).ready(function () {
    $('body').append(getPageTemplate());

    startDate = new Date();

    // update document title
    document.title = GLOBAL_JSON.prod + ' Coverage Report';

    // parse url
    urlParams = parseUrl();

    // update url hash
    updateUrlHash();

    // load json file
    loadJsonFile('t' + urlParams.f);
});

function processTogglesData(g_data) {
    var panelBodyId;

    dataObj = g_data[Number(urlParams.s)] || g_data[Number(urlParams.oneInst)];

    if (urlParams.hasOwnProperty('fsub') && urlParams.f == urlParams.fsub) {
        if (g_data.hasOwnProperty(urlParams.s + '_sub')) {
            $.merge(dataObj.t, g_data[urlParams.s + '_sub'].t);
        }
    }

    topPageDescription(urlParams.pr || dataObj.pr);

    // initialize dataGrid data
    initializeData(dataObj[TOGGLES.EXTENDED]);

    panelBodyId = createPanel('#page-body', 'Toggles Coverage', urlParams.cp);

    getRowData(dataObj);
    if (ScalarExist) {
        $('#' + panelBodyId).append('<div id="' + panelBodyId + 'Grid-scalar" style="width:100%;" class="ag-questa grid-container"></div>');

        scalarUrlParams = queryUrlParamsByPrefix(urlParams, PREFIX.SCALAR, {
            pageUrl: pageUrl,
            pageSize: pageSize
        });

        createDataGridInstance(panelBodyId + 'Grid-scalar', ScalarColumnDefs, rowData, {
            isTree: false,
            urlParams: scalarUrlParams,
        });
    }

    if (EnumExist) {
        if (ScalarExist) {
            $('#' + panelBodyId).append('<br /> <br /> <br /> <br />');
        }
        $('#' + panelBodyId).append('<div id="' + panelBodyId + 'Grid-enum" style="width:100%;" class="ag-questa grid-container"></div>');

        enumUrlParams = queryUrlParamsByPrefix(urlParams, PREFIX.ENUM, {
            pageUrl: pageUrl,
            pageSize: pageSize
        });

        createDataGridInstance(panelBodyId + 'Grid-enum', EnumColumnDefs, enumRowData, {
            treeExpanded: true,
            isTree: tree,
            urlParams: enumUrlParams,
        });
    }

    if (IntExist) {
        if (ScalarExist || EnumExist) {
            $('#' + panelBodyId).append('<br /> <br /> <br /> <br />');
        }
        $('#' + panelBodyId).append('<div id="' + panelBodyId + 'Grid-int" style="width:100%;" class="ag-questa grid-container"></div>');

        intUrlParams = queryUrlParamsByPrefix(urlParams, PREFIX.INT, {
            pageUrl: pageUrl,
            pageSize: pageSize
        });

        createDataGridInstance(panelBodyId + 'Grid-int', IntColumnDefs, intRowData, {
            treeExpanded: true,
            isTree: tree,
            urlParams: intUrlParams,
        });
    }

    if (urlParams.hasOwnProperty('p')) {
        var timeDiff = new Date() - startDate;
        console.save(urlParams.p + ',' + timeDiff, 'z_console.txt');
    }
}

function topPageDescription(instance) {
    $('#page-header-text').text(GLOBAL_JSON.prod  + ' Toggles Coverage Report');

    headerTemplate(urlParams, instance);
}

function getRowData(data) {
    var ext = data[TOGGLES.EXTENDED];

    data[TOGGLES.ARRAY].forEach(function(toggle) {
        var rowItems = {} ;
        rowItems = {
            name: toggle[TOGGLES.NAME],
            file: toggle[TOGGLES.FILE],
            line: toggle[TOGGLES.LINE],
            lToH: 0,
            hToL: 0,
            exc: toggle[TOGGLES.EXCLUSION_COMMENT]
        };
        if (ext) { //Extended toggles
            rowItems.lToZ = 0;
            rowItems.zToH = 0;
            rowItems.hToZ = 0;
            rowItems.zToL = 0;
        }
        if (toggle[TOGGLES.KIND] === TOGGLES.SCALAR || toggle[TOGGLES.KIND] === TOGGLES.SCALAR_EXT || toggle[TOGGLES.KIND] === TOGGLES.REG_SCALAR || toggle[TOGGLES.KIND] === TOGGLES.REG_SCALAR_EXT) { //Scalar toggle
            ScalarExist = true;
            if (toggle.length > 3) { //items have values not zero
                for (var val = 2; val < (toggle.length - 1); val++) {
                    rowItems[TOGGLES_VALUES[toggle[val][TOGGLES.KEY]]] = toggle[val][TOGGLES.VALUE];
                    if (toggle[val].length > 2) {
                        rowItems[TOGGLES_VALUES[toggle[val][TOGGLES.KEY]] + '_thitf'] = toggle[val][TOGGLES.THIT][TOGGLES.THIT_FILE_NUM];
                        rowItems[TOGGLES_VALUES[toggle[val][TOGGLES.KEY]] + '_thits'] = toggle[val][TOGGLES.THIT][TOGGLES.THIT_SCOPE];
                    }
                }
            }
            rowItems.coverage = toggle[toggle.length - 1];
            rowData.push(rowItems);
        } else  {  //Enum, Int
            if (toggle[TOGGLES.KIND] === TOGGLES.ENUM) { //Enum
                EnumExist = true;
                if (toggle[TOGGLES.ENUM_ARRAY].length != 1) {
                    enumRowData.push({
                        name: toggle[TOGGLES.NAME],
                        file: toggle[TOGGLES.FILE],
                        line: toggle[TOGGLES.LINE],
                        enump: 1,
                    });
                    if (toggle[TOGGLES.ENUM_ARRAY].length != 0) {
                        enumRowData[enumRowData.length - 1].children = [];
                        enumRowData[enumRowData.length - 1].group = true;
                        tree = true;
                    }
                }

                toggle[TOGGLES.ENUM_ARRAY].forEach(function(enumToggle) {
                    rowItems = {
                        hits: 0
                    };
                    rowItems.hits =  enumToggle[TOGGLES.VALUE];
                    rowItems.name =  enumToggle[TOGGLES.NAME];
                    rowItems.c = toggle[TOGGLES.ENUM_EXCLUSION_COMMENT]
                    if (enumToggle.length > 2) {
                        rowItems.thitf =  enumToggle[TOGGLES.THIT][TOGGLES.THIT_FILE_NUM];
                        rowItems.thits =  enumToggle[TOGGLES.THIT][TOGGLES.THIT_SCOPE];
                    }

                    if (toggle[TOGGLES.ENUM_ARRAY].length === 1) {
                        rowItems.coverage = ((rowItems.hToL > 0 && rowItems.lToH > 0) ? 100 : (rowItems.hToL > 0 || rowItems.lToH > 0) ? 50 : 0);
                        enumRowData.push(rowItems);
                    } else {
                        rowItems.coverage = (typeof rowItems.hits == 'string') ? 'Excluded' :  (rowItems.hits > 0 ) ? 'Covered' : 'Not Covered';
                        rowItems.enum = 1;
                        enumRowData[enumRowData.length - 1].children.push(rowItems);
                    }
                });
            } else if (toggle[TOGGLES.KIND] === TOGGLES.INT || toggle[TOGGLES.KIND] === TOGGLES.REAL) {  //int or Real
                IntExist = true;
                if (toggle[TOGGLES.ENUM_ARRAY].length != 1) {
                    rowItems = {
                        name: toggle[TOGGLES.NAME],
                        coverage: 'Covered',
                        enump: 1
                    };
                    if (!toggle[TOGGLES.ENUM_ARRAY].length) {
                        rowItems.hits =     toggle[TOGGLES.EXCLUSION_STATE] == 'E' ?  'Excluded' : 0;
                        rowItems.coverage = toggle[TOGGLES.EXCLUSION_STATE] == 'E' ?  'Excluded' : 'Not Covered';
                    } else {
                        rowItems.hits = toggle[TOGGLES.EXCLUSION_STATE] == 'E' ?  'E-hit' : '-';
                        rowItems.coverage = toggle[TOGGLES.EXCLUSION_STATE] == 'E' ?  'Excluded' : 'Covered';
                    }

                    intRowData.push(rowItems);
                    if (toggle[TOGGLES.ENUM_ARRAY].length != 0) {
                        intRowData[intRowData.length - 1].children = [];
                        intRowData[intRowData.length - 1].group = true;
                        tree = true;
                    }
                }

                toggle[TOGGLES.ENUM_ARRAY].forEach(function(intToggle) {
                    rowItems = {
                        hits: 0
                    };

                    rowItems.hits =  intToggle[TOGGLES.VALUE];
                    rowItems.name =  intToggle[TOGGLES.NAME];
                    if (intToggle.length > 2) {
                        rowItems.thitf =  intToggle[TOGGLES.THIT][TOGGLES.THIT_FILE_NUM];
                        rowItems.thits =  intToggle[TOGGLES.THIT][TOGGLES.THIT_SCOPE];
                    }

                    if (toggle[TOGGLES.ENUM_ARRAY].length === 1) {
                        intRowData.push(rowItems);
                    } else {
                        rowItems.enum = 1;
                        intRowData[intRowData.length - 1].children.push(rowItems);
                    }
                });

            }
        }
    });
}

function initializeData(EXT) {
    ScalarColumnDefs = [
        {
            headerName: 'SCALAR Signal / Value',
            headerTooltip: 'Signal / Value',
            headerClass: 'justify-left',
            field: 'name',
            tooltipField: 'name',
            minWidth: 120, width: 300,
            cellRenderer: 'group',
            suppressHideColumn: true,
            suppressMovable: true,
            cellRendererParams: {
                innerRenderer: function (params) {
                    var link = (GLOBAL_JSON.hasOwnProperty('srcAnnotate')  && GLOBAL_JSON.srcAnnotate && params.data.file && params.data.line)  ?
                    ('<a href="sourceViewer.html?f=' + params.data.file + '&l=' + params.data.line + '" >' + params.value  + '</a>') : params.value ;
                    if (params.data.enum) {
                        return '<span style="padding-left: 20px;">' + link +  '</span>';
                    } else {
                        return link;
                    }
                },
                suppressCount: true
            },
            cellStyle: {
                'text-align': 'left',
                'left': '4px'
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return isTogglesExtendedValueExcluded(params);
                },
            },
        }
    ];
    if (EXT) {
        ScalarColumnDefs.push(
            {
                headerName: 'Hits',
                headerTooltip: 'Hits',
                headerClass: 'justify-center',
                tooltipField: 'hits',
                field: 'hits',
                filter: 'number',
                minWidth: 120, width: 300,
                Style: {
                    'float': 'right',
                },
                children: [
                    {headerName: '0L->1H', field: 'lToH', tooltipField: 'lToH', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'lToH_thitf', scope: 'lToH_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },

                    },
                    {headerName: '1H->0L', field: 'hToL', tooltipField: 'hToL', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'hToL_thitf', scope: 'hToL_thits'});

                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },
                    },
                    {headerName: '0L->Z', field: 'lToZ', tooltipField: 'lToZ', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'lToZ_thitf', scope: 'lToZ_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },
                    },
                    {headerName: 'Z->0L', field: 'zToL', tooltipField: 'zToL', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'zToL_thitf', scope: 'zToL_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },
                    },
                    {headerName: '1H->Z', field: 'hToZ', tooltipField: 'hToZ', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'hToZ_thitf', scope: 'hToZ_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },
                    },
                    {headerName: 'Z->1H', field: 'zToH', tooltipField: 'zToH', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'zToH_thitf', scope: 'zToH_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },
                    },
                ],
                cellClassRules: {
                    'danger': function (params) {
                        return params.value == 0;
                    },
                    'exclusion': function (params) {
                        return isTogglesExtendedValueExcluded(params);
                    },

                }
            });
    } else {
        ScalarColumnDefs.push(
            {
                headerName: 'Hits',
                headerTooltip: 'Hits',
                headerClass: 'justify-center',
                tooltipField: 'hits',
                field: 'hits',
                filter: 'number',
                minWidth: 120, width: 300,
                Style: {
                    'float': 'right',
                },
                children: [
                    {headerName: '->1', field: 'lToH', tooltipField: 'lToH', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'lToH_thitf', scope: 'lToH_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },

                    },
                    {headerName: '->0', field: 'hToL', tooltipField: 'hToL', filter: 'number', minWidth: 50, width: 50,
                        cellRenderer: function (params) {
                            return hitsRenderer(params, {fileNum: 'hToL_thitf', scope: 'hToL_thits'});
                        },
                        cellClassRules: {
                            'exclusion': function (params) {
                                return isTogglesExtendedValueExcluded(params);
                            },
                        },
                    },
                ],
                cellClassRules: {
                    'danger': function (params) {
                        return params.value == 0;
                    },
                    'exclusion': function (params) {
                        return isTogglesExtendedValueExcluded(params);
                    },

                }
            });
    }
    ScalarColumnDefs.push(
        {
            headerName: 'Coverage',
            headerTooltip: 'Coverage',
            field: 'coverage',
            tooltipField: 'coverage',
            filter: 'number',
            minWidth: 120, width: 120, maxWidth: 120,
            cellRenderer: function (params) {
                return (params.value === 'E') ? 'Excluded' : (isValueNa(params)) ? 'na' : (isValueUndefined(params) && !params.data.enump) ? '-' : (params.data.enump || params.data.enum ) ? params.value : (params.value) + '%';
            },
            cellClassRules: {
                'fg-disabled': function (params) {
                    return isValueNa(params);
                },
                'undefined': function (params) {
                    return isValueUndefined(params);
                },
                'danger': function (params) {
                    return ((isValueBelowThreshold(params)) || params.value === 'Not Covered') && !((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string'));
                },
                'warning': function (params) {
                    return isValueInRange(params) && !((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string'));
                },
                'success': function (params) {
                    return (isValueAboveThreshold(params) || params.value === 'Covered') && !((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string'));
                },
                'exclusion': function (params) {
                    return isTogglesExtendedValueExcluded(params);
                },
            }
        });

    EnumColumnDefs = [
        {
            headerName: 'ENUM Signal / Value',
            headerTooltip: 'ENUM Signal / Value',
            headerClass: 'justify-left',
            tooltipField: 'name',
            field: 'name',
            minWidth: 120, width: 300,
            suppressHideColumn: true,
            suppressMovable: true,
            cellRenderer: 'group',
            cellRendererParams: {
                innerRenderer: function (params) {
                    var link = (GLOBAL_JSON.hasOwnProperty('srcAnnotate')  && GLOBAL_JSON.srcAnnotate && params.data.file && params.data.line)  ?
                    ('<a href="sourceViewer.html?f=' + params.data.file + '&l=' + params.data.line + '" >' + params.value  + '</a>') : params.value ;
                    if (params.data.enum) {
                        return '<span style="padding-left: 20px;">' + link +  '</span>';
                    } else {
                        return link;
                    }
                },
                suppressCount: true
            },
            cellStyle: {
                'text-align': 'left',
                'left': '4px'
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return isTogglesExtendedValueExcluded(params);
                },
            },
        },
    ];

    IntColumnDefs = [
        {
            headerName: 'INTEGER Signal / Value',
            headerTooltip: 'INTEGER Signal / Value',
            headerClass: 'justify-left',
            tooltipField: 'name',
            field: 'name',
            minWidth: 120, width: 300,
            suppressHideColumn: true,
            suppressMovable: true,
            cellRenderer: 'group',
            cellRendererParams: {
                innerRenderer: function (params) {
                    if (params.data.enum) {
                        return '<span style="padding-left: 20px;">' + params.value +  '</span>';
                    } else {
                        return params.value;
                    }
                },
                suppressCount: true
            },
            cellStyle: {
                'text-align': 'left',
                'left': '4px'
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return isTogglesExtendedValueExcluded(params);
                },
            },
        },
    ];

    IntEnumColumnDefs = [
        {
            headerName: 'Hits',
            headerTooltip: 'Hits',
            headerClass: 'justify-center',
            tooltipField: 'hits',
            field: 'hits',
            filter: 'number',
            minWidth: 120, width: 300,
            Style: {
                'float': 'right',
            },
            cellClassRules: {
                'danger': function (params) {
                    return params.value == 0;
                },
                'exclusion': function (params) {
                    return isTogglesExtendedValueExcluded(params);
                }
            },
            cellRenderer: function(params) {
                return hitsRenderer(params, {fileNum: 'thitf', scope: 'thits'});
            }
        },
        {
            headerName: 'Coverage',
            headerTooltip: 'Coverage',
            field: 'coverage',
            tooltipField: 'coverage',
            filter: 'number',
            minWidth: 120, width: 120, maxWidth: 120,
            cellRenderer: function (params) {
                return ((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string')) ? 'Excluded' : (isValueNa(params)) ? 'na' : (isValueUndefined(params) && !params.data.enump) ? '-' : (params.data.enump || params.data.enum ) ? params.value : (params.value) + '%';
            },
            cellClassRules: {
                'fg-disabled': function (params) {
                    return isValueNa(params);
                },
                'undefined': function (params) {
                    return isValueUndefined(params);
                },
                'danger': function (params) {
                    return ((isValueBelowThreshold(params)) || params.value === 'Not Covered') && !((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string'));
                },
                'warning': function (params) {
                    return isValueInRange(params) && !((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string'));
                },
                'success': function (params) {
                    return (isValueAboveThreshold(params) || params.value === 'Covered') && !((typeof params.data.lToH === 'string') || (typeof params.data.hToL === 'string'));
                },
                'exclusion': function (params) {
                    return isTogglesExtendedValueExcluded(params);
                },
            }
        }
    ];

    EnumColumnDefs.push.apply(EnumColumnDefs, IntEnumColumnDefs);
    IntColumnDefs.push.apply(IntColumnDefs, IntEnumColumnDefs);
}
