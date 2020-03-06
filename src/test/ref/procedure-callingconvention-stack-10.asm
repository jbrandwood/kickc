// Test a procedure with calling convention stack
// Returning and passing struct values
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const STACK_BASE = $103
  .const OFFSET_STRUCT_POINT_X = 0
  .label idx = 2
__bbegin:
  // idx = 0
  lda #0
  sta.z idx
  jsr main
  rts
// print(byte register(Y) p_x, byte register(X) p_y)
print: {
    .const OFFSET_STACK_P_X = 1
    .const OFFSET_STACK_P_Y = 0
    // }
    tsx
    lda STACK_BASE+OFFSET_STACK_P_X,x
    tay
    tsx
    lda STACK_BASE+OFFSET_STACK_P_Y,x
    tax
    // SCREEN[idx++] = p.x
    tya
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = p.x;
    inc.z idx
    // SCREEN[idx++] = p.y
    ldy.z idx
    txa
    sta SCREEN,y
    // SCREEN[idx++] = p.y;
    inc.z idx
    // }
    rts
}
// get(byte register(X) i)
get: {
    .const OFFSET_STACK_I = 0
    .const OFFSET_STACK_RETURN = 0
    .label p = 8
    tsx
    lda STACK_BASE+OFFSET_STACK_I,x
    tax
    // i/2
    txa
    lsr
    // p = { i, i/2 }
    stx.z p
    sta p+OFFSET_STRUCT_POINT_Y
    // return p;
    txa
    ldy p+OFFSET_STRUCT_POINT_Y
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN+OFFSET_STRUCT_POINT_X,x
    tya
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN+OFFSET_STRUCT_POINT_Y,x
    rts
}
main: {
    .label i = 3
    .label p = 6
    .label __1_x = 4
    .label __1_y = 5
    // i=0
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<5;i++)
    lda.z i
    cmp #5
    bcc __b2
    // }
    rts
  __b2:
    // get(i)
    lda.z i
    pha
    pha
    jsr get
    pla
    sta.z __1_x
    pla
    sta.z __1_y
    // p = get(i)
    lda.z __1_x
    sta.z p
    lda.z __1_y
    sta p+OFFSET_STRUCT_POINT_Y
    // print(p)
    lda.z p
    pha
    lda p+OFFSET_STRUCT_POINT_Y
    pha
    jsr print
    pla
    pla
    // for(char i=0;i<5;i++)
    inc.z i
    jmp __b1
}
