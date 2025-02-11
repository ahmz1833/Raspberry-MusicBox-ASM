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
    melody1_size: .word 28

    # Define the melody 2 : Happy Birthday
    melody2_freq:
        .word G4, G4, A4, G4, C5, B4, G4, G4, A4, G4, D5, C5
        .word G4, G4, G5, E5, C5, B4, A4, F5, F5, E5, C5, D5
    melody2_dur:
        .word 1, 1, 2, 2, 2, 4, 1, 1, 2, 2, 2, 4
        .word 1, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2
    melody2_size: .word 24

    # Define the melody 3 : Jingle Bells
    melody3_freq: .word 1
    melody3_dur:  .word 1
    melody3_size: .word 1


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
    
#lloop:
 #   gpio_freq [SP], $SPKR, $C4, $300
#    delay_ms $300
    # gpio_freq [SP], $SPKR, $D4, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $E4, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $F4, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $G4, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $A4, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $B4, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $C5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $D5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $E5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $F5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $G5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $A5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $B5, $300
    # delay_ms $300
    # gpio_freq [SP], $SPKR, $C6, $300
    # delay_ms $300
    
 #   B lloop

    // Play the melody 1
loop1:
    LDR R0, [SP]
    MOV R1, $SPKR
    LDR R2, =melody1_freq
    LDR R3, =melody1_dur
    LDR R4, =melody1_size
    LDR R4, [R4]
    CALL play_melody
    B loop1

read_loop:
    gpio_pin_read [SP], $BTN1
    delay_ms $100
    CMP R0,  $0
    BNE read_loop

loop:
    // Turn on the blue LED
    gpio_pin_high [SP], $LED_BLUE
    delay_ms $500
    // Turn off the blue LED
    gpio_pin_low [SP], $LED_BLUE
    delay_ms $500
    B loop

    MOV R0, $0
    leave
    RET

##################################################
# play_melody(gpio_base, pin, freq, dur, size)
play_melody:
    enter 1
    STR R0, [SP]                    // Store the mapped address of GPIO in the stack
    MOV R5, $0                      // Counter
    MOV R6, R2                      // Frequency Array
    MOV R7, R3                      // Duration Array
_play_note:
    LDR R8, [R6, R5, LSL $2]        // Load the frequency of the note
    LDR R0, [R7, R5, LSL $2]        // Load the duration of the note
    MOV R2, $NOTE_DURATION
    MUL R9, R2, R0                  // Multiply the duration by the note duration
    gpio_freq [SP], R1, R8, R9      // Play the note
    delay_ms $50                    // Delay between notes
    ADD R5, R5, $1                  // Increment the counter
    CMP R5, R4
    BLT _play_note
    leave
    RET
