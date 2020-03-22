// Test effective live range and register allocation
// Here main::c, outsw::c and outw::c can all have the same allocation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label c = 2
    ldx #0
    txa
    sta.z c
  __b1:
    // outsw(c)
    ldy.z c
    jsr outsw
    // for(char c: 0..39 )
    inc.z c
    lda #$28
    cmp.z c
    bne __b1
    // }
    rts
}
// outsw(byte register(Y) c)
outsw: {
    // out('-')
    lda #'-'
    jsr out
    // outw(c)
    sty.z outw.c
    jsr outw
    // }
    rts
}
// outw(byte zp(3) c)
outw: {
    .label c = 3
    // c<<4
    lda.z c
    asl
    asl
    asl
    asl
    // out(HEXTAB[c<<4])
    tay
    lda HEXTAB,y
    jsr out
    // c&0x0f
    lda #$f
    and.z c
    // out(HEXTAB[c&0x0f])
    tay
    lda HEXTAB,y
    jsr out
    // }
    rts
}
// out(byte register(A) c)
out: {
    // idx++;
    inx
    // SCREEN[idx] = c
    sta SCREEN,x
    // }
    rts
}
  HEXTAB: .text "0123456789abcdef"
  .byte 0
