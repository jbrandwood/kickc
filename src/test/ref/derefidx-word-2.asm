// Tests that array-indexing by a word variable that is a sum of a constant word and a byte is turned back into derefidx
  // Commodore 64 PRG executable file
.file [name="derefidx-word-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
  __b1:
    // screen[40*10+i] = 'a'
    lda #'a'
    sta screen+$28*$a,x
    // for( byte i : 0..39)
    inx
    cpx #$28
    bne __b1
    // }
    rts
}
