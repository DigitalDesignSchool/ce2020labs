# Clock

set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk100mhz    }];
create_clock -period 10 [get_ports { clk100mhz }];

# Switches

set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { sw[0]        }];
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { sw[1]        }];
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { sw[2]        }];
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { sw[3]        }];
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { sw[4]        }];
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { sw[5]        }];
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { sw[6]        }];
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { sw[7]        }];
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { sw[8]        }];
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { sw[9]        }];
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { sw[10]       }];
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { sw[11]       }];
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { sw[12]       }];
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { sw[13]       }];
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { sw[14]       }];
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { sw[15]       }];

# LEDs

set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { led[0]       }];
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { led[1]       }];
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { led[2]       }];
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { led[3]       }];
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { led[4]       }];
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { led[5]       }];
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { led[6]       }];
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { led[7]       }];
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { led[8]       }];
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { led[9]       }];
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { led[10]      }];
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { led[11]      }];
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { led[12]      }];
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { led[13]      }];
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { led[14]      }];
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { led[15]      }];

# RGB LEDs

set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { led16_b      }];
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { led16_g      }];
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { led16_r      }];
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { led17_b      }];
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { led17_g      }];
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { led17_r      }];

# 7 segment display

set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { ca           }];
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { cb           }];
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { cc           }];
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { cd           }];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { ce           }];
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { cf           }];
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { cg           }];

set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { dp           }];

set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { an[0]        }];
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { an[1]        }];
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { an[2]        }];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { an[3]        }];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { an[4]        }];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { an[5]        }];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { an[6]        }];
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { an[7]        }];

# Buttons

set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { cpu_resetn   }];

set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { btnc         }];
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { btnu         }];
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { btnl         }];
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { btnr         }];
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { btnd         }];

# Pmod Headers

# Pmod Header JA

set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { ja[1]        }];
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { ja[2]        }];
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { ja[3]        }];
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { ja[4]        }];
set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { ja[7]        }];
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { ja[8]        }];
set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { ja[9]        }];
set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { ja[10]       }];

# Pmod Header JB

set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { jb[1]        }];
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { jb[2]        }];
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { jb[3]        }];
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { jb[4]        }];
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { jb[7]        }];
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { jb[8]        }];
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { jb[9]        }];
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { jb[10]       }];

# Accelerometer

# set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { acl_miso     }];
# set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33 } [get_ports { acl_mosi     }];
# set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { acl_sclk     }];
# set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { acl_csn      }];
# set_property -dict { PACKAGE_PIN B13   IOSTANDARD LVCMOS33 } [get_ports { acl_int[1]   }];
# set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { acl_int[2]   }];

# Temperature Sensor

# set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports { tmp_scl      }];
# set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { tmp_sda      }];
# set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports { tmp_int      }];
# set_property -dict { PACKAGE_PIN B14   IOSTANDARD LVCMOS33 } [get_ports { tmp_ct       }];

# Omnidirectional Microphone

# set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { m_clk        }];
# set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { m_data       }];
# set_property -dict { PACKAGE_PIN F5    IOSTANDARD LVCMOS33 } [get_ports { m_lrsel      }];

# PWM Audio Amplifier

# set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { aud_pwm      }];
# set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports { aud_sd       }];

# USB-RS232 Interface

# set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in  }];
# set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
# set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { uart_cts     }];
# set_property -dict { PACKAGE_PIN E5    IOSTANDARD LVCMOS33 } [get_ports { uart_rts     }];
