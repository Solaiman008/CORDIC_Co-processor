interface cordic_if (input clk, rst_n);

	logic start;
	logic done;
    logic signed [31:0] target_angle;
    logic signed [31:0] cos_out;
    logic signed [31:0] sin_out;
  
    clocking driver_cb @(negedge clk);
    	default input #1 output #1;
		input done;
    	output start, target_angle;
    endclocking
  
    clocking mon_cb @(negedge clk);
    	default input #1 output #1;
    	input done, cos_out, sin_out;
    endclocking
  
    modport DRIVER (clocking driver_cb, input clk, rst_n);
    modport MONITOR (clocking mon_cb, input clk, rst_n);
    
endinterface
