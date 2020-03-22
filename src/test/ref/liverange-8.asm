// Test effective live range and register allocation
// Here main::c, out2::c and out::c can all have the same allocation - and the global idx can be allocated to a hardware register.
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
    // out2(c)
    ldy.z c
    jsr out2
    // for(char c: 0..39 )
    inc.z c
    lda #$28
    cmp.z c
    bne __b1
    // }
    rts
}
// out2(byte register(Y) c)
out2: {
    // out(c)
    tya
    jsr out
    // out(c)
    tya
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
