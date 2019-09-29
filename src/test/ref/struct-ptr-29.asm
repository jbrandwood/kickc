// Example of a struct containing a pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = 3
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .label SCREEN = $400
main: {
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    lda #<persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person
    lda #>persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person+1
    jsr print_person
    rts
}
// print_person(struct Person* zeropage(2) person)
print_person: {
    .label i = 4
    .label person = 2
    ldy #0
    lda (person),y
    tay
    lda DIGIT,y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    lda #0
    sta.z i
  __b1:
    ldy #OFFSET_STRUCT_PERSON_NAME
    lda (person),y
    sta.z $fe
    iny
    lda (person),y
    sta.z $ff
    ldy.z i
    lda ($fe),y
    cmp #0
    bne __b2
    lda #' '
    sta SCREEN,x
    inx
    rts
  __b2:
    ldy #OFFSET_STRUCT_PERSON_NAME
    lda (person),y
    sta.z $fe
    iny
    lda (person),y
    sta.z $ff
    ldy.z i
    lda ($fe),y
    sta SCREEN,x
    inx
    inc.z i
    jmp __b1
}
  __0: .text "jesper"
  .byte 0
  __1: .text "repsej"
  .byte 0
  persons: .byte 4
  .word __0
  .byte 7
  .word __1
  DIGIT: .text "0123456789"
  .byte 0
