// Test some forced zeropage access
  // Commodore 64 PRG executable file
.file [name="forced-zeropage.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label __1 = 4
    .label u = 2
    // u = *(word *)0xA0 - u
    sec
    lda.z $a0
    sbc #<$22b
    sta.z u
    lda.z $a0+1
    sbc #>$22b
    sta.z u+1
    // *((word*)0x0400) = u
    lda.z u
    sta $400
    lda.z u+1
    sta $400+1
    // *(byte **)0xD1 + 0xD400
    clc
    lda.z $d1
    adc #<$d400
    sta.z __1
    lda.z $d1+1
    adc #>$d400
    sta.z __1+1
    // *(byte **)0xF3 = *(byte **)0xD1 + 0xD400
    lda.z __1
    sta.z $f3
    lda.z __1+1
    sta.z $f3+1
    // }
    rts
}
