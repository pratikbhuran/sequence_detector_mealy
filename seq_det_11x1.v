///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename: seq_det_11x1.v
// Date created: 22-11-2022
// Author: pratikbhuran16@gmail.com
// Simulation: Vivado 2019.1 
// Description: Design of non-overlapping 11x1 sequence detector using mealy machine FSM .
//              This fsm will detect both the possible values of x => 0 & 1. It will detect both 1101 & 1111 sequences.
// Nomencleture: i = Input, o = Output, r = register, w = wire
//             
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module seq_det_11x1 #(
parameter s0 = 3'b000,
parameter s1 = 3'b001,
parameter s2 = 3'b010,
parameter s3 = 3'b011,
parameter s4 = 3'b100)
(
    input i_seq,                               //input sequence
    input clk,
    input rst_n,                               //aynchronous active low reset '0' = rst active, '1' = rst disabled 
    output reg o_seq_detect                    //sequence detected output
);

//state registers for assignments of state
reg [2:0] r_present_state;
reg [2:0] r_next_state;


//present state logic (state registers)
//reset should be low at start to start the fsm from S0 state
//reset should remain high after state is S0 for whole opearation 
always @(posedge clk , negedge rst_n) begin
    if (~rst_n) begin
        r_present_state <= s0;                     //go to S0(first state) on reset
    end
    else begin
        r_present_state <= r_next_state;           //assign next state to present state at every posedge of clk for the conditions on d_in
    end
end


//output logic
//11x1 can assume 2 values => 1101 and 1111 
//state machine gets branched at s2 to s3 and s4 for logic 0 and logic 1 in place of x
always @ *
begin
    case (r_present_state)
    s0 : o_seq_detect  <= 1'b0;
    s1 : o_seq_detect  <= 1'b0;
    s2 : o_seq_detect  <= 1'b0;
    s3 :begin                                           
            if (i_seq == 1'b1) begin
                o_seq_detect  <= 1'b1;
            end
            else begin
                o_seq_detect  <= 1'b0;
            end
        end
    s4 :begin
            if (i_seq == 1'b1) begin
                o_seq_detect  <= 1'b1;
            end
            else begin
                o_seq_detect  <= 1'b0;
            end
        end
    default : o_seq_detect  <= 1'b0;
      
    endcase
end


//next_state logic 
//assignment of next state logic depending on input sequence 
always @ *
begin
    case (r_present_state)
    s0 :begin 
            if (i_seq == 1'b0) begin
                r_next_state <= s0;
            end
            else begin 
                r_next_state <= s1;
            end
        end

    s1 :begin 
            if (i_seq == 1'b1) begin
                r_next_state <= s2;
            end
            else begin
                r_next_state <= s3;
            end
        end

    s2 :begin 
            if (i_seq == 1'b1) begin
                r_next_state <= s4;
            end
            else begin
                r_next_state <= s3;
            end
        end

    s3 :begin 
            if (i_seq == 1'b1) begin
                r_next_state <= s0;
            end
            else begin 
                r_next_state <= s0;
            end
        end

    s4 :begin 
            if (i_seq == 1'b1) begin
                r_next_state <= s0;
            end
            else begin 
                r_next_state <= s0;
            end
        end

    default :begin 
             r_next_state <= s0;
             end
    endcase
end

endmodule 