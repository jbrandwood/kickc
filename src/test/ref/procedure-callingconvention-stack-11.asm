// Test a procedure with calling convention stack
// Returning and passing struct of struct  values
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-11.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_VECTOR_P2 = 2
  .const SIZEOF_STRUCT_VECTOR = 4
  .const STACK_BASE = $103
  .label SCREEN = $400
  .label idx = 2
.segment Code
__start: {
    // char idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
// void print(__zp(5) struct Vector v)
print: {
    .const OFFSET_STACK_V = 0
    .label v = 5
    tsx
    lda STACK_BASE+OFFSET_STACK_V,x
    sta.z v
    lda STACK_BASE+OFFSET_STACK_V+1,x
    sta.z v+1
    lda STACK_BASE+OFFSET_STACK_V+2,x
    sta.z v+2
    lda STACK_BASE+OFFSET_STACK_V+3,x
    sta.z v+3
    // SCREEN[idx++] = v.p1.x
    lda.z v
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = v.p1.x;
    inc.z idx
    // SCREEN[idx++] = v.p1.y
    lda v+OFFSET_STRUCT_POINT_Y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = v.p1.y;
    inc.z idx
    // SCREEN[idx++] = v.p2.x
    lda v+OFFSET_STRUCT_VECTOR_P2
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = v.p2.x;
    inc.z idx
    // SCREEN[idx++] = v.p2.y
    lda v+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y
    ldy.z idx
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
// __zp($a) struct Vector get(__register(Y) char i)
get: {
    .const OFFSET_STACK_I = 0
    .const OFFSET_STACK_RETURN_0 = 0
    .label return = $a
    .label v = $e
    .label __0 = 3
    .label __2 = 4
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
    // struct Vector v = { {i, i/2}, {i+1, i*2} }
    sty.z v
    lda.z __0
    sta v+OFFSET_STRUCT_POINT_Y
    stx v+OFFSET_STRUCT_VECTOR_P2
    lda.z __2
    sta v+OFFSET_STRUCT_VECTOR_P2+OFFSET_STRUCT_POINT_Y
    // return v;
    ldy #SIZEOF_STRUCT_VECTOR
  !:
    lda v-1,y
    sta return-1,y
    dey
    bne !-
    // }
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    lda.z return+2
    sta STACK_BASE+OFFSET_STACK_RETURN_0+2,x
    lda.z return+3
    sta STACK_BASE+OFFSET_STACK_RETURN_0+3,x
    rts
}
main: {
    .label v = 5
    .label i = 9
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
    // struct Vector v = get(i)
    lda.z i
    pha
    pha
    pha
    pha
    jsr get
    pla
    sta.z v
    pla
    sta.z v+1
    pla
    sta.z v+2
    pla
    sta.z v+3
    // print(v)
    pha
    lda.z v+2
    pha
    lda.z v+1
    pha
    lda.z v
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
