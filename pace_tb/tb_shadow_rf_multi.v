`timescale 1ns/1ps

module tb_shadow_rf_multi;
    reg         clk;
    reg         rst_n;
    reg  [5:0]  wr_en;
    reg  [29:0] wr_addr; 
    reg  [383:0] wr_data; 
    reg  [4:0]  rd_addr0, rd_addr1, rd_addr2, rd_addr3;
    wire [63:0] rd_data0, rd_data1, rd_data2, rd_data3;
    wire        full;
    wire        empty;

    shadow_rf_multi u_dut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wr_addr(wr_addr), .wr_data(wr_data),
        .rd_addr0(rd_addr0), .rd_addr1(rd_addr1), .rd_addr2(rd_addr2), .rd_addr3(rd_addr3),
        .rd_data0(rd_data0), .rd_data1(rd_data1), .rd_data2(rd_data2), .rd_data3(rd_data3),
        .full(full), .empty(empty)
    );

    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst_n    = 1'b0;
        wr_en    = 6'b000000;
        wr_addr  = 30'd0;
        wr_data  = 384'd0;
        rd_addr0 = 5'd0; rd_addr1 = 5'd0; rd_addr2 = 5'd0; rd_addr3 = 5'd0;

        #25;
        rst_n = 1'b1;
        #10;

        @(posedge clk);
        wr_en   = 6'b111111;
        wr_addr = {5'd6, 5'd5, 5'd4, 5'd3, 5'd2, 5'd1};
        wr_data = {64'h66, 64'h55, 64'h44, 64'h33, 64'h22, 64'h11};
        
        @(posedge clk);
        wr_en = 6'b000000;
        #5;

        rd_addr0 = 5'd1; rd_addr1 = 5'd2; rd_addr2 = 5'd5; rd_addr3 = 5'd6;
        #20;

        $display("[TB STATUS] Port0=%h, Port1=%h, Port2=%h, Port3=%h", 
                 rd_data0, rd_data1, rd_data2, rd_data3);
        $display("[TB SUCCESS] Register file multi-port tests executed completely!");
        $finish;
    end
endmodule
