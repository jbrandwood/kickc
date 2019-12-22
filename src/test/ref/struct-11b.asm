// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    lda #<jesper_initials
    sta.z print_person.person_initials
    lda #>jesper_initials
    sta.z print_person.person_initials+1
    jsr print_person
    lda #<henry_initials
    sta.z print_person.person_initials
    lda #>henry_initials
    sta.z print_person.person_initials+1
    jsr print_person
    rts
}
// print_person(byte* zeropage(2) person_initials)
print_person: {
    .label person_initials = 2
    ldy #0
  __b1:
    lda (person_initials),y
    cmp #0
    bne __b2
    lda #' '
    sta SCREEN,x
    inx
    rts
  __b2:
    lda (person_initials),y
    sta SCREEN,x
    inx
    iny
    jmp __b1
}
  jesper_initials: .text "jg"
  .byte 0
  .fill $3d, 0
  henry_initials: .text "hg"
  .byte 0
  .fill $3d, 0
