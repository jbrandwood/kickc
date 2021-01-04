// Test declaring a variable as "memory", meaning it will be stored in main memory
// Test a fixed main memory address __notssa variable
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = $1000
.segment Code
__start: {
    // idx
    lda #0
    sta idx
    jsr main
    rts
}
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
