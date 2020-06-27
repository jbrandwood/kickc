.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label ptr = 2
_start: {
    // ptr = 0x1000
    lda #<$1000
    sta.z ptr
    lda #>$1000
    sta.z ptr+1
    jsr main
    rts
}
main: {
    // SCREEN[0] = <w
    lda #<ptr+$32
    sta SCREEN
    // }
    rts
}
