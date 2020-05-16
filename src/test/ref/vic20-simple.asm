// Trivial VIC 20 program
  .file [name="vic20-simple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$1001]
.segmentdef Code [start=$100e]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code


  .const RED = 2
  // Default address of screen color matrix
  .label DEFAULT_COLORRAM = $9600
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $1e00
.segment Code
main: {
    ldx #0
  __b1:
    // for(char i=0; MESSAGE[i]; i++)
    lda MESSAGE,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // DEFAULT_SCREEN[i] = MESSAGE[i]
    lda MESSAGE,x
    sta DEFAULT_SCREEN,x
    // DEFAULT_COLORRAM[i] = RED
    lda #RED
    sta DEFAULT_COLORRAM,x
    // for(char i=0; MESSAGE[i]; i++)
    inx
    jmp __b1
}
.segment Data
  MESSAGE: .text "hello world!"
  .byte 0
