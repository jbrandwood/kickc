// Test declaring a variable as "__mem __notssa", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-0.prg", type="prg", segments="Program"]
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
    // SCREEN[i] = idx
    lda idx
    sta SCREEN,x
    // idx +=i
    txa
    clc
    adc idx
    sta idx
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
.segment Data
  idx: .byte 0
