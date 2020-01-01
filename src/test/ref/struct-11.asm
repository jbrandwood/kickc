// Example of a struct containing an array
// Works because the struct is only handled as a value
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const jesper_id = 4
  .const henriette_id = 7
__bbegin:
  ldy #$40
!:
  lda __0-1,y
  sta jesper_name-1,y
  dey
  bne !-
  ldy #$40
!:
  lda __1-1,y
  sta henriette_name-1,y
  dey
  bne !-
  jsr main
  rts
main: {
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
}
// print_person(byte register(X) person_id, byte* zp(2) person_name)
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
  __b1:
    lda (person_name),y
    cmp #0
    bne __b2
    lda #' '
    sta SCREEN,x
    txa
    tay
    iny
    rts
  __b2:
    lda (person_name),y
    sta SCREEN,x
    inx
    iny
    jmp __b1
}
  DIGIT: .text "0123456789"
  .byte 0
  jesper_name: .fill $40, 0
  henriette_name: .fill $40, 0
  __0: .text "jesper"
  .byte 0
  .fill $39, 0
  __1: .text "henriette"
  .byte 0
  .fill $36, 0
