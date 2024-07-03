.text                               

.global _start                    

_start:                          

    movia r4, N                    // Move the address of N into register r4
    ldw r4, (r4)                   // Load the value at memory address r4 into r4,counter

    mov r2, r0                     //  r2 = 0, r2 will be our result

    call FINDSUM

END:                               
    br END                        

FINDSUM:                          

    beq r4, r0, END_FS             // End loop if counter is equal to 0
    add r2, r4, r2                 // Add r4 to r2 and store the result in r2 (accumulate sum)
    subi r4, r4, 1                 // Decrement counter
    br FINDSUM                     // Branch back to FINDSUM

END_FS:
    ret

N: .word 9                          // Define label N and initialize it with value 9

.end
