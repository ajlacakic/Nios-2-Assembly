.text                              

.global _start                     

start:                           

    movia sp, 0x7FFFFC             // Initialize stack pointer to the top of the stack

    movia r9, N                    // Move the address of the list N to register r9

BEGIN_SORT:

    ldw r20, (r9)                  // Load the number of elements in the list (10) to r20

    /* r20 will be used as the number of iterations */
    /* r19 will be used as the number of comparisons */
    /* when r18 reaches 0 it means all elements are sorted */

RESTART_SORT:                      // Label for restarting the sorting process

    add r18, r0, r0                // Reset r18 to 0 (indicates @)
    addi r19, r0, 1                // Set r19 to 1

    addi r4, r9, 4                 // Points to the first element of the list

SORT_LOOP:                         // Label for the sorting loop

    beq r19, r20, END_FOR          // If r19 equals r20, exit the loop (end of sorting),checks if all elements have been compared.
    call SWAP                      // Call the SWAP subroutine to swap elements if necessary
    or r18, r18, r2                // Update r18 to track the number of iterations and comparisons
    addi r19, r19, 1               // Increment r19 (number of comparisons)
    addi r4, r4, 4                 // Move to the next element of the list
    br SORT_LOOP                   // Branch back to SORT_LOOP for the next iteration

END_FOR:                          // Label for the end of one iteration

    addi r20, r20, -1              // Decrement r20 by 1 (decrease number of iteraatios)
    bne r18, r0, RESTART_SORT      // If r18 is not zero, restart the sorting process

END:                               // End label for the program
    br END                         // Unconditional branch to END, effectively ending the program

    addi sp, sp, -12               // Move stack pointer down by 12 bytes
    stw r5, (sp)                   // Save the value of r5 onto the stack
    stw r6, 4(sp)                  // Save the value of r6 onto the stack
    stw ra, 8(sp)                  // Save the value of ra onto the stack

SWAP:                              // Label for the SWAP subroutine

    add r2, r0, r0                 // Initialize return value to 0
    ldw r5, 0(r4)                  // Load the first list element from memory to r5
    ldw r6, 4(r4)                  // Load the second list element from memory to r6

    bgt r5, r6, SKIP_SWAP          // If r5 is greater than r6, skip the swap

    stw r6, 0(r4)                  // Swap the list elements
    stw r5, 4(r4)
    addi r2, r0, 1                 // Set return value to 1

SKIP_SWAP:                         // Label for skipping the swap if elements are already sorted
    ret                            // Return from subroutine, effectively ending SWAP

    ldw r5, 0(sp)                  // Restore the value of r5 from the stack
    ldw r6, 4(sp)                  // Restore the value of r6 from the stack
    ldw ra, 8(sp)                  // Restore the value of ra from the stack
    addi sp, sp, 12                // Move stack pointer up by 12 bytes to deallocate space

LIST:                             // Start of the list

N: .word 10, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 // Define the list with 10 elements

.end                               // End of the assembly code