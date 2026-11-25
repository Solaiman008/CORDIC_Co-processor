class cordic_coverage;
	logic signed [31:0] target_angle;
	logic done;

	covergroup cg;
	
		angle_cps: coverpoint (signed'(target_angle)){
			bins zero = {0};
			bins max_edge = {32'sh7FFFFFFF};
			bins min_edge = {32'sh80000001};
			bins quad1_half1 = {[32'sh00000001:32'sh40000000]};
			bins quad1_half2 = {[32'sh40000001:32'sh4FFFFFFE]};
			bins quad2_half1 = {[32'shC0000000:32'shFFFFFFFF]};
			bins quad2_half2 = {[32'sh80000002:32'shBFFFFFFF]};
		}

		done_cps: coverpoint done{
			bins idle_to_done = (0 => 1);
		}

		angle_done_cross: cross angle_cps, done_cps;

	endgroup

	function new();
		cg = new();
		cg.start();
	endfunction

	function void sample(transaction d_trans, m_trans);
		this.done = 0;
		cg.sample();

		this.target_angle = d_trans.target_angle;
		this.done = m_trans.done;
		cg.sample();
	endfunction

endclass

