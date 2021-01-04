// Tests a pointer to a boolean
  // Commodore 64 PRG executable file
.file [name="bool-pointer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // bscreen[0] = true
    lda #1
    sta $400
    // bscreen[1] = false
    lda #0
    sta $400+1
    // *bscreen = true
    lda #1
    sta $400+2
    // if(*bscreen)
    cmp #0
    bne __b1
    rts
  __b1:
    // *(++bscreen)= true
    lda #1
    sta $400+3
    // }
    rts
}
