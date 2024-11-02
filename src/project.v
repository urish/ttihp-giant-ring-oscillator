/*
 * Copyright (c) 2024 Uri Shaked
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_urish_giant_ringosc (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  parameter CHAIN_LENGTH = 1001;

  wire [CHAIN_LENGTH-1:0] inv_in;
  wire [CHAIN_LENGTH-1:0] inv_out;

  assign inv_in[0] = ui_in[0];
  assign inv_in[CHAIN_LENGTH-1:1] = inv_out[CHAIN_LENGTH-2:0];

  assign uo_out[0] = inv_out[0];
  assign uo_out[1] = inv_out[2];
  assign uo_out[2] = inv_out[4];
  assign uo_out[3] = inv_out[6];
  assign uo_out[4] = inv_out[10];
  assign uo_out[5] = inv_out[20];
  assign uo_out[6] = inv_out[50];
  assign uo_out[7] = inv_out[100];

  assign uio_oe = 8'b11111111;
  assign uio_out[0] = inv_out[200];
  assign uio_out[1] = inv_out[500];
  assign uio_out[2] = inv_out[1000];
  assign uio_out[7:3] = 5'b0;

  genvar i;
  generate
    for (i = 0; i < CHAIN_LENGTH; i = i + 1) begin : inv
      inverter inv (
          .in (inv_in[i]),
          .out(inv_out[i])
      );
    end
  endgenerate

  wire _unused = &{ena, clk, rst_n};

endmodule
