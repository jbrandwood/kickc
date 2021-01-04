// Test effective live range and register allocation
// Here main::c, out2::c and out::c can all have the same allocation - and the global idx can be allocated to a hardware register.
  // Commodore 64 PRG executable file
.file [name="liverange-7.prg", type="prg", segments="Program"]
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
    txa
  __b1:
    // out2(c)
    jsr out2
    // for(char c: 0..39 )
    clc
    adc #1
    cmp #$28
    bne __b1
    // }
    rts
}
// out2(byte register(A) c)
out2: {
    // out(c)
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
