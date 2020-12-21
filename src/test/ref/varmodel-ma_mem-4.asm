// Test memory model
// Constant memory variables
  // Commodore 64 PRG executable file
.file [name="varmodel-ma_mem-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const a = 'a'
  .label screen = 2
.segment Code
main: {
    .const b = 'b'
    // for( char i: 0..5 )
    lda #0
    sta i
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    // *(screen++) = a
    lda #a
    ldy #0
    sta (screen),y
    // *(screen++) = a;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *(screen++) = b
    lda #b
    ldy #0
    sta (screen),y
    // *(screen++) = b;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *(screen++) = i
    lda i
    ldy #0
    sta (screen),y
    // *(screen++) = i;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( char i: 0..5 )
    inc i
    lda #6
    cmp i
    bne __b1
    // }
    rts
  .segment Data
    i: .byte 0
}
