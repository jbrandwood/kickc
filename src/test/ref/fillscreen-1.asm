// Fill screen using an efficient char-based index
  // Commodore 64 PRG executable file
.file [name="fillscreen-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // for(char i=0;i<250;i++)
    cpx #$fa
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = ' '
    lda #' '
    sta SCREEN,x
    // (SCREEN+250)[i] = ' '
    sta SCREEN+$fa,x
    // (SCREEN+500)[i] = ' '
    sta SCREEN+$1f4,x
    // (SCREEN+750)[i] = ' '
    sta SCREEN+$2ee,x
    // for(char i=0;i<250;i++)
    inx
    jmp __b1
}
