// Test address-of - pass the pointer as parameter
  // Commodore 64 PRG executable file
.file [name="address-of-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label b1 = 4
    .label b2 = 5
    .label b3 = 6
    // byte b1 = 0
    lda #0
    sta.z b1
    // byte b2 = 0
    sta.z b2
    // byte b3 = 0
    sta.z b3
    // setByte(&b1, 'c')
    lda #<b1
    sta.z setByte.ptr
    lda #>b1
    sta.z setByte.ptr+1
    ldx #'c'
    jsr setByte
    // setByte(&b2, 'm')
    lda #<b2
    sta.z setByte.ptr
    lda #>b2
    sta.z setByte.ptr+1
    ldx #'m'
    jsr setByte
    // setByte(&b3, 'l')
    lda #<b3
    sta.z setByte.ptr
    lda #>b3
    sta.z setByte.ptr+1
    ldx #'l'
    jsr setByte
    // SCREEN[0] = b1
    lda.z b1
    sta SCREEN
    // SCREEN[1] = b2
    lda.z b2
    sta SCREEN+1
    // SCREEN[2] = b3
    lda.z b3
    sta SCREEN+2
    // }
    rts
}
// void setByte(__zp(2) char *ptr, __register(X) char b)
setByte: {
    .label ptr = 2
    // *ptr = b
    txa
    ldy #0
    sta (ptr),y
    // }
    rts
}
