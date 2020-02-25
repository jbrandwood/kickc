// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = $10
  .const OFFSET_STRUCT_PERSON_NAME = 1
main: {
    .label SCREEN = $400
    .label person = persons+SIZEOF_STRUCT_PERSON
    // SCREEN[0] = person->name[2]
    lda persons+OFFSET_STRUCT_PERSON_NAME+2
    sta SCREEN
    // SCREEN[1] = person->name[2]
    lda person+OFFSET_STRUCT_PERSON_NAME+2
    sta SCREEN+1
    // }
    rts
}
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
