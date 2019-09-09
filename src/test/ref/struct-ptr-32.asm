// Example of a struct containing an array
// Fails (by displaying "BB" ) because the memory layout is wrong - and the name is treated like a pointer (to 0x0000) instead of a value.
// https://gitlab.com/camelot/kickc/issues/312
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = 3
  .const OFFSET_STRUCT_PERSON_NAME = 1
main: {
    .label SCREEN = $400
    .label person = persons+SIZEOF_STRUCT_PERSON
    lda #'a'
    ldy persons+OFFSET_STRUCT_PERSON_NAME
    sty.z $fe
    ldy persons+OFFSET_STRUCT_PERSON_NAME+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    lda #'b'
    ldy persons+OFFSET_STRUCT_PERSON_NAME+1*SIZEOF_STRUCT_PERSON
    sty.z $fe
    ldy persons+OFFSET_STRUCT_PERSON_NAME+1*SIZEOF_STRUCT_PERSON+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    ldy persons+OFFSET_STRUCT_PERSON_NAME
    sty.z $fe
    ldy persons+OFFSET_STRUCT_PERSON_NAME+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    sta SCREEN
    ldy person+OFFSET_STRUCT_PERSON_NAME
    sty.z $fe
    ldy person+OFFSET_STRUCT_PERSON_NAME+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    sta SCREEN+1
    rts
}
  persons: .fill 3*2, 0
