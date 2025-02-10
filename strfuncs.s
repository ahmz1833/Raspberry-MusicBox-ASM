#==============================================
    # Project: Simple RaspberryPi Music Box
    # File Name: strfuncs.S
    # Description: This file contains functions and macros for string manipulation
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef STRFUNCS_S_
.eqv    STRFUNCS_S_, 1

.include "macros.s"

#----------------------------------------------------------------------
# Macro: strlen %dest, %basereg
# Description: Calculate the length of a string
# Note: basereg and dest should not be R9 or the same
.macro strlen dest basereg
    PUSH {R9}
    MOV   \dest, $-1
1:  ADD   R9, \basereg, \dest
    LDRB  R9, [R9, $1]
    ADD   \dest, $1
    CMP   R9,    $0
    BNE   1b
    POP  {R9}
.endm

#----------------------------------------------------------------------
# Macro: ltoa %buf, %num, [base=10], [mindigits=1]
# Description: Convert a number to a string
# Note: num should not be in R0
.macro ltoa buf, num, base=$10, mindigits=$1
    PUSH {R0-R3}
    MOV  R0, \buf
    MOV  R1, \num
    MOV  R2, \base
    MOV  R3, \mindigits
    CALL _ltoa
    POP  {R0-R3}
.endm

#----------------------------------------------------------------------
# Macro: atol %str, %dstreg, [base=10]
# Description: Convert a string to a number
.macro atol str, dstreg, base=$10
    PUSH {R0}
    PUSH {R0-R3}
    MOV  R0, \str
    MOV  R1, \base
    CALL _atol
    STR  R2, [SP, $16]
    POP  {R0-R3}
    POP  {\dstreg}
.endm

#----------------------------------------------------------------------
# Macro: strcheck %buf_lbl, "string", jmp_lbl
# Description: Compare a string with a literal string
# Note: This macro useful for checking commands with no arguments
.macro strcheck buf_lbl, str_lit, jmp_lbl
    .data; .align 8; 89:  .asciz "\str_lit"; .align 8; .text
    LDR    R0, =89b
    LDR    R1, =\buf_lbl
    strlen R2, R0
    strlen R3, R1
    CMP    R2, R3
    MOVLT  R2, R3
    CALL   _strncmp
    CMP    R0, $0
    BEQ    \jmp_lbl
.endm

#---------------------------------------------------------------------
# Macro: strncheck %buf_lbl, "string", jmp_lbl
# Description: Compare a string with a literal string (max n characters : strlen of literal string)
# Note: This macro useful for checking commands having arguments
.macro strncheck buf_lbl, str_lit, jmp_lbl
    .data; .align 8; 89:  .asciz "\str_lit"; .align 8; .text
    LDR    R0, =89b
    LDR    R1, =\buf_lbl
    strlen R2, R0
    CALL   _strncmp
    CMP    R0, $0
    BEQ    \jmp_lbl
.endm

#----------------------------------------------------------------------
# Macro: strchr %dest, %str, char_imm
# Description: Find the first occurrence of a character in a string
.macro strchr destreg, basereg, char_imm
    PUSH {R0}
    PUSH {R0, R1}
    MOV  R0, \basereg
    MOV  R1, \char_imm
    CALL _strchr
    STR  R0, [SP, $8]
    POP  {R0, R1}
    POP  {\destreg}
.endm

#----------------------------------------------------------------------
# Function: int32_t _strcmp(str1, str2, n)
# Description: Compare two strings up to n characters
_strncmp:
    enter
    MOV  R5, $0
    MOV  R6, $0
    MOV  R7, $0
    ._sncmp_loop:
        CMP  R7, R2                         @ Compare the counter with the required digits
        BGE  ._sncmp_end                    @ If the counter is equal to the required digits, jump to end
        LDRB R5, [R0, R7]                   @ Load the character of the first string to R5
        LDRB R6, [R1, R7]                   @ Load the character of the second string to R6
        ADD  R7, $1                         @ Move the string pointer to the next position
        CMP  R5, R6                         @ Compare the characters
        BEQ  ._sncmp_loop                   @ If characters are the same, continue
._sncmp_end:
    SUB  R0, R5, R6                         @ Return the difference
    leave
    RET

#----------------------------------------------------------------------
# Function: char* _strchr(str, c)
_strchr:
    enter
    MOV  R4, $0
._strchr_loop:
    LDRB R5, [R0, R4]                       @ Load the character of the string to R5
    CMP  R5, R0                             @ Compare the character with c
    BEQ  ._strchr_ret                       @ If the character is equal to c, return the pointer
    CMP  R5, $0                             @ Compare the character with null
    BEQ  ._strchr_end                       @ If the character is null, return null
    ADD  R4, $1                             @ Move the string pointer to the next position
    B    ._strchr_loop
._strchr_end:
    MOV  R0, $0                             @ Return null
    MOV  R4, $0
._strchr_ret:
    ADD  R0, R4                             @ Return the pointer
    leave
    RET

#----------------------------------------------------------------------
# Function: uint64_t _atol(str, base)
# Description: Convert a string to a number
# Note: not supported base > 10
.text
_atol:
    enter
    MOV    R7, $0                            @ The Number
    MOV    R8, $0                            @ The Sign
    LDRB   R5, [R0]                          @ Load the first character of the string to R5
    CMP    R5, $'-'                          @ Compare the first character with '-'
    BNE    _a2l_work                         @ If the first character is not '-', jump to pos
    MOV    R8, $1                            @ Set the sign to negative
    ADD    R0, $1                            @ Move the string pointer to the next position
_a2l_work:
    LDRB   R5, [R0]                          @ Load the first character of the string to R5
    CMP    R5, $0                            @ Compare the character with null
    BEQ    _a2l_end                          @ If the character is null, jump to end
    MUL    R9, R7, R1                        @ R9 <- R7 * base
    MOV    R7, R9                            @ R7 <- old R7 * base
    CMP    R5, $'0'                          @ Compare the character with '0'
    BLT    _a2l_err                          @ If the character is not a digit, jump to err
    CMP    R5, $'9'                          @ Compare the character with '9'
    BGT    _a2l_err                          @ If the character is not a digit, jump to err
    SUB    R5, R5, $'0'                      @ Convert the character to a number
    ADD    R7, R7, R5                        @ R7 <- R7 + R5
    ADD    R0, $1                            @ Move the string pointer to the next position
    B      _a2l_work                         @ Loop
_a2l_end:
    CMP    R8, $0                            @ Compare the sign with 0
    BEQ    _a2l_pos                          @ If the sign is positive, jump to pos
    MOV    R8, $0
    SUB    R7, R8, R7                        @ Negate the R7
_a2l_pos:
    MOV    R2, R7                            @ Return the number
    B      _a2l_ret
_a2l_err:
    MOV    R7, $0                            @ Error (return 0)
_a2l_ret:
    leave
    RET

#----------------------------------------------------------------------
# Function: _ltoa(buf, num, base, min_digits)
# Description: Convert a number to desired base string representation
.text
_ltoa:
    enter
    MOV    R4, R0                            @ Load the buffer address to R4
    MOV    R7, R1                            @ Load the number to R7
    MOV    R5, $0                            @ Initialize the counter to 0
    CMP    R7, $0                            @ Compare the number with 0
    BGE    10f                               @ If the number is positive, jump to 1
    MOV    R6, $'-'                          @ Load the negative sign to R8
    STRB   R6, [R4]                          @ Store the negative sign in the buffer
    ADD    R4, $1                            @ Move the buffer pointer to the next position
    MOV    R8, $0
    SUB    R7, R8, R7                        @ R7 <- -R7
10: DIVV   R9, R8, R7, R2                    @ R9 <- R7 / base, R8 <- R7 % base
    PUSH  {R8}                               @ Push the reminder to stack
    ADD    R5, $1                            @ R5 <- R5 + 1
    MOV    R7, R9                            @ R7 <- R9
    CMP    R7, $0                            @ Compare the number with 0
    BNE    10b                               @ If the number is not 0, jump to 1
11: CMP    R5, R3                            @ Compare the number of digits with the required digits
    BGE    12f                               @ If the number of digits is greater than the required digits, jump to 2
    MOV    R6, $0                            @ Load '0' to R8
    PUSH  {R6}                               @ Push '0' to stack
    ADD    R5, $1                            @ R5 <- R5 + 1
    B      11b                               @ Loop
12: POP   {R6}                               @ Pop the digit from stack
    CMP    R6, $9                            @ Compare the digit with 9
    BLE    13f                               @ If the digit is less than or equal to 9, jump to 3
    ADD    R6, $(-10 + 'A' - '0')            @ Convert the reminder to ASCII (HEX)
13: ADD    R6, $'0'                          @ Convert the reminder to ASCII
    STRB   R6, [R4]                          @ Store the digit in the buffer
    ADD    R4, $1                            @ Move the buffer pointer to the next position
    SUB    R5, $1                            @ R5 <- R5 - 1
    CMP    R5, $0                            @ Compare the number of digits with 0
    BNE    12b                               @ If the number of digits is not 0, jump to 2
    MOV    R6, $0                            @ Load the null terminator to R8
    STRB   R6, [R4]                          @ Store the null terminator in the buffer
    leave
    RET
#----------------------------------------------------------------------
.endif
