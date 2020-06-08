/*
 * JK-Flip Flop with Preset and Clear inputs Truth Table
 *  Preset, Clear and CLK with active-low logic
 *
 * -------------------------------------------------------------
 * | Preset | Clear | CLK | J | K | Output         | Qo  | ~Qo |
 * -------------------------------------------------------------
 * | 0      | 0     | x   | x | x | Invalid        | 1   | 1   |
 * | 0      | 1     | x   | x | x | Preset         | 1   | 0   |
 * | 1      | 0     | x   | x | x | Clear          | 0   | 1   |
 * | 1      | 1     | x   | x | x | No change      | Qo  | ~Qo |
 * | 1      | 1     | NEG | 0 | 0 | No change      | Qo  | ~Qo |
 * | 1      | 1     | NEG | 0 | 1 | Reset          | 0   | 1   |
 * | 1      | 1     | NEG | 1 | 0 | Set            | 1   | 0   |
 * | 1      | 1     | NEG | 1 | 1 | Toggle         | ~Qo | Qo  |
 * -------------------------------------------------------------
 */

module jk_ff_example (/*AUTOARG*/
   // Outputs
   QA, QB, QC, QD,
   // Inputs
   inputA, inputB, R01, R02, R91, R92
   );

  //..ports
  input inputA, inputB, R01, R02, R91, R92;
  output QA, QB, QC, QD;

  //..regs and wires declaration
  wire qa, qna, qb, qnb, qc, qnc, qd, qnd;
  wire r0, r9;
  //reg r0, r9, pre1, clr1, clr2, clr3, pre4, clr4, j2, j4, k4;

  //..initial statements
  /*initial begin
    qa = 0;
    qb = 0;
    qc = 0;
    qd = 0;
  end*/

  //..r0 and r9 inputs comb logic
  assign r0 = ~(R01 & R02);
  assign r9 = ~(R91 & R92);
  /*always @ (*) begin
    r0 = ~(R01 & R02);
    r9 = ~(R91 & R92);
  end*/

  //..qa jk-ff logic
  jk_ff qa_ff (
      .preset_i (r9),
      .clear_i  (r0),
      .clk_i    (inputA),
      .j_i      (1'b1),
      .k_i      (1'b1),
      .q_o      (qa),
      .qn_o     (qna)
    );
  /*always @(negedge inputA) begin
    pre1 = r0;
    clr1 = r9;
    case({pre1, clr1})
      2'b01 : qa = 1'b1;
      2'b10 : qa = 1'b0;
      2'b11 : qa = ~qa;//toggle is the original result of jk
    endcase//jk1
  end*/

  //..qb jk-ff logic
  jk_ff qb_ff (
      .preset_i (1'b1),
      .clear_i  (r0 | r9),
      .clk_i    (inputB),
      .j_i      (qnd),
      .k_i      (1'b1),
      .q_o      (qb),
      .qn_o     (qnb)
    );
  /*always @(negedge inputB) begin
    j2 = ~qd;
    clr2 = ~(r0 | r9);
    if (j2 == 0 && clr2 == 0) qb = 0;//clr=0 means must clear it
    if (j2 == 1 && clr2 == 0) qb = 0;//clr=0 means must clear it
    if (j2 == 1 && clr2 == 1) qb = ~qb;//toggle
    //jk2
  end*/

  //..qc jk-ff logic
  jk_ff qc_ff (
      .preset_i (1'b1),
      .clear_i  (r0 | r9),
      .clk_i    (qb),
      .j_i      (1'b1),
      .k_i      (1'b1),
      .q_o      (qc),
      .qn_o     (qnc)
    );
  /*always @(negedge qb) begin
    qc = ~qc;
    clr3 = ~(r0 | r9);
    if (clr3 == 0) qc = 0;//clr=0 means must clear it
    else qc = ~qc;
    //jk3
  end*/

  //..qd jk-ff logic
  jk_ff qd_ff (
      .preset_i (r9),
      .clear_i  (r0),
      .clk_i    (inputB),
      .j_i      (qb & qc),
      .k_i      (qd),
      .q_o      (qd),
      .qn_o     (qnd)
    );
  /*always @(negedge inputB) begin
    j4 = qb & qc;
    case({j4, k4, pre4, clr4})
      4'b0011 : qd = qd; //HOLD
      4'b0001 : qd = 1'b1; //PRESET
      4'b0010 : qd = 1'b0; //CLEAR

      4'b1011 : qd = 1'b1; //SET
      4'b1001 : qd = 1'b1; //PRESET
      4'b1010 : qd = 1'b0; //CLEAR

      4'b0111 : qd = 1'b0; //RESET
      4'b0101 : qd = 1'b1; //PRESET
      4'b0110 : qd = 1'b0; //CLEAR

      4'b1111 : qd = ~qd; //TOGGLE
      4'b1101 : qd = 1'b1; //PRESET
      4'b1110 : qd = 1'b0; //CLEAR
    endcase
    //jk4
  end*/

  assign QA = qa;
  assign QB = qb;
  assign QC = qc;
  assign QD = qd;

endmodule // jk_ff_example
