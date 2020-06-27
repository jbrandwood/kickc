// Test address-of by assigning the affected variable in multiple ways
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label val = 2
_start: {
    // val = 0
    lda #0
    sta.z val
    jsr main
    rts
}
main: {
    .label SCREEN1 = $400
    .label SCREEN2 = SCREEN1+$28
    // Use address-of - hereafter all versions of val must be in the same memory
    // Use address-of - hereafter all versions of val must be in the same memory
    .label ptr = val
    // SCREEN1[idx] = val
    lda.z val
    sta SCREEN1
    // SCREEN2[idx++] = '.'
    lda #'.'
    sta SCREEN2
    // val = 1
    // Here we have not yet used address-of - so val can be versioned freely
    lda #1
    sta.z val
    // SCREEN1[idx] = val
    sta SCREEN1+1
    // SCREEN2[idx++] = '.'
    lda #'.'
    sta SCREEN2+1
    // val = 2
    // Set value directly
    lda #2
    sta.z val
    // SCREEN1[idx] = val
    sta SCREEN1+2
    // SCREEN2[idx++] = *ptr
    lda.z ptr
    sta SCREEN2+2
    // *ptr = 3
    // Set value through pointer
    lda #3
    sta.z ptr
    // SCREEN1[idx] = val
    lda.z val
    sta SCREEN1+3
    // SCREEN2[idx++] = *ptr
    lda.z ptr
    sta SCREEN2+3
    // setv(4)
    // Set value directly in a call
    jsr setv
    // SCREEN1[idx] = val
    lda.z val
    sta SCREEN1+4
    // SCREEN2[idx++] = *ptr
    lda.z ptr
    sta SCREEN2+4
    // setp(ptr, 5)
    // Set value through pointer in a call
    jsr setp
    // SCREEN1[idx] = val
    lda.z val
    sta SCREEN1+5
    // SCREEN2[idx++] = *ptr
    lda.z ptr
    sta SCREEN2+5
    // }
    rts
}
setp: {
    .const v = 5
    // *p = v
    lda #v
    sta.z main.ptr
    // }
    rts
}
setv: {
    .const v = 4
    // val = v
    lda #v
    sta.z val
    // }
    rts
}
