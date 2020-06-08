/*
 * JK-Flip Flop with Preset and Clear inputs Truth Table
 *  Preset, Clear and CLK with active-low logic
 *
 * -------------------------------------------------------------
 * | Preset | Clear | CLK | J | K | Output         | Qo  | ~Qo |
 * -------------------------------------------------------------
 * | 0      | 0     | x   | x | x | Invalid        | 1*  | 0*  |
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

  //..r0 and r9 inputs comb logic
  assign r0 = ~(R01 & R02);
  assign r9 = ~(R91 & R92);

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

  assign QA = qa;
  assign QB = qb;
  assign QC = qc;
  assign QD = qd;

endmodule // jk_ff_example
