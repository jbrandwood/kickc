// used vars
  // Commodore 64 PRG executable file
.file [name="unused-vars.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // used vars
    .const col = 2
    .label COLS = $d800
    ldx #0
  __b1:
    // COLS[i] = col
    lda #col
    sta COLS,x
    // SCREEN[i] = b
    lda #2/2+1+1
    sta SCREEN,x
    // for(byte i : 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
