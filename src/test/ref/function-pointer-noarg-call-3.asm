// Tests creating, assigning returning and calling pointers to non-args no-return functions
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-3.prg", type="prg", segments="Program"]
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
    .label __0 = 2
    .label i = 4
    lda #0
    sta.z i
  __b2:
    // (*getfn(++i))();
    inc.z i
    // getfn(++i)
    lda.z i
    jsr getfn
    // (*getfn(++i))()
    jsr icall1
    jmp __b2
  icall1:
    jmp (__0)
}
// declare getfn as function (char b) returning pointer to function (void) returning void
// __zp(2) void (*)() getfn(__register(A) char b)
getfn: {
    .label return = 2
    // b&1
    and #1
    // if((b&1)==0)
    cmp #0
    beq __b1
    lda #<fn2
    sta.z return
    lda #>fn2
    sta.z return+1
    rts
  __b1:
    lda #<fn1
    sta.z return
    lda #>fn1
    sta.z return+1
    // }
    rts
}
