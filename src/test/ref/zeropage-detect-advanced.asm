// Illustrates a problem where absolute addressing is used for zeropage-access
// This is caused by the compiler believing the pointer is into memory" (not knowing the upper part is 0x00 )
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label c = t
    .label t = 2
    lda #<0
    sta.z t
    sta.z t+1
    lda #<0>>$10
    sta.z t+2
    lda #>0>>$10
    sta.z t+3
    lda.z c
    sta $400
    rts
}
