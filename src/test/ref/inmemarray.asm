  // Commodore 64 PRG executable file
.file [name="inmemarray.prg", type="prg", segments="Program"]
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
    ldy #0
  __b1:
    // SCREEN[i] = TXT[j]
    lda TXT,y
    sta SCREEN,x
    // if(++j==8)
    iny
    cpy #8
    bne __b2
    ldy #0
  __b2:
    // for(byte i : 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
.segment Data
  TXT: .byte 3, 1, $d, 5, $c, $f, $14, $20
