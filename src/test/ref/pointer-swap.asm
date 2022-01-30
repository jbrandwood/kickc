  // Commodore 64 PRG executable file
.file [name="pointer-swap.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 2
  .label tempbuffer = $c
  .label newbuffer = $a
  .label tempbuffer_1 = 6
  .label newbuffer_1 = 8
  .label oldbuffer = 4
.segment Code
main: {
    // print()
    lda #<buffer2
    sta.z oldbuffer
    lda #>buffer2
    sta.z oldbuffer+1
    lda #<buffer1
    sta.z newbuffer_1
    lda #>buffer1
    sta.z newbuffer_1+1
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<0
    sta.z tempbuffer_1
    sta.z tempbuffer_1+1
    jsr print
    // swap()
    lda #<buffer2
    sta.z newbuffer
    lda #>buffer2
    sta.z newbuffer+1
    lda #<buffer1
    sta.z tempbuffer
    lda #>buffer1
    sta.z tempbuffer+1
    jsr swap
    lda.z newbuffer
    sta.z tempbuffer
    lda.z newbuffer+1
    sta.z tempbuffer+1
    lda.z tempbuffer
    sta.z newbuffer
    lda.z tempbuffer+1
    sta.z newbuffer+1
    // swap()
    jsr swap
    lda.z newbuffer
    sta.z tempbuffer
    lda.z newbuffer+1
    sta.z tempbuffer+1
    lda.z tempbuffer
    sta.z newbuffer
    lda.z tempbuffer+1
    sta.z newbuffer+1
    // swap()
    jsr swap
    // }
    rts
}
print: {
    // (char)tempbuffer&0x0f
    lda.z tempbuffer_1
    and #$f
    // screen[0] = hextab[(char)tempbuffer&0x0f]
    tay
    lda hextab,y
    ldy #0
    sta (screen),y
    // (char)newbuffer&0x0f
    lda.z newbuffer_1
    and #$f
    // screen[2] = hextab[(char)newbuffer&0x0f]
    tay
    lda hextab,y
    ldy #2
    sta (screen),y
    // (char)oldbuffer&0x0f
    lda.z oldbuffer
    and #$f
    // screen[4] = hextab[(char)oldbuffer&0x0f]
    tay
    lda hextab,y
    ldy #4
    sta (screen),y
    // screen += 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // }
    rts
}
swap: {
    lda.z tempbuffer
    sta.z tempbuffer_1
    lda.z tempbuffer+1
    sta.z tempbuffer_1+1
    lda.z newbuffer
    sta.z newbuffer_1
    lda.z newbuffer+1
    sta.z newbuffer_1+1
    lda.z tempbuffer
    sta.z oldbuffer
    lda.z tempbuffer+1
    sta.z oldbuffer+1
    // print()
    jsr print
    // }
    rts
}
.segment Data
  buffer1: .fill $a, 0
  buffer2: .fill $a, 0
  hextab: .text "0123456789abcdef"
