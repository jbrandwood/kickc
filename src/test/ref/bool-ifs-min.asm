// A test of boolean conditions using && || and !
  // Commodore 64 PRG executable file
.file [name="bool-ifs-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if( (i<10) && ((i&1)==0) )
    cpx #$a
    bcs __b2
    cmp #0
    bne __b2
    // screen[i] = '*'
    lda #'*'
    sta screen,x
  __b2:
    // for( char i : 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
}
