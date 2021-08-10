// Live ranges were not functioning properly, when multiple method calls were chained - each modifying different vars.
// w1 and w2 ended up having the same zero-page register as their live range was not propagated properly
  // Commodore 64 PRG executable file
.file [name="liverange-call-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
  .label w1 = 2
  .label w2 = 4
.segment Code
main: {
    .label SCREEN = $400
    // incw1()
    lda #<0
    sta.z w1
    sta.z w1+1
    jsr incw1
    // incw2()
    lda #<0
    sta.z w2
    sta.z w2+1
    jsr incw2
    // incw1()
    jsr incw1
    // incw2()
    jsr incw2
    // SCREEN[0] = w1
    lda.z w1
    sta SCREEN
    lda.z w1+1
    sta SCREEN+1
    // SCREEN[2] = w2
    lda.z w2
    sta SCREEN+2*SIZEOF_UNSIGNED_INT
    lda.z w2+1
    sta SCREEN+2*SIZEOF_UNSIGNED_INT+1
    // }
    rts
}
incw1: {
    // w1++;
    inc.z w1
    bne !+
    inc.z w1+1
  !:
    // }
    rts
}
incw2: {
    // w2++;
    inc.z w2
    bne !+
    inc.z w2+1
  !:
    // }
    rts
}
