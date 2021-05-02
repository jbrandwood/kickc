// Tests creating a long (32bit) pointer on zeropage for 45GS02 flat memory access
  // Commodore 64 PRG executable file
.file [name="long-pointer-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const long_ptr_zp = long_ptr
    .label long_ptr = 2
    // __zp unsigned long long_ptr = 0x12345678
    lda #<$12345678
    sta.z long_ptr
    lda #>$12345678
    sta.z long_ptr+1
    lda #<$12345678>>$10
    sta.z long_ptr+2
    lda #>$12345678>>$10
    sta.z long_ptr+3
    // asm
    nop
    lda (long_ptr_zp),y
    sta.z $ff
    // }
    rts
}
