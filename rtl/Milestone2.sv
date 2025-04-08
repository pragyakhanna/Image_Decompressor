`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"
`include "dual_port_RAM0.v"
`include "dual_port_RAM1.v"
`include "dual_port_RAM2.v"


module Milestone2 (

	input logic Clock,
	input logic Resetn,
	input logic Enable,
	
	
	input  logic [15:0] SRAM_read_data,
	output logic [15:0] SRAM_write_data,
	output logic [17:0] SRAM_address,	
	output logic SRAM_we_n,
	
	output logic M2_finish

);



logic [6:0] address_1[2:0];
logic [6:0] address_2[2:0];
logic [31:0] write_data_a[2:0] ;
logic [31:0] write_data_b[2:0];
logic write_enable_a[2:0];
logic write_enable_b[2:0];
logic [31:0] read_data_a[2:0];
logic [31:0] read_data_b[2:0];


// instantiate RAM1

// instantiate RAM1                       //RAM2
dual_port_RAM0 dpram_0 (
	.address_a ( address_1[0]),
	.address_b ( address_2[0] ),
	.clock ( Clock ),
	.data_a ( write_data_a[0] ),
	.data_b ( write_data_b[0] ),
	.wren_a ( write_enable_a[0]),
	.wren_b ( write_enable_b[0] ),
	.q_a ( read_data_a[0]),
	.q_b ( read_data_b[0])
	);

	
// instantiate RAM1                       //RAM2
dual_port_RAM1 dpram_1 (
	.address_a ( address_1[1]),
	.address_b ( address_2[1] ),
	.clock ( Clock ),
	.data_a ( write_data_a[1] ),
	.data_b ( write_data_b[1] ),
	.wren_a ( write_enable_a[1]),
	.wren_b ( write_enable_b[1] ),
	.q_a ( read_data_a[1]),
	.q_b ( read_data_b[1])
	);


dual_port_RAM2 dpram_2 (
	.address_a ( address_1[2]),
	.address_b ( address_2[2] ),
	.clock ( Clock ),
	.data_a ( write_data_a[2] ),
	.data_b ( write_data_b[2] ),
	.wren_a ( write_enable_a[2]),
	.wren_b ( write_enable_b[2] ),
	.q_a ( read_data_a[2]),
	.q_b ( read_data_b[2])
	);




M2_state_name M2_state;

// Base address 
parameter int Start_base_address = 18'd76800;
parameter int c0 = 7'd0;
parameter int c1 = 7'd8;
parameter int c2 = 7'd16;
parameter int c3 = 7'd24;
parameter int c4 = 7'd32;
parameter int c5 = 7'd40;
parameter int c6 = 7'd48;
parameter int c7 = 7'd56;


parameter int c0_cs = 7'd0;
parameter int c1_cs = 7'd8;
parameter int c2_cs = 7'd16;
parameter int c3_cs = 7'd24;
parameter int c4_cs = 7'd32;
parameter int c5_cs = 7'd40;
parameter int c6_cs = 7'd48;
parameter int c7_cs = 7'd56;

//Made variables
logic [31:0] Base_address;
logic [31:0] Address;
logic [31:0] Buffer1;
logic [15:0] Y_row_counter;
logic [9:0] Y_col_counter;
logic [9:0] Block_row;
logic [9:0] Block_col;
logic [9:0] Block_count;
logic [15:0] dp_ram_1_write_counter;
logic [9:0] dp_ram_2_write_counter;
logic [9:0] dp_ram_0_write_counter;
logic [6:0] C_index_0;
logic [6:0] C_index_1;
logic [6:0] C_index_2;
logic[31:0] C_val;
logic[31:0] C_val_2;
logic[31:0] C_val_3;
logic CT_ws_flag;
logic Cs_fs_flag;
logic [31:0] T_even;
logic [31:0] T_odd;
logic[7:0] Write_t_address;

logic [15:0] counter;
logic [15:0] counter_2;

logic [7:0] add_1;
logic [7:0] add_2;
logic [7:0] add_3;
logic [7:0] add_4;



logic[7:0] read_add_ram1_1;
logic[7:0] read_add_ram1_2;
logic seven_column_flag;

logic [15:0] s_0;
logic [15:0] s_1;
logic [15:0] s_2;
logic [15:0] s_3;
logic [15:0] s_4;
logic [15:0] s_5;
logic [15:0] s_6;
logic [15:0] s_7;

logic [31:0]  mult_op1,mult_op2,mult_op3,mult_op4,mult_op5,mult_op6;
logic [31:0] multiresult1,multiresult2,multiresult3;
logic[63:0] multi1_long,multi2_long,multi3_long;

//CS variables
logic [31:0] t_0;
logic [31:0] t_1;
logic [31:0] t_2;
logic [31:0] t_3;
logic [31:0] t_4;
logic [31:0] t_5;
logic [31:0] t_6;
logic [31:0] t_7;
logic [31:0] c_0;
logic [31:0] c_1;
logic [31:0] c_2;
logic [31:0] c_3;
logic [31:0] c_4;
logic [31:0] c_5;
logic [31:0] c_6;
logic [31:0] c_7;

logic [31:0] S_even;
logic [31:0] S_odd;
logic[7:0] read_add_ram2_1;
logic[7:0] read_add_ram2_2;




//end of made variables


assign multi1_long = mult_op1*mult_op2;
assign multiresult1 = $signed(multi1_long[31:0]);  //1st multiplier


assign multi2_long = mult_op3*mult_op4;
assign multiresult2 = $signed(multi2_long[31:0]);  //2nd multiplier
 

assign multi3_long = mult_op5*mult_op6;
assign multiresult3 = $signed(multi3_long[31:0]);  //3rd multiplier


logic [31:0] multireg1,multireg2,multireg3;


 

assign Base_address = Start_base_address + Block_row + Block_col;



always_comb begin
	if(M2_state == CT_0 || M2_state == CT_3)begin
      C_index_0 = c0 + counter;
      C_index_1 = c1 + counter;
      C_index_2 = c2 + counter;
		mult_op1 = $signed(s_0);
		mult_op2 = C_val;
		mult_op3 = $signed(s_1);
		mult_op4 = C_val_2;
		mult_op5 = $signed(s_2);
		mult_op6 = C_val_3;
	
	end

    else if(M2_state == CT_1 || M2_state == CT_4)begin
      C_index_0 = c3 + counter;
      C_index_1 = c4 + counter;
      C_index_2 = c5 + counter; 
		mult_op1 = $signed(s_3);
		mult_op2 = C_val;
		mult_op3 = $signed(s_4);
		mult_op4 = C_val_2;
		mult_op5 = $signed(s_5);
		mult_op6 = C_val_3;
	
	end

    else if(M2_state == CT_2 || M2_state == CT_5)begin
      C_index_0 = c6 + counter;
      C_index_1 = c7 + counter;
		C_index_2 = c5 + counter;
		mult_op1 = $signed(s_6);
		mult_op2 = C_val;
		mult_op3 = $signed(s_7);
		mult_op4 = C_val_2;
      mult_op5 = 31'd0;
		mult_op6 = 31'd0;
	end
	
	//-------------------------------CS calculations----------------------------------------
	else if(M2_state == CS_0 || M2_state == CS_3)begin
      C_index_0 = c0_cs;
      C_index_1 = c1_cs;
      C_index_2 = c2_cs;
		mult_op1 = $signed(t_0);
		mult_op2 = C_val;
		mult_op3 = $signed(t_1);
		mult_op4 = C_val_2;
		mult_op5 = $signed(t_2);
		mult_op6 = C_val_3;
	
	end

    else if(M2_state == CS_1 || M2_state == CS_4)begin
      C_index_0 = c3_cs;
      C_index_1 = c4_cs;
      C_index_2 = c5_cs; 
		mult_op1 = $signed(t_3);
		mult_op2 = C_val;
		mult_op3 = $signed(t_4);
		mult_op4 = C_val_2;
		mult_op5 = $signed(t_5);
		mult_op6 = C_val_3;
	
	end

    else if(M2_state == CS_2 || M2_state == CS_5)begin
      C_index_0 = c6_cs;
      C_index_1 = c7_cs;
		C_index_2 = c5_cs;
		mult_op1 = $signed(t_6);
		mult_op2 = C_val;
		mult_op3 = $signed(t_7);
		mult_op4 = C_val_2;
      mult_op5 = 31'd0;
		mult_op6 = 31'd0;
	end
	
	
	
	//-----------------------------------------------------------------------------------
	else begin
		C_index_0 = 7'd0;
      C_index_1 = 7'd0;
      C_index_2 = 7'd0;
		mult_op1 = 31'd0;
		mult_op2 = 31'd0;
		mult_op3 = 31'd0;
		mult_op4 = 31'd0;
		mult_op5 = 31'd0;
		mult_op6 = 31'd0;
	end
	
end


always_comb begin
    case(C_index_0)
	0:   C_val = 32'sd1448;   //C00
	1:   C_val = 32'sd1448;   //C01
	2:   C_val = 32'sd1448;   //C02
	3:   C_val = 32'sd1448;   //C03
	4:   C_val = 32'sd1448;   //C04
	5:   C_val = 32'sd1448;   //C05
	6:   C_val = 32'sd1448;   //C06
	7:   C_val = 32'sd1448;   //C07
	8:   C_val = 32'sd2008;   //C10
	9:   C_val = 32'sd1702;   //C11
	10:  C_val = 32'sd1137;   //C12
	11:  C_val = 32'sd399;    //C13
	12:  C_val = -32'sd399;   //C14
	13:  C_val = -32'sd1137;  //C15
	14:  C_val = -32'sd1702;  //C16
	15:  C_val = -32'sd2008;  //C17
	16:  C_val = 32'sd1892;   //C20
	17:  C_val = 32'sd783;    //C21
	18:  C_val = -32'sd783;   //C22
	19:  C_val = -32'sd1892;  //C23
	20:  C_val = -32'sd1892;  //C24
	21:  C_val = -32'sd783;   //C25
	22:  C_val = 32'sd783;    //C26
	23:  C_val = 32'sd1892;   //C27
	24:  C_val = 32'sd1702;   //C30
	25:  C_val = -32'sd399;   //C31
	26:  C_val = -32'sd2008;  //C32
	27:  C_val = -32'sd1137;  //C33
	28:  C_val = 32'sd1137;   //C34
	29:  C_val = 32'sd2008;   //C35
	30:  C_val = 32'sd399;    //C36
	31:  C_val = -32'sd1702;  //C37
	32:  C_val = 32'sd1448;   //C40
	33:  C_val = -32'sd1448;  //C41
	34:  C_val = -32'sd1448;  //C42
	35:  C_val = 32'sd1448;   //C43
	36:  C_val = 32'sd1448;   //C44
	37:  C_val = -32'sd1448;  //C45
	38:  C_val = -32'sd1448;  //C46
	39:  C_val = 32'sd1448;   //C47
	40:  C_val = 32'sd1137;   //C50
	41:  C_val = -32'sd2008;  //C51
	42:  C_val = 32'sd399;    //C52
	43:  C_val = 32'sd1702;   //C53
	44:  C_val = -32'sd1702;  //C54
	45:  C_val = -32'sd399;   //C55
	46:  C_val = 32'sd2008;   //C56
	47:  C_val = -32'sd1137;  //C57
	48:  C_val = 32'sd783;    //C60
	49:  C_val = -32'sd1892;  //C61
	50:  C_val = 32'sd1892;   //C62
	51:  C_val = -32'sd783;   //C63
	52:  C_val = -32'sd783;   //C64
	53:  C_val = 32'sd1892;   //C65
	54:  C_val = -32'sd1892;  //C66
	55:  C_val = 32'sd783;    //C67
	56:  C_val = 32'sd399;    //C70
    57:  C_val = -32'sd1137;  //C71
    58:  C_val = 32'sd1702;   //C72
    59:  C_val = -32'sd2008;  //C73
    60:  C_val = 32'sd2008;   //C74
    61:  C_val = -32'sd1702;  //C75
    62:  C_val = 32'sd1137;   //C76
    63:  C_val = -32'sd399;   //C77
	 default: C_val = 32'd0; 
    endcase   
end


always_comb begin
    case(C_index_1)
    1:   C_val_2 = 32'sd1448;   //C01
	2:   C_val_2 = 32'sd1448;   //C02
	3:   C_val_2 = 32'sd1448;   //C03
	4:   C_val_2 = 32'sd1448;   //C04
	5:   C_val_2 = 32'sd1448;   //C05
	6:   C_val_2 = 32'sd1448;   //C06
	7:   C_val_2 = 32'sd1448;   //C07
	8:   C_val_2 = 32'sd2008;   //C10
	9:   C_val_2 = 32'sd1702;   //C11
	10:  C_val_2 = 32'sd1137;   //C12
	11:  C_val_2 = 32'sd399;    //C13
	12:  C_val_2 = -32'sd399;   //C14
	13:  C_val_2 = -32'sd1137;  //C15
	14:  C_val_2 = -32'sd1702;  //C16
	15:  C_val_2 = -32'sd2008;  //C17
	16:  C_val_2 = 32'sd1892;   //C20
	17:  C_val_2 = 32'sd783;    //C21
	18:  C_val_2 = -32'sd783;   //C22
	19:  C_val_2 = -32'sd1892;  //C23
	20:  C_val_2 = -32'sd1892;  //C24
	21:  C_val_2 = -32'sd783;   //C25
	22:  C_val_2 = 32'sd783;    //C26
	23:  C_val_2 = 32'sd1892;   //C27
	24:  C_val_2 = 32'sd1702;   //C30
	25:  C_val_2 = -32'sd399;   //C31
	26:  C_val_2 = -32'sd2008;  //C32
	27:  C_val_2 = -32'sd1137;  //C33
	28:  C_val_2 = 32'sd1137;   //C34
	29:  C_val_2 = 32'sd2008;   //C35
	30:  C_val_2 = 32'sd399;    //C36
	31:  C_val_2 = -32'sd1702;  //C37
	32:  C_val_2 = 32'sd1448;   //C40
	33:  C_val_2 = -32'sd1448;  //C41
	34:  C_val_2 = -32'sd1448;  //C42
	35:  C_val_2 = 32'sd1448;   //C43
	36:  C_val_2 = 32'sd1448;   //C44
	37:  C_val_2 = -32'sd1448;  //C45
	38:  C_val_2 = -32'sd1448;  //C46
	39:  C_val_2 = 32'sd1448;   //C47
	40:  C_val_2 = 32'sd1137;   //C50
	41:  C_val_2 = -32'sd2008;  //C51
	42:  C_val_2 = 32'sd399;    //C52
	43:  C_val_2 = 32'sd1702;   //C53
	44:  C_val_2 = -32'sd1702;  //C54
	45:  C_val_2 = -32'sd399;   //C55
	46:  C_val_2 = 32'sd2008;   //C56
	47:  C_val_2 = -32'sd1137;  //C57
	48:  C_val_2 = 32'sd783;    //C60
	49:  C_val_2 = -32'sd1892;  //C61
	50:  C_val_2 = 32'sd1892;   //C62
	51:  C_val_2 = -32'sd783;   //C63
	52:  C_val_2 = -32'sd783;   //C64
	53:  C_val_2 = 32'sd1892;   //C65
	54:  C_val_2 = -32'sd1892;  //C66
	55:  C_val_2 = 32'sd783;    //C67
	56:  C_val_2 = 32'sd399;    //C70
    57:  C_val_2 = -32'sd1137;  //C71
    58:  C_val_2 = 32'sd1702;   //C72
    59:  C_val_2 = -32'sd2008;  //C73
    60:  C_val_2 = 32'sd2008;   //C74
    61:  C_val_2 = -32'sd1702;  //C75
    62:  C_val_2 = 32'sd1137;   //C76
    63:  C_val_2 = -32'sd399;   //C77
	 default: C_val_2 = 32'd0;
    endcase   
end


always_comb begin
    case(C_index_2)
    1:   C_val_3 = 32'sd1448;   //C01
	2:   C_val_3 = 32'sd1448;   //C02
	3:   C_val_3 = 32'sd1448;   //C03
	4:   C_val_3 = 32'sd1448;   //C04
	5:   C_val_3 = 32'sd1448;   //C05
	6:   C_val_3 = 32'sd1448;   //C06
	7:   C_val_3 = 32'sd1448;   //C07
	8:   C_val_3 = 32'sd2008;   //C10
	9:   C_val_3 = 32'sd1702;   //C11
	10:  C_val_3 = 32'sd1137;   //C12
	11:  C_val_3 = 32'sd399;    //C13
	12:  C_val_3 = -32'sd399;   //C14
	13:  C_val_3 = -32'sd1137;  //C15
	14:  C_val_3 = -32'sd1702;  //C16
	15:  C_val_3 = -32'sd2008;  //C17
	16:  C_val_3 = 32'sd1892;   //C20
	17:  C_val_3 = 32'sd783;    //C21
	18:  C_val_3 = -32'sd783;   //C22
	19:  C_val_3 = -32'sd1892;  //C23
	20:  C_val_3 = -32'sd1892;  //C24
	21:  C_val_3 = -32'sd783;   //C25
	22:  C_val_3 = 32'sd783;    //C26
	23:  C_val_3 = 32'sd1892;   //C27
	24:  C_val_3 = 32'sd1702;   //C30
	25:  C_val_3 = -32'sd399;   //C31
	26:  C_val_3 = -32'sd2008;  //C32
	27:  C_val_3 = -32'sd1137;  //C33
	28:  C_val_3 = 32'sd1137;   //C34
	29:  C_val_3 = 32'sd2008;   //C35
	30:  C_val_3 = 32'sd399;    //C36
	31:  C_val_3 = -32'sd1702;  //C37
	32:  C_val_3 = 32'sd1448;   //C40
	33:  C_val_3 = -32'sd1448;  //C41
	34:  C_val_3 = -32'sd1448;  //C42
	35:  C_val_3 = 32'sd1448;   //C43
	36:  C_val_3 = 32'sd1448;   //C44
	37:  C_val_3 = -32'sd1448;  //C45
	38:  C_val_3 = -32'sd1448;  //C46
	39:  C_val_3 = 32'sd1448;   //C47
	40:  C_val_3 = 32'sd1137;   //C50
	41:  C_val_3 = -32'sd2008;  //C51
	42:  C_val_3 = 32'sd399;    //C52
	43:  C_val_3 = 32'sd1702;   //C53
	44:  C_val_3 = -32'sd1702;  //C54
	45:  C_val_3 = -32'sd399;   //C55
	46:  C_val_3 = 32'sd2008;   //C56
	47:  C_val_3 = -32'sd1137;  //C57
	48:  C_val_3 = 32'sd783;    //C60
	49:  C_val_3 = -32'sd1892;  //C61
	50:  C_val_3 = 32'sd1892;   //C62
	51:  C_val_3 = -32'sd783;   //C63
	52:  C_val_3 = -32'sd783;   //C64
	53:  C_val_3 = 32'sd1892;   //C65
	54:  C_val_3 = -32'sd1892;  //C66
	55:  C_val_3 = 32'sd783;    //C67
	56:  C_val_3 = 32'sd399;    //C70
    57:  C_val_3 = -32'sd1137;  //C71
    58:  C_val_3 = 32'sd1702;   //C72
    59:  C_val_3 = -32'sd2008;  //C73
    60:  C_val_3 = 32'sd2008;   //C74
    61:  C_val_3 = -32'sd1702;  //C75
    62:  C_val_3 = 32'sd1137;   //C76
    63:  C_val_3 = -32'sd399;   //C77
	 default: C_val_3 = 32'd0;
    endcase   
end

//Main
always_ff @(posedge Clock or negedge Resetn) begin
    if (~Resetn) begin
        SRAM_we_n <= 1'b1;
		  M2_finish <=1'b0;
        SRAM_write_data <= 16'd0;
        SRAM_address <= 16'd0;
        Y_col_counter <= 10'd0;
        Y_row_counter <= 10'd0;
        Block_col <= 10'd0;
        Block_row <= 10'd0;
        seven_column_flag <= 1'b0;
        dp_ram_2_write_counter <= 10'd0;
		  dp_ram_0_write_counter <= 10'd0;
        M2_state <= S_IDLE_M2;
    end else begin
	 
		  case (M2_state)
		  
			S_IDLE_M2: begin
				if (Enable) begin
					M2_state <= FS_0;
                    SRAM_we_n <= 1'b1;
                    Y_col_counter <= 10'd0;
                    Y_row_counter <= 10'd0;
                    Block_col <= 10'd0;
                    Block_row <= 10'd0;
						  counter <= 16'd0;
						  counter_2 <= 16'd0;
						  dp_ram_1_write_counter<= 16'd0;
						  add_1 <= 7'd0;
						  add_2 <= 7'd0;
						  add_3 <= 7'd0;
						  add_4 <= 7'd0;
						  read_add_ram1_1 <= 8'd0;
						  read_add_ram1_2 <= 8'd1;
						  read_add_ram2_1 <= 8'd0;
						  read_add_ram2_2 <= 8'd1;
						  address_1[1] <= 7'd0;
						  add_1 <= 7'd0;
						  add_2 <= 7'd8;
						  add_3 <= 7'd16;
						  add_4 <= 7'd24;
						  c_0 <= 32'd0;
						  c_1 <= 32'd0;
						  c_2 <= 32'd0;
						  c_3 <= 32'd0;
						  c_4 <= 32'd0;
						  c_5 <= 32'd0;
						  c_6 <= 32'd0;
						  c_7 <= 32'd0;
						  
				
						  
				end
			end
			
//fills dpram0
            FS_0:begin 
                SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
                M2_state <= FS_1;
            end

             FS_1:begin 
                SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
                M2_state <= FS_2;
            end

             FS_2:begin
				SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
	
                M2_state <= FS_3;
            end

             FS_3:begin
				SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
                Buffer1 <= SRAM_read_data;
                

                M2_state <= FS_4;
                
            end


            FS_4:begin 
                SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
					 
                write_enable_a[0] <= 1'b1;
                write_data_a[0] <= {Buffer1,SRAM_read_data};        //write in sram0
                address_1[0] <= dp_ram_1_write_counter;
                dp_ram_1_write_counter <= dp_ram_1_write_counter + 16'd1;
					 
					 
                M2_state <= FS_5;
            end

            FS_5:begin 
					 write_enable_a[0] <= 1'b0;
                SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
                Buffer1 <= SRAM_read_data;
                M2_state <= FS_6;
            end

             FS_6:begin 
                SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <= Y_col_counter + 1'd1; 
                SRAM_we_n <= 1'b1;
					 
                write_enable_a[0] <= 1'b1;
                write_data_a[0] <= {Buffer1,SRAM_read_data};
                address_1[0] <= dp_ram_1_write_counter;
                dp_ram_1_write_counter <= dp_ram_1_write_counter + 16'd1;
                M2_state <= FS_7;
            end

            FS_7:begin
					 write_enable_a[0] <= 1'b0;
                SRAM_address <= Base_address + Y_col_counter + Y_row_counter;
                Y_col_counter <=10'd0;
					 Y_row_counter <= Y_row_counter + 16'd320;
                SRAM_we_n <= 1'b1;
                Buffer1 <= SRAM_read_data;
                M2_state <= FS_8;
                
            end

             FS_8:begin 
                
                SRAM_we_n <= 1'b1;
                write_enable_a[0] <= 1'b1;
                write_data_a[0] <= {Buffer1,SRAM_read_data};
                address_1[0] <= dp_ram_1_write_counter;
                dp_ram_1_write_counter <= dp_ram_1_write_counter + 16'd1;
                M2_state <= FS_9;
            end
				
				FS_9:begin 
					 write_enable_a[0] <= 1'b0;
                Buffer1 <= SRAM_read_data;
                M2_state <= FS_10;
                
            end
				
				


             FS_10:begin 
                write_enable_a[0] <= 1'b1;
                write_data_a[0] <= {Buffer1,SRAM_read_data};
                address_1[0] <= dp_ram_1_write_counter;
                dp_ram_1_write_counter <= dp_ram_1_write_counter + 16'd1;
					 if (Y_row_counter == 16'd2560) begin
                Block_col <= Block_col + 10'd8;
					 Y_row_counter <= 10'd0;
                Block_count <= Block_count + 10'd1;
                
                M2_state <= CT_L0;end
					else begin
					 M2_state <= FS_0;
					end
                
            end

//----------------------------------------------------------------------First Fs After this FS will happen with Cs---------------------------------------------------------------------------------------------------------------------------------------------
//reads dpram0 and fills dpram1
          
			  CT_L0:begin
			  
            address_1[0] <= read_add_ram1_1;
				read_add_ram1_1 <= read_add_ram1_1 + 8'd2;
				
				address_2[0] <= read_add_ram1_2;
				read_add_ram1_2 <= read_add_ram1_2 + 8'd2;
				
				write_enable_a[0] <= 1'b0;
				write_enable_b[0] <= 1'b0;
				
            M2_state <= CT_L1; 
            end
				
				
				CT_L1:begin
				
             address_1[0] <= read_add_ram1_1;
             read_add_ram1_1 <= read_add_ram1_1 + 8'd2;
				 
             address_2[0] <= read_add_ram1_2;
             read_add_ram1_2 <= read_add_ram1_2 + 8'd2;
				 
             M2_state <= CT_L2; 
            end

            CT_L2:begin

             s_0 <= read_data_a[0][31:16];
             s_1 <= read_data_a[0][15:0];
             s_2 <= read_data_b[0][31:16];
             s_3 <= read_data_b[0][15:0];
             M2_state <= CT_L3; 
            end

            CT_L3:begin
             s_4 <= read_data_a[0][31:16];
             s_5 <= read_data_a[0][15:0];
             s_6 <= read_data_b[0][31:16];
             s_7 <= read_data_b[0][15:0];
             M2_state <= CT_0; 
            end

            CT_0: begin
            T_even <= $signed(multiresult1 + multiresult2 + multiresult3);
				
            if (seven_column_flag == 1'b1)begin 
             s_4 <= read_data_a[0][31:16];
             s_5 <= read_data_a[0][15:0];
             s_6 <= read_data_b[0][31:16];
             s_7 <= read_data_b[0][15:0];
	
             seven_column_flag <= 1'b0;
            end
				
				
				M2_state <= CT_1; 

            end

            CT_1: begin
            T_even <= $signed(T_even +  multiresult1 + multiresult2 + multiresult3);

            M2_state <= CT_2; 
            end

            CT_2: begin
				
            if (address_1[1] <= 7'd30) begin 
            address_1[1] <= dp_ram_2_write_counter;
				write_enable_a[1] <= 1'b1;
				write_data_a[1] <= ($signed(T_even +  multiresult1 + multiresult2)>>>8);
				
				if (address_1[1] == 7'd30) begin
				dp_ram_2_write_counter <= 10'd0; end else begin
				dp_ram_2_write_counter <= dp_ram_2_write_counter + 10'd1; 
				end
				
				end
				else begin 
				address_1[2] <= dp_ram_2_write_counter;
				write_enable_a[2] <= 1'b1;
				write_data_a[2] <= ($signed(T_even +  multiresult1 + multiresult2)>>>8);
            dp_ram_2_write_counter <= dp_ram_2_write_counter + 10'd1;
				
				end
				
				
            counter <= counter + 8'd1;
				M2_state <= CT_3; 
            
            end


            CT_3: begin
            T_odd <= $signed(multiresult1 + multiresult2 + multiresult3);
				write_enable_a[1] <= 1'b0;
				write_enable_a[2] <= 1'b0;
				if (counter == 8'd7)begin
             address_1[0] <= read_add_ram1_1;
             read_add_ram1_1 <= read_add_ram1_1 + 8'd2;
             address_2[0] <= read_add_ram1_2;
             read_add_ram1_2 <= read_add_ram1_2 + 8'd2;
            end
				
				M2_state <= CT_4; 

            end

            CT_4: begin
            T_odd <= $signed(T_odd +  multiresult1 + multiresult2 + multiresult3);
            write_enable_a[1] <= 1'b0;
				
            if (counter == 8'd7)begin
					 address_1[0] <= read_add_ram1_1;
                read_add_ram1_1 <= read_add_ram1_1 + 8'd2;
                address_2[0] <= read_add_ram1_2;
                read_add_ram1_2 <= read_add_ram1_2 + 8'd2;end
					 
				M2_state <= CT_5;
            end

            CT_5: begin
				
            if (address_1[1] <= 7'd30) begin
				
            address_1[1] <= dp_ram_2_write_counter;
				write_enable_a[1] <= 1'b1;
				write_data_a[1] <= ($signed(T_even +  multiresult1 + multiresult2)>>>8);
            dp_ram_2_write_counter <= 10'd0;
				
				if (address_1[1] == 7'd30) begin
				dp_ram_2_write_counter <= 10'd0; end else begin
				dp_ram_2_write_counter <= dp_ram_2_write_counter + 10'd1; 
				end
				
				end
				else begin 
				address_1[2] <= dp_ram_2_write_counter;
				write_enable_a[2] <= 1'b1;
				write_data_a[2] <= ($signed(T_even +  multiresult1 + multiresult2)>>>8);
            dp_ram_2_write_counter <= dp_ram_2_write_counter + 10'd1;
				end
				
				
            write_data_a[1] <= ($signed(T_odd +  multiresult1 + multiresult2)>>>8);
            
            if (counter == 8'd7)begin
                counter <= 8'd0;
					 s_0 <= read_data_a[0][31:16];
                s_1 <= read_data_a[0][15:0];
                s_2 <= read_data_b[0][31:16];
                s_3 <= read_data_b[0][15:0];
					 seven_column_flag <= 1'b1;
					 M2_state <= CT_0;
					 
            end 
				
				else begin
                counter <= counter + 8'd1;
					 M2_state <= CT_0;
                
            end
				
				if ((address_1[1] + address_1[2]) == 10'd61)begin
					//address_3 <= 10'd0;
					 M2_state <= TEST;
				end

            
            end
				
				TEST: begin 
				
				M2_state <= CS_L0;
				
			
				end

 //-------------------------------------------------------------------------------------------------CT done-------------------------------------------------------------------------------------------------------------------------------
			CS_L0: begin
			write_enable_a[1] <= 1'b0;
			write_enable_b[1] <= 1'b0;
			
			write_enable_a[2] <= 1'b0;
			write_enable_b[2] <= 1'b0;
			
			address_1[1] <= add_1;
			address_1[2] <= add_1;
			add_1 <= add_1 + 7'd1;
			
			address_2[1] <= add_2;
			address_2[2] <= add_2;
			add_2 <= add_2 + 7'd1;
			
			M2_state <= CS_L1;
		 
		 end
		 
		 CS_L1: begin
			write_enable_a[1] <= 1'b0;
			write_enable_b[1] <= 1'b0;
			
			write_enable_a[2] <= 1'b0;
			write_enable_b[2] <= 1'b0;
			
			address_1[1] <= add_3;
			address_1[2] <= add_3;
			add_3 <= add_3 + 7'd1;
			
			address_2[1] <= add_4;
			address_2[2] <= add_4;
			add_4 <= add_4 + 7'd1;
			
			M2_state <= CS_L2;
		 
		 end
		 
		 
		  CS_L2: begin
			t_0 <= read_data_a[1];
		   t_1 <= read_data_b[1];	
			
			t_4 <= read_data_a[2];
			t_5 <= read_data_b[2];
			M2_state <= CS_L3;
			end
			
		  CS_L3: begin
			t_2 <= read_data_a[1];
		   t_3 <= read_data_b[1];	
			
			t_6 <= read_data_a[2];
			t_7 <= read_data_b[2];
			M2_state <= CS_0;	
		end
		 
		 
		
		 CS_0: begin
		 
		 S_even <= $signed(multiresult1 + multiresult2 + multiresult3);
		 
		 address_1[1] <= add_1;
		 address_1[2] <= add_1;
		 add_1 <= add_1 + 7'd1;	
		 address_2[1] <= add_2;
		 address_2[2] <= add_2;
		 add_2 <= add_2 + 7'd1;
		 
		 M2_state <= CS_1;
		
		 end
		 
		 
		 CS_1: begin
		 S_even <= $signed(S_even +  multiresult1 + multiresult2 + multiresult3);
		 
		 write_enable_a[1] <= 1'b0;
		 write_enable_b[1] <= 1'b0;
			
		 write_enable_a[2] <= 1'b0;
		 write_enable_b[2] <= 1'b0;
			
		 address_1[1] <= add_3;
		 address_1[2] <= add_3;
		 add_3 <= add_3 + 7'd1;
			
		 address_2[1] <= add_4;
		 address_2[2] <= add_4;
		 add_4 <= add_4 + 7'd1;
		 
		 M2_state <= CS_2;
		
		 
		 end
		 
		 
		 CS_2: begin
		 address_1[1] <= add_1;
		 address_1[2] <= add_1;
		 add_1 <= add_1 + 7'd1;	
		 address_2[1] <= add_2;
		 address_2[2] <= add_2;
		 add_2 <= add_2 + 7'd1;
		 
		 t_0 <= read_data_a[1];
		 t_1 <= read_data_b[1];	
			
		 t_4 <= read_data_a[2];
		 t_5 <= read_data_b[2];
		 
		 S_even <= $signed(S_even +  multiresult1 + multiresult2)>>>16;
		
		 
		 M2_state <= CS_3;
		 end
		 
		 CS_3: begin
		 S_odd <= $signed(multiresult1 + multiresult2 + multiresult3);
		 write_enable_a[1] <= 1'b0;
		 write_enable_b[1] <= 1'b0;
			
		 write_enable_a[2] <= 1'b0;
		 write_enable_b[2] <= 1'b0;
			
		 address_1[1] <= add_3;
		 address_1[2] <= add_3;
		 add_3 <= add_3 + 7'd1;
			
		 address_2[1] <= add_4;
		 address_2[2] <= add_4;
		 add_4 <= add_4 + 7'd1;
		
		 t_2 <= read_data_a[1];
		 t_3 <= read_data_b[1];	
			
	    t_6 <= read_data_a[2];
		 t_7 <= read_data_b[2];
		 M2_state <= CS_4;
		 end
		 
		 CS_4:begin
		  S_odd <= $signed(S_odd + multiresult1 + multiresult2 + multiresult3);
		 t_0 <= read_data_a[1];
		   t_1 <= read_data_b[1];	
			
			t_4 <= read_data_a[2];
			t_5 <= read_data_b[2];
		 
		 M2_state <= CS_5;
		 end
		 
		 CS_5:begin
			S_odd <= $signed(S_odd + multiresult1 + multiresult2)>>>16;
		 	t_2 <= read_data_a[1];
		   t_3 <= read_data_b[1];	
			
			t_6 <= read_data_a[2];
			t_7 <= read_data_b[2];
			counter_2 <= counter_2 + 16'd2;
			if (counter_2 == 16'd8) begin 
			   M2_finish <= 1'b1;
				counter_2 <= 16'd0;
				M2_state <= TEST2;
			end else begin
			M2_state <= CS_0;end 
			
			
		 end
		 
		 TEST2:begin 
		 
		 
		 end
		 
		 
//--------------------------------finish----------------------------------------------------------------
			
			default: M2_state <= S_IDLE_M2;
			endcase
		end
	end




endmodule