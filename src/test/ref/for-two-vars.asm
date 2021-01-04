// Test a for-loop with two iterating variables
// Illustrates that for()-loops currently cannot contain two variable declarations.
  // Commodore 64 PRG executable file
.file [name="for-two-vars.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label sc = 2
    lda #<SCREEN+$27
    sta.z sc
    lda #>SCREEN+$27
    sta.z sc+1
    ldx #0
  __b1:
    // for( byte i=0; i<40; i++, sc--)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // *sc = i
    txa
    ldy #0
    sta (sc),y
    // for( byte i=0; i<40; i++, sc--)
    inx
    lda.z sc
    bne !+
    dec.z sc+1
  !:
    dec.z sc
    jmp __b1
}
