// Tests a sub-optimal fragment synthesis
// vbuaa=vbuxx_band_pbuz1_derefidx_vbuc1 < vbuaa=pbuz1_derefidx_vbuc1_band_vbuxx < vbuaa=pbuz1_derefidx_vbuaa_band_vbuxx < vbuaa=pbuz1_derefidx_vbuyy_band_vbuxx < vbuaa=pbuz1_derefidx_vbuyy_band_vbuaa < vbuaa=vbuaa_band_pbuz1_derefidx_vbuyy - clobber:A Y  cycles:11.5
  // Commodore 64 PRG executable file
.file [name="fragment-synth.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // z[2] = $f0
    lda #$f0
    sta $450+2
    // z[3] = $0f
    lda #$f
    sta $450+3
    // fct(x, z)
    lda #<$450
    sta.z fct.z
    lda #>$450
    sta.z fct.z+1
    ldx #$aa
    jsr fct
    // fct(x, z)
    // byte a1 = fct(x, z)
    // screen[0] = a1
    sta screen
    // fct(x, z)
    lda #<$450+1
    sta.z fct.z
    lda #>$450+1
    sta.z fct.z+1
    ldx #$55
    jsr fct
    // fct(x, z)
    // byte a2 = fct(x, z)
    // screen[1] = a2
    sta screen+1
    // }
    rts
}
// fct(byte register(X) x, byte* zp(2) z)
fct: {
    .label z = 2
    // x & z[2]
    ldy #2
    txa
    and (z),y
    // }
    rts
}
