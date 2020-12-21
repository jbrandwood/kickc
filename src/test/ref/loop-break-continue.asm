// Illustrates both break & continue statements in a loop
// Prints a message ending at NUL skipping all spaces
  // Commodore 64 PRG executable file
.file [name="loop-break-continue.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    // if(str[i]==0)
    lda str,x
    cmp #0
    bne __b2
  __breturn:
    // }
    rts
  __b2:
    // if(str[i]==' ')
    lda str,x
    cmp #' '
    beq __b4
    // *screen++ = str[i]
    lda str,x
    ldy #0
    sta (screen),y
    // *screen++ = str[i];
    inc.z screen
    bne !+
    inc.z screen+1
  !:
  __b4:
    // for( byte i: 0..255)
    inx
    cpx #0
    beq __breturn
    jmp __b1
  .segment Data
    str: .text "hello brave new world"
    .byte 0
}
