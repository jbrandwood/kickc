// Reference file for Minimal struct -  using address-of
  // Commodore 64 PRG executable file
.file [name="struct-ptr-12-ref.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label q = p
    .label p = 2
    // p = { 2, 3 }
    lda #<2*$100+3
    sta.z p
    lda #>2*$100+3
    sta.z p+1
    // <*q
    lda.z q
    // SCREEN[0] = <*q
    sta SCREEN
    // >*q
    lda.z q+1
    // SCREEN[1] = >*q
    sta SCREEN+1
    // }
    rts
}
