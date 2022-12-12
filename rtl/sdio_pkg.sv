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

package sdio_pkg;
  // sdio structure
	typedef struct packed {
		logic        sdclk_out;
		logic        sdcmd_out;
    logic        sdcmd_oen;
    logic [3:0]  sddata_out;
    logic [3:0]  sddata_oen;
	} sdio_to_pad_t;
	typedef struct packed {
    logic        sdcmd_in;
		logic [3:0]  sddata_in;
	} pad_to_sdio_t;
endpackage
