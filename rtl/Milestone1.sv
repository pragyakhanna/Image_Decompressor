`timescale 1ns/100ps

`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

module Milestone1 (

	input logic Clock,
	input logic Resetn,
	input logic Enable,
	
	
	input  logic [15:0] SRAM_read_data,
	output logic [15:0] SRAM_write_data,
	output logic [17:0] SRAM_address,	
	output logic SRAM_we_n,
	
	output logic M1_finish

);

M1_state_name M1_state;

// Base address 
parameter int Y_address_base = 18'd0;
parameter int U_address_base = 18'd38400;
parameter int V_address_base = 18'd57600;
parameter int RGB_address = 18'd146944;


// Registers for address and counter
logic [31:0] RGB_count;
logic [15:0] lead_out_counter;
logic [15:0] Y_count, UV_count;
logic UV_read_flag;
logic cc3_write_flag;
logic last_cycle_flag;
logic done;

//RGB values 

logic [7:0] R_even,G_even,B_even,R_odd,B_odd,G_odd,Y_even,Y_odd;


//UV values
logic [7:0] U_prime_odd,U_prime_even,V_prime_odd,V_prime_even, U_buffer,V_buffer;
logic [7:0] V_buffer_for_prime [5:0];
logic [7:0] U_buffer_for_prime [5:0];


//Multipliers
logic [31:0]  mult_op1,mult_op2,mult_op3,mult_op4,mult_op5,mult_op6;
logic [31:0] multiresult1,multiresult2,multiresult3;
logic[31:0] R_even_temp,G_even_temp,B_even_temp,R_odd_temp,G_odd_temp,B_odd_temp;
logic[31:0] R_even_temp2,G_even_temp2,B_even_temp2,R_odd_temp2,G_odd_temp2,B_odd_temp2;


logic[63:0] multi1_long,multi2_long,multi3_long;


logic [8:0] v1,v2,v3,u1,u2,u3;


assign multi1_long = mult_op1*mult_op2;
assign multiresult1 = multi1_long[31:0];  //1st multiplier


assign multi2_long = mult_op3*mult_op4;
assign multiresult2 = multi2_long[31:0];  //2nd multiplier

logic lead_out_flag;

assign multi3_long = mult_op5*mult_op6;
assign multiresult3 = multi3_long[31:0];  //3rd multiplier


logic [31:0] multireg1,multireg2,multireg3;





always_comb begin
	if(M1_state == CC0)begin
		mult_op1 = v1;
		mult_op2 = 31'd21;
		mult_op3 = v2;
		mult_op4 = 31'd52;
		mult_op5 = v3;
		mult_op6 = 31'd159;
	
	end
	
	else if(M1_state == CC1)begin
		mult_op1 = u1;
		mult_op2 = 31'd21;
		mult_op3 = u2;
		mult_op4 = 31'd52;
		mult_op5 = u3;
		mult_op6 = 31'd159;
	end
	
	else if(M1_state == CC2)begin
		mult_op1 = (Y_even - 31'd16);
		mult_op2 = 31'd76284; //a
		mult_op3 = (V_prime_even - 31'd128);
		mult_op4 = 31'd104595; //c
		mult_op5 = (U_prime_even -31'd128);
		mult_op6 = 31'd25624; //e
	end
	
	
	else if(M1_state == CC3)begin
		mult_op1 = (V_prime_even - 31'd128);
		mult_op2 = 31'd53281; //f 
		mult_op3 = (Y_odd - 31'd16);
		mult_op4 = 31'd76284; //a
		mult_op5 = (U_prime_even -31'd128);
		mult_op6 = 31'd132251; //h
	end
	
	else if(M1_state == CC4)begin
		mult_op1 = (V_prime_odd - 31'd128);
		mult_op2 = 31'd104595; //c
		mult_op3 = (U_prime_odd - 31'd128);
		mult_op4 = 31'd25624; //e
		mult_op5 = (V_prime_odd - 31'd128);
		mult_op6 = 31'd53281;//f
	end
	
	else if(M1_state == CC5)begin
		mult_op1 = (U_prime_odd - 31'd128);
		mult_op2 = 31'd132251;//h
		mult_op3 = 31'd0;
		mult_op4 = 31'd0;
		mult_op5 = 31'd0;
		mult_op6 = 31'd0;
	end
	else begin

		mult_op1 = 31'd0;
		mult_op2 = 31'd0;
		mult_op3 = 31'd0;
		mult_op4 = 31'd0;
		mult_op5 = 31'd0;
		mult_op6 = 31'd0;

	
	end
	
end

always_comb begin
 if ( R_even_temp2[31] == 1'b1)begin 
		R_even = 8'd0;
 end else if (R_even_temp2[31:24]>= 8'd1) begin 
	R_even = 8'd255;
 end
	else begin 
	R_even = R_even_temp2[23:16];
 end

 
 if ( G_even_temp2[31] == 1'b1)begin 
		G_even = 8'd0;
 end else if (G_even_temp2[31:24]>= 8'd1) begin 
	G_even = 8'd255;
 end
	else begin 
	G_even = G_even_temp2[23:16];
 end
 
 
 if ( B_even_temp2[31] == 1'b1)begin 
		B_even = 8'd0;
 end else if (B_even_temp2[31:24]>= 8'd1) begin 
	B_even = 8'd255;
 end
	else begin 
	B_even = B_even_temp2[23:16];
 end
 
 
 if ( R_odd_temp2[31] == 1'b1)begin 
		R_odd = 8'd0;
 end else if (R_odd_temp2[31:24]>= 8'd1) begin 
	R_odd = 8'd255;
 end
	else begin 
	R_odd = R_odd_temp2[23:16];
 end
 
 
  
 if ( B_odd_temp2[31] == 1'b1)begin 
		B_odd = 8'd0;
 end else if (B_odd_temp2[31:24]>= 8'd1) begin 
	B_odd = 8'd255;
 end
	else begin 
	B_odd = B_odd_temp2[23:16];
 end
 
  if ( G_odd_temp2[31] == 1'b1)begin 
		G_odd = 8'd0;
 end else if (G_odd_temp2[31:24]>= 8'd1) begin 
	G_odd = 8'd255;
 end
	else begin 
	G_odd = G_odd_temp2[23:16];
 end
 
end


//Main
always_ff @(posedge Clock or negedge Resetn) begin
    if (~Resetn) begin
        SRAM_we_n <= 1'b1;
		  M1_finish <=1'b0;
        SRAM_write_data <= 16'd0;
        SRAM_address <= 16'd0;
        UV_read_flag <= 1'b0;
        RGB_count <= 16'd0;
        Y_count <= 16'd0;
        UV_count <= 16'd0;
		  lead_out_counter <= 16'd0;
		  cc3_write_flag <=1'b0;
		  last_cycle_flag <= 1'b0;
		  U_prime_odd <= 8'd0;
		  U_prime_even <= 8'd0;
		  V_prime_odd <= 8'd0;
		  V_prime_even <= 8'd0;
		  U_buffer <= 8'd0;
		  V_buffer <= 8'd0;
		  V_buffer_for_prime[0] <= 8'd0;
		  V_buffer_for_prime[1] <= 8'd0;
		  V_buffer_for_prime[2] <= 8'd0;
		  V_buffer_for_prime[3] <= 8'd0;
		  V_buffer_for_prime[4] <= 8'd0;
		  V_buffer_for_prime[5] <= 8'd0;
		  
		  U_buffer_for_prime[0] <= 8'd0;
		  U_buffer_for_prime[1] <= 8'd0;
		  U_buffer_for_prime[2] <= 8'd0;
		  U_buffer_for_prime[3] <= 8'd0;
		  U_buffer_for_prime[4] <= 8'd0;
		  U_buffer_for_prime[5] <= 8'd0;
		  
		  R_even_temp <= 32'd0;
		  G_even_temp <= 32'd0;
		  B_even_temp <= 32'd0;
		  
		  R_odd_temp <= 32'd0;
		  G_odd_temp <= 32'd0;
		  B_odd_temp <= 32'd0;
		  
		  
		  R_even_temp2 <= 32'd0;
		  G_even_temp2 <= 32'd0;
		  B_even_temp2 <= 32'd0;
		  
		  R_odd_temp2 <= 32'd0;
		  G_odd_temp2 <= 32'd0;
		  B_odd_temp2 <= 32'd0;
		  
		  v1 <= 9'd0;
		  v2 <= 9'd0;
		  v3 <= 9'd0;
		  u1 <= 9'd0;
		  u2 <= 9'd0;
		  u3 <= 9'd0;
		  
		  lead_out_flag <= 1'b0;
		  
		  multireg1 <= 32'd0;
		  multireg2 <= 32'd0;
		  multireg3 <= 32'd0;
		  
        M1_state <= S_IDLE_M1;
    end else begin
	 
		  case (M1_state)
		  
			S_IDLE_M1: begin
				if (Enable) begin
					M1_state <= LI0;
					SRAM_we_n <= 1'b1;
					RGB_count <= 16'd0;
					Y_count <= 16'd0;
					UV_count <= 16'd0;
					UV_read_flag <= 1'd1;
					SRAM_address <= 16'd0;
					lead_out_counter <= 16'd0;
					
				end
			end
			
			LI0:begin
			cc3_write_flag <= 1'b0;
			last_cycle_flag <= 1'b1;
			lead_out_flag <= 1'b1;
			SRAM_we_n <= 1'b1;
			SRAM_address <= Y_address_base + Y_count;
			Y_count <= Y_count + 16'd1;//read Y0,Y1
			lead_out_counter <= lead_out_counter + 16'd1;
			
			M1_state <= LI1;
			end
			
			
			LI1:begin
			SRAM_address <= V_address_base + UV_count;  //read V0,V1
			M1_state <= LI2;
			end
			
			
			LI2:begin
			SRAM_address <= U_address_base + UV_count; //read U0,U1
			UV_count <= UV_count + 16'd1;
			M1_state <= LI3;
			end
			
			
			LI3:begin
			SRAM_address <= V_address_base + UV_count; //read V2,V3  store Y0,Y1
			Y_even <= SRAM_read_data[15:8];
			Y_odd <= SRAM_read_data[7:0];
			M1_state <= LI4;
			end
			
			
			LI4:begin
			SRAM_address <= U_address_base + UV_count; //read U2,U3 
			UV_count <= UV_count + 16'd1;
			V_buffer_for_prime[3] <= SRAM_read_data[7:0];
			V_buffer_for_prime[2] <= SRAM_read_data[15:8];
			V_buffer_for_prime[1] <= SRAM_read_data[15:8];
			V_buffer_for_prime[0] <= SRAM_read_data[15:8];
			M1_state <= LI5;
			end
			
			LI5:begin
			U_buffer_for_prime[3] <= SRAM_read_data[7:0];
			U_buffer_for_prime[2] <= SRAM_read_data[15:8];
			U_buffer_for_prime[1] <= SRAM_read_data[15:8];
			U_buffer_for_prime[0] <= SRAM_read_data[15:8];
			M1_state <= LI6;
			end
			
			LI6:begin
			V_buffer_for_prime[5] <= SRAM_read_data[7:0];
			V_buffer_for_prime[4] <= SRAM_read_data[15:8];
			M1_state <= LI7;
			end
			
			LI7:begin
			U_buffer_for_prime[5] <= SRAM_read_data[7:0];
			U_buffer_for_prime[4] <= SRAM_read_data[15:8];
			M1_state <= LI8;
			end
			
			
			LI8:begin
			
			v1 = V_buffer_for_prime[0] + V_buffer_for_prime[5];
			v2 = V_buffer_for_prime[1] + V_buffer_for_prime[4];
			v3 = V_buffer_for_prime[2] + V_buffer_for_prime[3];
			
			
			u1 = U_buffer_for_prime[0] + U_buffer_for_prime[5];
			u2 = U_buffer_for_prime[1] + U_buffer_for_prime[4];
			u3 = U_buffer_for_prime[2] + U_buffer_for_prime[3];

			M1_state <= CC0;
			end
			
//---------------------Common Case Started----------------------------------------------------//
			
			CC0:begin
			
			if (lead_out_counter != 16'd160 && last_cycle_flag == 1'b1)begin
			SRAM_we_n <= 1'b1;
			SRAM_address <= Y_address_base + Y_count; //read Yeven,Yodd till the last pixel of the row is hit
			Y_count <= Y_count + 16'd1; 
			lead_out_counter <= lead_out_counter + 16'd1;  //increment the counter
			end
			SRAM_we_n <= 1'b1;
			
			
			if (lead_out_counter == 16'd156)begin 
				lead_out_flag <= 1'b0; end
			
			multireg1 <= multiresult1;   //store the multiplier result into registers for saving
			multireg2 <= multiresult2;
			multireg3 <= multiresult3;
			M1_state <= CC1;
			end
			
			CC1:begin
			
			if (UV_read_flag == 1'b1 && lead_out_flag == 1'b1)begin
			SRAM_we_n <= 1'b1;										//read V every other cycle and not in leadout
			SRAM_address <= V_address_base + UV_count;
			end
			
			V_prime_even <= V_buffer_for_prime[2];
			U_prime_even <= U_buffer_for_prime[2];
			V_prime_odd  <= (multireg1 - multireg2 + multireg3 + 8'd128) >>> 8;
			
			multireg1 <= multiresult1;
			multireg2 <= multiresult2;
			multireg3 <= multiresult3;
			
			M1_state <= CC2;
			end
			
			
			CC2:begin
			
			if (UV_read_flag == 1'b1 && lead_out_flag == 1'b1)begin  //read U every other cycle and not in leadout
			SRAM_we_n <= 1'b1;
			SRAM_address <= U_address_base + UV_count;
			UV_count <= UV_count + 16'd1;
			end
			
			U_prime_odd  <= (multireg1 - multireg2 + multireg3 + 8'd128) >>> 8;
			
			multireg1 <= multiresult1;
			multireg2 <= multiresult2;
			multireg3 <= multiresult3;

			
			M1_state <= CC3;
			
			end
			
			
			CC3:begin
			
			
			
			if (cc3_write_flag == 1'b0)begin
				cc3_write_flag <= 1'b1;
			end else begin 
				SRAM_we_n <= 1'b0;
			   SRAM_address = RGB_address + RGB_count;
				RGB_count <= RGB_count + 16'd1;
				SRAM_write_data <= {G_odd,B_odd};	
			end
			
			
			R_even_temp2 <= (multireg1 + multireg2);
				
				
				
			B_even_temp <= multireg1;
			G_even_temp <= multireg1 - multireg3;
			
			Y_even <= SRAM_read_data[15:8];
			Y_odd <= SRAM_read_data[7:0];
			
			
			multireg1 <= multiresult1;
			multireg2 <= multiresult2;
			multireg3 <= multiresult3;
			
			M1_state <= CC4;
			end
			
			
			CC4:begin
			
			B_even_temp2 <= (B_even_temp + multireg3);
			
				
			
			
			G_even_temp2 <= (G_even_temp - multireg1);
				
			
			R_odd_temp <= multireg2;
			B_odd_temp <= multireg2;
			G_odd_temp <= multireg2;
			
			if (UV_read_flag == 1'b1 && lead_out_flag == 1'b1 )begin 
			V_buffer <= SRAM_read_data[7:0];
			V_buffer_for_prime[5] <= SRAM_read_data[15:8];
			V_buffer_for_prime[4] <= V_buffer_for_prime[5];
			V_buffer_for_prime[3] <= V_buffer_for_prime[4];
			V_buffer_for_prime[2] <= V_buffer_for_prime[3];
			V_buffer_for_prime[1] <= V_buffer_for_prime[2];
			V_buffer_for_prime[0] <= V_buffer_for_prime[1]; 
			end else begin
			V_buffer_for_prime[5] <= V_buffer;
			V_buffer_for_prime[4] <= V_buffer_for_prime[5];
			V_buffer_for_prime[3] <= V_buffer_for_prime[4];
			V_buffer_for_prime[2] <= V_buffer_for_prime[3];
			V_buffer_for_prime[1] <= V_buffer_for_prime[2];
			V_buffer_for_prime[0] <= V_buffer_for_prime[1]; 
			end
			
			
			
			multireg1 <= multiresult1;
			multireg2 <= multiresult2;
			multireg3 <= multiresult3;
			//derive the write to zero
			SRAM_we_n <= 1'b1;
			M1_state <= CC5;
			end
			
			
			CC5:begin
			
			SRAM_address <= RGB_address + RGB_count;
			RGB_count <= RGB_count + 16'd1;
			SRAM_write_data <= {R_even,G_even};
			SRAM_we_n <= 1'b0;
			
			R_odd_temp2 <= (R_odd_temp + multireg1);
			
			

			G_odd_temp2 <= (G_odd_temp - multireg2 - multireg3);
			
		
			
			
			
			
			multireg1 <= multiresult1;

			if (UV_read_flag == 1'b1 && lead_out_flag == 1'b1)begin
			U_buffer <= SRAM_read_data[7:0];
			U_buffer_for_prime[5] <= SRAM_read_data[15:8];
			U_buffer_for_prime[4] <= U_buffer_for_prime[5];
			U_buffer_for_prime[3] <= U_buffer_for_prime[4];
			U_buffer_for_prime[2] <= U_buffer_for_prime[3];
			U_buffer_for_prime[1] <= U_buffer_for_prime[2];
			U_buffer_for_prime[0] <= U_buffer_for_prime[1];
			end else begin
			U_buffer_for_prime[5] <= U_buffer;
			U_buffer_for_prime[4] <= U_buffer_for_prime[5];
			U_buffer_for_prime[3] <= U_buffer_for_prime[4];
			U_buffer_for_prime[2] <= U_buffer_for_prime[3];
			U_buffer_for_prime[1] <= U_buffer_for_prime[2];
			U_buffer_for_prime[0] <= U_buffer_for_prime[1];
			end
			M1_state <= CC6;
			
			end
			
			CC6:begin
			
			SRAM_address <= RGB_address + RGB_count;
			RGB_count <= RGB_count + 16'd1;
			
			SRAM_write_data <= {B_even,R_odd};
			
			B_odd_temp2 <= (B_odd_temp + multireg1);
			
			
			
			v1 = V_buffer_for_prime[0] + V_buffer_for_prime[5];
			v2 = V_buffer_for_prime[1] + V_buffer_for_prime[4];
			v3 = V_buffer_for_prime[2] + V_buffer_for_prime[3];
			
			
			u1 = U_buffer_for_prime[0] + U_buffer_for_prime[5];
			u2 = U_buffer_for_prime[1] + U_buffer_for_prime[4];
			u3 = U_buffer_for_prime[2] + U_buffer_for_prime[3];
			
			
			
			if (lead_out_counter == 16'd160)begin
			if (last_cycle_flag == 1'b1)begin 
			last_cycle_flag <= 1'b0;
			M1_state <= CC0; end
			else begin
			M1_state <= LO1;end
			
			end else begin
			UV_read_flag <= ~UV_read_flag;
			M1_state <= CC0;
			
			end
			end
			
//---------------------------Lead out-------------------------------------------------------------------
		
			LO1:begin
			
			
			SRAM_address <= RGB_address + RGB_count;
			RGB_count <= RGB_count  + 16'd1;
			SRAM_write_data <= {G_odd,B_odd};
			
			
			if (Y_count == 31'd38400)begin
				M1_state <= DUMMY_CYCLE;
				M1_finish <= 1'b1;
				
			end else begin
				lead_out_counter <= 16'd0;
				SRAM_we_n <= 1'b0;
				M1_state <= LI0;
				end
			end
			
			
			DUMMY_CYCLE: begin
			
			M1_state <= S_IDLE_M1;
			
			end
//--------------------------------finish----------------------------------------------------------------
			
			default: M1_state <= S_IDLE_M1;
			endcase
		end
	end




endmodule