// Tests a cast that is not needed
  // Commodore 64 PRG executable file
.file [name="cast-not-needed.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label sprite = $5000
  .label SCREEN = $4400
.segment Code
main: {
    .label sprite_ptr = SCREEN+$378
    // sprite_ptr[0] = (byte)(sprite/$40)
    lda #$ff&sprite/$40
    sta sprite_ptr
    // }
    rts
}
