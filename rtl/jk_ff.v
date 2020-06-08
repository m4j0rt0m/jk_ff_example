/*
 * JK-Flip Flop with Preset and Clear inputs Truth Table
 *  Preset, Clear and CLK with active-low logic
 *
 * -------------------------------------------------------------
 * | Preset | Clear | CLK | J | K | Output         | Qo  | ~Qo |
 * -------------------------------------------------------------
 * | 0      | 0     | x   | x | x | Invalid        | 1   | 0*  |
 * | 0      | 1     | x   | x | x | Preset         | 1   | 0   |
 * | 1      | 0     | x   | x | x | Clear          | 0   | 1   |
 * | 1      | 1     | x   | x | x | No change      | Qo  | ~Qo |
 * | 1      | 1     | NEG | 0 | 0 | No change      | Qo  | ~Qo |
 * | 1      | 1     | NEG | 0 | 1 | Reset          | 0   | 1   |
 * | 1      | 1     | NEG | 1 | 0 | Set            | 1   | 0   |
 * | 1      | 1     | NEG | 1 | 1 | Toggle         | ~Qo | Qo  |
 * -------------------------------------------------------------
 */

module jk_ff (/*AUTOARG*/
   // Outputs
   q_o, qn_o,
   // Inputs
   preset_i, clear_i, clk_i, j_i, k_i
   );

  //..ports
  input preset_i, clear_i, clk_i, j_i, k_i;
  output q_o, qn_o;

  //..regs and wires
  reg q = 0;

  //..jk ff w/ preset and clear logic
  always @ (*) begin
    case({preset_i, clear_i})
      2'b00: q = 0; //..invalid
      2'b01: q = 1; //..preset
      2'b10: q = 0; //..clear
      2'b11: begin
        if(clk_i) //..no change
          q = q;
        else begin
          case({j_i, k_i})
            2'b00: q = q;  //..no change
            2'b01: q = 0;  //..reset
            2'b10: q = 1;  //..set
            2'b11: q = ~q; //..toggle
          endcase
        end
      end
    endcase
  end

  //..output assignment
  assign q_o = q;
  assign qn_o = ~q;

endmodule // jk_ff
