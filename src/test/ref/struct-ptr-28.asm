// Example of a struct containing an array
// It works on the surface - but illustrates the problem with structs containing arrays treating them like pointers.
// https://gitlab.com/camelot/kickc/issues/314
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_PERSON = $11
  .const OFFSET_STRUCT_PERSON_NAME = 1
main: {
    .label jesper = 8
    .label henriette = $19
    ldy #SIZEOF_STRUCT_PERSON
  !:
    lda __0-1,y
    sta jesper-1,y
    dey
    bne !-
    ldx #0
    lda #<jesper
    sta.z print_person.person
    lda #>jesper
    sta.z print_person.person+1
    jsr print_person
    ldy #SIZEOF_STRUCT_PERSON
  !:
    lda __1-1,y
    sta henriette-1,y
    dey
    bne !-
    lda #<henriette
    sta.z print_person.person
    lda #>henriette
    sta.z print_person.person+1
    jsr print_person
    rts
}
// print_person(struct Person* zp(2) person)
print_person: {
    .label __1 = 4
    .label __2 = 6
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
    ldy #0
  __b1:
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z __1
    lda #0
    adc.z person+1
    sta.z __1+1
    lda (__1),y
    cmp #0
    bne __b2
    lda #' '
    sta SCREEN,x
    inx
    rts
  __b2:
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z __2
    lda #0
    adc.z person+1
    sta.z __2+1
    lda (__2),y
    sta SCREEN,x
    inx
    iny
    jmp __b1
}
  DIGIT: .text "0123456789"
  .byte 0
  __0: .byte 4
  .text "jesper"
  .byte 0
  .fill 9, 0
  __1: .byte 7
  .text "henriette"
  .byte 0
  .fill 6, 0
