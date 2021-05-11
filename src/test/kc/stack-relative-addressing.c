// Test stack-relative addressing (for passing parameters through the stack)

/** The hardware stack. The offset 3 is to skip the return address and the fact that the pointer is to the next free position. */
char* const STACK = (char*)0x0103;


void main() {

    // Push a few values to the stack
    asm {
        lda #'1'
        pha
        lda #'2'
        pha
        lda #'3'
        pha
    }
    // Then call a function
    peek_stack();
    // Clean up the stack
    asm {
        pla
        pla
        pla
    }
}

/** The screen. */
char* const SCREEN = (char*)0x0400;

// Peek values from the stack using stack-relative addressing
void peek_stack() {
    asm {
        tsx
        lda STACK,x // The last byte pushed
        sta SCREEN
        lda STACK+1,x // The 2nd last byte pushed
        sta SCREEN+1
        lda STACK+2,x // The 3rd last byte pushed
        sta SCREEN+2
    }
}