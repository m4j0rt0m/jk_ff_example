module jk_ff_example_tb;
  reg clk, r0, r9;
  wire [3:0] Q;

  jk_ff_example dut (.inputA(clk), .inputB(Q[0]), .R01(r0), .R02(r0), .R91(r9), .R92(r9), .QA(Q[0]), .QB(Q[1]), .QC(Q[2]), .QD(Q[3]));

  always
    #5 clk=~clk;

  initial begin
    clk=1'b0;
    $monitor(" [Cycle: %3d] [Q value: %d]", $time, Q);
    $dumpfile("jk_ff_example.vcd");
    $dumpvars();
  end

  always begin
    //0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,0,1,2,3,9,0,1,2,3,4,5,6,7,8
    $display("Starting simulation");
    r0 = 1'b1; r9 = 1'b0; #3 ;r0 = 1'b0; r9 = 1'b0; #157; 
    r0 = 1'b1; r9 = 1'b0; #3 ;r0 = 1'b0; r9 = 1'b0; #37;
    r0 = 1'b0; r9 = 1'b1; #3; r0 = 1'b0; r9 = 1'b0; #97;
    $display("End simulation");
    $finish;
  end

endmodule
