// Test stack-relative addressing (for passing parameters through the stack)
  // Commodore 64 PRG executable file
.file [name="stack-relative-addressing.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /** The hardware stack. The offset 3 is to skip the return address and the fact that the pointer is to the next free position. */
  .label STACK = $103
  /** The screen. */
  .label SCREEN = $400
.segment Code
main: {
    // asm
    // Push a few values to the stack
    lda #'1'
    pha
    lda #'2'
    pha
    lda #'3'
    pha
    // peek_stack()
    // Then call a function
    jsr peek_stack
    // asm
    // Clean up the stack
    pla
    pla
    pla
    // }
    rts
}
// Peek values from the stack using stack-relative addressing
peek_stack: {
    // asm
    tsx
    lda STACK,x
    sta SCREEN
    lda STACK+1,x
    sta SCREEN+1
    lda STACK+2,x
    sta SCREEN+2
    // }
    rts
}
