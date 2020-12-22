// Tests that array-indexing by a constant word is turned into a constant pointer
  // Commodore 64 PRG executable file
.file [name="derefidx-word-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // screen[40*10] = 'a'
    lda #'a'
    sta screen+$28*$a
    // }
    rts
}
