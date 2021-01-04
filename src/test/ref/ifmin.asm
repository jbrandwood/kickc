// Minimal if() test
  // Commodore 64 PRG executable file
.file [name="ifmin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // if(i<50)
    cpx #$32
    bcs __b2
    // *SCREEN = i
    stx SCREEN
  __b2:
    // while(++i<100)
    inx
    cpx #$64
    bcc __b1
    // }
    rts
}
