class monitor;
  mailbox mon2sb;
  virtual cordic_if.MONITOR cordicif;
  transaction m_trans;
  event driven;
  
  function new(mailbox mon2sb, virtual cordic_if.MONITOR cordicif, event driven);
    this.mon2sb=mon2sb;
    this.cordicif=cordicif;
    this.driven=driven;
  endfunction
  
  task main(input int count);
    repeat(count) begin
      @(driven);
      @(cordicif.mon_cb);
      m_trans=new();
      m_trans.cos_out = cordicif.mon_cb.cos_out;
      m_trans.sin_out = cordicif.mon_cb.sin_out;
	  m_trans.done = cordicif.mon_cb.done;
      mon2sb.put(m_trans);
    end
  endtask:main
  
  
endclass:monitor
