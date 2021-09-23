// Test a procedure with calling convention stack
// Returning and passing struct values
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 2
  .const STACK_BASE = $103
  .label SCREEN = $400
  .label idx = 4
.segment Code
__start: {
    // char idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
// void print(__zp(2) struct Point p)
print: {
    .const OFFSET_STACK_P = 0
    .label p = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_P,x
    sta.z p
    lda STACK_BASE+OFFSET_STACK_P+1,x
    sta.z p+1
    // SCREEN[idx++] = p.x
    lda.z p
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = p.x;
    inc.z idx
    // SCREEN[idx++] = p.y
    lda p+OFFSET_STRUCT_POINT_Y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = p.y;
    inc.z idx
    // }
    rts
}
// __zp(6) struct Point get(__register(X) char i)
get: {
    .const OFFSET_STACK_I = 0
    .const OFFSET_STACK_RETURN_0 = 0
    .label return = 6
    .label p = 8
    tsx
    lda STACK_BASE+OFFSET_STACK_I,x
    tax
    // i/2
    txa
    lsr
    // struct Point p = { i, i/2 }
    stx.z p
    sta p+OFFSET_STRUCT_POINT_Y
    // return p;
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p-1,y
    sta return-1,y
    dey
    bne !-
    // }
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    rts
}
main: {
    .label p = 2
    .label i = 5
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
    // struct Point p = get(i)
    lda.z i
    pha
    pha
    jsr get
    pla
    sta.z p
    pla
    sta.z p+1
    // print(p)
    pha
    lda.z p
    pha
    jsr print
    pla
    pla
    // for(char i=0;i<5;i++)
    inc.z i
    jmp __b1
}
