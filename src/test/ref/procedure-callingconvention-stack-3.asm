// Test a procedure with calling convention stack
// Test casting of parameter types
// Currently fails because the pushed are done based on the actual value instead of the declared parameter type
// https://gitlab.com/camelot/kickc/issues/319
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
  .label SCREEN = $400
.segment Code
// __zp(2) unsigned int plus(__zp(2) unsigned int a, __zp(4) unsigned int b)
plus: {
    .const OFFSET_STACK_A = 2
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_2 = 2
    .label a = 2
    .label b = 4
    .label return = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    lda STACK_BASE+OFFSET_STACK_A+1,x
    sta.z a+1
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    sta.z b
    lda STACK_BASE+OFFSET_STACK_B+1,x
    sta.z b+1
    // return a+b;
    clc
    lda.z return
    adc.z b
    sta.z return
    lda.z return+1
    adc.z b+1
    sta.z return+1
    // }
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN_2,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_2+1,x
    rts
}
main: {
    .label __0 = 2
    // plus('0', 7)
    lda #0
    pha
    lda #<'0'
    pha
    lda #0
    pha
    lda #<7
    pha
    jsr plus
    pla
    pla
    pla
    sta.z __0
    pla
    sta.z __0+1
    // SCREEN[0] = plus('0', 7)
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    // }
    rts
}
