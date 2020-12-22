// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label val = 2
.segment Code
__start: {
    // val = 0
    lda #0
    sta.z val
    jsr main
    rts
}
printother: {
    ldx #0
  __b1:
    // (SCREEN+40)[i]++;
    inc SCREEN+$28,x
    // for(char i:0..5)
    inx
    cpx #6
    bne __b1
    // }
    rts
}
incval: {
    // val++;
    inc.z val
    // }
    rts
}
printval: {
    // SCREEN[0] = val
    lda.z val
    sta SCREEN
    // }
    rts
}
ival: {
    // incval()
    jsr incval
    // }
    rts
}
pval: {
    // printval()
    jsr printval
    // }
    rts
}
main: {
    ldy #0
  __b1:
    // pval()
    jsr pval
    // printother()
    jsr printother
    // ival()
    jsr ival
    // for(char i:0..5)
    iny
    cpy #6
    bne __b1
    // }
    rts
}
