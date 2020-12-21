// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code that do not exist with the encoding.
  // Commodore 64 PRG executable file
.file [name="string-escapes-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const CH = '\$ff'
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // while(MESSAGE[i])
    lda MESSAGE,x
    cmp #0
    bne __b2
    // SCREEN[0x28] = CH
    lda #CH
    sta SCREEN+$28
    // }
    rts
  __b2:
    // SCREEN[i] = MESSAGE[i++]
    lda MESSAGE,x
    sta SCREEN,x
    // SCREEN[i] = MESSAGE[i++];
    inx
    jmp __b1
}
.segment Data
  MESSAGE: .text @"q\$ffw\$60e\$ddr"
  .byte 0
