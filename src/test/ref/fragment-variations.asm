// Tests that ASM fragment variations works
// ASM fragment variations "cast" constants to different types
  // Commodore 64 PRG executable file
.file [name="fragment-variations.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_DWORD = 4
.segment Code
main: {
    .label screen = $400
    .label __0 = 6
    .label __1 = 6
    // mul16u(w, w)
    lda #<$a
    sta.z mul16u.a
    lda #>$a
    sta.z mul16u.a+1
    lda #<$a
    sta.z mul16u.b
    lda #>$a
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u(w, w)
    // screen[0] = mul16u(w, w)
    lda.z __0
    sta screen
    lda.z __0+1
    sta screen+1
    lda.z __0+2
    sta screen+2
    lda.z __0+3
    sta screen+3
    // mul16u(w, w)
    lda #<$3e8
    sta.z mul16u.a
    lda #>$3e8
    sta.z mul16u.a+1
    lda #<$3e8
    sta.z mul16u.b
    lda #>$3e8
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u(w, w)
    // screen[1] = mul16u(w, w)
    lda.z __1
    sta screen+1*SIZEOF_DWORD
    lda.z __1+1
    sta screen+1*SIZEOF_DWORD+1
    lda.z __1+2
    sta screen+1*SIZEOF_DWORD+2
    lda.z __1+3
    sta screen+1*SIZEOF_DWORD+3
    // }
    rts
}
// mul16u(word zp(2) b, word zp(4) a)
mul16u: {
    .label return = 6
    .label mb = 6
    .label b = 2
    .label a = 4
    // mb = b
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    // mb+a
    lda.z return
    clc
    adc.z a
    sta.z return
    lda.z return+1
    adc.z a+1
    sta.z return+1
    lda.z return+2
    adc #0
    sta.z return+2
    lda.z return+3
    adc #0
    sta.z return+3
    // }
    rts
}
