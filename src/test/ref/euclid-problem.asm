// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.
  // Commodore 64 PRG executable file
.file [name="euclid-problem.prg", type="prg", segments="Program"]
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
    ldx #2
    lda #$80
    sta.z a
  __b1:
    // while (a!=b)
    cpx.z a
    bne __b2
    // *SCREEN = a
    lda.z a
    sta SCREEN
    // }
    rts
  __b2:
    // if(a>b)
    cpx.z a
    bcc __b4
    // b = b-a
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b4:
    // a = a-b
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp __b1
}
