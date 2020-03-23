// Test effective live range and register allocation
// Here main::c, outsw::c and outw::c can all have the same allocation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    ldy #0
  __b1:
    // outsw(c)
    jsr outsw
    // for(char c: 0..39 )
    iny
    cpy #$28
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
    jsr outw
    // }
    rts
}
// outw(byte register(Y) c)
outw: {
    // out(c<<4)
    tya
    asl
    asl
    asl
    asl
    jsr out
    // out(c&0x0f)
    tya
    and #$f
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
