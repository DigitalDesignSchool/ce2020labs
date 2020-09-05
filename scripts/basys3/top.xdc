# Clock signal

set_property -dict { PACKAGE_PIN W5  IOSTANDARD LVCMOS33 } [get_ports { clk          }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ejtag_tck_in]

# Switches

set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { sw[0]        }]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { sw[1]        }]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { sw[2]        }]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports { sw[3]        }]
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports { sw[4]        }]
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { sw[5]        }]
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports { sw[6]        }]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports { sw[7]        }]
set_property -dict { PACKAGE_PIN V2  IOSTANDARD LVCMOS33 } [get_ports { sw[8]        }]
set_property -dict { PACKAGE_PIN T3  IOSTANDARD LVCMOS33 } [get_ports { sw[9]        }]
set_property -dict { PACKAGE_PIN T2  IOSTANDARD LVCMOS33 } [get_ports { sw[10]       }]
set_property -dict { PACKAGE_PIN R3  IOSTANDARD LVCMOS33 } [get_ports { sw[11]       }]
set_property -dict { PACKAGE_PIN W2  IOSTANDARD LVCMOS33 } [get_ports { sw[12]       }]
set_property -dict { PACKAGE_PIN U1  IOSTANDARD LVCMOS33 } [get_ports { sw[13]       }]
set_property -dict { PACKAGE_PIN T1  IOSTANDARD LVCMOS33 } [get_ports { sw[14]       }]
set_property -dict { PACKAGE_PIN R2  IOSTANDARD LVCMOS33 } [get_ports { sw[15]       }]


# LEDs

set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { led[0]       }]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports { led[1]       }]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports { led[2]       }]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports { led[3]       }]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports { led[4]       }]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { led[5]       }]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { led[6]       }]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { led[7]       }]
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { led[8]       }]
set_property -dict { PACKAGE_PIN V3  IOSTANDARD LVCMOS33 } [get_ports { led[9]       }]
set_property -dict { PACKAGE_PIN W3  IOSTANDARD LVCMOS33 } [get_ports { led[10]      }]
set_property -dict { PACKAGE_PIN U3  IOSTANDARD LVCMOS33 } [get_ports { led[11]      }]
set_property -dict { PACKAGE_PIN P3  IOSTANDARD LVCMOS33 } [get_ports { led[12]      }]
set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports { led[13]      }]
set_property -dict { PACKAGE_PIN P1  IOSTANDARD LVCMOS33 } [get_ports { led[14]      }]
set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports { led[15]      }]


# 7 segment display

set_property -dict { PACKAGE_PIN W7  IOSTANDARD LVCMOS33 } [get_ports { seg[0]       }]
set_property -dict { PACKAGE_PIN W6  IOSTANDARD LVCMOS33 } [get_ports { seg[1]       }]
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports { seg[2]       }]
set_property -dict { PACKAGE_PIN V8  IOSTANDARD LVCMOS33 } [get_ports { seg[3]       }]
set_property -dict { PACKAGE_PIN U5  IOSTANDARD LVCMOS33 } [get_ports { seg[4]       }]
set_property -dict { PACKAGE_PIN V5  IOSTANDARD LVCMOS33 } [get_ports { seg[5]       }]
set_property -dict { PACKAGE_PIN U7  IOSTANDARD LVCMOS33 } [get_ports { seg[6]       }]

set_property -dict { PACKAGE_PIN V7  IOSTANDARD LVCMOS33 } [get_ports { dp           }]

set_property -dict { PACKAGE_PIN U2  IOSTANDARD LVCMOS33 } [get_ports { an[0]        }]
set_property -dict { PACKAGE_PIN U4  IOSTANDARD LVCMOS33 } [get_ports { an[1]        }]
set_property -dict { PACKAGE_PIN V4  IOSTANDARD LVCMOS33 } [get_ports { an[2]        }]
set_property -dict { PACKAGE_PIN W4  IOSTANDARD LVCMOS33 } [get_ports { an[3]        }]

# Buttons

set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { btnc         }]
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { btnu         }]
set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports { btnl         }]
set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { btnr         }]
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { btnd         }]

# Pmod Header JA

# Sch name = JA1
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports { ja[0]        }]
# Sch name = JA2
set_property -dict { PACKAGE_PIN L2  IOSTANDARD LVCMOS33 } [get_ports { ja[1]        }]
# Sch name = JA3
set_property -dict { PACKAGE_PIN J2  IOSTANDARD LVCMOS33 } [get_ports { ja[2]        }]
# Sch name = JA4
set_property -dict { PACKAGE_PIN G2  IOSTANDARD LVCMOS33 } [get_ports { ja[3]        }]
# Sch name = JA7
set_property -dict { PACKAGE_PIN H1  IOSTANDARD LVCMOS33 } [get_ports { ja[4]        }]
# Sch name = JA8
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports { ja[5]        }]
# Sch name = JA9
set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports { ja[6]        }]
# Sch name = JA10
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports { ja[7]        }]

# Pmod Header JB

# Sch name = JB1
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [get_ports { jb[0]        }]
# Sch name = JB2
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [get_ports { jb[1]        }]
# Sch name = JB3
set_property -dict { PACKAGE_PIN B15 IOSTANDARD LVCMOS33 } [get_ports { jb[2]        }]
# Sch name = JB4
set_property -dict { PACKAGE_PIN B16 IOSTANDARD LVCMOS33 } [get_ports { jb[3]        }]
# Sch name = JB7
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [get_ports { jb[4]        }]
# Sch name = JB8
set_property -dict { PACKAGE_PIN A17 IOSTANDARD LVCMOS33 } [get_ports { jb[5]        }]
# Sch name = JB9
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33 } [get_ports { jb[6]        }]
# Sch name = JB10
set_property -dict { PACKAGE_PIN C16 IOSTANDARD LVCMOS33 } [get_ports { jb[7]        }]

# Pmod Header JC

# Sch name = JC1
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports { jc[0]        }]
# Sch name = JC2
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { jc[1]        }]
# Sch name = JC3
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { jc[2]        }]
# Sch name = JC4
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { jc[3]        }]
# Sch name = JC7
set_property -dict { PACKAGE_PIN L17 IOSTANDARD LVCMOS33 } [get_ports { jc[4]        }]
# Sch name = JC8
set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports { jc[5]        }]
# Sch name = JC9
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { jc[6]        }]
# Sch name = JC10
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { jc[7]        }]

# Pmod Header JXADC

# Sch name = XA1_P
set_property -dict { PACKAGE_PIN J3  IOSTANDARD LVCMOS33 } [get_ports { jxadc[0]     }]
# Sch name = XA2_P
set_property -dict { PACKAGE_PIN L3  IOSTANDARD LVCMOS33 } [get_ports { jxadc[1]     }]
# Sch name = XA3_P
set_property -dict { PACKAGE_PIN M2  IOSTANDARD LVCMOS33 } [get_ports { jxadc[2]     }]
# Sch name = XA4_P
set_property -dict { PACKAGE_PIN N2  IOSTANDARD LVCMOS33 } [get_ports { jxadc[3]     }]
# Sch name = XA1_N
set_property -dict { PACKAGE_PIN K3  IOSTANDARD LVCMOS33 } [get_ports { jxadc[4]     }]
# Sch name = XA2_N
set_property -dict { PACKAGE_PIN M3  IOSTANDARD LVCMOS33 } [get_ports { jxadc[5]     }]
# Sch name = XA3_N
set_property -dict { PACKAGE_PIN M1  IOSTANDARD LVCMOS33 } [get_ports { jxadc[6]     }]
# Sch name = XA4_N
set_property -dict { PACKAGE_PIN N1  IOSTANDARD LVCMOS33 } [get_ports { jxadc[7]     }]

# VGA Connector

set_property -dict { PACKAGE_PIN G19 IOSTANDARD LVCMOS33 } [get_ports { vga_red[0]   }]
set_property -dict { PACKAGE_PIN H19 IOSTANDARD LVCMOS33 } [get_ports { vga_red[1]   }]
set_property -dict { PACKAGE_PIN J19 IOSTANDARD LVCMOS33 } [get_ports { vga_red[2]   }]
set_property -dict { PACKAGE_PIN N19 IOSTANDARD LVCMOS33 } [get_ports { vga_red[3]   }]
set_property -dict { PACKAGE_PIN N18 IOSTANDARD LVCMOS33 } [get_ports { vga_blue[0]  }]
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { vga_blue[1]  }]
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { vga_blue[2]  }]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { vga_blue[3]  }]
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { vga_green[0] }]
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { vga_green[1] }]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { vga_green[2] }]
set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports { vga_green[3] }]
set_property -dict { PACKAGE_PIN P19 IOSTANDARD LVCMOS33 } [get_ports { hsync        }]
set_property -dict { PACKAGE_PIN R19 IOSTANDARD LVCMOS33 } [get_ports { vsync        }]

# USB-RS232 Interface

set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports { rs_rx        }]
set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports { rs_tx        }]

# USB HID (PS/2)

set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports { ps2_clk      }]
set_property PULLUP true IOSTANDARD LVCMOS33 } [get_ports PS2Clk]

set_property -dict { PACKAGE_PIN B17 IOSTANDARD LVCMOS33 } [get_ports { ps2_data     }]
set_property PULLUP true IOSTANDARD LVCMOS33 } [get_ports PS2Data]

# Quad SPI Flash
# Note that CCLK_0 cannot be placed in 7 series devices.
# You can access it using the STARTUPE2 primitive.

set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { qspi_db[0]   }]
set_property -dict { PACKAGE_PIN D19 IOSTANDARD LVCMOS33 } [get_ports { qspi_db[1]   }]
set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports { qspi_db[2]   }]
set_property -dict { PACKAGE_PIN F18 IOSTANDARD LVCMOS33 } [get_ports { qspi_db[3]   }]
set_property -dict { PACKAGE_PIN K19 IOSTANDARD LVCMOS33 } [get_ports { qspi_csn     }]
