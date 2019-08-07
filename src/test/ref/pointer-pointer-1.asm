// Tests a simple pointer to a pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label ppb = pb
    .label b = 2
    .label pb = 3
    lda #'a'
    sta.z b
    lda #<b
    sta.z pb
    lda #>b
    sta.z pb+1
    ldy #0
    lda (ppb),y
    sta SCREEN
    rts
}
