// Test a procedure with calling convention stack
// A slightly more complex call
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const STACK_BASE = $103
  .label SCREEN = $400
  .label i = 3
.segment Code
__start: {
    // char i = 0
    lda #0
    sta.z i
    jsr main
    rts
}
// plus(byte zp(4) a, byte register(A) b)
plus: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_1 = 1
    .label a = 4
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // i++;
    inc.z i
    // return a+b;
    clc
    adc.z a
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
main: {
    .label a = 2
    lda #0
    sta.z a
  __b1:
    // char v = a+1
    ldx.z a
    inx
    // char w = plus('0', v)
    lda #'0'
    pha
    txa
    pha
    jsr plus
    pla
    pla
    // w+a
    clc
    adc.z a
    // SCREEN[i] = w+a
    ldy.z i
    sta SCREEN,y
    // for(char a:0..1)
    inc.z a
    lda #2
    cmp.z a
    bne __b1
    // }
    rts
}
