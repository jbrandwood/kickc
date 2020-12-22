// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable containing a pointer
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-2.prg", type="prg", segments="Program"]
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
    // *cursor = '*'
    lda #'*'
    ldy cursor
    sty.z $fe
    ldy cursor+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // cursor += 41
    lda #$29
    clc
    adc cursor
    sta cursor
    bcc !+
    inc cursor+1
  !:
    // for( char i: 0..24 )
    inx
    cpx #$19
    bne __b1
    // }
    rts
}
.segment Data
  cursor: .word SCREEN
