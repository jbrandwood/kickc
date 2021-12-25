// Demonstrates how to code a ROM
// The rom.ld linker file declares segments for RomCode and RomData. 
// It also declares a TestRom segment used for testing the ROM calls.This ensures that the compiler does not optimize them away.
  // ROM linking file
.file [name="rom.bin", type="bin", segments="Rom"]
.segmentdef Rom [segments="RomCode, RomData"]
.segmentdef RomCode [start=$f000]
.segmentdef RomData [startAfter="RomCode"]
.segmentdef TestRom
  .const STACK_BASE = $103
.segment TestRom
main: {
    .label ptr = $fe
    // call1(1,2)
    lda #1
    pha
    lda #2
    pha
    jsr call1
    pla
    pla
    // *ptr = call1(1,2)
    sta.z ptr
    // call1(3,4)
    lda #3
    pha
    lda #4
    pha
    jsr call1
    pla
    pla
    // *ptr = call1(3,4)
    sta.z ptr
    // call2(1,2)
    lda #2
    ldx #1
    jsr call2
    // call2(1,2)
    lda.z call2.return
    // *ptr = call2(1,2)
    sta.z ptr
    // call2(3,4)
    lda #4
    ldx #3
    jsr call2
    // call2(3,4)
    lda.z call2.return
    // *ptr = call2(3,4)
    sta.z ptr
    // call3(1,2)
    lda #2
    ldx #1
    jsr call3
    // call3(1,2)
    // *ptr = call3(1,2)
    sta.z ptr
    // call3(3,4)
    lda #4
    ldx #3
    jsr call3
    // call3(3,4)
    // *ptr = call3(3,4)
    sta.z ptr
    // }
    rts
}
.segment RomCode
// A stack based ROM function that will transfer all parameters and return values through the stack.
// __register(A) char call1(__zp(2) char param1, __register(A) char param2)
call1: {
    .const OFFSET_STACK_PARAM1 = 1
    .const OFFSET_STACK_PARAM2 = 0
    .const OFFSET_STACK_RETURN_1 = 1
    .label param1 = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_PARAM1,x
    sta.z param1
    tsx
    lda STACK_BASE+OFFSET_STACK_PARAM2,x
    // return param1+param2;
    clc
    adc.z param1
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
// A memory based ROM function that will transfer all parameters and return values through zeropage.
// __zp(2) char call2(__register(X) char param1, __register(A) char param2)
call2: {
    .label return = 2
    // param1+param2
    stx.z $ff
    clc
    adc.z $ff
    // return param1+param2;
    sta.z return
    // }
    rts
}
// A "normal" optimized ROM function that will transfer parameters and return value through registers or zeropage.
// __register(A) char call3(__register(X) char param1, __register(A) char param2)
call3: {
    // param1+param2
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
