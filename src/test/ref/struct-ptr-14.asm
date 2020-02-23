// Minimal struct -  using address-of and passing it to a function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label q = p
    .label p = 2
    // p = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p-1,y
    dey
    bne !-
    // set(q)
    jsr set
    // SCREEN[0] = q->x
    lda.z q
    sta SCREEN
    // SCREEN[1] = q->y
    lda q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
set: {
    // ptr->x = 4
    lda #4
    sta.z main.q
    // ptr->y = 5
    lda #5
    sta main.q+OFFSET_STRUCT_POINT_Y
    // }
    rts
}
  __0: .byte 2, 3
