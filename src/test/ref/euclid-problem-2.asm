// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.
  // Commodore 64 PRG executable file
.file [name="euclid-problem-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // euclid(128,2)
    ldx #2
    lda #$80
    sta.z euclid.a
    jsr euclid
    // euclid(128,2)
    lda.z euclid.a
    // SCREEN[idx++] = euclid(128,2)
    sta SCREEN
    // euclid(169,69)
    ldx #$45
    lda #$a9
    sta.z euclid.a
    jsr euclid
    // euclid(169,69)
    lda.z euclid.a
    // SCREEN[idx++] = euclid(169,69)
    sta SCREEN+1
    // euclid(255,155)
    ldx #$9b
    lda #$ff
    sta.z euclid.a
    jsr euclid
    // euclid(255,155)
    lda.z euclid.a
    // SCREEN[idx++] = euclid(255,155)
    sta SCREEN+2
    // euclid(99,3)
    ldx #3
    lda #$63
    sta.z euclid.a
    jsr euclid
    // euclid(99,3)
    lda.z euclid.a
    // SCREEN[idx++] = euclid(99,3)
    sta SCREEN+3
    // }
    rts
}
// Calculate least common denominator using euclids subtraction method
// __register(A) char euclid(__zp(2) char a, __register(X) char b)
euclid: {
    .label a = 2
  __b1:
    // while (a!=b)
    cpx.z a
    bne __b2
    // }
    rts
  __b2:
    // if(a>b)
    cpx.z a
    bcc __b3
    // b = b-a
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b3:
    // a = a-b
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp __b1
}
