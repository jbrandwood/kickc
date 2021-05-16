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
  .const STACK_BASE = $103
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
  .label idx = 3
.segment Code
__start: {
    // char idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
// print(byte register(Y) p_x, byte register(X) p_y)
print: {
    .const OFFSET_STACK_P_X = 1
    .const OFFSET_STACK_P_Y = 0
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
get: {
    .const OFFSET_STACK_I = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_I,x
    tax
    // i/2
    txa
    lsr
    tay
    // }
    txa
    tsx
    sta STACK_BASE+0,x
    tya
    tsx
    sta STACK_BASE+OFFSET_STRUCT_POINT_Y,x
    rts
}
main: {
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
    jsr get
    // struct Point p = get(i)
    pla
    tay
    pla
    tax
    // print(p)
    tya
    pha
    txa
    pha
    jsr print
    pla
    pla
    // for(char i=0;i<5;i++)
    inc.z i
    jmp __b1
}
