// Tests calling into arrays of pointers to non-args no-return functions
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label i = 2
    .label f = 3
    lda #0
    sta.z i
  __b2:
    // f = fns[++i&1]
    inc.z i
    // ++i&1
    lda #1
    and.z i
    // f = fns[++i&1]
    asl
    tay
    lda fns,y
    sta.z f
    lda fns+1,y
    sta.z f+1
    // (*f)()
    jsr bi_f
    jmp __b2
  bi_f:
    jmp (f)
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
.segment Data
  fns: .word fn1, fn2
