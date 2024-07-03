.text

.global _start

start:

    ldw r4, N(r0)                  // Load the value at memory address N into register r4

    mov r2, r0                      // Set r2 to 0
    mov r8, r0                      // Set r8 to 0

    call FINDSUM
    call END

FINDSUM:                            // Start of the FINDSUM subroutine

    bne r4, r0, RECURSE            // Branch to RECURSE if r4 is not equal to 0 (base case)
    mov r2, r8                     // Move the accumulated sum from r8 to r2
    ret                             // Return from the subroutine

RECURSE:
    add r8, r8, r4                  // Add the value in r4 to the accumulated sum in r8
    subi r4, r4, 1                  // Decrement r4 counter
    call FINDSUM                    // Call FINDSUM recursively

END:
    br END

N: .word 5

.end