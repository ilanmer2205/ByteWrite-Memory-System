module TB_mem_tx();

	reg [31:0] store_data;
	reg [1:0] Addr2Lsb;
	reg [2:0] func3;
	wire [3:0] w_mask;
	wire [31:0] mem_wdata;

	

	mem_transmitter tb_mem_tx(store_data, Addr2Lsb, func3, w_mask, mem_wdata);

    integer i,j;
	initial begin 
		//check the data is loaded up properly
		store_data = 32'h1234_5678;
		Addr2Lsb = 2'b00;
		#1;
		for(i=0; i<4; i=i+1) begin
			Addr2Lsb = i;
			#1;
			$display ("Time: %0t, Addr2Lsb = %b, mem_wdata = %h \n",$time, Addr2Lsb ,mem_wdata); //00: 1234_5678, 01: 0000_7800, 10: 5678_0000, 11: 7800_0000; 
		end
        
		//check w_mask
		func3 = 3'b000;
		Addr2Lsb = 2'b00;
		for(i=0; i<2; i=i+1) begin
			func3 = i;
			for(j=0; j<4; j=j+1) begin
				Addr2Lsb = j;
				#1;
				$display ("Time: %0t, func3 = %b, Addr2Lsb = %b, w_mask = %b \n",$time, func3, Addr2Lsb, w_mask); //0 , 00 .. 0,11 ; 1 , 00 .. 1 ,11 ; 
		     end
		end
	end
endmodule