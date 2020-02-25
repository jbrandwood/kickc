// Tests creating, assigning returning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label __1 = 3
    .label i = 2
    lda #0
    sta.z i
  __b2:
    // (*getfn(++i))();
    inc.z i
    // getfn(++i)
    lda.z i
    jsr getfn
    // (*getfn(++i))()
    jsr bi___1
    jmp __b2
  bi___1:
    jmp (__1)
}
// getfn(byte register(A) b)
getfn: {
    .label return = 3
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
fn2: {
    .label BGCOL = $d021
    // (*BGCOL)++;
    inc BGCOL
    // }
    rts
}
fn1: {
    .label BORDERCOL = $d020
    // (*BORDERCOL)++;
    inc BORDERCOL
    // }
    rts
}
