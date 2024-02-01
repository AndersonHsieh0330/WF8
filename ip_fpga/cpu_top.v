`default_nettype none
`timescale 1ps/1ps
module cpu_top (
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] io_bus_addr,
    output wire [7:0] io_bus_dout
);

/*
    pipline stages are :
    - fetch
    - decode + execute
    - memory
    - write back

    Signals are prefixed with :
    - f_
    - dx_
    - m_
    - wb_

    If a signal is prefixed with wb_m_, ex. wb_m_dx_alu_out
    that means it was generated from dx stage and was passed 
    down all the way to wb stage.
    
    A signal will only have a pipline prefix if it is passed down 
    to the next pipline stage. Otherwise it will be prefixed with 
    the module name that it was generated from.
*/

//---  fetch stage signals ---//
reg  [7:0] f_pc;
wire [7:0] imem_data_out;
wire [7:0] i_mem_addr_in;

//--- decode_execute stage signals ---//
wire [7:0] dx_pc;

wire [7:0] dx_insn;

wire [3:0] decoder_imm_out;
wire [2:0] decoder_reg_out;

wire [2:0] writeback_addr;

wire [7:0] rf_reg_b_out;
wire [7:0] rf_reg_acc_out;
wire [7:0] rf_write_data_in;

wire [`ALU_MODE_COUNT-1:0] control_alu_mode;
wire       control_rf_write_en;
wire       control_rf_write_data_sel;
wire       control_rf_write_addr_sel;
wire       control_alu_a_sel;
wire       control_alu_b_sel;
wire       control_mem_write_en;

wire [7:0] alu_out;
wire [`ALU_FLAG_COUNT-1:0] alu_flags;

wire       bd_pc_sel;

//--- meomory stage signals ---//
wire [7:0] m_pc;
wire       m_mem_write_en;
wire [7:0] m_alu_out;
wire [2:0] m_writeback_addr;
wire       m_control_rf_write_en;
wire       m_control_rf_write_data_sel;
wire [7:0] m_reg_b_out;

wire [7:0] dmem_data_out;

//--- write_back stage signals ---//
wire [7:0] wb_pc;
wire [7:0] wb_m_alu_out;
wire [7:0] wb_dmem_data_out;
wire [2:0] wb_m_writeback_addr;
wire       wb_m_control_rf_write_data_sel;

//--- PC instantiation ---//
always @(posedge clk) begin
    if (reset) begin
        f_pc <= 8'b0;
    end else begin
        // pc input mux
        if (bd_pc_sel) begin
            f_pc <= wb_m_alu_out;
        end else begin
            //  8 bit adder
            f_pc <= f_pc + 1;
        end
    end
end
////////////////////////////////////////////
///--------- fetch stage start ----------///
////////////////////////////////////////////
assign i_mem_addr_in = dx_pc;
imemory imem_inst (
    .clk(clk),
    .reset(reset),
    .addr_in(f_pc),
    .data_out(imem_data_out)
);
////////////////////////////////////////////
///---------- fetch stage end -----------///
////////////////////////////////////////////
pipline_register #(.WIDTH(16)) f_dx_pip_reg_inst  (
    .clk(clk),
    .reset(reset),
    .in({
        f_pc,
        imem_data_out
    }),
    .out({
        dx_pc,
        dx_insn
    })
);
////////////////////////////////////////////
///----- decode_execute stage start -----///
////////////////////////////////////////////
insn_decoder insn_decoder_inst (
    .insn(dx_insn),
    .imm_out(decoder_imm_out),
    .reg_out(decoder_reg_out)
);

register_file reg_file_inst (
    .clk(clk),
    .reset(reset),
    .write_data_in(rf_write_data_in),
    .write_addr_in(wb_m_writeback_addr),
    .write_en(control_rf_write_en),
    .read_addr_in(decoder_reg_out),
    .reg_b_out(rf_reg_b_out),
    .reg_acc_out(rf_reg_acc_out)
);

alu alu_inst (
    // input a mux
    .a(control_alu_a_sel?dx_pc:rf_reg_acc_out),
    // input b mux
    .b(control_alu_b_sel?decoder_imm_out:rf_reg_b_out),
    .reg_acc(rf_reg_acc_out),
    .reg_b(rf_reg_b_out),
    .alu_mode(control_alu_mode),
    .c(alu_out),
    .alu_flags(alu_flags)
);

branch_decision branch_decision_inst (
    .opcode(dx_insn[7:3]),
    .alu_flags(alu_flags),
    .pc_sel(bd_pc_sel)
);

// register file writeback address select mux
assign writeback_addr = control_rf_write_addr_sel ? 3'd7 : decoder_reg_out;

control control_inst (
    .opcode(dx_insn[7:3]),
    .alu_mode(control_alu_mode),
    .rf_write_en(control_rf_write_en), 
    .rf_write_data_sel(control_rf_write_data_sel),
    .rf_write_addr_sel(control_rf_write_addr_sel),
    .alu_a_sel(control_alu_a_sel),   
    .alu_b_sel(control_alu_b_sel),   
    .mem_write_en(control_mem_write_en)
);
////////////////////////////////////////////
///------ decode_execute stage end ------///
////////////////////////////////////////////
pipline_register #(.WIDTH(30)) dx_m_pip_reg_inst  (
    .clk(clk),
    .reset(reset),
    .in({
        dx_pc,
        control_mem_write_en,
        alu_out,
        rf_reg_b_out,
        control_rf_write_en,
        control_rf_write_data_sel,
        writeback_addr
    }),
    .out({
        m_pc,
        m_mem_write_en,
        m_alu_out,
        m_reg_b_out,
        m_control_rf_write_en,
        m_control_rf_write_data_sel,
        m_writeback_addr
    })
);
////////////////////////////////////////////
///--------- memory stage start ---------///
////////////////////////////////////////////
dmemory dmem_inst (
    .clk(clk),
    .reset(reset),
    .write_en(m_mem_write_en),
    .addr_in(m_alu_out),
    .data_in(m_reg_b_out),
    .memory_mapped_io_addr_in(io_bus_addr),
    .memory_mapped_io_data_out(io_bus_dout),
    .data_out(dmem_data_out)
);
////////////////////////////////////////////
///--------- memory stage end -----------///
////////////////////////////////////////////
pipline_register #(.WIDTH(28)) m_wb_pip_reg_inst  (
    .clk(clk),
    .reset(reset),
    .in({
        m_pc,
        m_alu_out,
        m_writeback_addr,
        m_control_rf_write_data_sel,
        dmem_data_out
    }),
    .out({
        wb_pc,
        wb_m_alu_out,
        wb_m_writeback_addr,
        wb_m_control_rf_write_data_sel,
        wb_dmem_data_out
    })
);
////////////////////////////////////////////
///------- write_back stage start -------///
////////////////////////////////////////////
assign rf_write_data_in = wb_m_control_rf_write_data_sel ? wb_dmem_data_out : wb_m_alu_out;
// register file instantiated in dx stage
////////////////////////////////////////////
///------- write_back stage end ---------///
////////////////////////////////////////////
endmodule