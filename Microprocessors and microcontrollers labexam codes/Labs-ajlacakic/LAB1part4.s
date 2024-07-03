
.global _start
_start:
movia r4, N # r4 holds address of N
addi r7, r4, 4  # r7 points to the place where the digits will be stored
ldw r4, (r4) # load N into r4
call DIVIDE # after r3 = 12, r2 =34
movi r16,10 # r16 holds 10
div r8, r3, r16 # r8 holds r3/10 (r8 = 1)
div r10, r2, r16 # r10 holds r2/10 (r10 = 3)
mul r15, r16, r8 # r15 holds original quotient (r15 = 10)
mul r14, r16,r10 # r14 holds original remainder (r14 = 30)
sub r9, r3, r15 # r9 holds r3 - r15 (r9 = 12 - 10 = 2)
sub r11, r2, r14 # r11 holds r2 - r14 (r11 = 34 - 30 = 4)
# r8 = 1, r9 = 2, r10 = 3, r11 = 4

stb r3, 1(r7) # store the first 2 digits with offset 1 added to address specified by r7
stb r2, (r7) # store the second 2 digits

END: br END

DIVIDE: mov r2, r4 # r2 now holds N (N = 1234)
		movi r5, 100 # r5 holds 100, divisor
		movi r3, 0 # r3 holds 0
CONT: blt r2, r5, DIV_END 
		sub r2, r2, r5 # subtract the divisor from r2 (1234 - 100)
		addi r3, r3, 1 # r3++
	br CONT # branch and repeat until r2 < r5
DIV_END: ret 
N: .word 1234
Digits: .space 8  # allocates 8 bytes for storing 4 digits 
.end
