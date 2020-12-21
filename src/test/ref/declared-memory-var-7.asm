// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a zeropage notregister variable
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = 2
.segment Code
__start: {
    // idx
    lda #0
    sta.z idx
    jsr main
    rts
}
main: {
    ldx #0
  __b1:
    // SCREEN[i] = idx
    lda.z idx
    sta SCREEN,x
    // idx +=i
    txa
    clc
    adc.z idx
    sta.z idx
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
