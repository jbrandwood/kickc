// Test effective live range and register allocation
// Here out::b, print::b and main::b can have the same allocation
  // Commodore 64 PRG executable file
.file [name="liverange-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label a = 2
    lda #0
    sta.z a
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
    // ca = c+a
    tya
    clc
    adc.z a
    // print(b, ca)
    jsr print
    // for( char c: 0..100 )
    iny
    cpy #$65
    bne __b3
    // for( char b: 0..100 )
    inx
    cpx #$65
    bne __b2
    // for(char a: 0..100 )
    inc.z a
    lda #$65
    cmp.z a
    bne __b1
    // }
    rts
}
// print(byte register(X) b, byte register(A) ca)
print: {
    // out(b, ca)
    jsr out
    // }
    rts
}
// out(byte register(X) b, byte register(A) ca)
out: {
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    // SCREEN[b] = ca
    sta SCREEN,x
    // }
    rts
}
