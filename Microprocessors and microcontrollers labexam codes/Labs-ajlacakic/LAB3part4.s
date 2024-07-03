# this code counts to 60 real-time seconds and then resets the counter to 0

.global _start
_start:
    movi r9, 0x64         # initialize r9 with decimal value 100 (0x64 in hex)
    movia r10, 0x10000050 # load the address of the interval timer in r10

    mov r18, r0          # Initialize counter r18 to 0
    mov r19, r0          # Initialize counter r19 to 0

    # Set up the interval timer
    movia r16, 0x10002000 # Load the address of the interval timer into r16
    movia r12, 0x7A120    # Load the timer interval value (0.01 seconds at 50 MHz) into r12

    # Store the high 16 bits of the timer interval value
    sthio r12, 8(r16)
    srli r12, r12, 16     # Shift right to extract the high 16 bits
    sthio r12, 12(r16)    # Store the high 16 bits of the timer interval value

START:
    movia r8, 0x10000020   # Load the output address into r8 (for seven-segment display)
    movi r6, 0x3F3F        # Load the seven-segment display code for "00" into r6
    stwio r6, (r8)         # Display "00" at the start

DO_DELAY:
    movi r15, 0x6          # Set timer start and continue bits START = 1, CONT=1 (6 = 0110)
    stwio r15, 4(r16)      # Start the timer by writing to the control register

LOOP:
    ldwio r20, (r16)       # Load the timer status
    andi r20, r20, 0x1     # Extract the timeout bit
    ldwio r7, (r10)        # Check for button press
    bne r0, r7, STOP       # Branch to STOP if button press detected
    beq r20, r0, LOOP      # Loop until the timer reaches 0

    stwio r0, (r16)        # Reset the timer timeout status to 0
    addi r18, r18, 0x1     # Increment counter r18
    beq r18, r9, IncS      # Branch to IncS if counter r18 reaches the threshold
    br DISPLAY             # Branch to DISPLAY to update the display

STOP:
    movi r15, 0xA          # Set stop bits in the timer control register
    stwio r15, 4(r16)      # Stop the timer

CHECK:
    ldwio r7, (r10)        # Check for button release
    bne r0, r7, CHECK      # Loop until button is released

LOOP_START:
    ldwio r7, (r10)        # Wait for button press again
    beq r0, r7, LOOP_START # Loop until button press detected

CHECK2:
    ldwio r7, (r10)        # Check for button release after delay
    bne r0, r7, CHECK2     # Loop until button is released
    br DO_DELAY            # Branch back to DO_DELAY for another delay cycle

IncS:
    mov r18, r0            # Reset counter r18 to 0
    addi r19, r19, 0x1     # Increment counter r19
    beq r19, r12, RESET    # Branch to RESET if counter r19 reaches 60
    br DISPLAY             # Branch to DISPLAY to update the display

RESET:
    mov r19, r0            # Reset counter r19 to 0
    br DISPLAY             # Branch to DISPLAY to update the display

DISPLAY:
    # Display the values on the seven-segment display
    mov r4, r18             # Move counter r18 to r4
    call DIVIDE             # Call subroutine to divide r4 by 10
    mov r4, r2              # Move the quotient back to r4
    call SEG7_CODE          # Convert r4 to seven-segment display code
    mov r14, r2             # Store the result in r14

    mov r4, r19             # Move counter r19 to r4
    call DIVIDE             # Call subroutine to divide r4 by 10
    mov r4, r2              # Move the quotient back to r4
    call SEG7_CODE          # Convert r4 to seven-segment display code
    slli r2, r2, 8          # Shift the display code to the left by 8 bits
    or r14, r14, r2         # Combine both display codes

    stwio r14, (r8)         # Output the combined display code to the seven-segment display
    br DO_DELAY             # Branch back to DO_DELAY for another delay cycle

DIVIDE:
    mov r2, r4              # Move the dividend to r2
    movi r5, 10             # Load divisor (10) into r5
    mov r3, r0              # Initialize quotient r3 to 0

CONT:
    blt r2, r5, RET         # Branch to RET if dividend < divisor
    sub r2, r2, r5          # Subtract divisor from dividend
    addi r3, r3, 1          # Increment quotient
    br CONT                 # Loop until dividend < divisor

SEG7_CODE:
    movia r15, BIT_CODES    # Load the address of the seven-segment display code table
    add r15, r15, r4        # Calculate the address of the display code for r4
    ldb r2, (r15)           # Load the display code into r2
    ret                     # Return from subroutine

BIT_CODES:
    .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
    .byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
    .skip 2

RET:
    ret

END:
    br END
.end
