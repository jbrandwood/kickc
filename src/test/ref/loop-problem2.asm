  // Commodore 64 PRG executable file
.file [name="loop-problem2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BORDER_COLOR = $d020
  .label SCREEN = $400
.segment Code
main: {
    // print_cls()
    jsr print_cls
    // mode_ctrl()
    jsr mode_ctrl
    // }
    rts
}
print_cls: {
    .label sc = 2
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    // for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++)
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z sc
    cmp #<SCREEN+$3e8
    bne __b2
    // }
    rts
  __b2:
    // *sc = ' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
mode_ctrl: {
  __b1:
    // byte before = *BORDER_COLOR
    lda BORDER_COLOR
    // if(before==$ff)
    cmp #$ff
    beq __b2
    // *BORDER_COLOR = 3
    lda #3
    sta BORDER_COLOR
    jmp __b1
  __b2:
    // *BORDER_COLOR = 2
    lda #2
    sta BORDER_COLOR
    jmp __b1
}
