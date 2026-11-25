`include "testcase01.sv"
`include "interface.sv"

module testbench;
  bit clk;
  bit rst_n;
  
  initial begin
    forever #5 clk =~clk;
  end

  initial begin
    rst_n = 0;
    #20;
    rst_n = 1;
  end
  
  int count=250;
  cordic_if cordicif(clk, rst_n);
  
  test test01(count,cordicif);
  
  //initial begin
    //$dumpfile("dump.vcd");
    //$dumpvars;
  //end
  
  cordic DUT (
    .clk(clk),
    .rst_n(rst_n),
    .start(cordicif.start),
    .target_angle(cordicif.target_angle),
    .cos_out(cordicif.cos_out),
    .sin_out(cordicif.sin_out),
    .done(cordicif.done)
	);
  
endmodule
