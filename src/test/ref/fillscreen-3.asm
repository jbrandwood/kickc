// Fill screen using a pointer
  // Commodore 64 PRG executable file
.file [name="fillscreen-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label dst = 2
    lda #<SCREEN
    sta.z dst
    lda #>SCREEN
    sta.z dst+1
  __b1:
    // for(char* dst = SCREEN; dst!=SCREEN + 1000; dst++)
    lda.z dst+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z dst
    cmp #<SCREEN+$3e8
    bne __b2
    // }
    rts
  __b2:
    // *dst = ' '
    lda #' '
    ldy #0
    sta (dst),y
    // for(char* dst = SCREEN; dst!=SCREEN + 1000; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
