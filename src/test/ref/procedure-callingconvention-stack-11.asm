// Test a procedure with calling convention stack
// Returning and passing struct of struct  values
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_P2 = 2
  .const STACK_BASE = $103
  .label idx = 2
__bbegin:
  // idx = 0
  lda #0
  sta.z idx
  jsr main
  rts
// print(byte register(Y) v_p1_x, byte zp(3) v_p1_y, byte zp(4) v_p2_x, byte register(X) v_p2_y)
print: {
    .const OFFSET_STACK_V_P1_X = 3
    .const OFFSET_STACK_V_P1_Y = 2
    .const OFFSET_STACK_V_P2_X = 1
    .const OFFSET_STACK_V_P2_Y = 0
    .label v_p1_y = 3
    .label v_p2_x = 4
    // }
    tsx
    lda STACK_BASE+OFFSET_STACK_V_P1_X,x
    tay
    tsx
    lda STACK_BASE+OFFSET_STACK_V_P1_Y,x
    sta.z v_p1_y
    tsx
    lda STACK_BASE+OFFSET_STACK_V_P2_X,x
    sta.z v_p2_x
    tsx
    lda STACK_BASE+OFFSET_STACK_V_P2_Y,x
    tax
    // SCREEN[idx++] = v.p1.x
    tya
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = v.p1.x;
    inc.z idx
    // SCREEN[idx++] = v.p1.y
    lda.z v_p1_y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = v.p1.y;
    inc.z idx
    // SCREEN[idx++] = v.p2.x
    lda.z v_p2_x
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = v.p2.x;
    inc.z idx
    // SCREEN[idx++] = v.p2.y
    ldy.z idx
    txa
    sta SCREEN,y
    // SCREEN[idx++] = v.p2.y;
    inc.z idx
    // SCREEN[idx++] = ' '
    lda #' '
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = ' ';
    inc.z idx
    // }
    rts
}
// get(byte register(Y) i)
get: {
    .const OFFSET_STACK_I = 0
    .label __0 = 3
    .label __2 = 4
    .label v = $10
    .label return_p2_x = 6
    .label return_p2_y = 7
    tsx
    lda STACK_BASE+OFFSET_STACK_I,x
    tay
    // i/2
    tya
    lsr
    sta.z __0
    // i+1
    tya
    tax
    inx
    // i*2
    tya
    asl
    sta.z __2
    // v = { {i, i/2}, {i+1, i*2} }
    sty.z v
    lda.z __0
    sta v+OFFSET_STRUCT_POINT_Y
    stx v+OFFSET_STRUCT_VECTOR_P2
    lda.z __2
    sta v+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y
    // return v;
    ldx.z v
    ldy v+OFFSET_STRUCT_POINT_Y
    lda v+OFFSET_STRUCT_VECTOR_P2
    sta.z return_p2_x
    lda v+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y
    sta.z return_p2_y
    // }
    txa
    tsx
    sta STACK_BASE+0,x
    tya
    tsx
    sta STACK_BASE+OFFSET_STRUCT_POINT_Y,x
    lda.z return_p2_x
    tsx
    sta STACK_BASE+OFFSET_STRUCT_VECTOR_P2,x
    lda.z return_p2_y
    tsx
    sta STACK_BASE+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y,x
    rts
}
main: {
    .label i = 5
    .label v = $c
    .label __1_p2_x = 6
    .label __1_p2_y = 7
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
    pha
    pha
    jsr get
    pla
    tay
    pla
    tax
    pla
    sta.z __1_p2_x
    pla
    sta.z __1_p2_y
    // v = get(i)
    sty.z v
    stx v+OFFSET_STRUCT_POINT_Y
    lda.z __1_p2_x
    sta v+OFFSET_STRUCT_VECTOR_P2
    lda.z __1_p2_y
    sta v+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y
    // print(v)
    tya
    pha
    txa
    pha
    lda v+OFFSET_STRUCT_VECTOR_P2
    pha
    lda v+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y
    pha
    jsr print
    tsx
    txa
    axs #-4
    txs
    // for(char i=0;i<5;i++)
    inc.z i
    jmp __b1
}
