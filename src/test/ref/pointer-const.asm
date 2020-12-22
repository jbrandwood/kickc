// Test pointer to const and const pointer
  // Commodore 64 PRG executable file
.file [name="pointer-const.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Const pointer
  .label SCREEN = $400
  // Const pointer to const
  .label BASIC = $a004
.segment Code
main: {
    ldx #0
  __b1:
    // while(MSG[i])
    lda MSG,x
    cmp #0
    bne __b2
    ldx #0
  __b3:
    // while(BASIC[i]!='0')
    lda BASIC,x
    cmp #'0'
    bne __b4
    // }
    rts
  __b4:
    // BASIC[i]&0x3f
    lda #$3f
    and BASIC,x
    // SCREEN[40+i] = BASIC[i]&0x3f
    sta SCREEN+$28,x
    // i++;
    inx
    jmp __b3
  __b2:
    // SCREEN[i] = MSG[i]
    lda MSG,x
    sta SCREEN,x
    // i++;
    inx
    jmp __b1
}
.segment Data
  // Pointer to const
  MSG: .text "hello world!"
  .byte 0
