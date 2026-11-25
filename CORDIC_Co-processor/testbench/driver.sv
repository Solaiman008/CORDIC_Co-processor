class driver;
  mailbox gen2driv, driv2sb;
  virtual cordic_if.DRIVER cordicif;
  transaction d_trans;
  event driven;
  
  function new(mailbox gen2driv, driv2sb , virtual cordic_if.DRIVER cordicif, event driven);
    this.gen2driv=gen2driv;  
    this.cordicif=cordicif;
    this.driven=driven;
    this.driv2sb=driv2sb;
  endfunction
    
    
  task main(input int count);
	wait(cordicif.rst_n);

    repeat(count) begin
      d_trans=new();
      gen2driv.get(d_trans);

      @(cordicif.driver_cb);
	  cordicif.driver_cb.start <= 1'b1;
	  cordicif.driver_cb.target_angle <= d_trans.target_angle;

	  @(cordicif.driver_cb);
	  cordicif.driver_cb.start <= 1'b0;
	  
	  repeat(26) @(cordicif.driver_cb); 

      driv2sb.put(d_trans);      
	  -> driven;
    end
      
  endtask:main
  
endclass:driver
