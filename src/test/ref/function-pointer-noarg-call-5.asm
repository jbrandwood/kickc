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
    .label i = 4
    .label f = 2
    lda #0
    sta.z i
  __b2:
    // void (*f)() = fns[++i&1]
    inc.z i
    // ++i&1
    lda #1
    and.z i
    // void (*f)() = fns[++i&1]
    asl
    tay
    lda fns,y
    sta.z f
    lda fns+1,y
    sta.z f+1
    // (*f)()
    jsr icall1
    jmp __b2
  icall1:
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
  // declare fns as array 2 of pointer to function (void) returning void
  fns: .word fn1, fn2
