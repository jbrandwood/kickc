// Test MAKELONG4()
  // Commodore 64 PRG executable file
.file [name="makelong4-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label __4 = 2
    .label lolo = 7
    .label lohi = 6
    lda #0
    sta.z lolo
  __b1:
    // for(char lolo=0;lolo<100;lolo++)
    lda.z lolo
    cmp #$64
    bcc __b3
    // }
    rts
  __b3:
    lda #0
    sta.z lohi
  __b2:
    // for(char lohi=0;lohi<100;lohi++)
    lda.z lohi
    cmp #$64
    bcc __b5
    // for(char lolo=0;lolo<100;lolo++)
    inc.z lolo
    jmp __b1
  __b5:
    ldy #0
  __b4:
    // for(char hilo=0;hilo<100;hilo++)
    cpy #$64
    bcc __b8
    // for(char lohi=0;lohi<100;lohi++)
    inc.z lohi
    jmp __b2
  __b8:
    ldx #0
  __b6:
    // for(char hihi=0;hihi<100;hihi++)
    cpx #$64
    bcc __b7
    // for(char hilo=0;hilo<100;hilo++)
    iny
    jmp __b4
  __b7:
    // MAKELONG4(hihi, hilo, lohi, lolo)
    lda.z main.lolo
    sta.z main.__4
    lda.z main.lohi
    sta.z main.__4+1
    sty.z main.__4+2
    stx.z main.__4+3
    // *SCREEN = MAKELONG4(hihi, hilo, lohi, lolo)
    lda.z __4
    sta SCREEN
    lda.z __4+1
    sta SCREEN+1
    lda.z __4+2
    sta SCREEN+2
    lda.z __4+3
    sta SCREEN+3
    // for(char hihi=0;hihi<100;hihi++)
    inx
    jmp __b6
}
