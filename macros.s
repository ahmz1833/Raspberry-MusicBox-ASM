#==============================================
    # Project: Simple RaspberryPi Music Box 
    # File Name: macros.s
    # Description: This file contains the general macros used in the program
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef MACROS_S_
.eqv    MACROS_S_, 1

############## Macro: call <label> ##############
# <label> : The label of the function to be called.
.macro CALL func
    BL \func
.endm

################# Macro: ret ####################
# This macro returns to the caller function.
.macro RET
    BX  LR
.endm

######## Macro: enter [n=0] [size=4] ########
# [n=0]  : The number of local variables to be allocated in stack.
# [size=4] : The size of each local variable in bytes.
# This macro allocates space in stack for local variables,
# and saves the -saved- registers in stack
.macro enter n=0 size=4
    PUSH {R4-R9, SL, FP, LR} 
    MOV  FP, SP
    SUB  SP, SP, $(\size*\n)
.endm

####### Macro: leave [size=0] [first=6] ########
# [size=0] : The number of 32-bit local variables to be deallocated in stack.
# This macro deallocates space in stack for local variables,
# and restores the -saved- registers from stack frame
.macro leave
    MOV  SP, FP
    POP  {R4-R9, SL, FP, LR}
.endm

#____________________________________________________
    # _div: Divide two numbers
    # R0 = dividend, R1 = divisor
    # R0 = quotient, R1 = remainder
    # This function divides R0 by R1 and stores the quotient in R0 and remainder in R1
.text
_div:
    enter
    MOV  R2, R0        // Dividend
    MOV  R3, R1        // Divisor
    MOV  R0, $0        // Quotient
    MOV  R1, $0        // Remainder
    CMP  R3, $0
    BEQ  error         // Handle division by zero
    MOV  R4, $1
1:  CMP  R2, R3
    BLT  2f
    LSL  R3, R3, $1    // Left shift divisor
    LSL  R4, R4, $1    // Left shift bit mask
    B    1b
2:  LSR  R3, R3, $1    // Right shift divisor
    LSR  R4, R4, $1    // Right shift bit mask
3:  CMP  R4, $0
    BEQ  done
    CMP  R2, R3
    BLT  4f
    SUB  R2, R2, R3    // Subtract divisor from dividend
    ORR  R0, R0, R4    // Set corresponding bit in quotient
4:  LSR  R3, R3, $1    // Right shift divisor
    LSR  R4, R4, $1    // Right shift bit mask
    B    3b
done:
    MOV  R1, R2        // Remainder
    leave
    RET
error:
    MOV  R0, $-1       // Return -1 for division by zero
    leave
    RET

####### Macro: DIVV q r s t ########
.macro DIVV q r s t 
    # q = s / t
    # r = s % t
    PUSH {R0}
    PUSH {R0}
    PUSH {R0-R4}
    MOV  R0, \s
    MOV  R1, \t
    CALL _div
    STR  R0, [SP, $20]
    STR  R1, [SP, $24]
    POP  {R0-R4}
    POP  {\q}
    POP  {\r}
.endm

########### Linux System Call Macros ###########
# void _exit(int status);
.macro sys_exit status
    MOV R0, \status
    MOV R7, #1
    SWI #0
.endm
# ssize_t read(int fd, void *buf, size_t count);
.macro sys_read fd, buf, count
    MOV R0, \fd
    MOV R1, \buf
    MOV R2, \count
    MOV R7, #3
    SWI #0
.endm
# ssize_t write(int fd, const void *buf, size_t count);
.macro sys_write fd, buf, count
    MOV R0, \fd
    MOV R1, \buf
    MOV R2, \count
    MOV R7, #4
    SWI #0
.endm
# int open(const char *filename, int flags, mode_t mode);
.macro sys_open filename, flags, mode
    MOV R0, \filename
    MOV R1, \flags
    MOV R2, \mode
    MOV R7, #5
    SWI #0
.endm
# int close(int fd);
.macro sys_close fd
    MOV R0, \fd
    MOV R7, #6
    SWI #0
.endm
# int creat(const char *filename, mode_t mode);
.macro sys_creat filename, mode
    MOV R0, \filename
    MOV R1, \mode
    MOV R7, #8
    SWI #0
.endm
# int unlink(const char *pathname);
.macro sys_unlink pathname
    MOV R0, \pathname
    MOV R7, #10
    SWI #0
.endm
# int chdir(const char *path);
.macro sys_chdir path
    MOV R0, \path
    MOV R7, #12
    SWI #0
.endm
# int fstat(int fd, struct stat *buf);
.macro sys_rename oldpath, newpath
    MOV R0, \oldpath
    MOV R1, \newpath
    MOV R7, #38
    SWI #0
.endm
# int mkdir(const char *pathname, mode_t mode);
.macro sys_mkdir pathname, mode
    MOV R0, \pathname
    MOV R1, \mode
    MOV R7, #39
    SWI #0
.endm
# int rmdir(const char *pathname);
.macro sys_rmdir pathname
    MOV R0, \pathname
    MOV R7, #40
    SWI #0
.endm
# int sys_times(struct tms *buf);
.macro sys_times buf
    MOV R0, \buf
    MOV R7, #43
    SWI #0
.endm
# int gettimeofd(struct timeval *tv, struct timezone *tz);
.macro sys_timeofd tv, tz
    MOV R0, \tv
    MOV R1, \tz
    MOV R7, #78
    SWI #0
.endm
# int getdents(unsigned int fd, struct linux_dirent *dirp, unsigned int count);
.macro sys_getdents fd, dirp, count
    MOV R0, \fd
    MOV R1, \dirp
    MOV R2, \count
    MOV R7, #141
    SWI #0
.endm
# int nanosleep(const struct timespec *req, struct timespec *rem);
.macro sys_nanosleep request, remain
    MOV R0, \request
    MOV R1, \remain
    MOV R7, #162
    SWI #0
.endm
# int getcwd(char *buf, size_t size);
.macro sys_getcwd buf, size
    MOV R0, \buf
    MOV R1, \size
    MOV R7, #183
    swi #0
.endm
# void* mmap2(void *addr, size_t length, int prot, int flags, int fd, unsigned long pgoffset);
.macro sys_mmap2 addr, length, prot, flags, fd, pgoffset
    MOV R0, \addr
    MOV R1, \length
    MOV R2, \prot
    MOV R3, \flags
    MOV R4, \fd
    MOV R5, \pgoffset    @ pgoffset is the offset / 4096 (= offset >> 12)
    MOV R7, #192
    SWI #0
.endm
# int clock_gettime(clockid_t clk_id, struct timespec *tp);
.macro sys_clock_gettime clk_id, tp
    MOV R0, \clk_id
    MOV R1, \tp
    MOV R7, #263
    SWI #0
.endm

.endif
