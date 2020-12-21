// Test all types of pointers
  // Commodore 64 PRG executable file
.file [name="ptrtestmin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // A constant pointer
    .label SCREEN = $400
    lda #0
    ldx #2
  __b1:
    // while(i<10)
    cpx #$a
    bcc __b2
    // SCREEN[999] = b
    sta SCREEN+$3e7
    // }
    rts
  __b2:
    // b = SCREEN[i++]
    lda SCREEN,x
    // b = SCREEN[i++];
    inx
    jmp __b1
}
