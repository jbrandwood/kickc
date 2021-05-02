// Tests creating and assigning pointers to non-args no-return functions - plus inline kickasm-based calling
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
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
main: {
    .label f = 2
    // void()* f
    lda #<0
    sta.z f
    sta.z f+1
    tax
  __b2:
    // ++i;
    inx
    // i&1
    txa
    and #1
    // if((i&1)==0)
    cmp #0
    beq __b3
    // f = &fn2
    lda #<fn2
    sta.z f
    lda #>fn2
    sta.z f+1
  __b4:
    // kickasm
    jsr ff
        
    jmp __b2
  __b3:
    // f = &fn1
    lda #<fn1
    sta.z f
    lda #>fn1
    sta.z f+1
    jmp __b4
}
.segment Data
// Inline KickAsm function
ff:
jmp (main.f)

