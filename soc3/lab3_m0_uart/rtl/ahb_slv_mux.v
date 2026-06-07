// --=========================================================================--
// Copyright (c) 2025-2026 DSAL, Hanyang University. All rights reserved
//                     DSAL Confidential Proprietary
//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from DSAL.
// -----------------------------------------------------------------------------
// FILE NAME       : ahb_slv_mux.v
// DEPARTMENT      : Digital System Architecture Lab.
// AUTHOR          : Ji-Hoon Kim
// AUTHOR'S EMAIL  : jhoonkim@hanyang.ac.kr
// -----------------------------------------------------------------------------
// ahb_slv_mux.v — Lab3 AHB subordinate-to-manager mux
//
// 3 subordinates + default slave → manager response mux

module ahb_slv_mux (
  input  wire        hclk,
  input  wire        hrst_n,
  input  wire        hready_i,

  input  wire        hsel_sram_i,
  input  wire        hsel_led_i,
  input  wire        hsel_uart_i,

  input  wire [31:0] hrdata_sram_i,
  input  wire        hreadyout_sram_i,
  input  wire [31:0] hrdata_led_i,
  input  wire        hreadyout_led_i,
  input  wire [31:0] hrdata_uart_i,
  input  wire        hreadyout_uart_i,

  input  wire [31:0] hrdata_nomap_i,
  input  wire        hreadyout_nomap_i,
  input  wire        hresp_nomap_i,

  output wire [31:0] hrdata_o,
  output wire        hready_o,
  output wire        hresp_o
);

  localparam [1:0] MUX_SRAM  = 2'd0;
  localparam [1:0] MUX_LED   = 2'd1;
  localparam [1:0] MUX_UART  = 2'd2;
  localparam [1:0] MUX_NOMAP = 2'd3;

  reg [1:0] mux_sel;

  always @(posedge hclk or negedge hrst_n)
    if (!hrst_n)       mux_sel <= MUX_NOMAP;
    else if (hready_i) begin
      if      (hsel_sram_i) mux_sel <= MUX_SRAM;
      else if (hsel_led_i)  mux_sel <= MUX_LED;
      else if (hsel_uart_i) mux_sel <= MUX_UART;
      else                  mux_sel <= MUX_NOMAP;
    end

  reg [31:0] hrdata_mux;
  reg        hready_mux;
  reg        hresp_mux;

  always @* begin
    case (mux_sel)
      MUX_SRAM: begin hrdata_mux = hrdata_sram_i; hready_mux = hreadyout_sram_i; hresp_mux = 1'b0; end
      MUX_LED:  begin hrdata_mux = hrdata_led_i;  hready_mux = hreadyout_led_i;  hresp_mux = 1'b0; end
      MUX_UART: begin hrdata_mux = hrdata_uart_i; hready_mux = hreadyout_uart_i; hresp_mux = 1'b0; end
      default:  begin hrdata_mux = hrdata_nomap_i; hready_mux = hreadyout_nomap_i; hresp_mux = hresp_nomap_i; end
    endcase
  end

  assign hrdata_o = hrdata_mux;
  assign hready_o = hready_mux;
  assign hresp_o  = hresp_mux;

endmodule
