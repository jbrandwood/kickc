// https://gitlab.com/camelot/kickc/-/issues/587
// Creating variable instances of structs with array members fails to compile
  // Commodore 64 PRG executable file
.file [name="struct-46.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_OTHER = 2
  .const SIZEOF_STRUCT_NETCONFIG = $60
  .label OUT = $8000
.segment Code
main: {
    // Other x
    ldy #SIZEOF_STRUCT_OTHER
    lda #0
  !:
    dey
    sta x,y
    bne !-
    // NetConfig a = {"123", "abc"}
    ldy #SIZEOF_STRUCT_NETCONFIG
  !:
    lda __0-1,y
    sta a-1,y
    dey
    bne !-
    // *(OUT + 0) = a.ssid[0]
    lda a
    sta OUT
    // NetConfig b
    ldy #SIZEOF_STRUCT_NETCONFIG
    lda #0
  !:
    dey
    sta b,y
    bne !-
    // }
    rts
  .segment Data
    x: .fill SIZEOF_STRUCT_OTHER, 0
    a: .fill SIZEOF_STRUCT_NETCONFIG, 0
    b: .fill SIZEOF_STRUCT_NETCONFIG, 0
}
  __0: .text "123"
  .byte 0
  .fill $1c, 0
  .text "abc"
  .byte 0
  .fill $3c, 0
