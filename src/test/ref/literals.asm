  // Commodore 64 PRG executable file
.file [name="literals.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const ch = 'a'
  .const num = 1
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = ch
    lda #ch
    sta SCREEN
    // SCREEN[2] = num
    lda #num
    sta SCREEN+2
    ldx #0
  __b1:
    // SCREEN[4+i] = str[i]
    lda str,x
    sta SCREEN+4,x
    // SCREEN[9+i] = nums[i]
    lda nums,x
    sta SCREEN+9,x
    // for(byte i : 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
.segment Data
  str: .text "bcde"
  .byte 0
  nums: .byte 2, 3, 4, 5
