
.text
.global _start
_start:
    movia r8, 0x10000020   # r8= base address of the output port 
    movia r10, 0x10000050  # r10= address of the input port 

    
    movi r11, 0x2   # button1 (increment display digit)
    movi r12, 0x4   # button2 (decrement display digit)
    movi r13, 0x8   # button3 (reset display digit to 0)

    mov r4, r0      # r4 = 0
    mov r16, r0     # r16 = 0

LOOP:
    ldwio r7, (r10)   # load word from the input port to r7
    beq r16, r7, LOOP # loop until r7 matches r16 (r16 = 0), meaning loop until we get an input

MAIN:
    beq r7, r11, FIRST  # branch to FIRST if input r7=2 (button 1)
    beq r7, r12, SECOND # branch to SECOND if input r7=4 (button 2)
    beq r7, r13, THIRD  # branch to THIRD if input r7=8 (button 3)
    mov r16, r0         # reset r16 to 0
    br LOOP             # branch back to LOOP to wait for next input

DISP:
    call SEG7_CODE    # call SEG7_CODE subroutine
    stwio r2, (r8)    # store word in r2 (digit byte) to r8, which is the output port
    br LOOP           # branch back to LOOP to wait for next input

FIRST:
    addi r4, r4, 0x1  # increment r4 by 1
    mov r16, r11      # r16 = 2
    br DISP           # branch to DISP to display the updated value of r4

SECOND:
    subi r4, r4, 0x1  # decrement r4 by 1
    mov r16, r12      # r16=4
    br DISP           # branch to DISP to display the updated value of r4

THIRD:
    mov r4, r0        # set r4 to 0
    stwio r4, (r8)    # store 0 to the output port (r8) to clear the display
    mov r16, r13      # r16=8

LOOP1:
    ldwio r7, (r10)     # load word from the input port (r10) to r7
    beq r16, r7, LOOP1  # loop until r7 matches r16 (8)
    beq r0, r7, LOOP1   # loop until r7 is not 0
						# the previous two brances keep our display turned off, and it will turn it back on only if we press any of the other 3 buttons
    mov r4, r0          # set r4 to 0, so when we click any other button, 0 will be displayed, since 0 is the first digit in the BIT_CODES
    mov r16, r7         # set r16 to the current input value
    br DISP             # branch to DISP to display the current input value, which is 0

SEG7_CODE:
    movia r15, BIT_CODES   # load base address of BIT_CODES array to r15
    add r15, r15, r4       # calculate array index (r15 base + r4 number)
    ldb r2, (r15)          # load byte pointed at by r15 to r2
    ret

BIT_CODES:
    .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110 # 0, 1, 2, 3, 4
    .byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111 # 5, 6, 7, 8, 9
    .skip 2                # Skip 2 bytes

RET:
    ret

END:
    br END
.end
