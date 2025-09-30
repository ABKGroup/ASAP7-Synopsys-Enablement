##################################################################
# Portions Copyright 2022 Synopsys, Inc. All rights reserved.
# Portions of these TCL scripts are proprietary to and owned
# by Synopsys, Inc. and may only be used for internal use by
# educational institutions (including United States government
# labs, research institutes and federally funded research and
# development centers) on Synopsys tools for non-profit research,
# development, instruction, and other non-commercial uses or as
# otherwise specifically set forth by written agreement with
# Synopsys. All other use, reproduction, modification, or
# distribution of these TCL scripts is strictly prohibited.
##################################################################

set DESIGN $env(DESIGN)
set NWORST $env(NWORST)

set HOME_DIR "../../.."
set PDK_DIR "${HOME_DIR}/ASAP7"
set DESIGN_DIR "${HOME_DIR}/benchmark/${DESIGN}"
set CAP_EX_DIR "${DESIGN_DIR}/net_capacitance"
set TIMING_EX_DIR "${DESIGN_DIR}/timing_details"

set DB_FILE " \
    asap7sc7p5t_AO_RVT_FF_nldm_201020.db \
    sram_asap7_116x128_1rw.db \
    sram_asap7_32x256_1rw.db \
    sram_asap7_64x512_1rw.db \
    asap7sc7p5t_INVBUF_RVT_FF_nldm_201020.db \
    sram_asap7_124x64_1rw.db \
    sram_asap7_32x32_1rw.db \
    sram_asap7_64x64_1rw.db \
    asap7sc7p5t_OA_RVT_FF_nldm_201020.db \
    sram_asap7_16x256_1rw.db \
    sram_asap7_48x256_1rw.db \
    asap7sc7p5t_SEQ_RVT_FF_nldm_201020.db \
    sram_asap7_256x128_1rw.db \
    sram_asap7_62x64_1rw.db \
    asap7sc7p5t_SIMPLE_RVT_FF_nldm_201020.db \
    sram_asap7_32x128_1rw.db \
    sram_asap7_64x256_1rw.db \
    "
set SDC_FILE "${DESIGN_DIR}/${DESIGN}.sdc"
set NETLIST_FILE "${DESIGN_DIR}/${DESIGN}.v"


set search_path ". ${PDK_DIR}/db"
set target_library ${DB_FILE}
set link_library "* ${target_library}"
