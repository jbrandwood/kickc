// Test effective live range and register allocation
// Here outsw::sw and outw::w should have the same allocation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label sw = 2
    .label w = 4
    ldx #0
    lda #<-$14
    sta.z sw
    lda #>-$14
    sta.z sw+1
  __b1:
    // outsw(sw)
    lda.z sw
    sta.z outsw.sw
    lda.z sw+1
    sta.z outsw.sw+1
    jsr outsw
    // for(signed int sw: -20..19 )
    inc.z sw
    bne !+
    inc.z sw+1
  !:
    lda.z sw+1
    cmp #>$14
    bne __b1
    lda.z sw
    cmp #<$14
    bne __b1
    lda #<0
    sta.z w
    sta.z w+1
  __b2:
    // outw(w)
    jsr outw
    // for(unsigned int w: 0..39 )
    inc.z w
    bne !+
    inc.z w+1
  !:
    lda.z w+1
    cmp #>$28
    bne __b2
    lda.z w
    cmp #<$28
    bne __b2
    // }
    rts
}
// outsw(signed word zp(4) sw)
outsw: {
    .label sw = 4
    // if(sw<0)
    lda.z sw+1
    bpl __b1
    // out('-')
    lda #'-'
    jsr out
    // sw = -sw
    sec
    lda #0
    sbc.z sw
    sta.z sw
    lda #0
    sbc.z sw+1
    sta.z sw+1
  __b1:
    // outw((unsigned int)sw)
    jsr outw
    // }
    rts
}
// outw(word zp(4) w)
outw: {
    .label w = 4
    // >w
    lda.z w+1
    // (>w)<<4
    asl
    asl
    asl
    asl
    // out(HEXTAB[(>w)<<4])
    tay
    lda HEXTAB,y
    jsr out
    // >w
    lda.z w+1
    // (>w)&0x0f
    and #$f
    // out(HEXTAB[(>w)&0x0f])
    tay
    lda HEXTAB,y
    jsr out
    // <w
    lda.z w
    // (<w)<<4
    asl
    asl
    asl
    asl
    // out(HEXTAB[(<w)<<4])
    tay
    lda HEXTAB,y
    jsr out
    // <w
    lda.z w
    // (<w)&0x0f
    and #$f
    // out(HEXTAB[(<w)&0x0f])
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
