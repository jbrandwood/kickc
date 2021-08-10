// Test declaring a variable as at a hard-coded address
// zero-page hard-coded address parameter
  // Commodore 64 PRG executable file
.file [name="address-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = 3
.segment Code
__start: {
    // volatile char __address(0x03) idx
    lda #0
    sta.z idx
    jsr main
    rts
}
main: {
    // print('c')
    lda #'c'
    sta.z print.ch
    jsr print
    // print('m')
    lda #'m'
    sta.z print.ch
    jsr print
    // print('l')
    lda #'l'
    sta.z print.ch
    jsr print
    // }
    rts
}
// void print(__zp(2) volatile char ch)
print: {
    .label ch = 2
    // asm
    ldx idx
    lda ch
    sta SCREEN,x
    inc idx
    // }
    rts
}
