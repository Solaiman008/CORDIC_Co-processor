module cordic (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               start,
    input  logic signed [31:0] target_angle,
    output logic signed [31:0] cos_out,
    output logic signed [31:0] sin_out,
    output logic               done
);

    logic signed [31:0] x, y, z;
    logic [5:0]         step_counter;

    typedef enum {IDLE, ROTATE, FINISH} state_t;
    state_t current_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            done <= 0;
        end 

		else begin
            case (current_state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        x <= 32'd326016434; 
                        y <= 32'd0;
                        z <= target_angle;
                        step_counter <= 0;
                        current_state <= ROTATE;
                    end
                end

                ROTATE: begin
                    if (z >= 0) begin
                        x <= x - (y >>> step_counter);
                        y <= y + (x >>> step_counter);
                        z <= z - get_angle_lut(step_counter);
                    end else begin
                        x <= x + (y >>> step_counter);
                        y <= y - (x >>> step_counter);
                        z <= z + get_angle_lut(step_counter);
                    end
                    if (step_counter == 25) current_state <= FINISH;
                    else step_counter <= step_counter + 1;
                end

                FINISH: begin
                    cos_out <= x; sin_out <= y;
                    done <= 1;
                    current_state <= IDLE;
                end
            endcase
        end
    end
	
    function logic signed [31:0] get_angle_lut(logic [5:0] index);
        case(index)
            6'd0:  return 32'd1073741823; 
			6'd1:  return 32'd633866810;
            6'd2:  return 32'd334917814;  
			6'd3:  return 32'd170009512;
            6'd4:  return 32'd85334662;   
			6'd5:  return 32'd42708930;
            6'd6:  return 32'd21359676;   
			6'd7:  return 32'd10680490;
            6'd8:  return 32'd5340326;    
			6'd9:  return 32'd2670173;
            6'd10: return 32'd1335088;    
			6'd11: return 32'd667544;
            6'd12: return 32'd333772;     
			6'd13: return 32'd166886;
			6'd14: return 32'd83443;    
			6'd15: return 32'd41721;
            6'd16: return 32'd20860;     
			6'd17: return 32'd10430;
			6'd18: return 32'd5215;    
			6'd19: return 32'd2607;
            6'd20: return 32'd1303;
			6'd21: return 32'd651;
            6'd22: return 32'd325;     
			6'd23: return 32'd162;
			6'd24: return 32'd81;    
			6'd25: return 32'd40;
            6'd26: return 32'd20;     
			6'd27: return 32'd10;
			6'd28: return 32'd5;    
			6'd29: return 32'd2;
            6'd30: return 32'd1;     
            default: return 32'd0;
        endcase
    endfunction

endmodule
