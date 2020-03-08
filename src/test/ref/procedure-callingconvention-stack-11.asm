// Test a procedure with calling convention stack
// Returning and passing struct of struct  values
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_P2 = 2
  .label idx = 3
__bbegin:
  // idx = 0
  lda #0
  sta.z idx
  jsr main
  rts
// print(byte register(Y) v_p1_x, byte zp(4) v_p1_y, byte zp(5) v_p2_x, byte register(X) v_p2_y)
print: {
    .const OFFSET_STACK_V_P1_X = 3
    .const OFFSET_STACK_V_P1_Y = 2
    .const OFFSET_STACK_V_P2_X = 1
    .const OFFSET_STACK_V_P2_Y = 0
    .label v_p1_y = 4
    .label v_p2_x = 5
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
get: {
    .const OFFSET_STACK_I = 0
    .label return_p1_y = 4
    .label return_p2_y = 5
    tsx
    lda STACK_BASE+OFFSET_STACK_I,x
    tax
    // i/2
    txa
    lsr
    sta.z return_p1_y
    // i+1
    txa
    tay
    iny
    // i*2
    txa
    asl
    sta.z return_p2_y
    // }
    txa
    tsx
    sta STACK_BASE+0,x
    lda.z return_p1_y
    tsx
    sta STACK_BASE+OFFSET_STRUCT_POINT_Y,x
    tya
    tsx
    sta STACK_BASE+OFFSET_STRUCT_VECTOR_P2,x
    lda.z return_p2_y
    tsx
    sta STACK_BASE+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y,x
    rts
}
main: {
    .label v_p2_x = 4
    .label v_p2_y = 5
    .label i = 2
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
    // v = get(i)
    pla
    tay
    pla
    tax
    pla
    sta.z v_p2_x
    pla
    sta.z v_p2_y
    // print(v)
    tya
    pha
    txa
    pha
    lda.z v_p2_x
    pha
    lda.z v_p2_y
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
