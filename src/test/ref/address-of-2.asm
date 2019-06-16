// Test address-of by assigning the affected variable in multiple ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label val = 2
main: {
    .label SCREEN1 = $400
    .label ptr = val
    .label SCREEN2 = SCREEN1+$28
    lda #0
    sta SCREEN1
    lda #'.'
    sta SCREEN2
    // Here we have not yet used address-of - so val can be versioned freely
    lda #1
    sta val
    sta SCREEN1+1
    lda #'.'
    sta SCREEN2+1
    lda #2
    sta SCREEN1+2
    lda ptr
    sta SCREEN2+2
    // Set value through pointer
    lda #3
    sta ptr
    lda #2
    sta SCREEN1+3
    lda ptr
    sta SCREEN2+3
    jsr setv
    lda #setv.v
    sta SCREEN1+4
    lda ptr
    sta SCREEN2+4
    jsr setp
    lda #setv.v
    sta SCREEN1+5
    lda ptr
    sta SCREEN2+5
    rts
}
setp: {
    .const v = 5
    lda #v
    sta main.ptr
    rts
}
setv: {
    .label v = 4
    rts
}
