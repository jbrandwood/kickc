// Tests calling into different function pointers which call a common sub-method
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 7
bbegin:
  lda #0
  sta idx
  jsr main
  rts
main: {
    lda #<hello
    sta do10.fn
    lda #>hello
    sta do10.fn+1
    jsr do10
    lda #<world
    sta do10.fn
    lda #>world
    sta do10.fn+1
    jsr do10
    rts
}
// do10(void()* zeropage(2) fn)
do10: {
    .label i = 4
    .label fn = 2
    lda #0
    sta i
  b1:
    jsr bi_fn
    inc i
    lda #$a
    cmp i
    bne b1
    rts
  bi_fn:
    jmp (fn)
}
world: {
    lda #<msg
    sta print.msg
    lda #>msg
    sta print.msg+1
    jsr print
    rts
    msg: .text "world "
    .byte 0
}
// print(byte* zeropage(5) msg)
print: {
    .label msg = 5
    ldy #0
  b1:
    lda (msg),y
    ldx idx
    sta SCREEN,x
    inc idx
    iny
    lda (msg),y
    cmp #'@'
    bne b1
    rts
}
hello: {
    lda #<msg
    sta print.msg
    lda #>msg
    sta print.msg+1
    jsr print
    rts
    msg: .text "hello "
    .byte 0
}
