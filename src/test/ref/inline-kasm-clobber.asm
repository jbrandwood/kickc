// Tests that inline kickasm supports the clobbering directive
  // Commodore 64 PRG executable file
.file [name="inline-kasm-clobber.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label l = 2
    .label k = 3
    lda #0
    sta.z k
  __b1:
    lda #0
    sta.z l
  __b2:
    ldy #0
  __b3:
    // kickasm
    lda #0
                    ldx #0
                    sta SCREEN,x
                
    // for(byte m: 0..10)
    iny
    cpy #$b
    bne __b3
    // for(byte l: 0..10)
    inc.z l
    lda #$b
    cmp.z l
    bne __b2
    // for(byte k : 0..10)
    inc.z k
    cmp.z k
    bne __b1
    // }
    rts
}
