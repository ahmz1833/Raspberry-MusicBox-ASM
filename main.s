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
.eqv SALAMMMMM, 0     # This is Contribution
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

.eqv NOTE_DURATION, 120
##################################################

# Begin of data section
.data
    # Define melody 1 : Twinkle Twinkle Little Star
    melody1_freq: 
        .word G3, G3, D4, D4, E4, E4, D4  @ Twinkle Twinkle Little Star
        .word C4, C4, B3, B3, A3, A3, G3  @ How I wonder what you are
        .word D4, D4, C4, C4, B3, B3, A3  @ Up above the world so high
        .word D4, D4, C4, C4, B3, B3, A3  @ Like a diamond in the sky
        .word G3, G3, D4, D4, E4, E4, D4  @ Twinkle Twinkle Little Star
        .word C4, C4, B3, B3, A3, A3, G3  @ How I wonder what you are
    melody1_dur:
        .word 2, 2, 2, 2, 2, 2, 4
        .word 2, 2, 2, 2, 2, 2, 4
        .word 2, 2, 2, 2, 2, 2, 4
        .word 2, 2, 2, 2, 2, 2, 4
        .word 2, 2, 2, 2, 2, 2, 4
        .word 2, 2, 2, 2, 2, 2, 4
    melody1_led:
        .word 0b001, 0b001, 0b100, 0b100, 0b010, 0b010, 0b100 
        .word 0b010, 0b010, 0b001, 0b001, 0b111, 0b111, 0b001
        .word 0b100, 0b100, 0b010, 0b010, 0b001, 0b001, 0b111
        .word 0b100, 0b100, 0b010, 0b010, 0b001, 0b001, 0b111
        .word 0b001, 0b001, 0b100, 0b100, 0b010, 0b010, 0b100
        .word 0b010, 0b010, 0b001, 0b001, 0b111, 0b111, 0b001
    melody1_size: .word 42
    #________________________________________________
    # Define melody 2 : Happy Birthday
    melody2_freq:
        .word G4, G4, A4, G4, C5, B4
        .word G4, G4, A4, G4, D5, C5
        .word G4, G4, G5, E5, C5, B4, A4
        .word F5, F5, E5, C5, D5, C5
    melody2_dur:
        .word 1, 1, 2, 2, 2, 4
        .word 1, 1, 2, 2, 2, 4
        .word 1, 1, 2, 2, 2, 2, 4
        .word 1, 1, 2, 2, 2, 4
    melody2_led:
        .word 0b010, 0b010, 0b100, 0b010, 0b001, 0b111
        .word 0b010, 0b010, 0b100, 0b010, 0b001, 0b111
        .word 0b010, 0b010, 0b001, 0b100, 0b001, 0b010, 0b111
        .word 0b001, 0b001, 0b100, 0b001, 0b010, 0b111
    melody2_size: .word 25
    #________________________________________________
    # Define melody 3 : Row Row Row Your Boat
    melody3_freq:
        .word C4, C4, C4, D4, E4, E4, D4, E4, F4, G4
        .word C5, C5, C5, G4, G4, G4, E4, E4, E4, C4, C4, C4
        .word G4, F4, E4, D4, C4
    melody3_dur:
        .word 4, 4, 2, 1, 4, 2, 1, 2, 1, 6
        .word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        .word 2, 1, 2, 1, 6
    melody3_led:
        .word 0b001, 0b001, 0b001, 0b010, 0b100, 0b100, 0b010, 0b100, 0b010, 0b001
        .word 0b001, 0b001, 0b001, 0b010, 0b010, 0b010, 0b100, 0b100, 0b100, 0b111, 0b000, 0b111
        .word 0b010, 0b010, 0b100, 0b010, 0b001
    melody3_size: .word 27
    #________________________________________________
    # Define melody 4 : Jingle Bells
    melody4_freq:
        .word E4, E4, E4, E4, E4, E4, E4, G4, C4, D4, E4
        .word F4, F4, F4, F4, F4, E4, E4, E4, E4, D4, D4, C4, D4, G4
        .word E4, E4, E4, E4, E4, E4, E4, G4, C4, D4, E4
        .word F4, F4, F4, F4, F4, E4, E4, E4, G4, G4, F4, D4, C4
    melody4_dur:
        .word 2, 2, 4, 2, 2, 4, 2, 2, 2, 2, 8
        .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4
        .word 2, 2, 4, 2, 2, 4, 2, 2, 2, 2, 8
        .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 8
    melody4_led:
        .word 0b100, 0b100, 0b100, 0b100, 0b100, 0b100, 0b100, 0b001, 0b100, 0b010, 0b001
        .word 0b010, 0b010, 0b010, 0b010, 0b010, 0b100, 0b100, 0b100, 0b100, 0b010, 0b010, 0b001, 0b010, 0b111
        .word 0b100, 0b100, 0b100, 0b100, 0b100, 0b100, 0b100, 0b001, 0b100, 0b010, 0b001
        .word 0b010, 0b010, 0b010, 0b010, 0b010, 0b100, 0b100, 0b100, 0b001, 0b001, 0b010, 0b011, 0b111
    melody4_size: .word 49
    #________________________________________________
    # Define melody 5: Persian Tavalodet Mobarak
    melody5_freq:
        .word C4, C4, F4, C4, C4, F4, C4, C4, F4, F4, E4, D4, E4
        .word C4, C4, E4, C4, C4, E4, C4, C4, E4, E4, D4, E4, F4
        .word E4, F4, G4, G4, F4, E4, D4, D4, E4, F4, D4, E4, D4, C4
    melody5_dur:
        .word 1, 2, 4, 1, 2, 4, 1, 2, 1, 2, 1, 2, 4
        .word 1, 2, 4, 1, 2, 4, 1, 2, 1, 2, 1, 2, 4
        .word 1, 2, 1, 2, 1, 2, 4, 1, 2, 2, 1, 1, 2, 4
    melody5_led: 
        .word 0b001, 0b001, 0b010, 0b001, 0b001, 0b010, 0b001, 0b001, 0b010, 0b010, 0b100, 0b010, 0b100
        .word 0b001, 0b001, 0b100, 0b001, 0b001, 0b100, 0b001, 0b001, 0b100, 0b100, 0b010, 0b100, 0b010
        .word 0b100, 0b010, 0b001, 0b001, 0b010, 0b100, 0b010, 0b010, 0b100, 0b001, 0b100, 0b010, 0b100, 0b001
    melody5_size: .word 40
    #________________________________________________
    # Define melody 6: Für Elise (Full Version, Simplified)
    melody6_freq:
        .word E5, D5s, E5, D5s, E5, B4, D5, C5, A4
        .word C4, E4, A4, B4, E4, G4s, B4, C5
        .word E5, D5s, E5, D5s, E5, B4, D5, C5, A4
        .word C4, E4, A4, B4, E4, C5, B4, A4
        .word B4, C5, D5, E5, G4, F5, E5, D5, F4, E5, D5, C5, E4, D5, C5, B4
    melody6_dur:
        .word 1, 1, 1, 1, 1, 1, 1, 1, 4
        .word 1, 1, 1, 4, 1, 1, 1, 4
        .word 1, 1, 1, 1, 1, 1, 1, 1, 4
        .word 1, 1, 1, 4, 1, 1, 1, 4
        .word 1, 1, 1, 4, 1, 1, 1, 4, 1, 1, 1, 4, 1, 1, 1, 4
    melody6_led:
        .word 0b001, 0b010, 0b001, 0b010, 0b001, 0b100, 0b010, 0b001, 0b100
        .word 0b010, 0b100, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100
        .word 0b001, 0b010, 0b001, 0b010, 0b001, 0b100, 0b010, 0b001, 0b100
        .word 0b010, 0b100, 0b001, 0b010, 0b100, 0b010, 0b100, 0b001
        .word 0b100, 0b001, 0b010, 0b001, 0b100, 0b010, 0b001, 0b010, 0b100, 0b001, 0b010, 0b100, 0b010, 0b001, 0b100, 0b010
    melody6_size: .word 50
#################################################
    # read_buttons(btn1, btn2, btn3) : Read the button states
    # R1 = 0b BTN3 BTN2 BTN1
.macro read_buttons btn3, btn2, btn1
    PUSH {R2-R5}
    gpio_pin_read "[SP, $16]", $BTN1
    MOV R5, R0
    gpio_pin_read "[SP, $16]", $BTN2
    LSL R0, $1
    ORR R5, R0
    gpio_pin_read "[SP, $16]", $BTN3
    LSL R0, $2
    ORR R5, R0
    EOR R1, R5, $7
    POP {R2-R5}
.endm

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
    
    // A Pre-loop to some blinking demonstration
preloop:
    gpio_freq [SP], $LED_RED, $4, $1000
    gpio_freq [SP], $LED_GREEN, $2, $1000
    gpio_freq [SP], $LED_BLUE, $3, $1000
    delay_ms $1000
    read_buttons $BTN1, $BTN2, $BTN3
    CMP R1, $0
    BEQ preloop

    // Initilize Playing state
    LDR R2, =melody1_freq
    LDR R3, =melody1_dur
    LDR R4, =melody1_led
    LDR R5, =melody1_size
    MOV R6, $1  // Playing state
    MOV R7, $0  // Looping flag
    
loop:
    delay_ms $300

    // Read the button states -> R1 (0b BTN3 BTN2 BTN1)
    read_buttons $BTN1, $BTN2, $BTN3

    // If No button is pressed, set playing state (R6) to loop flag (R7)
    CMP   R1, $0
    BNE   0f
    MOV   R6, R7
    B     _play
0:  MOV   R6, $1            // If any button is pressed, set playing state (R6) to 1
    
    // If button state is 0b001, select melody 1
    CMP   R1, $1
    LDREQ R2, =melody1_freq
    LDREQ R3, =melody1_dur
    LDREQ R4, =melody1_led
    LDREQ R5, =melody1_size
    BNE 1f
    ANSI_CYN
    fprint_lit $STDOUT, "Playing Melody 1: Twinkle Twinkle Little Star\n"
    ANSI_RST
    B _play
1:

    // If button state is 0b010, select melody 2
    CMP   R1, $2
    LDREQ R2, =melody2_freq
    LDREQ R3, =melody2_dur
    LDREQ R4, =melody2_led
    LDREQ R5, =melody2_size
    BNE 2f
    ANSI_CYN
    fprint_lit $STDOUT, "Playing Melody 2: Happy Birthday\n"
    ANSI_RST
    B _play
2:
    
    // If button state is 0b011, select melody 3
    CMP   R1, $3
    LDREQ R2, =melody3_freq
    LDREQ R3, =melody3_dur
    LDREQ R4, =melody3_led
    LDREQ R5, =melody3_size
    BNE 3f
    ANSI_CYN
    fprint_lit $STDOUT, "Playing Melody 3: Row Row Row Your Boat\n"
    ANSI_RST
    B _play
3:

    // If button state is 0b100, select melody 4
    CMP   R1, $4
    LDREQ R2, =melody4_freq
    LDREQ R3, =melody4_dur
    LDREQ R4, =melody4_led
    LDREQ R5, =melody4_size
    BNE 4f
    ANSI_CYN
    fprint_lit $STDOUT, "Playing Melody 4: Jingle Bells\n"
    ANSI_RST
    B _play
4:

    // If button state is 0b101, select melody 5
    CMP   R1, $5
    LDREQ R2, =melody5_freq
    LDREQ R3, =melody5_dur
    LDREQ R4, =melody5_led
    LDREQ R5, =melody5_size
    BNE 5f
    ANSI_CYN
    fprint_lit $STDOUT, "Playing Melody 5: Persian Tavalodet Mobarak\n"
    ANSI_RST
    B _play
5:
    
    // If button state is 0b110, select melody 6
    CMP   R1, $6
    LDREQ R2, =melody6_freq
    LDREQ R3, =melody6_dur
    LDREQ R4, =melody6_led
    LDREQ R5, =melody6_size
    BNE 6f
    ANSI_CYN
    fprint_lit $STDOUT, "Playing Melody 6: Für Elise\n"
    ANSI_RST
    B _play
6:

    // If button state is 0b111, Toggle Looping flag (R7)
    CMP   R1, $7
    EOREQ R7, R7, $1
    BNE _play
    ANSI_YLW
    fprint_lit $STDOUT, "Looping: "
    fprint_num $STDOUT, R7
    fprint_lit $STDOUT, "\n"
    ANSI_RST

_play:
    // If playing state (R6) is not set, loop
    CMP R6, $0
    BEQ loop

    // Play the selected melody
    LDR R0, [SP]
    MOV R1, $SPKR
    PUSH {R2-R5}
    LDR R5, [R5]
    CALL play_melody
    POP {R2-R5}
    
    // loop
    B loop

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
