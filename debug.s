#==============================================
    # Project: Simple RaspberryPi Music Box
    # File Name: debug.s
    # Description: This file contains the debugging functions and macros
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef DEBUG_S_
.eqv    DEBUG_S_, 1

.include "macros.s"
.include "strfuncs.s"
.include "iofuncs.s"

##################################### Debug Purposes #####################################
    # Debugging macros for printing the value of a register in hexadecimal format
    # Usage: debugd <register>
    # <register> : The register to be printed in hexadecimal format.
    # This macro prints the value of register in hexadecimal and decimal format.
.data
.align 8
debug_fmt:  .asciz "\033[0;91mDEBUG: \033[0;36m\0\0"
debug_fmt2: .asciz "\033[0m == \033[1;33m0x\0\0\0\0\0\0"
debug_fmt3: .asciz "\033[0;1m (\0\0\0"
debug_fmt4: .asciz ")\033[0m\n\0"
.text
.macro debugd reg
    fprint_rl  $STDERR debug_fmt
    fprint_lit $STDERR "\reg"
    fprint_rl  $STDERR debug_fmt2
    PUSH {R12}
    MOV   R12, \reg
    LSR   R12, R12, $16
    fprint_num $STDERR, R12, $16, $4
    MOV   R12, \reg
    LSL   R12, R12, $16
    LSR   R12, R12, $16
    fprint_num $STDERR, R12, $16, $4
    POP  {R12}
    fprint_rl  $STDERR debug_fmt3
    fprint_num $STDERR, \reg
    fprint_rl  $STDERR debug_fmt4
.endm

.endif
