// Test a procedure with calling convention stack - and enough parameters to use fast ASM for cleaning stack
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
  .label SCREEN = $400
.segment Code
// plus(word zp(4) a, word zp(2) b)
plus: {
    .const OFFSET_STACK_A = 2
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN = 2
    .label a = 4
    .label b = 2
    .label return = 4
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
    lda.z return
    clc
    adc.z b
    sta.z return
    lda.z return+1
    adc.z b+1
    sta.z return+1
    // }
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN+1,x
    rts
}
main: {
    .label __0 = 4
    // plus(0x1234, 0x2345)
    lda #>$1234
    pha
    lda #<$1234
    pha
    lda #>$2345
    pha
    lda #<$2345
    pha
    jsr plus
    pla
    pla
    pla
    sta.z __0
    pla
    sta.z __0+1
    // SCREEN[0] = plus(0x1234, 0x2345)
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    // }
    rts
}
