// Example of a struct containing an array
// Works because the struct is only handled as a value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const jesper_id = 4
    .const henriette_id = 7
    lda #<jesper_name
    sta.z print_person.person_name
    lda #>jesper_name
    sta.z print_person.person_name+1
    ldy #0
    ldx #jesper_id
    jsr print_person
    lda #<henriette_name
    sta.z print_person.person_name
    lda #>henriette_name
    sta.z print_person.person_name+1
    ldx #henriette_id
    jsr print_person
    rts
    jesper_name: .text "jesper"
    .byte 0
    .fill 57, 0
    henriette_name: .text "repsej"
    .byte 0
    .fill 57, 0
}
// print_person(byte register(X) person_id, byte[$40] zeropage(2) person_name)
print_person: {
    .label person_name = 2
    lda DIGIT,x
    sta SCREEN,y
    tya
    tax
    inx
    lda #' '
    sta SCREEN,x
    inx
    ldy #0
  b1:
    lda (person_name),y
    cmp #0
    bne b2
    lda #' '
    sta SCREEN,x
    txa
    tay
    iny
    rts
  b2:
    lda (person_name),y
    sta SCREEN,x
    inx
    iny
    jmp b1
}
  DIGIT: .text "0123456789"
  .byte 0
