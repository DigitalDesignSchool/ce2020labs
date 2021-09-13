'use strict';

var startDate;
var testplanColumnDefs;
var pageSize = 25;
var tpUrlParams;
var urlParams;

var TESTPLAN_ITEM = {
    BINS: 0,
    HITS: 1,
    COVERAGE: 2,
    GOALP: 3,
    TYPE: 4,
    WEIGHT: 5,
    SECTION_NAME: 6,
    GOAL: 7,
    LEVEL: 8,
    SECTION_NUMBER: 9,
    LINKSTATUS: 10
};
var parentExc;

var TESTPLAN_TYPE = {
    'stmt bin': 'Statement Bin',
    'expr bin': 'Expression Bin',
    'cond bin': 'Condition Bin',
    'toggle bin': 'Toggle Bin',
    'branch bin': 'Branch Bin',
    'fsm bin': 'FSM Bin',
    'cover bin': 'Cover Directive Bin',
    'assert bin': 'Assertion Fail Bin',
    'pass bin': 'Assertion Pass Bin',
};

var PREFIX = {
    TEST_PLAN: 'tp'
};


function buildTree (tree) {
    var map = {}, parents = [], i;
    for (i = 0; i < tree.length; i += 1) {
        map[tree[i].id] = i;
        if (tree[i].parent !== '' && tree[map[tree[i].parent]]) {
            if (!(tree[map[tree[i].parent]].hasOwnProperty('children'))) {
                tree[map[tree[i].parent]].children = [];
                tree[map[tree[i].parent]].group = true;
            }
            tree[map[tree[i].parent]].children.push(tree[i]);
        } else {
            tree[i].children = [];
            tree[i].group = true;
            parents.push(tree[i]);
        }
    }
    return parents;
}


function getTestPlanRowData(data, mode) {
    var rowData = [];
    var parentId, Idn;
    urlParams = parseUrl();
    Object.keys(data.tp).forEach(function (item, itemIndex) {




        if ((data.tp[item].fixed_attr_val).length === 11) {
            var index = (data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NUMBER]).lastIndexOf('.');
            Idn = data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NUMBER];

            // Check the parent Id to be Empty ('') if first element in the Data and there is no dots ('.') in the section number
            // Check the parent Id to be (0) if there is no dots ('.') in the section number
            parentId = index == -1 ? Idn == 0 ? '' : 0 : (data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NUMBER]).slice(0, index);
        }
        var rowItems = {
            bins: data.tp[item].fixed_attr_val[TESTPLAN_ITEM.BINS],
            hits: data.tp[item].fixed_attr_val[TESTPLAN_ITEM.HITS],
            coverage: data.tp[item].fixed_attr_val[TESTPLAN_ITEM.COVERAGE],
            goal: data.tp[item].fixed_attr_val[TESTPLAN_ITEM.GOAL],
            goalP: data.tp[item].fixed_attr_val[TESTPLAN_ITEM.GOALP],
            type: (TESTPLAN_TYPE[data.tp[item].fixed_attr_val[TESTPLAN_ITEM.TYPE]]) ? TESTPLAN_TYPE[data.tp[item].fixed_attr_val[TESTPLAN_ITEM.TYPE]] : data.tp[item].fixed_attr_val[TESTPLAN_ITEM.TYPE],
            weight: data.tp[item].fixed_attr_val[TESTPLAN_ITEM.WEIGHT]
        } ;

        if ((data.tp[item].fixed_attr_val).length === 11) { //Section or SubSection
            rowItems.testplan = data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NUMBER] + ' ' + data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NAME];
            rowItems.sectionName = data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NAME];
            rowItems.linkStatus = (data.tp[item].fixed_attr_val[TESTPLAN_ITEM.LINKSTATUS] === 1) ? 'Clean' : 'Not Clean';
            rowItems.id = data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NUMBER];
            rowItems.parent = parentId;

            if ((data.tp[item]).hasOwnProperty('usr_attr')) {
                for (var usratt = 0, l = data.head.length; usratt < l; usratt++ ) {
                    rowItems['usrattr' + Object.keys(data.tp[item].usr_attr[usratt])] = data.tp[item].usr_attr[usratt][Object.keys(data.tp[item].usr_attr[usratt])];
                }
            }

        } else {
            rowItems.testplan = data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NAME];
            rowItems.parent = Idn;
        }
        if (itemIndex == 0 ) { // First element in the testplan
            rowItems.expand = true;
        }

        if (urlParams.hasOwnProperty('section') && data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NAME] == urlParams.section) {
            rowItems.expand = true;

        }

        ['coverage', 'goal', 'goalP', 'weight'].forEach(function(covType) {
            if (rowItems[covType] == '-') {
                delete rowItems[covType];
            }
        });

        if (mode === 'summary')  // If summary mode we will check only for the section headers
        {
            if ((data.tp[item].fixed_attr_val).length === 11 &&  (data.tp[item].fixed_attr_val[TESTPLAN_ITEM.SECTION_NUMBER]).indexOf('.') === -1 ) {
                rowData.push(rowItems);
            }
        } else { // Else Add sections and sub sections
            rowData.push(rowItems);
        }


    });


    var treeRowData = buildTree(rowData);

    return treeRowData;
}

function initializeTestPlanData(usr_attr, mode) {
    testplanColumnDefs = [
        {
            headerName: 'Testplan Section / Coverage Link',
            headerTooltip: 'Testplan Section / Coverage Link',
            headerClass: 'justify-left',
            field: 'testplan',
            tooltipField: 'testplan',
            minWidth: 180, width: 250,
            filter: 'text',
            suppressHideColumn: true,
            suppressMovable: true,
            cellStyle: {
                'text-align': 'left'
            },
            expanded: true,
            cellRenderer: 'group',
            cellRendererParams: {
                suppressCount: true,
                innerRenderer: function (params) {
                    if (mode === 'summary') {
                        return '<a href="testPlan.html?section='+ params.data.sectionName + '">' + params.value + '</a>'
                    } else {
                         // Handling Linking testplan to crossbin by replacing "<" and ">" by the corresponding HTML symbols
                     if (params.data.type === 'cvg bin' && params.value.indexOf('<') > -1 && params.value.indexOf('>') > -1) {
                         return params.value.replace('<', '&lt;').replace('>', '&gt;')
                     } else {

                         return params.value;
                     }

                    }
                }
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            },
        },
        {
            headerName: 'Type',
            headerTooltip: 'Type',
            field: 'type',
            tooltipField: 'type',
            minWidth: 120, width: 120, maxWidth: 120,
            filter: 'text',
            headerClass: 'justify-left',
            cellStyle: {
                'text-align': 'left'
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            },
        },
        {
            headerName: 'Hits',
            headerTooltip: 'Hits',
            field: 'hits',
            tooltipField: 'hits',
            minWidth: 100, width: 100, maxWidth: 100,
            filter: 'number',
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            },
        },
        {
            headerName: 'Bins',
            headerTooltip: 'Bins',
            field: 'bins',
            tooltipField: 'bins',
            minWidth: 100, width: 100, maxWidth: 100,
            filter: 'number',
            filterParams: {
                clearButton: true,
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            },
        },
        {
            headerName: 'Coverage',
            headerTooltip: 'Coverage',
            field: 'coverage',
            tooltipField: 'coverage',
            minWidth: 120, width: 120, maxWidth: 120,
            filter: 'number',
            cellRenderer: function (params) {
                if (params.value == 'C') {
                    return 'Covered';
                } else if (params.value == 'U') {
                    return 'Uncovered';
                } else if (isValueUndefined(params)) {
                    return '-';
                } else {
                    return params.value + '%';
                }
            },
            cellClassRules: {
                'fg-disabled': function (params) {
                    return params.value === 'na';
                },
                'undefined': function (params) {
                    return isValueUndefined(params);
                },
                'danger': function (params) {
                    return isValueBelowThreshold(params) || params.value === 'U';
                },
                'warning': function (params) {
                    return isValueInRange(params);
                },
                'success': function (params) {
                    return isValueAboveThreshold(params) || params.value === 'C';
                },
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            }
        },
        {
            headerName: '% of Goal',
            headerTooltip: '% of Goal',
            field: 'goalP',
            tooltipField: 'goalP',
            minWidth: 100, width: 100, maxWidth: 100,
            filter: 'number',
            cellRenderer: function (params) {
                return (typeof params.value !== 'undefined') ? (params.value + '%') : '-';
            },
            cellClassRules: {
                'danger': function (params) {
                    return isValueBelowThreshold(params);
                },
                'warning': function (params) {
                    return isValueInRange(params);
                },
                'success': function (params) {
                    return isValueAboveThreshold(params);
                },
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            }
        },
        {
            headerName: 'Goal',
            headerTooltip: 'Goal',
            field: 'goal',
            tooltipField: 'goal',
            comparator: gridSortingCustomComparator,
            minWidth: 100, width: 100, maxWidth: 100,
            filter: 'number',
            cellRenderer: function (params) {
                return (typeof params.value !== 'undefined') ? (params.value) : '-';
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
                'justify-center': function (params) {
                    return isValueUndefined(params) ||  params.value === '-';
                },
            }
        },
        {
            headerName: 'Weight',
            headerTooltip: 'Weight',
            field: 'weight',
            tooltipField: 'weight',
            minWidth: 100, width: 100, maxWidth: 100,
            filter: 'number',
            cellRenderer: function (params) {
                return (typeof params.value !== 'undefined') ? Number(params.value) : '-';
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            },
        },
        {
            headerName: 'Link Status',
            headerTooltip: 'Link Status',
            field: 'linkStatus',
            tooltipField: 'linkStatus',
            minWidth: 120, width: 120, maxWidth: 120,
            filter: 'text',
            headerClass: 'justify-left',
            cellStyle: {
                'text-align': 'left'
            },
            cellClassRules: {
                'exclusion': function (params) {
                    return CheckExclusion(params);
                },
            },
        },
    ];

    if (mode != 'summary') {
        for (var usratt = 0; usratt < usr_attr.length; usratt++ ) {
            testplanColumnDefs.push({
                headerName: usr_attr[usratt],
                headerTooltip: usr_attr[usratt],
                field: 'usrattr' + usr_attr[usratt],
                tooltipField: 'usrattr' + usr_attr[usratt],
                minWidth: 120, width: 120,
                filter: 'text',
                hide: true,
                cellStyle: {
                    'text-align': 'left'
                },
                headerClass: 'justify-left',
                cellClassRules: {
                    'exclusion': function (params) {
                        return CheckExclusion(params);
                    },
                    'justify-right': function (params) {
                        return (!isNaN(params.value));
                    },
                },

            });
        }
    } else { // In case of summary tracker remove unwanted columns

        delete testplanColumnDefs.splice(8, 1); // Remove Hits Column
        delete testplanColumnDefs.splice(7, 1); // Remove Hits Column
        delete testplanColumnDefs.splice(3, 1); // Remove Hits Column
        delete testplanColumnDefs.splice(2, 1);  // Remove Hits Column
        delete testplanColumnDefs.splice(1, 1);  // Remove Type Column
    }

}

function CheckExclusion(params) {
    var node = params.node;
    parentExc = false;
    while (node.parent) {
        if (!node.parent.data.weight) {
            parentExc = true;
            break;
        }
        node = node.parent;
    }
    return (!params.data.weight || parentExc);
}
