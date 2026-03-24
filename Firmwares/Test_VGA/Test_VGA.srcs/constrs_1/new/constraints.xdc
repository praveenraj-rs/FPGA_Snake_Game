## =========================
## CLOCK (100 MHz - Basys3)
## =========================
set_property PACKAGE_PIN W5 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 10.000 -name sys_clk -waveform {0 5} [get_ports CLK]


## =========================
## RESET
## =========================
set_property PACKAGE_PIN V17 [get_ports RESET]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]


## =========================
## VGA COLOR OUTPUT (12-bit)
## =========================

# Red
set_property PACKAGE_PIN G19 [get_ports {COLOUR_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[0]}]

set_property PACKAGE_PIN H19 [get_ports {COLOUR_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[1]}]

set_property PACKAGE_PIN J19 [get_ports {COLOUR_OUT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[2]}]

set_property PACKAGE_PIN N19 [get_ports {COLOUR_OUT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[3]}]


# Green
set_property PACKAGE_PIN J17 [get_ports {COLOUR_OUT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[4]}]

set_property PACKAGE_PIN H17 [get_ports {COLOUR_OUT[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[5]}]

set_property PACKAGE_PIN G17 [get_ports {COLOUR_OUT[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[6]}]

set_property PACKAGE_PIN D17 [get_ports {COLOUR_OUT[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[7]}]


# Blue
set_property PACKAGE_PIN N18 [get_ports {COLOUR_OUT[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[8]}]

set_property PACKAGE_PIN L18 [get_ports {COLOUR_OUT[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[9]}]

set_property PACKAGE_PIN K18 [get_ports {COLOUR_OUT[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[10]}]

set_property PACKAGE_PIN J18 [get_ports {COLOUR_OUT[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[11]}]


## =========================
## VGA SYNC SIGNALS
## =========================

set_property PACKAGE_PIN P19 [get_ports HS]
set_property IOSTANDARD LVCMOS33 [get_ports HS]

set_property PACKAGE_PIN R19 [get_ports VS]
set_property IOSTANDARD LVCMOS33 [get_ports VS]
