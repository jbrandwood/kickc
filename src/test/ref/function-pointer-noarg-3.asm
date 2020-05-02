// Tests creating and assigning pointers to non-args no-return functions - plus inline kickasm-based calling
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // kickasm
  ff:
    jmp (main.f)

main: {
    .label f = 2
    ldx #0
  __b2:
    // ++i;
    inx
    // i&1
    txa
    and #1
    // if((i&1)==0)
    cmp #0
    beq __b3
    lda #<fn2
    sta.z f
    lda #>fn2
    sta.z f+1
    jmp __b4
  __b3:
    lda #<fn1
    sta.z f
    lda #>fn1
    sta.z f+1
  __b4:
    // kickasm
    jsr ff
        
    jmp __b2
}
fn2: {
    .label BG_COLOR = $d021
    // (*BG_COLOR)++;
    inc BG_COLOR
    // }
    rts
}
fn1: {
    .label BORDER_COLOR = $d020
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // }
    rts
}
