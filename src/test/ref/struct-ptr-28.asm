// Example of a struct containing an array
// It works on the surface - but illustrates the problem with structs containing arrays treating them like pointers.
// https://gitlab.com/camelot/kickc/issues/312
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .label SCREEN = $400
main: {
    .label jesper_id = 5
    .label jesper_name = 6
    .label henriette_id = 8
    .label henriette_name = 9
    lda #4
    sta.z jesper_id
    lda #<_4
    sta.z jesper_name
    lda #>_4
    sta.z jesper_name+1
    ldx #0
    lda #<jesper_id
    sta.z print_person.person
    lda #>jesper_id
    sta.z print_person.person+1
    jsr print_person
    lda #7
    sta.z henriette_id
    lda #<_5
    sta.z henriette_name
    lda #>_5
    sta.z henriette_name+1
    lda #<henriette_id
    sta.z print_person.person
    lda #>henriette_id
    sta.z print_person.person+1
    jsr print_person
    rts
    _4: .text "jesper"
    .byte 0
    _5: .text "henriette"
    .byte 0
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
  b1:
    ldy #OFFSET_STRUCT_PERSON_NAME
    lda (person),y
    sta.z $fe
    iny
    lda (person),y
    sta.z $ff
    ldy.z i
    lda ($fe),y
    cmp #0
    bne b2
    lda #' '
    sta SCREEN,x
    inx
    rts
  b2:
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
    jmp b1
}
  DIGIT: .text "0123456789"
  .byte 0
