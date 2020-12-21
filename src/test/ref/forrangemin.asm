// Minimal range based for() loop
  // Commodore 64 PRG executable file
.file [name="forrangemin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN1 = $400
  .label SCREEN2 = $500
.segment Code
main: {
    ldx #0
  __b1:
    // SCREEN1[i] = i
    txa
    sta SCREEN1,x
    // for(byte i : 0..255)
    inx
    cpx #0
    bne __b1
    ldx #$64
  __b2:
    // SCREEN2[j] = j
    txa
    sta SCREEN2,x
    // for(j : 100..0)
    dex
    cpx #$ff
    bne __b2
    // }
    rts
}
