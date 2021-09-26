  // Commodore 64 PRG executable file
.file [name="struct-function.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_MENU_ITEM_CODE = 2
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<2;i++)
    lda.z i
    cmp #2
    bcc __b2
    // }
    rts
  __b2:
    // (*(menu[i].code))()
    lda.z i
    asl
    asl
    tay
    lda menu+OFFSET_STRUCT_MENU_ITEM_CODE,y
    sta !+ +1
    lda menu+OFFSET_STRUCT_MENU_ITEM_CODE+1,y
    sta !+ +2
  !:
    jsr 0
    // for(char i=0;i<2;i++)
    inc.z i
    jmp __b1
}
exit: {
    // SCREEN[1] = 'x'
    lda #'x'
    sta SCREEN+1
    // }
    rts
}
file: {
    // SCREEN[0] = 'f'
    lda #'f'
    sta SCREEN
    // }
    rts
}
.segment Data
  menu: .word menu_item_text, file, menu_item_text1, exit
  menu_item_text: .text "File"
  .byte 0
  menu_item_text1: .text "Exit"
  .byte 0
