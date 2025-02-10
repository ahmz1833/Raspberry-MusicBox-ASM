#==============================================
    # Project: Simple RaspberryPi Music Box
    # File Name: iofuncs.s
    # Description: This file contains functions and macros for printing and scanning
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef IOFUNCS_S_
.eqv    IOFUNCS_S_, 1

.include "macros.s"
.include "strfuncs.s"

.eqv STDIN,  0
.eqv STDOUT, 1
.eqv STDERR, 2

################################# Macros for output #################################
# fprint %fd, %buf
# fprint_lit %fd, "LiteralString"
# fputc %fd, %char_reg
# fprint_num %fd, %num, [base=10], [mindigits=1]

#----------------------------------------------------
# Macro: fprint %fd, %buf
# Note fd must not be in R1
.macro fprint fd buf
    PUSH {R0-R3}
    MOV  R1, \buf
    MOV  R0, \fd
    strlen R2, R1
    sys_write R0, R1, R2
    POP  {R0-R3}
.endm

#----------------------------------------------------
# Macro: fprint_rl %fd, buf_lbl
# Note fd must not be in R1
.macro fprint_rl fd buf_lbl
    B 92f
    .ltorg
92: PUSH {R1}
    LDR   R1, =\buf_lbl
    B 93f
    .ltorg
93: fprint \fd, R1
    POP  {R1}
.endm

#----------------------------------------------------
# Macro: fprint_lit %fd, "LiteralString"
# %fd is file descriptor and "LiteralString" is the string
# Note fd must not be in R1
.macro fprint_lit fd str:vararg
    .data; .align 8; 99:  .asciz ""\str""; .align 8; .text
    fprint_rl \fd, 99b
.endm

#----------------------------------------------------
# Macro: fputc %fd, %char
# %fd is  file descriptor, %char character
.macro fputc fd char
    PUSH {R0-R3}
    SUB  SP, SP, $4
    MOV  R3, \char
    STRB R3, [SP]
    sys_write \fd, SP, $1
    ADD  SP, SP, $4
    POP {R0-R3}
.endm

#----------------------------------------------------
# Macro: fprint_num %fdreg, %num, [base=10], [mindigits=1]
# %fd is file descriptor, %num is reg contains number
# base is the base of the number, mindigits is the minimum digits to print
# Note: fd must not be in R1
.macro fprint_num fd num base=$10 mindigits=$1
    PUSH {R0-R3}
    SUB   SP, SP, $32       @ Allocate space for fd and string buffer
    MOV   R1, \num
    MOV   R0, \fd
    STR   R0, [SP]	    @ Save fd in stack
    ADD   R0, SP, $8        @ Load string buffer address
    MOV   R2, \base
    MOV   R3, \mindigits
    CALL  _ltoa
    LDR   R0, [SP]         @ Load fd from stack
    ADD   R1, SP, $8        @ Load string buffer address
    fprint R0, R1
    ADD   SP, SP, $32
    POP   {R0-R3}
.endm

################################# Macros for input #################################
# fgetc %fd, %dest
# fgets %fd, %buf_reg, [size=1024]
# fgets_rl %fd_reg, buf_lbl, [size=1024]

#----------------------------------------------------
# Macro: fgetc %fd, %dest
# %fd is file descriptor, %dest is reg to store the character
.macro fgetc fd dest
    PUSH {R0}
    PUSH {R0-R3}
    MOV   R0, \fd
    ADD   R1, SP, $16
    MOV   R2, $1
    sys_read R0, R1, R2
    SUB   R0, R0, $1
    CMP   R0, $0
    STRNE R0, [SP, $12]
    POP   {R0-R3}
    POP   {\dest}
.endm

#----------------------------------------------------
# Macro: fgets %fd, %bufreg, [size=1024]
# %fd is file descriptor, %bufreg is reg contains buffer address, size is the size of the buffer
# Note: fd must not be in R1
# Note: this trims the newline character
.macro fgets fd basereg size=$1024
    PUSH {R0-R3}
    MOV  R1, \basereg
    MOV  R0, \fd
    MOV  R2, \size
    CALL _fgets
    POP  {R0-R3}
.endm

# Macro: fgets_rl %fd, buf_lbl, [size=1024]
# %fd is file descriptor, buf_lbl is the label of the buffer, size is the size of the buffer
# Note: this trims the newline character
.macro fgets_rl fd buf_lbl size=$1024
    PUSH {R1}
    LDR   R1, =\buf_lbl
    fgets \fd, R1, \size
    POP  {R1}
.endm

#---------------------------------------------------------
# Function: int _fgets(fd, buf, size)
# Description: Read a line from file descriptor fd to buffer buf with size size
# Note: the size is size with null terminator
# Note: This trims the newline character
_fgets:
    enter
    MOV    R4,  $1
._fgets_loop:
    CMP    R4,  R2
    BGE    ._fgets_end
    fgetc  R0, R5
    CMP    R5, $-1
    BEQ    ._fgets_eof
    ADD    R6, R1, R4
    STRB   R5, [R6, $-1]
    ADD    R4, R4, $1
    CMP    R5, $10
    BNE    ._fgets_loop
    SUB    R4, R4, $1
._fgets_end:
    ADD    R4, R4, $1
    MOV    R5, $0
    STRB   R5, [R1, R4]		@ Null terminate the string
    MOV    R0, R4		@ Return the number of characters read
    B      ._fgets_ret
._fgets_eof:
    MOV    R5, $0
    STRB   R5, [R1, R4]		@ Null terminate the string
    MOV    R0, $-1		@ return -1 for EOF
._fgets_ret:
    leave
    RET

.endif
