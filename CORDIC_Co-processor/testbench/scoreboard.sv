`include "coverage.sv"

import "DPI-C" pure function real cos(real r);
import "DPI-C" pure function real sin(real r);

class scoreboard;

  mailbox driv2sb;
  mailbox mon2sb;
  
  transaction d_trans;
  transaction m_trans;

  cordic_coverage coverage;
  
  event driven;

  const real PI = 3.141592653589793;
  const real scaling_factor_angle = 2147483647.0 / 90.0;
  const real scaling_factor = 1 << 29;
  const real error_margin = 107;
  real angle, angle_degree, result_cos, result_sin;

  int passed, failed;
  
  function new(mailbox driv2sb, mon2sb);
    this.driv2sb=driv2sb;
    this.mon2sb=mon2sb;
	this.passed=0;
	this.failed=0;
	coverage = new();
  endfunction
  
  task main(input int count);
    $display("------------------Scoreboard Test Starts--------------------");
    repeat(count) begin
      m_trans=new();
      mon2sb.get(m_trans);
      calculate();
	  coverage.sample(d_trans, m_trans);
	  view_result();
    end
    $display("------------------Scoreboard Test Ends--------------------");
	$display("Total Passed: %d    |    Total Failed: %d", this.passed, this.failed);

	$display("--------------------Coverage Report-----------------------");
	$display("Coverage: %f%%", coverage.cg.get_coverage());
  endtask:main
  
  task calculate();
    d_trans=new();
    driv2sb.get(d_trans);

    angle = d_trans.target_angle * PI / 180.0 / scaling_factor_angle;
	angle_degree = d_trans.target_angle / scaling_factor_angle;
    d_trans.cos_out = int'(cos(angle) * scaling_factor);
    d_trans.sin_out = int'(sin(angle) * scaling_factor);

	result_cos = m_trans.cos_out / scaling_factor;
	result_sin = m_trans.sin_out / scaling_factor;
    
  endtask:calculate

  task view_result();
    if(abs_diff(d_trans.cos_out, m_trans.cos_out) > error_margin) begin
      $display("Cosine Value Failed.      Angle: %d    |    Expected Value: %d    |    Resulted Value: %d    |    Difference: %d", 
				d_trans.target_angle, d_trans.cos_out, m_trans.cos_out, abs_diff(d_trans.cos_out, m_trans.cos_out));
	  $display("                             (%f)                     (%.8f)                         (%.8f)", angle_degree, cos(angle), result_cos);
	  this.failed++;
	end
	else begin
	  $display("Cosine Value Passed.      Angle: %d    |    Expected Value: %d    |    Resulted Value: %d    |    Difference: %d", 
				d_trans.target_angle, d_trans.cos_out, m_trans.cos_out, abs_diff(d_trans.cos_out, m_trans.cos_out));
	  $display("                             (%f)                     (%.8f)                         (%.8f)\n", angle_degree, cos(angle), result_cos);
	  this.passed++;
	end

    if(abs_diff(d_trans.sin_out, m_trans.sin_out) > error_margin) begin
      $display("  Sine Value Failed.      Angle: %d    |    Expected Value: %d    |    Resulted Value: %d    |    Difference: %d", 
				d_trans.target_angle, d_trans.sin_out, m_trans.sin_out, abs_diff(d_trans.sin_out, m_trans.sin_out));
	  $display("                             (%f)                     (%.8f)                         (%.8f)", angle_degree, sin(angle), result_sin);
	  this.failed++;
	end
	else begin
      $display("  Sine Value Passed.      Angle: %d    |    Expected Value: %d    |    Resulted Value: %d    |    Difference: %d", 
				d_trans.target_angle, d_trans.sin_out, m_trans.sin_out, abs_diff(d_trans.sin_out, m_trans.sin_out));
	  $display("                             (%f)                     (%.8f)                         (%.8f)", angle_degree, sin(angle), result_sin);
	  this.passed++;
	end
	
	$display("%s", {150{"-"}});


  endtask:view_result 

  function int abs_diff(int a, int b);
        int res;
        res = a - b;
        return (res < 0) ? -res : res;
  endfunction
             
endclass:scoreboard
