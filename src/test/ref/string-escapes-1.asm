// Test using some simple supported string escape \n in both string and char
  // Commodore 64 PRG executable file
.file [name="string-escapes-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label cursor = 6
    .label msg = 2
    .label line = 4
    lda #<$400
    sta.z cursor
    lda #>$400
    sta.z cursor+1
    lda #<$400
    sta.z line
    lda #>$400
    sta.z line+1
    lda #<MESSAGE
    sta.z msg
    lda #>MESSAGE
    sta.z msg+1
  __b1:
    // while(*msg)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // case '\n':
    //                 line += 0x28;
    //                 cursor = line;
    //                 break;
    lda #'\n'
    ldy #0
    cmp (msg),y
    beq __b3
    // *cursor++ = *msg
    lda (msg),y
    sta (cursor),y
    // *cursor++ = *msg;
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
  __b5:
    // msg++;
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
  __b3:
    // line += 0x28
    lda #$28
    clc
    adc.z line
    sta.z cursor
    lda #0
    adc.z line+1
    sta.z cursor+1
    lda.z cursor
    sta.z line
    lda.z cursor+1
    sta.z line+1
    jmp __b5
}
.segment Data
  MESSAGE: .text @"hello\nworld"
  .byte 0
