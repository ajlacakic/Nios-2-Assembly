.text
.global _start
_start:
ldw r9, TEST_NUM(r0) # holds the test number
mov r10, r0 # longest string of 1's
mov r11, r0 # longest string of 0's
mov r12, r0 # longest string of alternating 1's and 0's
call ONES

ldw r9, TEST_NUM(r0)
nor r9, r9, r9 # invert r9
mov r13, r0 # initialize lonest string of 0's=0
call ZEROS # does the same thing as ONES, but now that we inverted the TEST_NUM, it will count the longest string of 0's and not 1's

ldw r9, TEST_NUM(r0) 
ldw r14, ALT_NUM(r0) 
xor r5, r14, r9
nor r5, r5, r5 # invert r5
call ALTERNATING 
movi r20,2
divu r12, r12, r20 # divide r12 by 2 since we r12 holds the number of digits, we need the number of pairs
call END

ONES: beq r9, r0, RET # if r9 = 0, RET
	srli r13, r9, 0x01 # shift r9 right by 1 bit and store result in 13 
	and r9, r9, r13 # logical AND r9 and r13
	addi r10, r10, 0x01 # increment r10 by 1 
br ONES

ZEROS: beq r9, r0, RET # if r9 = 0, RET
	srli r13, r9, 0x01 # shift r9 right by 1 bit and store result in 13 
	and r9, r9, r13 # logical AND r9 and r13
	addi r11, r11, 0x01 # increment r11 by 1 
br ZEROS

ALTERNATING:
	beq r5, r0, RET # if r5 = 0, RET
	srli r13, r5, 0x01 # shift r5 right by 1 bit and store result in r13
	and r5, r5, r13 # logical AND r5 and r13 
	addi r12, r12, 0x01 # increment r12 by 1
br ALTERNATING

RET: ret
END: br END 
ALT_NUM: .word 0xAAAAAAAA 
TEST_NUM: .word 0xA5AEDEE 
.end
