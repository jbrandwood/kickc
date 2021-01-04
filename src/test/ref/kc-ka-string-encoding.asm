  // Commodore 64 PRG executable file
.file [name="kc-ka-string-encoding.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // strTemp[2] = 'e'
  .encoding "petscii_mixed"
    lda #'e'
    sta strTemp+2
    // strTemp[3] = 0
    lda #0
    sta strTemp+3
    // asm
    tay
  loop:
    lda strTemp,y
    beq done
    jsr $ffd2
    iny
    jmp loop
  done:
    // }
    rts
}
.segment Data
  strTemp: .text "v=X"
  .byte 0
