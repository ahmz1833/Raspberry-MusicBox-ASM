#==============================================
    # Project: Simple RaspberryPi Music Box
    # File Name: iofuncs.s
    # Description: This file contains the input/output functions and macros
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.ifndef GPIOFUNCS_S_
.eqv    GPIOFUNCS_S_, 1

.include "macros.s"
.include "iofuncs.s"
.include "delay.s"

.eqv O_RDONLY,    00000000
.eqv O_WRONLY,    00000001
.eqv O_RDWR,      00000002
.eqv O_CREAT,     00000100
.eqv O_EXCL,      00000200
.eqv O_APPEND,    00002000
.eqv O_DIRECTORY, 00200000
.eqv O_NOATIME,   01000000
.eqv O_CLOEXEC,   02000000
.eqv O_SYNC,      04010000

.eqv DT_REG,      0x08
.eqv DT_DIR,      0x04

.eqv PROT_READ,   0x1
.eqv PROT_WRITE,  0x2
.eqv PROT_EXEC,   0x4
.eqv PROT_NONE,   0x0

.eqv MAP_SHARED,            0x01
.eqv MAP_PRIVATE,           0x02
.eqv MAP_SHARED_VALIDATE,   0x03

# GPIO Base Address in Raspberry Pi (BCM2835) - Physical Address is 0x7E200000 - Virtual Address is 0x20200000
# Because we are using /dev/gpiomem, we will use 0x00200000 (0x20000000 already mapped to /dev/gpiomem)
.eqv GPIO_BASE, 0x00200000

# GPIO Function Select Registers
.eqv GPFSEL0, 0x00
.eqv GPFSEL1, 0x04
.eqv GPFSEL2, 0x08
.eqv GPFSEL3, 0x0C
.eqv GPFSEL4, 0x10
.eqv GPFSEL5, 0x14
.eqv FSEL_INPUT,  0b000
.eqv FSEL_OUTPUT, 0b001
.eqv FSEL_ALT0,   0b100
.eqv FSEL_ALT1,   0b101
.eqv FSEL_ALT2,   0b110
.eqv FSEL_ALT3,   0b111
.eqv FSEL_ALT4,   0b011
.eqv FSEL_ALT5,   0b010
.eqv FSEL_MASK,   0b111

# GPIO Pin Output Set Registers
.eqv GPSET0,    0x1C
.eqv GPSET1,    0x20

# GPIO Pin Output Clear Register
.eqv GPCLR0,    0x28
.eqv GPCLR1,    0x2C

# GPIO Pin Level Register
.eqv GPLEV0,    0x34
.eqv GPLEV1,    0x38

# GPIO Pin Pull-up/down Enable Register
.eqv GPPUD,     0x94
.eqv PUD_OFF,   0b00
.eqv PUD_DOWN,  0b01
.eqv PUD_UP,    0b10

# GPIO Pin Pull-up/down Clock Registers
.eqv GPPUDCLK0, 0x98
.eqv GPPUDCLK1, 0x9C

.eqv DELAY_CALIBRATION, 100000
#==============================================

.macro gpio_pin_fselect gpio_base pin function
    LDR R0, \gpio_base
    MOV R1, \pin
    MOV R2, \function
    CALL gpio_fselect
.endm

.macro gpio_pin_high gpio_base pin
    LDR R0, \gpio_base
    MOV R1, \pin
    MOV R2, $1
    CALL gpio_write
.endm

.macro gpio_pin_low gpio_base pin
    LDR R0, \gpio_base
    MOV R1, \pin
    MOV R2, $0
    CALL gpio_write
.endm

.macro gpio_pin_read gpio_base pin
    LDR R0, \gpio_base
    MOV R1, \pin
    CALL gpio_read
.endm

.macro gpio_freq gpio_base pin freq duration
    LDR R0, \gpio_base
    MOV R1, \pin
    MOV R2, \freq
    MOV R3, \duration
    CALL __gpio_generate_freq
.endm
#==============================================
.data
    gpio_path: .asciz "/dev/gpiomem"
.text

#==============================================
# Function: gpio_init()
# Description: This function opens the GPIO device and maps the GPIO registers to the virtual memory
# Inputs: None
# Outputs: void* (Mapped address of GPIO registers)
gpio_init:
    enter
    LDR R0, =gpio_path
    LDR R1, =(O_RDWR + O_SYNC + O_CLOEXEC + O_NOATIME)
    sys_open R0, R1, $0
    CMP R0, $-1
    BEQ ._init_gpio_error
    MOV R3, R0              @ File Descriptor
    sys_mmap2 $0, $4096, $(PROT_READ + PROT_WRITE), $(MAP_SHARED_VALIDATE), R3, $(GPIO_BASE / 4096)
    CMP R0, $-1
    BEQ ._init_gpio_error
    B ._init_gpio_done
._init_gpio_error:
    fprint_lit $STDERR, "Error: Unable to open GPIO device\n"
    sys_exit $-1
._init_gpio_done:
    leave
    RET

#==============================================
# Function: gpio_fselect(gpio_base, pin, function)
# Description: This function sets the function of the GPIO pin
# Inputs: void* gpio_base (Mapped address of GPIO registers), pin (GPIO Pin Number), function (Function to set)
# Outputs: None
gpio_fselect:
    enter
    ADD R0, $GPFSEL0
.gpio_fsel_loop:
    CMP R1, $10
    BLT .gpio_fsel_endloop
    ADD R0, $4
    ADD R1, $-10
    B .gpio_fsel_loop
.gpio_fsel_endloop:
    # Now, R0 contains the address of the proper FSEL register
    MOV R6, $3          @|
    MUL R1, R6, R1      @|
    MOV R6, $FSEL_MASK  @|
    LSL R6, R6, R1      @| R6 = FSEL_MASK << (3 * (pin % 10))
    LDR R7, [R0]        @| R7 = *FSEL
    BIC R7, R7, R6      @| R7 = R7 & ~R6
    LSL R6, R2, R1      @| R6 = function << (3 * (pin % 10))
    ORR R7, R7, R6      @| R7 = R7 | (function << (3 * (pin % 10)))
    STR R7, [R0]        @| *FSEL = R7
    leave
    RET

#==============================================
# Function: gpio_write(gpio_base, pin, value)
# Description: This function writes a value to the GPIO pin
# Inputs: void* gpio_base (Mapped address of GPIO registers), pin (GPIO Pin Number), value (Value to write)
# Outputs: None
gpio_write:
    enter
    CMP   R2, $0                    @|
    ADDEQ R0, $GPCLR0               @|
    ADDNE R0, $GPSET0               @| R0 = GPIO Pin Output Set/Clear Register Base
    CMP   R1, $32                   @|
    ADDGE R0, $4                    @|
    ADDGE R1, $-32                  @| R0 = GPIO Pin Output Set/Clear Register Appropriate
    MOV R2, $1                      @|
    LSL R2, R2, R1                  @| R2 = 1 << (pin % 32)
    STR R2, [R0]                    @| *GPIO Pin Output Set/Clear Register = R2
    MOV R2, $0                      @|
    STR R2, [R0]                    @| *GPIO Pin Output Set/Clear Register = 0
    leave
    RET

#==============================================
# Function: gpio_read(gpio_base, pin)
# Description: This function reads the value of the GPIO pin
# Inputs: void* gpio_base (Mapped address of GPIO registers), pin (GPIO Pin Number)
# Outputs: Value of the GPIO pin (0 or 1)
gpio_read:
    enter
    CMP R1, $32                     @|
    ADDGE R0, $GPLEV1               @|
    ADDLT R0, $GPLEV0               @| R0 = GPIO Pin Level Register
    ADDGE R1, $-32                  @|
    LDR R2, [R0]                    @| R2 = *GPIO Pin Level Register
    MOV R0, $1                      @|
    LSL R0, R0, R1                  @| R0 = 1 << (pin % 32)
    AND R0, R2, R0                  @| R0 = R2 & R0
    LSR R0, R0, R1                  @| R0 = R0 >> (pin % 32)
    leave
    RET

#==============================================
# Function: gpio_pullud(gpio_base, pin, pud)
# Description: This function sets the pull-up/down resistor of the GPIO pin
# Inputs: void* gpio_base (Mapped address of GPIO registers), pin (GPIO Pin Number), pud (PUD_OFF, PUD_DOWN, PUD_UP)
# Outputs: None
gpio_pullud:
    enter
    STR R2, [R0, $GPPUD]            @| Set the pull-up/down control
    delay_us $15                    @| Delay for 15 microseconds
    CMP R1, $32                     @|
    ADDGE R7, R0, $GPPUDCLK1        @|
    ADDLT R7, R0, $GPPUDCLK0        @| R7 = GPPUDCLK0 or GPPUDCLK1
    ADDGE R1, $-32                  @| 
    MOV R2, $1                      @|
    LSL R2, R2, R1                  @| R2 = 1 << (pin % 32)
    STR R2, [R7]                    @| Set the pull-up/down clock
    delay_us $15                    @| Delay for 15 microseconds
    MOV R2, $0                      @|
    STR R2, [R7]                    @| Clear the pull-up/down clock
    STR R2, [R0, $GPPUD]            @| Clear the pull-up/down control
    leave
    RET

#==============================================
# Function: __gpio_generate_freq(gpio_base, pin, freq, duration)
# Description: This function generates a square wave of a given frequency and duration on the GPIO pin
# Inputs: void* gpio_base (Mapped address of GPIO registers), pin (GPIO Pin Number), freq (Frequency in Hz), duration (Duration in milliseconds)
# Outputs: None
__gpio_generate_freq:
    enter 1
    STR R0, [SP]                            @| Store the GPIO Base Address
    LDR R5, =500000000                      @| 500,000,000
    DIVV R6, R7, R5, R2                     @| R6 = 500,000,000 / freq
    MOV R0, $1000                           @| 
    MUL R7, R0, R3                          @| R7 = duration * 1,000 (Convert milliseconds to microseconds)
    gettimes R0                             @| R0 = Current Time in Microseconds
    ADD R7, R0, R7                          @| R7 = Current Time + duration  (End Time)
    LDR R0, =DELAY_CALIBRATION              @| Load the calibration value
    SUB R6, R0                              @| Subtract the calibration value
__gpio_freq_loop:
    MOV R2, $1                              @|
    LDR R0, [SP]                            @|
    CALL gpio_write                         @| Set the GPIO Pin High
    delay $0, R6                            @| Delay for half the period
    MOV R2, $0                              @|
    LDR R0, [SP]                            @|
    CALL gpio_write                         @| Set the GPIO Pin Low
    delay $0, R6                            @| Delay for half the period
    gettimes R0                             @| R0 = Current Time in Microseconds
    CMP R0, R7                              @|
    BLT __gpio_freq_loop                    @| Loop until the end time
    leave
    RET

.endif
