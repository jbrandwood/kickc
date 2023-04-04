// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val
.cpu _65c02
  .segmentdef Program                 [segments="Basic, Code, Data, stage, platform"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef stage                   [start=$0400, min=$0400, max=$07FF, align=$100]
.segmentdef platform                [start=$C000, min=$C000, max=$C7FF, align=$100]

  .label SCREEN = $400
  .label val = 2
.segment Code
__start: {
    // char val = 0
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
.segment platform
incval: {
    // val++;
    inc.z val
    // }
    rts
}
.segment stage
printval: {
    // SCREEN[0] = val
    lda.z val
    sta SCREEN
    // }
    rts
}
.segment platform
ival: {
    // incval()
    jsr incval
    // }
    rts
}
.segment stage
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
