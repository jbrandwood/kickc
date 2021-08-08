// Tests calling functions pointer with no parameter and a return value
  // Commodore 64 PRG executable file
.file [name="function-pointer-return-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
.segment Code
fn2: {
    .const OFFSET_STACK_RETURN_0 = 0
    .label BG_COLOR = $d021
    // (*BG_COLOR)++;
    inc BG_COLOR
    // return *BG_COLOR;
    lda BG_COLOR
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    rts
}
fn1: {
    .const OFFSET_STACK_RETURN_0 = 0
    .label BORDER_COLOR = $d020
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // return *BORDER_COLOR;
    lda BORDER_COLOR
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    rts
}
main: {
    .label SCREEN = $400
    .label i = 2
    .label f = 3
    lda #0
    sta.z i
  __b1:
    // ++i;
    inc.z i
    // i&1
    lda #1
    and.z i
    // if((i&1)==0)
    cmp #0
    beq __b2
    lda #<fn2
    sta.z f
    lda #>fn2
    sta.z f+1
    jmp __b3
  __b2:
    lda #<fn1
    sta.z f
    lda #>fn1
    sta.z f+1
  __b3:
    // (*f)()
    pha
    jsr icall1
    // char v = (*f)()
    pla
    // SCREEN[0] = v
    sta SCREEN
    jmp __b1
  icall1:
    jmp (f)
}
