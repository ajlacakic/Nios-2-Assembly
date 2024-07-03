.text
.global _start
_start:

    movi r9, 0x64         # initialize r9 with hexadecimal value 0x64 
    mov r11, r0           #  r11=0 (counter)

START:

    movia r8, 0x10000020  # load the address of the output port to r8
    movi r10, 0x3f3f      # display '00' (3f = 00111111 -  0 el. u BIT_CODES)
    stwio r10, (r8)       # store '00' to the output port (display)
    mov r10, r0           # r10=0

    movia r10, 0x10000050 # load the address of the input port to r10

DO_DELAY:
    movia r7, 800000      # Initialize delay counter 
SUB_LOOP:
    subi r7, r7, 1        # decrement delay counter
    bne r7, r0, SUB_LOOP  # loop until delay counter reaches 0
    addi r11, r11, 1      # increment counter r11
    ldwio r13, (r10)      # load value from input to r13
    bne r13, r0, STOP     # if input is not zero, meaning if we press any of the 4 buttons, branch to STOP
    br STARTagain         # branch to STARTagain if input is zero

STARTagain:
    mov r4, r11           # move counter value r11 to r4 (r11 deals with incrementing the 7segment counter)
    call DIVIDE           # call DIVIDE

    mov r4, r2            # Move remainder to r4, which is the digit we want do display
    call SEG7_CODE        # call SEG7_CODE subroutine
    mov r14, r2           # move result of SEG7_CODE to r14
                    # *now we obtained 7-segment byte digit and have it in r14*

    mov r4, r3            # move quotient (r3) to r4
    call SEG7_CODE        # call SEG7_CODE subroutine for quotient
                    # *r2 now holds the second digit, and now we will merge the two digits*
    slli r2, r2, 8        # shift 7-segment code for quotient (first digit) to left by 8 bits
    or r14, r14, r2       # Combine 7-segment codes for quotient and remainder

    stwio r14, (r8)       # output combined 7-segment codes to display
    mov r14, r0           # clear r14
    beq r11, r9, NUL      # branch to NUL if counter r11 equals 100 (0x64)
    br DO_DELAY           # branch back to DO_DELAY for delay loop

NUL:
    mov r11, r0           # reset counter r11 to 0
    br START              # branch back to START

STOP:
    ldwio r13, (r10)      # Read from input port
    beq r13, r0, STOP     # Loop in STOP until input is zero
LOOP_START:               # Loop label
    ldwio r13, (r10)      # Read from input port
    bne r13, r0, LOOP_START # Loop in LOOP_START until input is zero
    br STARTagain          # Branch back to STARTagain

DIVIDE:
    mov r2, r4            # r2 = r4, which is our dividend
    movi r5, 10           # r5 = 10, which is our divisor
    mov r3, r0            # r3 = 0, which is our quotient
CONT:
    blt r2, r5, LOOP      # branch to LOOP if dividend (r2) < divisor (r5)
    sub r2, r2, r5        # subtract divisor (r5) from dividend (r2)
    addi r3, r3, 1        # increment quotient (r3) by 1
    br CONT               # loop back to CONT
 # when we branch back to LOOP, r2 will hold our remainder, which is the digit we want to display

SEG7_CODE:
    movia r15, BIT_CODES   # load base address of BIT_CODES array to r15
    add r15, r15, r4       # calculate array index (r15 base + r4 number)
    ldb r2, (r15)          # load byte pointed at by r15 to r2, meaning load the 7-segment digit byte to r2
    ret

BIT_CODES: .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
.byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
.skip 2

RET: ret
END: br END
LOOP:
    br RET
