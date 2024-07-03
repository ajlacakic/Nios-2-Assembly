.text

.global _start

_start:

    movia r4, N                    // Move the address of N into register r4
    ldw r4, (r4)                   // Load the value at memory address pointed to by r4 into r4
								   // r4 will be the number of fibonacci numbers we want to add up

    movi r2, 1                     // Set r2 to 1 (first sequence number)
    movi r6, 1                     // Set r6 to 1 (second sequence number)
    mov r8, r0                     // Set r8 to 0 (r8 will hold the sum)

    call FIBONACCI

END:
    br END

FIBONACCI:

    beq r4, r0, END                // Branch if counter reaces 0
    subi r4, r4, 1                 // Decrement r4 counter
    add r8, r6, r2                 // Add r6 and r2 and store to r8
    mov r2, r6                     // Move the value of r6 into r2 (the first number is now the second number)
    mov r6, r8                     // Move the value of r8 into r6 (the second number is now the sum of the previous two)
    br FIBONACCI

N: .word 5

.end