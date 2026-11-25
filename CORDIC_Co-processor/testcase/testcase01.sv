`include "environment.sv"

program test(input int count, cordic_if cordicif);
  environment env;

  class constrained_trans extends transaction;
    constraint cs {
	//target_angle inside {929184892, 172872577, 631148784};
    }
  endclass:constrained_trans

  class edge_cases extends transaction;
    constraint cs {
	target_angle inside {0, 32'sh7FFFFFFF, 32'sh80000001};
    }
  endclass:edge_cases

  initial begin
    constrained_trans trans_handle;
	edge_cases edge_handle;

    trans_handle=new();
	edge_handle=new();
    
    env=new(cordicif);

    env.gen.custom_trans=trans_handle;
    env.main(count);

    env.gen.custom_trans=edge_handle;
    env.main(count);

	$finish;
  end
  
  
endprogram:test
