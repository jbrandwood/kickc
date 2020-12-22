// Concatenates string constants in different ways
  // Commodore 64 PRG executable file
.file [name="constant-string-concat-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // for( byte i=0;msg[i]!=0;i++)
    lda msg,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = msg[i]
    lda msg,x
    sta SCREEN,x
    // for( byte i=0;msg[i]!=0;i++)
    inx
    jmp __b1
  .segment Data
    msg: .text "camelot"
    .byte 0
}
