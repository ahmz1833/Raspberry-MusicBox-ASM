#==============================================
    # Project: Simple RaspberryPi Music Box
    # File Name: ansi.s
    # Description: This file contains ANSI escape sequences for colored output
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef ANSI_S_
.eqv    ANSI_S_, 1

.include "iofuncs.s"

.data
ANSI_RED_CODE:      .asciz "\033[0;31m"
ANSI_LRED_CODE:     .asciz "\033[0;91m"
ANSI_REDB_CODE:     .asciz "\033[1;31m"
ANSI_LREDB_CODE:    .asciz "\033[1;91m"
ANSI_GRN_CODE:      .asciz "\033[0;32m"
ANSI_LGRN_CODE:     .asciz "\033[0;92m"
ANSI_GRNB_CODE:     .asciz "\033[1;32m"
ANSI_LGRNB_CODE:    .asciz "\033[1;92m"
ANSI_YLW_CODE:      .asciz "\033[0;33m"
ANSI_LYLW_CODE:     .asciz "\033[0;93m"
ANSI_YLWB_CODE:     .asciz "\033[1;33m"
ANSI_LYLWB_CODE:    .asciz "\033[1;93m"
ANSI_BLU_CODE:      .asciz "\033[0;34m"
ANSI_LBLU_CODE:     .asciz "\033[0;94m"
ANSI_BLUB_CODE:     .asciz "\033[1;34m"
ANSI_LBLUB_CODE:    .asciz "\033[1;94m"
ANSI_MGN_CODE:      .asciz "\033[0;35m"
ANSI_LMGN_CODE:     .asciz "\033[0;95m"
ANSI_MGNB_CODE:     .asciz "\033[1;35m"
ANSI_LMGNB_CODE:    .asciz "\033[1;95m"
ANSI_CYN_CODE:      .asciz "\033[0;36m"
ANSI_LCYN_CODE:     .asciz "\033[0;96m"
ANSI_CYNB_CODE:     .asciz "\033[1;36m"
ANSI_LCYNB_CODE:    .asciz "\033[1;96m"
ANSI_RST_CODE:      .asciz "\033[0m"
ANSI_BOLD_CODE:     .asciz "\033[1m"
ANSI_UNDERL_CODE:   .asciz "\033[4m"

.text
.macro ANSI_RED    stream=$STDOUT  ;fprint_rl \stream, ANSI_RED_CODE;   .endm
.macro ANSI_LRED   stream=$STDOUT  ;fprint_rl \stream, ANSI_LRED_CODE;  .endm
.macro ANSI_REDB   stream=$STDOUT  ;fprint_rl \stream, ANSI_REDB_CODE;  .endm
.macro ANSI_LREDB  stream=$STDOUT  ;fprint_rl \stream, ANSI_LREDB_CODE; .endm
.macro ANSI_GRN    stream=$STDOUT  ;fprint_rl \stream, ANSI_GRN_CODE;   .endm
.macro ANSI_LGRN   stream=$STDOUT  ;fprint_rl \stream, ANSI_LGRN_CODE;  .endm
.macro ANSI_GRNB   stream=$STDOUT  ;fprint_rl \stream, ANSI_GRNB_CODE;  .endm
.macro ANSI_LGRNB  stream=$STDOUT  ;fprint_rl \stream, ANSI_LGRNB_CODE; .endm
.macro ANSI_YLW    stream=$STDOUT  ;fprint_rl \stream, ANSI_YLW_CODE;   .endm
.macro ANSI_LYLW   stream=$STDOUT  ;fprint_rl \stream, ANSI_LYLW_CODE;  .endm
.macro ANSI_YLWB   stream=$STDOUT  ;fprint_rl \stream, ANSI_YLWB_CODE;  .endm
.macro ANSI_LYLWB  stream=$STDOUT  ;fprint_rl \stream, ANSI_LYLWB_CODE; .endm
.macro ANSI_BLU    stream=$STDOUT  ;fprint_rl \stream, ANSI_BLU_CODE;   .endm
.macro ANSI_LBLU   stream=$STDOUT  ;fprint_rl \stream, ANSI_LBLU_CODE;  .endm
.macro ANSI_BLUB   stream=$STDOUT  ;fprint_rl \stream, ANSI_BLUB_CODE;  .endm
.macro ANSI_LBLUB  stream=$STDOUT  ;fprint_rl \stream, ANSI_LBLUB_CODE; .endm
.macro ANSI_MGN    stream=$STDOUT  ;fprint_rl \stream, ANSI_MGN_CODE;   .endm
.macro ANSI_LMGN   stream=$STDOUT  ;fprint_rl \stream, ANSI_LMGN_CODE;  .endm
.macro ANSI_MGNB   stream=$STDOUT  ;fprint_rl \stream, ANSI_MGNB_CODE;  .endm
.macro ANSI_LMGNB  stream=$STDOUT  ;fprint_rl \stream, ANSI_LMGNB_CODE; .endm
.macro ANSI_CYN    stream=$STDOUT  ;fprint_rl \stream, ANSI_CYN_CODE;   .endm
.macro ANSI_LCYN   stream=$STDOUT  ;fprint_rl \stream, ANSI_LCYN_CODE;  .endm
.macro ANSI_CYNB   stream=$STDOUT  ;fprint_rl \stream, ANSI_CYNB_CODE;  .endm
.macro ANSI_LCYNB  stream=$STDOUT  ;fprint_rl \stream, ANSI_LCYNB_CODE; .endm
.macro ANSI_RST    stream=$STDOUT  ;fprint_rl \stream, ANSI_RST_CODE;   .endm
.macro ANSI_BOLD   stream=$STDOUT  ;fprint_rl \stream, ANSI_BOLD_CODE;  .endm
.macro ANSI_UNDERL stream=$STDOUT  ;fprint_rl \stream, ANSI_UNDERL_CODE;.endm

.endif
