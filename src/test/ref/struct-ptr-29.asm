// Example of a struct containing a pointer
  // Commodore 64 PRG executable file
.file [name="struct-ptr-29.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_PERSON = 3
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .label SCREEN = $400
  .label idx = 5
.segment Code
main: {
    // print_person(&persons[0])
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    // print_person(&persons[1])
    lda #<persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person
    lda #>persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person+1
    jsr print_person
    // }
    rts
}
// print_person(struct Person* zp(2) person)
print_person: {
    .label i = 4
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
    stx.z idx
    lda #0
    sta.z i
    // for(byte i=0; person->name[i]; i++)
    .assert "Missing ASM fragment Fragment not found 0_neq_(qbuz1_derefidx_vbuc1)_derefidx_vbuz2_then_la1. Attempted variations 0_neq_(qbuz1_derefidx_vbuc1)_derefidx_vbuz2_then_la1 0_neq_(qbuz1_derefidx_vbsc1)_derefidx_vbuz2_then_la1 0_neq_(qbuz1_derefidx_vwuc1)_derefidx_vbuz2_then_la1 0_neq_(qbuz1_derefidx_vwsc1)_derefidx_vbuz2_then_la1 0_neq_(qbuz1_derefidx_vduc1)_derefidx_vbuz2_then_la1 0_neq_(qbuz1_derefidx_vdsc1)_derefidx_vbuz2_then_la1 ", 0, 1
    // SCREEN[idx++] = ' '
    lda #' '
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = ' ';
    inx
    // }
    rts
    // SCREEN[idx++] = person->name[i]
    // SCREEN[idx++] = person->name[i];
    // for(byte i=0; person->name[i]; i++)
}
.segment Data
  persons: .byte 4
  .word person_name
  .byte 7
  .word person_name1
  DIGIT: .text "0123456789"
  .byte 0
  person_name: .text "jesper"
  .byte 0
  person_name1: .text "repsej"
  .byte 0
