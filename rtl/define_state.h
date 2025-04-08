`ifndef DEFINE_STATE

	// for top state - we have more states than needed
	typedef enum logic [1:0]{
		S_IDLE,
		S_UART_RX,
		S_M1,
		S_M2} top_state_type;

typedef enum logic [1:0]{
	S_RXC_IDLE,
	S_RXC_SYNC,
	S_RXC_ASSEMBLE_DATA,
	S_RXC_STOP_BIT} RX_Controller_state_type;

typedef enum logic [2:0]{
	S_US_IDLE,
	S_US_STRIP_FILE_HEADER_1,
	S_US_STRIP_FILE_HEADER_2,
	S_US_START_FIRST_BYTE_RECEIVE,
	S_US_WRITE_FIRST_BYTE,
	S_US_START_SECOND_BYTE_RECEIVE,
	S_US_WRITE_SECOND_BYTE} UART_SRAM_state_type;

typedef enum logic [3:0]{
	S_VS_WAIT_NEW_PIXEL_ROW,
	S_VS_NEW_PIXEL_ROW_DELAY_1,
	S_VS_NEW_PIXEL_ROW_DELAY_2,
	S_VS_NEW_PIXEL_ROW_DELAY_3,
	S_VS_NEW_PIXEL_ROW_DELAY_4,
	S_VS_NEW_PIXEL_ROW_DELAY_5,
	S_VS_FETCH_PIXEL_DATA_0,
	S_VS_FETCH_PIXEL_DATA_1,
	S_VS_FETCH_PIXEL_DATA_2,
	S_VS_FETCH_PIXEL_DATA_3} VGA_SRAM_state_type;

typedef enum logic [4:0]{
	S_IDLE_M1,
	// Lead in states
	LI0,
	LI1,
	LI2,
	LI3,
	LI4,
	LI5,
	LI6,
	LI7,
	LI8,
	// Common Case
	CC0,
	CC1,
	CC2,
	CC3,
	CC4,
	CC5,
	CC6,
	// LEAD OUT STATES
	LO1,
	DUMMY_CYCLE} M1_state_name;

typedef enum logic [6:0]{
	S_IDLE_M2,
	FS_10,
	FS_0,
	FS_1,
	FS_2,
	FS_3,
	FS_4,
	FS_5,
	FS_6,
	FS_7,
	FS_8,
	FS_9,
	CT_L0,
	CT_L1,
	CT_L2,
	CT_L3,
	CT_0,
	CT_1,
	CT_2,
	CT_3,
	CT_4,
	CT_5,
	CS_L0,
	CS_L1,
	CS_L2,
	CS_L3,
	CS_L4,
	CS_L5,
	CS_0,
	CS_1,
	CS_2,
	CS_3,
	CS_4,
	CS_5,
	TEST,
	TEST2

} M2_state_name;

parameter
	VIEW_AREA_LEFT = 160,
	VIEW_AREA_RIGHT = 480,
	VIEW_AREA_TOP = 120,
	VIEW_AREA_BOTTOM = 360;

`define DEFINE_STATE 1
`endif
