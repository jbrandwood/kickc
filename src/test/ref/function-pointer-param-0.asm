// Test function pointers with parameters
// Currently the parameter is not transferred properly
  // Commodore 64 PRG executable file
.file [name="function-pointer-param-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
  .label SCREEN = $400
.segment Code
// fn3(byte register(A) e)
fn3: {
    .const OFFSET_STACK_E = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_E,x
    // SCREEN[e] = 'c'
    tay
    lda #'c'
    sta SCREEN,y
    // }
    rts
}
// fn2(byte register(A) d)
fn2: {
    .const OFFSET_STACK_D = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_D,x
    // SCREEN[d] = 'b'
    tay
    lda #'b'
    sta SCREEN,y
    // }
    rts
}
// fn1(byte register(A) c)
fn1: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    // SCREEN[c] = 'a'
    tay
    lda #'a'
    sta SCREEN,y
    // }
    rts
}
main: {
    .label i = 2
    // A pointer to a function taking a single char param
    .label f = 3
    lda #0
    sta.z i
  __b1:
    // for(char i=0;i<160;i++)
    lda.z i
    cmp #$a0
    bcc __b2
    // }
    rts
  __b2:
    // i&1
    lda #1
    and.z i
    // if((i&1)==0)
    cmp #0
    bne __b3
    // fn3(i)
    lda.z i
    pha
    jsr fn3
    pla
  __b4:
    // for(char i=0;i<160;i++)
    inc.z i
    jmp __b1
  __b3:
    // i&3
    lda #3
    and.z i
    // if((i&3)==1)
    cmp #1
    beq __b5
    lda #<fn2
    sta.z f
    lda #>fn2
    sta.z f+1
    jmp __b6
  __b5:
    lda #<fn1
    sta.z f
    lda #>fn1
    sta.z f+1
  __b6:
    // (*f)(i)
    lda.z i
    pha
    jsr icall2
    pla
    jmp __b4
  icall2:
    jmp (f)
}
