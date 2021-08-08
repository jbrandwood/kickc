// Tests creating, assigning and calling pointers to non-args no-return functions
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-2.prg", type="prg", segments="Program"]
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
    .label i = 2
    .label f = 3
    lda #0
    sta.z i
  __b2:
    // ++i;
    inc.z i
    // i&1
    lda #1
    and.z i
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
    // (*f)()
    jsr icall1
    jmp __b2
  icall1:
    jmp (f)
}
