// Test a procedure with calling convention stack
// Illustrates live ranges for main::val and printline::i
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
.segment Code
__start: {
    jsr main
    rts
}
printline: {
    ldx #0
  __b1:
    // for(char i=0; i<40; i++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = '*'
    lda #'*'
    sta SCREEN,x
    // for(char i=0; i<40; i++)
    inx
    jmp __b1
}
main: {
    // val = *SCREEN
    ldy SCREEN
    // printline()
    jsr printline
    // SCREEN[80] = val
    sty SCREEN+$50
    // }
    rts
}
