// Demonstrate problem with inline kasm clobbering memory
// And the ASM peephole optimizer not realizing this
  // Commodore 64 PRG executable file
.file [name="inline-kasm-clobbermem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label tile = 2
    // __ma char tile = 0
    lda #0
    sta.z tile
    tax
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // kickasm
    lda #4
            sta tile
            lda #2
            sta $02
        
    // SCREEN[i] = tile
    lda.z tile
    sta SCREEN,x
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
