
module TB_mem_rx();
	reg [31:0] read_data;
	reg [1:0] Addr2Lsb;
	reg [2:0] func3;
	wire [31:0] load_word;

	mem_reciever tb_mem_rx(read_data, Addr2Lsb, func3, load_word);

	integer i,j;
	initial begin
		read_data = 32'h1234_5678; 
		func3 = 3'b000;
		Addr2Lsb = 2'b00;
		#1; 
		for (i=0; i<2; i=i+1) begin
			func3 = i;
			for (j=0; j<4; j=j+1) begin
				Addr2Lsb = j;
				#1;
				$display("Time %0t: func3 = %b, Addr2Lsb = %b, load_word = %h", $time, func3, Addr2Lsb, load_word); //first 4 different bytes in [7:0] and then 2 half word in [15:0] 
			end
		end
	end
endmodule 