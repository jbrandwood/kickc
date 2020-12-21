// Demonstrates problem with __ma coalescing
// c1a is erroneously zp-coalesced with c1A
  // Commodore 64 PRG executable file
.file [name="ma_coalesce_problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
  __b1:
    // c1a = c1A
    lda c1A
    sta c1a
    // i = 0
    lda #0
    sta i
  __b2:
    // for (char i = 0; i < 40; ++i)
    lda i
    cmp #$28
    bcc __b3
    // c1A += 3
    lax c1A
    axs #-[3]
    stx c1A
    jmp __b1
  __b3:
    // SCREEN[i] = SINTABLE[c1a]
    ldy c1a
    lda SINTABLE,y
    ldy i
    sta SCREEN,y
    // c1a += 4
    lax c1a
    axs #-[4]
    stx c1a
    // for (char i = 0; i < 40; ++i)
    inc i
    jmp __b2
  .segment Data
    c1a: .byte 0
    i: .byte 0
}
  .align $100
SINTABLE:
.for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))

  // Plasma state variables
  c1A: .byte 0
