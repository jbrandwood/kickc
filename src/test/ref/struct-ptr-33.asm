// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = $10
  .const OFFSET_STRUCT_PERSON_NAME = 1
main: {
    .label SCREEN = $400
    .label person = persons+SIZEOF_STRUCT_PERSON
    lda persons+OFFSET_STRUCT_PERSON_NAME+2
    sta SCREEN
    lda person+OFFSET_STRUCT_PERSON_NAME+2
    sta SCREEN+1
    rts
}
  _0: .text "jesper"
  .byte 0
  _1: .text "henry"
  .byte 0
  persons: .byte 7
  .text "jesper"
  .byte 0
  .fill 6, 0
  .word $141
  .byte 9
  .text "henry"
  .byte 0
  .fill 7, 0
  .word $7b
