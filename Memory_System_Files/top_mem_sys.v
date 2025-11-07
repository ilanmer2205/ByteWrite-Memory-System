

module top_mem_sys(
    input clk,
    input ena,
    input [31:0] store_data,
    input [2:0] func3,
    input [5:0] addrA,
    output [31:0] load_data
);

wire [3:0]  w_mask;
wire [31:0] mem_wdata, mem_rdata;

wire [1:0] addr2lsb = addrA [1:0];

mem_transmitter tx (
    .store_data(store_data),
    .Addr2Lsb(addr2lsb),
    .func3(func3),
    .w_mask(w_mask),
    .mem_wdata(mem_wdata)
);

bytewrite_tdp_ram_nc mem (
    .clkA(clk),
    .enaA(ena),
    .weA(w_mask),
    .addrA(addrA),
    .dinA(mem_wdata),
    .doutA(mem_rdata)
);

mem_receiver rx (
    .read_data(mem_rdata),
    .Addr2Lsb(addr2lsb),
    .func3(func3),
    .load_word(load_data)
);

endmodule
