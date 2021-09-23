// Structs with char* pointer members
// https://gitlab.com/camelot/kickc/-/issues/397
  // Commodore 64 PRG executable file
.file [name="struct-49.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label msg = 2
    .label screen = 4
    .label txt = 6
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<Text
    sta.z txt
    lda #>Text
    sta.z txt+1
    ldx #0
  __b1:
    // for(char i=0;i<sizeof(Text)/sizeof(TextDesc); i++, txt++)
    cpx #$c*3/3
    bcc __b2
    // }
    rts
  __b2:
    // char* msg = txt->Msg
    ldy #1
    lda (txt),y
    sta.z msg
    iny
    lda (txt),y
    sta.z msg+1
  __b3:
    // for(char* msg = txt->Msg; *msg; msg++)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b4
    // *(screen++) = ' '
    lda #' '
    sta (screen),y
    // *(screen++) = ' ';
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for(char i=0;i<sizeof(Text)/sizeof(TextDesc); i++, txt++)
    inx
    lda #3
    clc
    adc.z txt
    sta.z txt
    bcc !+
    inc.z txt+1
  !:
    jmp __b1
  __b4:
    // *(screen++) = *msg
    ldy #0
    lda (msg),y
    sta (screen),y
    // *(screen++) = *msg;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for(char* msg = txt->Msg; *msg; msg++)
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b3
}
.segment Data
  Text: .byte 2
  .word __0_msg
  .byte 4
  .word __0_msg1
  .byte 5
  .word __0_msg2
  .byte 9
  .word __0_msg3
  .byte $b
  .word __0_msg4
  .byte $c
  .word __0_msg5
  .byte $d
  .word __0_msg6
  .byte $e
  .word __0_msg10
  .byte $f
  .word __0_msg8
  .byte $12
  .word __0_msg9
  .byte $13
  .word __0_msg10
  .byte $17
  .word __0_msg11
  __0_msg: .text "Wolfgang Amadeus Mozart"
  .byte 0
  __0_msg1: .text @"\"Eine kleine Nachtmusik\""
  .byte 0
  __0_msg2: .text "(KV 525)"
  .byte 0
  __0_msg3: .text "Ported to the SID in 1987 by"
  .byte 0
  __0_msg4: .text "Joachim von Bassewitz"
  .byte 0
  __0_msg5: .text "(joachim@von-bassewitz.de)"
  .byte 0
  __0_msg6: .text "and"
  .byte 0
  __0_msg8: .text "(ullrich@von-bassewitz.de)"
  .byte 0
  __0_msg9: .text "C Implementation by"
  .byte 0
  __0_msg10: .text "Ullrich von Bassewitz"
  .byte 0
  __0_msg11: .text "Press any key to quit..."
  .byte 0
