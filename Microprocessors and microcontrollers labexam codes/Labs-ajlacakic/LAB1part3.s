#largest number in a list and stores it in r2

.text
.global start
_start:
movia r8, RESULT # r8 points to the result
ldw r4, 4(r8) # r4 now holds N
addi r5, r8, 8 # r5 points to the start of the list / first element of the list
call LARGE 
stw r2, (r8) # after the subroutine, store the value from r2 into address of r8 which is the result pointer
STOP: br STOP
LARGE: subi r4, r4, 1 # r4 is the counter; decrement it
	beq r4, r0, DONE # if r4 == r0 (r0 = 0), branch to DONE
	addi r5, r5, 4  # else increment the list pointer so it points to the next element
	ldw r6, (r5) # load the list element into r6
	bge r2, r6, LARGE # if r2 > r6, branch to LARGE, which means r2 is bigger, r2 holds biggest number
	mov r2, r6 # if r6 > r2, store r6 into r2
	br LARGE
DONE: stw r2, (r8)
RESULT: .skip 4 
N: .word 7 
NUMBERS: .word 5, 6, 7, 5 
			.word 1, 10, 3
.end