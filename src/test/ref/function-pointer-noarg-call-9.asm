// Tests calling into a function pointer which modifies global volatile
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 2
__start: {
    // idx = 0
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
