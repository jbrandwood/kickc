  // Commodore 64 PRG executable file
.file [name="constantmin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STAR = $51
  .const RED = 2
  .label SCREEN = $400
  .label VIC = $d000
.segment Code
main: {
    // *SCREEN = STAR
    lda #STAR
    sta SCREEN
    // *BG_COLOR = RED
    lda #RED
    sta VIC+$10*2+1
    ldx #$28
  __b1:
    // SCREEN[i] = (STAR+1)
    lda #STAR+1
    sta SCREEN,x
    // for(byte i: 40..79)
    inx
    cpx #$50
    bne __b1
    // }
    rts
}
