// Tests that constants are identified early
  // Commodore 64 PRG executable file
.file [name="const-early-identification.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  // Not an early constant (address-of is used)
  .label A = 2
.segment Code
__start: {
    // byte A = 'a'
    lda #'a'
    sta.z A
    jsr main
    rts
}
main: {
    .const B = 'b'
    .label addrA = A
    // SCREEN[0] = A
    lda.z A
    sta SCREEN
    // SCREEN[1] = B
    lda #B
    sta SCREEN+1
    // SCREEN[2] = *addrA
    lda.z addrA
    sta SCREEN+2
    // sub()
    jsr sub
    // }
    rts
}
sub: {
    .const C = 'c'
    // SCREEN[3] = C
    lda #C
    sta SCREEN+3
    // byte D = A+1
    // Not an early constant (expression)
    ldx.z A
    inx
    // SCREEN[4] = D
    stx SCREEN+4
    // }
    rts
}
