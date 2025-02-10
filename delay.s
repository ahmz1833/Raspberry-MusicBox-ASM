#==============================================
    # Project: Simple RaspberryPi Music Box
    # File Name: delay.s
    # Description: This file contains the precise delay functions
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef DELAY_S_
.eqv    DELAY_S_, 1

.include "macros.s"

#----------------------------------------------------
# Macro: delay s ns
# s : The delay time in seconds
# ns : The delay time in nanoseconds
.macro delay s, ns
    PUSH {R0-R8}
    SUB SP, SP, $8      @ Allocate space for timespec structure
    MOV R0, \s          @ Load the seconds
    MOV R1, \ns         @ Load the nanoseconds
    STR R0, [SP, $0]    @ Store the seconds in timespec structure
    STR R1, [SP, $4]    @ Store the nanoseconds in timespec structure
    sys_nanosleep SP, $0
    ADD SP, SP, $8      @ Deallocate space for timespec structure
    POP {R0-R8}
.endm

#----------------------------------------------------
# Macro: delay_ms ms
# ms : The delay time in milliseconds
.macro delay_ms ms
    PUSH {R0-R8}
    SUB SP, SP, $8      @ Allocate space for timespec structure
    MOV R0, $0          @ Load the seconds
    MOV R1, \ms         @ Load the milliseconds
    MOV R6, $1000       @ Load the conversion factor
    MUL R1, R6          @ Convert milliseconds to microseconds
    MUL R1, R6          @ Convert microseconds to nanoseconds
    STR R0, [SP, $0]    @ Store the milliseconds in timespec structure
    STR R1, [SP, $4]    @ Store the nanoseconds in timespec structure
    sys_nanosleep SP, $0
    ADD SP, SP, $8      @ Deallocate space for timespec structure
    POP {R0-R8}
.endm

#----------------------------------------------------
# Macro: delay_us us
# us : The delay time in microseconds
.macro delay_us us
    PUSH {R0-R8}
    SUB SP, SP, $8      @ Allocate space for timespec structure
    MOV R0, $0          @ Load the seconds
    MOV R1, \us         @ Load the microseconds
    MOV R6, $1000       @ Load the conversion factor
    MUL R1, R6          @ Convert microseconds to nanoseconds
    STR R0, [SP, $0]    @ Store the microseconds in timespec structure
    STR R1, [SP, $4]    @ Store the nanoseconds in timespec structure
    sys_nanosleep SP, $0
    ADD SP, SP, $8      @ Deallocate space for timespec structure
    POP {R0-R8}
.endm

#----------------------------------------------------
# Macro: gettimes dest
# dest : The destination register to store the current time in microseconds
.macro gettimes dest
    PUSH {R0}
    PUSH {R0-R9}
    SUB SP, SP, $8          @ Allocate space for tv structure
    sys_timeofd SP, $0      @ Get the current time
    LDR R0, [SP]            @ Load the current seconds  
    LDR R1, [SP, $4]        @ Load the current microseconds
    LDR R2, =1000000        @ Load the conversion factor
    MUL R0, R2              @ Convert seconds to microseconds
    ADD R0, R1              @ Add the microseconds
    ADD SP, SP, $8          @ Deallocate space for tv structure
    STR R0, [SP, $40]
    POP {R0-R9}
    POP {\dest}
.endm

.endif
