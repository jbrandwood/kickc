// Demonstrates problem with __ma coalescing
// c1a is erroneously zp-coalesced with c1A
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
  __b1:
    lda c1A
    sta c1a
    lda #0
    sta i
  __b2:
    lda i
    cmp #$28
    bcc __b3
    lax c1A
    axs #-[3]
    stx c1A
    jmp __b1
  __b3:
    ldy c1a
    lda SINTABLE,y
    ldy i
    sta SCREEN,y
    lax c1a
    axs #-[4]
    stx c1a
    inc i
    jmp __b2
    c1a: .byte 0
    i: .byte 0
}
  .align $100
SINTABLE:
.for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))

  // Plasma state variables
  c1A: .byte 0
