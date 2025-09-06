#pin Assignment

set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_DEVICE_WIDE_RESET OFF
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

########## Clock ##########
set_location_assignment PIN_G21 -to CLOCK_50
set_location_assignment PIN_B12 -to CLOCK_50_2

########## Switch (Up-High, Down-Low) ##########
set_location_assignment PIN_J6 -to SW[0]
set_location_assignment PIN_H5 -to SW[1]
set_location_assignment PIN_H6 -to SW[2]
set_location_assignment PIN_G4 -to SW[3]
set_location_assignment PIN_G5 -to SW[4]
set_location_assignment PIN_J7 -to SW[5]
set_location_assignment PIN_H7 -to SW[6]
set_location_assignment PIN_E3 -to SW[7]
set_location_assignment PIN_E4 -to SW[8]
set_location_assignment PIN_D2 -to SW[9]

########## Button (Active Low) ##########
set_location_assignment PIN_H2 -to BUTTON[0]
set_location_assignment PIN_G3 -to BUTTON[1]
set_location_assignment PIN_F1 -to BUTTON[2]

########## LEDG ##########
set_location_assignment PIN_J1 -to LEDG[0]
set_location_assignment PIN_J2 -to LEDG[1]
set_location_assignment PIN_J3 -to LEDG[2]
set_location_assignment PIN_H1 -to LEDG[3]
set_location_assignment PIN_F2 -to LEDG[4]
set_location_assignment PIN_E1 -to LEDG[5]
set_location_assignment PIN_C1 -to LEDG[6]
set_location_assignment PIN_C2 -to LEDG[7]
set_location_assignment PIN_B2 -to LEDG[8]
set_location_assignment PIN_B1 -to LEDG[9]

########## HEX ##########
set_location_assignment PIN_E11 -to HEX0_D[0]
set_location_assignment PIN_F11 -to HEX0_D[1]
set_location_assignment PIN_H12 -to HEX0_D[2]
set_location_assignment PIN_H13 -to HEX0_D[3]
set_location_assignment PIN_G12 -to HEX0_D[4]
set_location_assignment PIN_F12 -to HEX0_D[5]
set_location_assignment PIN_F13 -to HEX0_D[6]
set_location_assignment PIN_D13 -to HEX0_DP
set_location_assignment PIN_A13 -to HEX1_D[0]
set_location_assignment PIN_B13 -to HEX1_D[1]
set_location_assignment PIN_C13 -to HEX1_D[2]
set_location_assignment PIN_A14 -to HEX1_D[3]
set_location_assignment PIN_B14 -to HEX1_D[4]
set_location_assignment PIN_E14 -to HEX1_D[5]
set_location_assignment PIN_A15 -to HEX1_D[6]
set_location_assignment PIN_B15 -to HEX1_DP
set_location_assignment PIN_D15 -to HEX2_D[0]
set_location_assignment PIN_A16 -to HEX2_D[1]
set_location_assignment PIN_B16 -to HEX2_D[2]
set_location_assignment PIN_E15 -to HEX2_D[3]
set_location_assignment PIN_A17 -to HEX2_D[4]
set_location_assignment PIN_B17 -to HEX2_D[5]
set_location_assignment PIN_F14 -to HEX2_D[6]
set_location_assignment PIN_A18 -to HEX2_DP
set_location_assignment PIN_B18 -to HEX3_D[0]
set_location_assignment PIN_F15 -to HEX3_D[1]
set_location_assignment PIN_A19 -to HEX3_D[2]
set_location_assignment PIN_B19 -to HEX3_D[3]
set_location_assignment PIN_C19 -to HEX3_D[4]
set_location_assignment PIN_D19 -to HEX3_D[5]
set_location_assignment PIN_G15 -to HEX3_D[6]
set_location_assignment PIN_G16 -to HEX3_DP

########## LCD ##########
set_location_assignment PIN_D22 -to LCD_DATA[0]
set_location_assignment PIN_D21 -to LCD_DATA[1]
set_location_assignment PIN_C22 -to LCD_DATA[2]
set_location_assignment PIN_C21 -to LCD_DATA[3]
set_location_assignment PIN_B22 -to LCD_DATA[4]
set_location_assignment PIN_B21 -to LCD_DATA[5]
set_location_assignment PIN_D20 -to LCD_DATA[6]
set_location_assignment PIN_C20 -to LCD_DATA[7]
set_location_assignment PIN_E22 -to LCD_RW
set_location_assignment PIN_E21 -to LCD_EN
set_location_assignment PIN_F22 -to LCD_RS
set_location_assignment PIN_F21 -to LCD_BLON



########## VGA ##########
set_location_assignment PIN_H19 -to VGA_R[0]
set_location_assignment PIN_H17 -to VGA_R[1]
set_location_assignment PIN_H20 -to VGA_R[2]
set_location_assignment PIN_H21 -to VGA_R[3]
set_location_assignment PIN_H22 -to VGA_G[0]
set_location_assignment PIN_J17 -to VGA_G[1]
set_location_assignment PIN_K17 -to VGA_G[2]
set_location_assignment PIN_J21 -to VGA_G[3]
set_location_assignment PIN_K22 -to VGA_B[0]
set_location_assignment PIN_K21 -to VGA_B[1]
set_location_assignment PIN_J22 -to VGA_B[2]
set_location_assignment PIN_K18 -to VGA_B[3]
set_location_assignment PIN_L21 -to VGA_HS
set_location_assignment PIN_L22 -to VGA_VS

########## UART ##########
set_location_assignment PIN_U22 -to UART_RXD
set_location_assignment PIN_U21 -to UART_TXD
set_location_assignment PIN_V21 -to UART_CTS
set_location_assignment PIN_V22 -to UART_RTS

########## PS2 ##########
set_location_assignment PIN_P22 -to PS2_KBCLK
set_location_assignment PIN_P21 -to PS2_KBDAT
set_location_assignment PIN_R21 -to PS2_MSCLK
set_location_assignment PIN_R22 -to PS2_MSDAT

########## SDIO ##########
set_location_assignment PIN_Y21  -to SD_CLK
set_location_assignment PIN_Y22  -to SD_CMD
set_location_assignment PIN_AA22 -to SD_DAT0
set_location_assignment PIN_W21  -to SD_DAT3
set_location_assignment PIN_W20  -to SD_WP_N

########## SDRAM ##########
set_location_assignment PIN_C4  -to DRAM_ADDR[0]
set_location_assignment PIN_A3  -to DRAM_ADDR[1]
set_location_assignment PIN_B3  -to DRAM_ADDR[2]
set_location_assignment PIN_C3  -to DRAM_ADDR[3]
set_location_assignment PIN_A5  -to DRAM_ADDR[4]
set_location_assignment PIN_C6  -to DRAM_ADDR[5]
set_location_assignment PIN_B6  -to DRAM_ADDR[6]
set_location_assignment PIN_A6  -to DRAM_ADDR[7]
set_location_assignment PIN_C7  -to DRAM_ADDR[8]
set_location_assignment PIN_B7  -to DRAM_ADDR[9]
set_location_assignment PIN_B4  -to DRAM_ADDR[10]
set_location_assignment PIN_A7  -to DRAM_ADDR[11]
set_location_assignment PIN_C8  -to DRAM_ADDR[12]
set_location_assignment PIN_D10 -to DRAM_DQ[0]
set_location_assignment PIN_G10 -to DRAM_DQ[1]
set_location_assignment PIN_H10 -to DRAM_DQ[2]
set_location_assignment PIN_E9  -to DRAM_DQ[3]
set_location_assignment PIN_F9  -to DRAM_DQ[4]
set_location_assignment PIN_G9  -to DRAM_DQ[5]
set_location_assignment PIN_H9  -to DRAM_DQ[6]
set_location_assignment PIN_F8  -to DRAM_DQ[7]
set_location_assignment PIN_A8  -to DRAM_DQ[8]
set_location_assignment PIN_B9  -to DRAM_DQ[9]
set_location_assignment PIN_A9  -to DRAM_DQ[10]
set_location_assignment PIN_C10 -to DRAM_DQ[11]
set_location_assignment PIN_B10 -to DRAM_DQ[12]
set_location_assignment PIN_A10 -to DRAM_DQ[13]
set_location_assignment PIN_E10 -to DRAM_DQ[14]
set_location_assignment PIN_F10 -to DRAM_DQ[15]
set_location_assignment PIN_B5  -to DRAM_BA[0]
set_location_assignment PIN_A4  -to DRAM_BA[1]
set_location_assignment PIN_E7  -to DRAM_DQM[0]
set_location_assignment PIN_B8  -to DRAM_DQM[1]
set_location_assignment PIN_F7  -to DRAM_RAS_N
set_location_assignment PIN_G8  -to DRAM_CAS_N
set_location_assignment PIN_E6  -to DRAM_CKE
set_location_assignment PIN_E5  -to DRAM_CLK
set_location_assignment PIN_D6  -to DRAM_WE_N
set_location_assignment PIN_G7  -to DRAM_CS_N

########## Flash ##########
set_location_assignment PIN_P7 -to FL_ADDR[0]
set_location_assignment PIN_P5 -to FL_ADDR[1]
set_location_assignment PIN_P6 -to FL_ADDR[2]
set_location_assignment PIN_N7 -to FL_ADDR[3]
set_location_assignment PIN_N5 -to FL_ADDR[4]
set_location_assignment PIN_N6 -to FL_ADDR[5]
set_location_assignment PIN_M8 -to FL_ADDR[6]
set_location_assignment PIN_M4 -to FL_ADDR[7]
set_location_assignment PIN_P2 -to FL_ADDR[8]
set_location_assignment PIN_N2 -to FL_ADDR[9]
set_location_assignment PIN_N1 -to FL_ADDR[10]
set_location_assignment PIN_M3 -to FL_ADDR[11]
set_location_assignment PIN_M2 -to FL_ADDR[12]
set_location_assignment PIN_M1 -to FL_ADDR[13]
set_location_assignment PIN_L7 -to FL_ADDR[14]
set_location_assignment PIN_L6 -to FL_ADDR[15]
set_location_assignment PIN_AA -to FL_ADDR[16]
set_location_assignment PIN_M5 -to FL_ADDR[17]
set_location_assignment PIN_M6 -to FL_ADDR[18]
set_location_assignment PIN_P1 -to FL_ADDR[19]
set_location_assignment PIN_P3 -to FL_ADDR[20]
set_location_assignment PIN_R2 -to FL_ADDR[21]
set_location_assignment PIN_R7 -to FL_DQ[0]
set_location_assignment PIN_P8 -to FL_DQ[1]
set_location_assignment PIN_R8 -to FL_DQ[2]
set_location_assignment PIN_U1 -to FL_DQ[3]
set_location_assignment PIN_V2 -to FL_DQ[4]
set_location_assignment PIN_V3 -to FL_DQ[5]
set_location_assignment PIN_W1 -to FL_DQ[6]
set_location_assignment PIN_Y1 -to FL_DQ[7]
set_location_assignment PIN_T5 -to FL_DQ[8]
set_location_assignment PIN_T7 -to FL_DQ[9]
set_location_assignment PIN_T4 -to FL_DQ[10]
set_location_assignment PIN_U2 -to FL_DQ[11]
set_location_assignment PIN_V1 -to FL_DQ[12]
set_location_assignment PIN_V4 -to FL_DQ[13]
set_location_assignment PIN_W2 -to FL_DQ[14]
set_location_assignment PIN_Y2 -to FL_DQ[15]
set_location_assignment PIN_AA -to FL_BYTE_N
set_location_assignment PIN_N8 -to FL_CE_N
set_location_assignment PIN_R6 -to FL_OE_N
set_location_assignment PIN_R1 -to FL_RST_N
set_location_assignment PIN_M7 -to FL_RY
set_location_assignment PIN_P4 -to FL_WE_N
set_location_assignment PIN_T3 -to FL_WP_N

########## AS ##########
set_location_assignment PIN_K2 -to AS_CLK
set_location_assignment PIN_D1 -to AS_DO
set_location_assignment PIN_E2 -to AS_CS_N
set_location_assignment PIN_K1 -to AS_DI

