// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a pointer to a memory variable
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label idx_p = idx
.segment Code
main: {
    ldx #0
  __b1:
    // SCREEN[i] = *idx_p
    lda idx_p
    sta SCREEN,x
    // *idx_p +=i
    txa
    clc
    adc idx_p
    sta idx_p
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
.segment Data
  idx: .byte 0
