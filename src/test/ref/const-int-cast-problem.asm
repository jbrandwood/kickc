// Test a problem with converting casted constant numbers to fixed type constant integers
  // Commodore 64 PRG executable file
.file [name="const-int-cast-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #$79
  __b1:
    // i>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // SCREEN[i] = i>>4
    sta SCREEN,x
    // for( byte i: 121..122)
    inx
    cpx #$7b
    bne __b1
    // }
    rts
}
