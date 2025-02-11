#==============================================
    # Project: Simple RaspberryPi Music Box 
    # File Name: main.s
    # Description: This file contains the main function of the program
    # ARM32 Project - CSL 1403-1 - Dr. Jahangir
#==============================================
.include "macros.s"
.include "strfuncs.s"
.include "iofuncs.s"
.include "gpiofuncs.s"
.include "debug.s"
.include "ansi.s"
.include "delay.s"

################################################
# Define GPIO Pins

.eqv LED_BLUE, 22
.eqv LED_RED, 17
.eqv LED_GREEN, 27

.eqv BTN1, 23
.eqv BTN2, 24
.eqv BTN3, 25

.eqv SPKR, 4

################################################
# Define Music Notes

.eqv B2,  123   // Si
.eqv C3,  131   // Do
.eqv C3s, 139   // Do Dièse - Re Bémol
.eqv D3,  147   // Re
.eqv D3s, 156   // Re Dièse - Mi Bémol
.eqv E3,  165   // Mi
.eqv F3,  175   // Fa
.eqv F3s, 185   // Fa Dièse - Sol Bémol
.eqv G3,  196   // Sol
.eqv G3s, 208   // Sol Dièse - La Bémol
.eqv A3,  220   // La
.eqv A3s, 233   // La Dièse - Si Bémol
.eqv B3,  247   // Si
.eqv C4,  261   // Do
.eqv C4s, 277   // Do Dièse - Re Bémol
.eqv D4,  294   // Re
.eqv D4s, 311   // Re Dièse - Mi Bémol
.eqv E4,  329   // Mi
.eqv F4,  349   // Fa
.eqv F4s, 370   // Fa Dièse - Sol Bémol
.eqv G4,  392   // Sol
.eqv G4s, 415   // Sol Dièse - La Bémol
.eqv A4,  440   // La
.eqv A4s, 466   // La Dièse - Si Bémol
.eqv B4,  493   // Si
.eqv C5,  523   // Do
.eqv C5s, 554   // Do Dièse - Re Bémol
.eqv D5,  587   // Re
.eqv D5s, 622   // Re Dièse - Mi Bémol
.eqv E5,  659   // Mi
.eqv F5,  698   // Fa
.eqv F5s, 740   // Fa Dièse - Sol Bémol
.eqv G5,  784   // Sol
.eqv G5s, 831   // Sol Dièse - La Bémol
.eqv A5,  880   // La
.eqv A5s, 932   // La Dièse - Si Bémol
.eqv B5,  987   // Si
.eqv C6,  1046  // Do
.eqv C6s, 1108  // Do Dièse - Re Bémol
.eqv D6,  1174  // Re
.eqv D6s, 1244  // Re Dièse - Mi Bémol
.eqv E6,  1318  // Mi
.eqv F6,  1396  // Fa
.eqv F6s, 1480  // Fa Dièse - Sol Bémol
.eqv G6,  1568  // Sol
.eqv G6s, 1661  // Sol Dièse - La Bémol
.eqv A6,  1760  // La

.eqv NOTE_DURATION, 300
##################################################

# Begin of data section
.data
    # Define the melody 1 : Twinkle Twinkle Little Star
    melody1_freq: 
        .word C4, C4, G4, G4, A4, A4, G4, F4, F4, E4, E4, D4, D4, C4
        .word G4, G4, F4, F4, E4, E4, D4, G4, G4, F4, F4, E4, E4, D4
    melody1_dur:
        .word 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2
        .word 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2
    melody1_led:  // Raghs Noor
        .word 0b001, 0b001, 0b010, 0b010, 0b100, 0b100, 0b010, 0b111, 0b111, 0b100, 0b100, 0b010, 0b010, 0b001
        .word 0b010, 0b010, 0b111, 0b111, 0b100, 0b100, 0b010, 0b010, 0b010, 0b111, 0b111, 0b100, 0b100, 0b010
    melody1_size: .word 28

    # Define the melody 2 : Happy Birthday
    melody2_freq:
        .word G4, G4, A4, G4, C5, B4, G4, G4, A4, G4, D5, C5
        .word G4, G4, G5, E5, C5, B4, A4, F5, F5, E5, C5, D5
        .word C5, G4, G4, A4, G4, C5, B4, G4, G4, G5, E5, C5
        .word B4, A4, F5, F5, E5, C5, D5, C5
    melody2_dur:
        .word 1, 1, 2, 2, 2, 4, 1, 1, 2, 2, 2, 4
        .word 1, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2
        .word 1, 1, 2, 2, 2, 4, 1, 1, 2, 2, 2, 4
        .word 1, 1, 2, 2, 2, 2, 2, 1
    melody2_led:  // Raghs Noor
        .word 0b010, 0b010, 0b100, 0b010, 0b001, 0b100, 0b010, 0b010, 0b100, 0b010, 0b001, 0b001
        .word 0b010, 0b010, 0b001, 0b010, 0b001, 0b100, 0b010, 0b010, 0b001, 0b001, 0b001, 0b100
        .word 0b100, 0b010, 0b010, 0b100, 0b010, 0b001, 0b100, 0b010, 0b010, 0b001, 0b001, 0b001
        .word 0b100, 0b010, 0b010, 0b001, 0b001, 0b001, 0b100, 0b010
    melody2_size: .word 42
    
    # Define the melody: Canon in D (Simplified)
    melody3_freq:
        .word D4, A3, B3, F3s, G3, D3, G3, A3
        .word D4, A3, B3, F3s, G3, D3, G3, A3
        .word B3, F3s, G3, D3, E3, B2, E3, F3s
        .word G3, D3, G3, A3, B3, F3s, G3, A3
    melody3_dur:
        .word 2, 2, 2, 2, 2, 2, 2, 2
        .word 2, 2, 2, 2, 2, 2, 2, 2
        .word 2, 2, 2, 2, 2, 2, 2, 2
        .word 2, 2, 2, 2, 2, 2, 2, 2
    melody3_led:  # LED effect pattern
        .word 0b001, 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010
        .word 0b100, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100, 0b001
        .word 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100
        .word 0b001, 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010
    melody3_size: .word 32

    # Define the melody: My Heart Will Go On (Simplified)
    melody4_freq:
        .word E4, G4, A4, B4, A4, G4, E4, D4
        .word B4, C5, D5, C5, A4, G4, A4, E4
        .word E4, G4, A4, B4, A4, G4, E4, D4
        .word B4, C5, D5, C5, A4, G4, A4, E4
    melody4_dur:
        .word 1, 1, 1, 2, 1, 1, 1, 2
        .word 1, 1, 1, 2, 1, 1, 1, 2
        .word 1, 1, 1, 2, 1, 1, 1, 2
        .word 1, 1, 1, 2, 1, 1, 1, 2
    melody4_led:  # LED effect pattern (soft pulsing)
        .word 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100
        .word 0b001, 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010
        .word 0b100, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100, 0b001
        .word 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100
    melody4_size: .word 32


    # Define the melody: Persian Tavalodet Mobarak
    melody5_freq:
        .word C4, C4, F4, C4, C4, F4, C4, C4, F4, F4, E4, D4, E4
        .word C4, C4, E4, C4, C4, E4, C4, C4, E4, E4, D4, E4, F4
        .word E4, F4, G4, G4, F4, E4, D4, D4, E4, F4, D4, E4, D4, C4
    melody5_dur:
        .word 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2
        .word 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2
        .word 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2
    melody5_led:  // Raghs Noor
        .word 0b001, 0b001, 0b010, 0b001, 0b001, 0b010, 0b001, 0b001, 0b010, 0b010, 0b100, 0b010, 0b100
        .word 0b001, 0b001, 0b100, 0b001, 0b001, 0b100, 0b001, 0b001, 0b100, 0b100, 0b010, 0b100, 0b010
        .word 0b100, 0b010, 0b001, 0b001, 0b010, 0b100, 0b010, 0b010, 0b100, 0b001, 0b100, 0b010, 0b100, 0b001
    melody5_size: .word 40
#################################################

# Begin of text section
.text
.global _start
_start:
    CALL main
    sys_exit R0

##################################################
main:
    enter 1
    
    CALL gpio_init
    STR R0, [SP]                    // Store the mapped address of GPIO in the stack

    // Set the LED pins as output
    gpio_pin_fselect [SP], $LED_BLUE, $FSEL_OUTPUT
    gpio_pin_fselect [SP], $LED_RED, $FSEL_OUTPUT
    gpio_pin_fselect [SP], $LED_GREEN, $FSEL_OUTPUT

    // Set the button pins as input
    gpio_pin_fselect [SP], $BTN1, $FSEL_INPUT
    gpio_pin_fselect [SP], $BTN2, $FSEL_INPUT
    gpio_pin_fselect [SP], $BTN3, $FSEL_INPUT

    // Set the speaker pin as output
    gpio_pin_fselect [SP], $SPKR, $FSEL_OUTPUT
    
    gpio_freq [SP], $LED_RED, $4, $1000
    

loop1:
    LDR R0, [SP]
    MOV R1, $SPKR
    LDR R2, =melody5_freq
    LDR R3, =melody5_dur
    LDR R4, =melody5_led
    LDR R5, =melody5_size
    LDR R5, [R5]
    CALL play_melody
    gpio_pin_read [SP], $BTN1
    CMP R0,  $0
    BNE loop1

    MOV R0, $0
    leave
    RET

##################################################
# play_melody(gpio_base, pin, freq, dur, led, size)
play_melody:
    enter 2
    STR R0, [SP]                    // Store the mapped address of GPIO in the stack
    STR R5, [SP, $4]                // Store the size of the melody in the stack
    MOV R5, $0                      // Counter
    MOV R6, R2                      // Frequency Array
    MOV R7, R3                      // Duration Array
    MOV R8, R4                      // LED Array
_play_note:
    LDR R0, [SP]                    // Load the mapped address of GPIO
    PUSH {R1}
    LDR R1, [R8, R5, LSL $2]        // Load the LED state
    CALL set_leds
    POP {R1}
    LDR R3, [R6, R5, LSL $2]        // Load the frequency of the note
    LDR R0, [R7, R5, LSL $2]        // Load the duration of the note
    MOV R2, $NOTE_DURATION
    MUL R9, R2, R0                  // Multiply the duration by the note duration
    gpio_freq [SP], R1, R3, R9      // Play the note
    delay_ms $50                    // Delay between notes
    ADD R5, R5, $1                  // Increment the counter
    LDR R2, [SP, $4]                // Load the size of the melody
    CMP R5, R2
    BLT _play_note
    leave
    RET

##################################################
# set_leds(gpio_base, leds) : Set the LEDs (0bRGB)
set_leds:
    enter
    STR R0, [SP]                    // Store the mapped address of GPIO in the stack
    MOV R4, R1                      // Store the LED state in R4
    MOV R1, $LED_BLUE               // Blue LED
    AND R2, R4, $1                  // Check the state of the blue LED
    CALL gpio_write
    LDR R0, [SP]                    // Load the mapped address of GPIO
    MOV R1, $LED_GREEN              // Green LED
    LSR R4, R4, $1                  // Shift the LED state
    AND R2, R4, $1                  // Check the state of the green LED
    CALL gpio_write
    LDR R0, [SP]                    // Load the mapped address of GPIO
    MOV R1, $LED_RED                // Red LED
    LSR R4, R4, $1                  // Shift the LED state
    AND R2, R4, $1                  // Check the state of the red LED
    CALL gpio_write
    leave
    RET
