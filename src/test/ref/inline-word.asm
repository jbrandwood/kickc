  // Commodore 64 PRG executable file
.file [name="inline-word.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label w = 3
    .label h = 2
    lda #0
    sta.z h
  // constant array
  __b1:
    ldx #4
  __b2:
    // word w = MAKEWORD( his[h], l )
    ldy.z h
    lda his,y
    sta.z w+1
    stx.z w
    // *sc = '*'
    lda #'*'
    ldy #0
    sta (w),y
    // for (byte l: 4..7)
    inx
    cpx #8
    bne __b2
    // for( byte h: 0..2)
    inc.z h
    lda #3
    cmp.z h
    bne __b1
    // }
    rts
  .segment Data
    his: .byte >SCREEN, >SCREEN+$100, >SCREEN+$200
}
