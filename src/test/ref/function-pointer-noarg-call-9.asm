// Tests calling into a function pointer which modifies global volatile
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = 2
.segment Code
__start: {
    // volatile byte idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
fn1: {
    // idx++;
    inc.z idx
    // }
    rts
}
main: {
    // (*f)()
    jsr fn1
    // SCREEN[idx] = 'a'
    lda #'a'
    ldy.z idx
    sta SCREEN,y
    // (*f)()
    jsr fn1
    // SCREEN[idx] = 'a'
    lda #'a'
    ldy.z idx
    sta SCREEN,y
    // }
    rts
}
