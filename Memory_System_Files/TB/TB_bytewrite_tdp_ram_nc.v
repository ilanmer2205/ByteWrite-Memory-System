module TB_bytewrite_tdp_ram_nc ();

parameter NUM_COL = 4;
parameter COL_WIDTH = 8;
parameter ADDR_WIDTH = 6; // Addr Width in bits : 2**ADDR_WIDTH = RAM Depth
parameter DATA_WIDTH = NUM_COL*COL_WIDTH; // Data Width in bits

reg clkA=0;
reg enaA;
reg [NUM_COL-1:0] weA;
reg [ADDR_WIDTH-1:0] addrA;
reg [DATA_WIDTH-1:0] dinA;
wire [DATA_WIDTH-1:0] doutA;

bytewrite_tdp_ram_nc tb_bytewrite_tdp_ram_nc(clkA, enaA, weA, addrA, dinA, doutA);

always #5 clkA = ~clkA;

integer i;
initial begin
	enaA = 1'b1; addrA = 6'b000000; weA = 4'b1111;
	dinA = 32'h0000_0000;
	@(posedge clkA);
	$display("Time: %0t, weA = %b ,ram_block[%h] = %h",$time, weA, 2**addrA-1 ,doutA);
	weA = 4'b0000; 
	dinA = 32'h1234_5678;
	for(i=0; i<4; i=i+1) begin
	   weA = (4'b0000 + 1) << i ;
	   @(posedge clkA);
		$display("Time: %0t, weA = %b ,ram_block[%h] = %h",$time, weA, 2**addrA-1 ,doutA);
	end

end

endmodule