# this code returns the longest string of 1's in a binary number

.text
.global _start
_start:
ldw r9, TEST_NUM(r0)  # load the test word into r9
mov r10, r0 # initialize r10 to 0(counter)
call ONES
ONES: beq r9, r0, END # end if r9 = r0
	srli r11, r9, 0x01 # shift r9 by 1 bit to the right and store the result into r11
	and r9, r9, r11 # logical AND r9 and r11 
	addi r10, r10, 0x01  # increment r10 by 1, r10 holds the longest number of consecutive one's
br ONES
END: br END 
TEST_NUM: .word 0x3fabedef 
.end

