// Example of a struct containing an array
// It works on the surface - but illustrates the problem with structs containing arrays treating them like pointers.
// https://gitlab.com/camelot/kickc/issues/314
  // Commodore 64 PRG executable file
.file [name="struct-ptr-28.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_PERSON = $11
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .label SCREEN = $400
.segment Code
main: {
    .label jesper = 8
    .label henriette = $19
    // struct Person jesper = { 4, "jesper" }
    ldy #SIZEOF_STRUCT_PERSON
  !:
    lda __0-1,y
    sta jesper-1,y
    dey
    bne !-
    // print_person(&jesper)
    ldx #0
    lda #<jesper
    sta.z print_person.person
    lda #>jesper
    sta.z print_person.person+1
    jsr print_person
    // struct Person henriette = { 7, "henriette" }
    ldy #SIZEOF_STRUCT_PERSON
  !:
    lda __1-1,y
    sta henriette-1,y
    dey
    bne !-
    // print_person(&henriette)
    lda #<henriette
    sta.z print_person.person
    lda #>henriette
    sta.z print_person.person+1
    jsr print_person
    // }
    rts
}
// print_person(struct Person* zp(2) person)
print_person: {
    .label __1 = 4
    .label __2 = 6
    .label person = 2
    // SCREEN[idx++] = DIGIT[person->id]
    ldy #0
    lda (person),y
    tay
    lda DIGIT,y
    sta SCREEN,x
    // SCREEN[idx++] = DIGIT[person->id];
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    ldy #0
  __b1:
    // for(byte i=0; person->name[i]; i++)
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
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // }
    rts
  __b2:
    // SCREEN[idx++] = person->name[i]
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z __2
    lda #0
    adc.z person+1
    sta.z __2+1
    lda (__2),y
    sta SCREEN,x
    // SCREEN[idx++] = person->name[i];
    inx
    // for(byte i=0; person->name[i]; i++)
    iny
    jmp __b1
}
.segment Data
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
