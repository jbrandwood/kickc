.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label screen = $400
    lda #$f0
    sta $450+2
    lda #$f
    sta $450+3
    lda #<$450
    sta fct.z
    lda #>$450
    sta fct.z+1
    ldx #$aa
    jsr fct
    sta screen
    lda #<$450+1
    sta fct.z
    lda #>$450+1
    sta fct.z+1
    ldx #$55
    jsr fct
    sta screen+1
    rts
}
fct: {
    .label z = 2
    ldy #2
    txa
    and (z),y
    rts
}
