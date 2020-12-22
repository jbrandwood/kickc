// Tests comma-separated declarations inside for()
  // Commodore 64 PRG executable file
.file [name="comma-decl-for.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    lda #'g'
    ldx #0
  __b1:
    // for(byte i, j='g'; i<10; i++, j++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = j
    sta SCREEN,x
    // for(byte i, j='g'; i<10; i++, j++)
    inx
    clc
    adc #1
    jmp __b1
}
