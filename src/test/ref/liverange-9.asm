// Test effective live range and register allocation
// Here main::c, outsw::c and outw::c can all have the same allocation
  // Commodore 64 PRG executable file
.file [name="liverange-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
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
// void outsw(__register(Y) char c)
outsw: {
    // out('-')
    lda #'-'
    jsr out
    // outw(c)
    jsr outw
    // }
    rts
}
// void out(__register(A) char c)
out: {
    // idx++;
    inx
    // SCREEN[idx] = c
    sta SCREEN,x
    // }
    rts
}
// void outw(__register(Y) char c)
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
