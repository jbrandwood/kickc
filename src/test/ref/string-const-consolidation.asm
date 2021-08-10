// Tests that identical strings are consolidated
  // Commodore 64 PRG executable file
.file [name="string-const-consolidation.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 2
.segment Code
main: {
    // print(rex1)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr print
    // print(rex2)
    jsr print
    // print("rex")
    jsr print
    // }
    rts
}
// void print(__zp(4) char *string)
print: {
    .label string = 4
    lda #<rex1
    sta.z string
    lda #>rex1
    sta.z string+1
  __b1:
    // while(*string)
    ldy #0
    lda (string),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *screen++ = *string++
    ldy #0
    lda (string),y
    sta (screen),y
    // *screen++ = *string++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z string
    bne !+
    inc.z string+1
  !:
    jmp __b1
}
.segment Data
  rex1: .text "rex"
  .byte 0
