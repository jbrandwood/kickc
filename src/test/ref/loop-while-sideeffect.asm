// Test a while()-loop where the condition has a side-effect
  // Commodore 64 PRG executable file
.file [name="loop-while-sideeffect.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    lda #7
  __b1:
    // while(i++!=7)
    tax
    inx
    cmp #7
    bne __b2
    // (SCREEN)[i] = 'x'
    // The condition-evaluation should increment i - even if when it is not met
    lda #'x'
    sta SCREEN,x
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    txa
    jmp __b1
}
