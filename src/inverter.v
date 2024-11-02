/*
 * Copyright (c) 2024 Uri Shaked
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

(* keep_hierarchy *)
module inverter (
    input  wire in,
    output wire out
);

  assign out = ~in;

endmodule
