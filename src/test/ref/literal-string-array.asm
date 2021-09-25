// Tests literal string array
  // Commodore 64 PRG executable file
.file [name="literal-string-array.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_POINTER = 2
  .label SCREEN = $400
  .label NUL = 0
.segment Code
main: {
    .label c = 2
    .label msg = 4
    ldx #0
    lda #<msgs
    sta.z msg
    lda #>msgs
    sta.z msg+1
  __b1:
    // while(*msg)
    ldy #0
    tya
    cmp (msg),y
    bne __b2
    iny
    cmp (msg),y
    bne __b2
    // }
    rts
  __b2:
    // char* c = *msg
    ldy #0
    lda (msg),y
    sta.z c
    iny
    lda (msg),y
    sta.z c+1
  __b3:
    // while(*c)
    ldy #0
    lda (c),y
    cmp #0
    bne __b4
    // msg++;
    lda #SIZEOF_POINTER
    clc
    adc.z msg
    sta.z msg
    bcc !+
    inc.z msg+1
  !:
    jmp __b1
  __b4:
    // SCREEN[i++] = *c++
    ldy #0
    lda (c),y
    sta SCREEN,x
    // SCREEN[i++] = *c++;
    inx
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b3
}
.segment Data
  // Works
  // char*[] msgs = { (char*)"hello", (char*)"cruel", (char*)"world", (char*)NUL };
  // Not working
  msgs: .word __0, __1, __2, NUL
  __0: .text "hello"
  .byte 0
  __1: .text "cruel"
  .byte 0
  __2: .text "world"
  .byte 0
