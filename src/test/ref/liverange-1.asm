// Test propagation of live ranges back over PHI-calls
// The idx-variable is alive between the two calls to out() - but not before the first call.
  // Commodore 64 PRG executable file
.file [name="liverange-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // out('c')
    ldx #0
    lda #'c'
    jsr out
    // out('m')
    lda #'m'
    jsr out
    // }
    rts
}
// void out(__register(A) char c)
out: {
    // SCREEN[idx++] = c
    sta SCREEN,x
    // SCREEN[idx++] = c;
    inx
    // }
    rts
}
