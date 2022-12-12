//-----------------------------------------------------------------------------
// Copyright (C) 2022 ETH Zurich, University of Bologna
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
// SPDX-License-Identifier: SHL-0.51
//
// Manuel Eggimann <meggimann@iis.ee.ethz.ch>
//-----------------------------------------------------------------------------

module udma_sdio_wrap
  import udma_pkg::udma_evt_t;
  import sdio_pkg::sdio_to_pad_t;
  import sdio_pkg::pad_to_sdio_t;
(
  input  logic         sys_clk_i,
  input  logic         periph_clk_i,
  input  logic         rstn_i,

	input  logic  [31:0] cfg_data_i,
	input  logic   [4:0] cfg_addr_i,
	input  logic         cfg_valid_i,
	input  logic         cfg_rwn_i,
	output logic         cfg_ready_o,
  output logic  [31:0] cfg_data_o,

  output udma_evt_t    events_o,
  input  udma_evt_t    events_i,

  // UDMA CHANNEL CONNECTION
  UDMA_LIN_CH.rx_out   rx_ch[0:0],
  UDMA_LIN_CH.tx_in    tx_ch[0:0],

  // PAD SIGNALS CONNECTION
  output  sdio_to_pad_t sdio_to_pad,
  input   pad_to_sdio_t pad_to_sdio
);

import udma_pkg::TRANS_SIZE;
import udma_pkg::L2_AWIDTH_NOAL;

udma_sdio_top #(.L2_AWIDTH_NOAL(L2_AWIDTH_NOAL), .TRANS_SIZE(TRANS_SIZE)) i_udma_sdio_top (
    .sys_clk_i          (sys_clk_i       ),
    .periph_clk_i       (periph_clk_i    ),
    .rstn_i             (rstn_i          ),

    .cfg_data_i         (cfg_data_i      ),
    .cfg_addr_i         (cfg_addr_i      ),
    .cfg_valid_i        (cfg_valid_i     ),
    .cfg_rwn_i          (cfg_rwn_i       ),
    .cfg_ready_o        (cfg_ready_o     ),
    .cfg_data_o         (cfg_data_o      ),

    .cfg_rx_startaddr_o (rx_ch[0].startaddr  ),
    .cfg_rx_size_o      (rx_ch[0].size       ),
    .cfg_rx_continuous_o(rx_ch[0].continuous ),
    .cfg_rx_en_o        (rx_ch[0].cen        ),
    .cfg_rx_clr_o       (rx_ch[0].clr        ),
    .cfg_rx_en_i        (rx_ch[0].en         ),
    .cfg_rx_pending_i   (rx_ch[0].pending    ),
    .cfg_rx_curr_addr_i (rx_ch[0].curr_addr  ),
    .cfg_rx_bytes_left_i(rx_ch[0].bytes_left ),

    .cfg_tx_startaddr_o (tx_ch[0].startaddr ),
    .cfg_tx_size_o      (tx_ch[0].size      ),
    .cfg_tx_continuous_o(tx_ch[0].continuous),
    .cfg_tx_en_o        (tx_ch[0].cen       ),
    .cfg_tx_clr_o       (tx_ch[0].clr       ),
    .cfg_tx_en_i        (tx_ch[0].en        ),
    .cfg_tx_pending_i   (tx_ch[0].pending   ),
    .cfg_tx_curr_addr_i (tx_ch[0].curr_addr ),
    .cfg_tx_bytes_left_i(tx_ch[0].bytes_left),

    .data_tx_req_o      (tx_ch[0].req       ),
    .data_tx_gnt_i      (tx_ch[0].gnt       ),
    .data_tx_datasize_o (tx_ch[0].datasize  ),
    .data_tx_i          (tx_ch[0].data      ),
    .data_tx_valid_i    (tx_ch[0].valid     ),
    .data_tx_ready_o    (tx_ch[0].ready     ),

    .data_rx_datasize_o (rx_ch[0].datasize  ),
    .data_rx_o          (rx_ch[0].data      ),
    .data_rx_valid_o    (rx_ch[0].valid     ),
    .data_rx_ready_i    (rx_ch[0].ready     ),

    .eot_o              ( events_o[2]       ),
    .err_o              ( events_o[3]       ),

    .sdclk_o            ( sdio_to_pad.sdclk      ),
    .sdcmd_o            ( sdio_to_pad.sdcmd      ),
    .sdcmd_i            ( pad_to_sdio.sdcmd      ),
    .sdcmd_oen_o        ( sdio_to_pad.sdcmd_oen  ),
    .sddata_o           ( sdio_to_pad.sddata     ),
    .sddata_i           ( pad_to_sdio.sddata     ),
    .sddata_oen_o       ( sdio_to_pad.sddata_oen )
);

// padding unused events
assign events_o[0] = rx_ch[0].events;
assign events_o[1] = tx_ch[0].events;

// assigning unused signals
assign rx_ch[0].stream = '0;
assign rx_ch[0].stream_id = '0;
assign rx_ch[0].destination = '0;
assign tx_ch[0].destination = '0;

endmodule : udma_sdio_wrap
