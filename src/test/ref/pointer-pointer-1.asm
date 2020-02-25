// Tests a simple pointer to a pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label ppb = pb
    .label b = 2
    .label pb = 3
    // b = 'a'
    lda #'a'
    sta.z b
    // pb = &b
    lda #<b
    sta.z pb
    lda #>b
    sta.z pb+1
    // *SCREEN = **ppb
    ldy.z ppb
    sty.z $fe
    ldy.z ppb+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    sta SCREEN
    // }
    rts
}
