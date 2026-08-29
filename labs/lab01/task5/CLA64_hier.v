// cla64_hier.v
// Hierarchical O(log n) 64-bit carry-lookahead adder (Task 5 bonus).

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [15:0] G_blk, P_blk;
  wire [15:1] bc;

  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      assign #(2) p[i] = a[i] ^ b[i];
      assign #(2) g[i] = a[i] & b[i];
    end
  endgenerate

  genvar k;
  generate
    for (k = 0; k < 16; k = k + 1) begin : gen_blk_pg
      assign #(2) P_blk[k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k+0];
      assign #(2) G_blk[k] = g[4*k+3]
                          | (p[4*k+3] & g[4*k+2])
                          | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                          | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k+0]);
    end
  endgenerate

  // Second-level CLA across 16 blocks
  assign #(2) bc[1] = G_blk[0] | (P_blk[0] & cin);
  assign #(2) bc[2] = G_blk[1] | (P_blk[1] & G_blk[0]) | (P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[3] = G_blk[2] | (P_blk[2] & G_blk[1]) | (P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[4] = G_blk[3] | (P_blk[3] & G_blk[2]) | (P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[5] = G_blk[4] | (P_blk[4] & G_blk[3]) | (P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[6] = G_blk[5] | (P_blk[5] & G_blk[4]) | (P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[7] = G_blk[6] | (P_blk[6] & G_blk[5]) | (P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[8] = G_blk[7] | (P_blk[7] & G_blk[6]) | (P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[9] = G_blk[8] | (P_blk[8] & G_blk[7]) | (P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[10] = G_blk[9] | (P_blk[9] & G_blk[8]) | (P_blk[9] & P_blk[8] & G_blk[7]) | (P_blk[9] & P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[11] = G_blk[10] | (P_blk[10] & G_blk[9]) | (P_blk[10] & P_blk[9] & G_blk[8]) | (P_blk[10] & P_blk[9] & P_blk[8] & G_blk[7]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[12] = G_blk[11] | (P_blk[11] & G_blk[10]) | (P_blk[11] & P_blk[10] & G_blk[9]) | (P_blk[11] & P_blk[10] & P_blk[9] & G_blk[8]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & G_blk[7]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[13] = G_blk[12] | (P_blk[12] & G_blk[11]) | (P_blk[12] & P_blk[11] & G_blk[10]) | (P_blk[12] & P_blk[11] & P_blk[10] & G_blk[9]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & G_blk[8]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & G_blk[7]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[14] = G_blk[13] | (P_blk[13] & G_blk[12]) | (P_blk[13] & P_blk[12] & G_blk[11]) | (P_blk[13] & P_blk[12] & P_blk[11] & G_blk[10]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & G_blk[9]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & G_blk[8]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & G_blk[7]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);
  assign #(2) bc[15] = G_blk[14] | (P_blk[14] & G_blk[13]) | (P_blk[14] & P_blk[13] & G_blk[12]) | (P_blk[14] & P_blk[13] & P_blk[12] & G_blk[11]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & G_blk[10]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & G_blk[9]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & G_blk[8]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & G_blk[7]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & G_blk[6]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & G_blk[5]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & G_blk[4]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & G_blk[3]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[14] & P_blk[13] & P_blk[12] & P_blk[11] & P_blk[10] & P_blk[9] & P_blk[8] & P_blk[7] & P_blk[6] & P_blk[5] & P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & cin);

  cla4 block0  (.a(a[3:0]),    .b(b[3:0]),    .cin(cin),   .sum(sum[3:0]),    .cout());
  cla4 block1  (.a(a[7:4]),    .b(b[7:4]),    .cin(bc[1]), .sum(sum[7:4]),    .cout());
  cla4 block2  (.a(a[11:8]),   .b(b[11:8]),   .cin(bc[2]), .sum(sum[11:8]),   .cout());
  cla4 block3  (.a(a[15:12]),  .b(b[15:12]),  .cin(bc[3]), .sum(sum[15:12]),  .cout());
  cla4 block4  (.a(a[19:16]),  .b(b[19:16]),  .cin(bc[4]), .sum(sum[19:16]),  .cout());
  cla4 block5  (.a(a[23:20]),  .b(b[23:20]),  .cin(bc[5]), .sum(sum[23:20]),  .cout());
  cla4 block6  (.a(a[27:24]),  .b(b[27:24]),  .cin(bc[6]), .sum(sum[27:24]),  .cout());
  cla4 block7  (.a(a[31:28]),  .b(b[31:28]),  .cin(bc[7]), .sum(sum[31:28]),  .cout());
  cla4 block8  (.a(a[35:32]),  .b(b[35:32]),  .cin(bc[8]), .sum(sum[35:32]),  .cout());
  cla4 block9  (.a(a[39:36]),  .b(b[39:36]),  .cin(bc[9]), .sum(sum[39:36]),  .cout());
  cla4 block10 (.a(a[43:40]),  .b(b[43:40]),  .cin(bc[10]),.sum(sum[43:40]),  .cout());
  cla4 block11 (.a(a[47:44]),  .b(b[47:44]),  .cin(bc[11]),.sum(sum[47:44]),  .cout());
  cla4 block12 (.a(a[51:48]),  .b(b[51:48]),  .cin(bc[12]),.sum(sum[51:48]),  .cout());
  cla4 block13 (.a(a[55:52]),  .b(b[55:52]),  .cin(bc[13]),.sum(sum[55:52]),  .cout());
  cla4 block14 (.a(a[59:56]),  .b(b[59:56]),  .cin(bc[14]),.sum(sum[59:56]),  .cout());
  cla4 block15 (.a(a[63:60]),  .b(b[63:60]),  .cin(bc[15]),.sum(sum[63:60]),  .cout(cout));

endmodule