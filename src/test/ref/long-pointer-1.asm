// Tests creating a long (32bit) pointer on zeropage for 45GS02 flat memory access
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const long_ptr_zp = long_ptr
    .label long_ptr = 2
    lda #<$12345678
    sta.z long_ptr
    lda #>$12345678
    sta.z long_ptr+1
    lda #<$12345678>>$10
    sta.z long_ptr+2
    lda #>$12345678>>$10
    sta.z long_ptr+3
    nop
    lda (long_ptr_zp),y
    sta.z $ff
    rts
}
