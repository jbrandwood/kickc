// Tests creating a literal pointer from two bytes
  // Commodore 64 PRG executable file
.file [name="inline-pointer-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // puta(4, 0x00)
    lda #0
    ldx #4
    jsr puta
    // puta(5, 0x18)
    lda #$18
    ldx #5
    jsr puta
    // }
    rts
}
// puta(byte register(X) ph, byte register(A) pl)
puta: {
    .label screen = 2
    // MAKEWORD( ph, pl )
    stx.z screen+1
    sta.z screen
    // *screen = 'a'
    lda #'a'
    ldy #0
    sta (screen),y
    // }
    rts
}
