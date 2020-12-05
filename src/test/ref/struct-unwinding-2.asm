// Test combining unwind structs with classic structs
// Function calls parameter passing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
main: {
    .const p2_x = 3
    .const p2_y = 4
    .label p1 = 3
    // p1 = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p1-1,y
    dey
    bne !-
    // print1(p1, 0)
    ldy.z p1
    ldx p1+OFFSET_STRUCT_POINT_Y
  // Pass classic struct to function taking unwound struct
    lda #0
    jsr print1
    // print2(p1, 2)
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p1-1,y
    sta print2.p-1,y
    dey
    bne !-
  // Pass classic struct to function taking classic struct
    lda #2
    jsr print2
    // print1(p2, 4)
  // Pass unwound struct to function taking unwound struct
    ldx #p2_y
    ldy #p2_x
    lda #4
    jsr print1
    // print2(p2, 6)
    lda #p2_x
    sta.z print2.p
    lda #p2_y
    sta print2.p+OFFSET_STRUCT_POINT_Y
  // Pass unwound struct to function taking classic struct
    lda #6
    jsr print2
    // }
    rts
}
// Function taking unwound struct as parameter
// print1(byte register(Y) p_x, byte register(X) p_y, byte register(A) idx)
print1: {
    .label __0 = 2
    // SCREEN[idx] = p
    asl
    sta.z __0
    tya
    ldy.z __0
    sta SCREEN,y
    txa
    sta SCREEN+OFFSET_STRUCT_POINT_Y,y
    // }
    rts
}
// Function taking classic struct as parameter
// print2(struct Point zp(5) p, byte register(A) idx)
print2: {
    .label p = 5
    // SCREEN[idx] = p
    asl
    tay
    ldx #0
  !:
    lda.z p,x
    sta SCREEN,y
    iny
    inx
    cpx #SIZEOF_STRUCT_POINT
    bne !-
    // }
    rts
}
  __0: .byte 1, 2
