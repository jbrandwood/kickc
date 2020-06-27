// Tests that constants are identified early
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label SCREEN = $400
  // Not an early constant (address-of is used)
  .label A = 2
_start: {
    // A = 'a'
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
    // D = A+1
    ldx.z A
    inx
    // SCREEN[4] = D
    stx SCREEN+4
    // }
    rts
}
