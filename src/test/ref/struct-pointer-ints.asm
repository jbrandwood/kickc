// Demonstrates missing fragment _deref_pwuc1=_deref_pwuc1_plus_vwuc2
// https://gitlab.com/camelot/kickc/-/issues/435 reported by G.B.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_MYSTRUCT = 4
main: {
    .label s = 2
    // s
    ldy #SIZEOF_STRUCT_MYSTRUCT
    lda #0
  !:
    dey
    sta s,y
    bne !-
    // update(&s, 1000)
    jsr update
    // }
    rts
}
update: {
    .const size = $3e8
    .label s = main.s
    // s->a += size
    lda #<size
    clc
    adc.z s
    sta.z s
    lda #>size
    adc.z s+1
    sta.z s+1
    // }
    rts
}
