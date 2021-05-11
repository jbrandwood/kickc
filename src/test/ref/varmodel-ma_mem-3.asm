// Test two different memory models
  // Commodore 64 PRG executable file
.file [name="varmodel-ma_mem-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // model_ma_mem()
    jsr model_ma_mem
    // model_ssa_zp()
    jsr model_ssa_zp
    // }
    rts
}
model_ma_mem: {
    // char* screen = (char*)0x0400
    // A local pointer
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    // for( char i: 0..5 )
    lda #0
    sta i
  // A local counter
  __b1:
    // *(screen++) = 'a'
    lda #'a'
    ldy screen
    sty.z $fe
    ldy screen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *(screen++) = 'a';
    inc screen
    bne !+
    inc screen+1
  !:
    // for( char i: 0..5 )
    inc i
    lda #6
    cmp i
    bne __b1
    // }
    rts
  .segment Data
    screen: .word 0
    i: .byte 0
}
.segment Code
model_ssa_zp: {
    // A local pointer
    .label screen = 2
    ldx #0
    lda #<$428
    sta.z screen
    lda #>$428
    sta.z screen+1
  // A local counter
  __b1:
    // *(screen++) = 'b'
    lda #'b'
    ldy #0
    sta (screen),y
    // *(screen++) = 'b';
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
