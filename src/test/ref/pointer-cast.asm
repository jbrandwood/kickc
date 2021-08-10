// Tests casting pointer types to other pointer types
  // Commodore 64 PRG executable file
.file [name="pointer-cast.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
  .const SIZEOF_INT = 2
  .const ub = $29
  .const sb = -$29
  .const uw = $3000
  .const sw = -$3000
  .label ub_screen = $400
  .label sb_screen = $428
  .label uw_screen = $450
  .label sw_screen = $478
.segment Code
main: {
    // *((byte*)ub_screen) = ub
    lda #ub
    sta ub_screen
    // *((signed byte*)ub_screen+1) = sb
    lda #sb
    sta ub_screen+1
    // *((word*)ub_screen+1)= uw
    lda #<uw
    sta ub_screen+1*SIZEOF_UNSIGNED_INT
    lda #>uw
    sta ub_screen+1*SIZEOF_UNSIGNED_INT+1
    // *((signed word*)ub_screen+2) = sw
    lda #<sw
    sta ub_screen+2*SIZEOF_INT
    lda #>sw
    sta ub_screen+2*SIZEOF_INT+1
    // *((byte*)sb_screen) = ub
    lda #ub
    sta sb_screen
    // *((signed byte*)sb_screen+1) = sb
    lda #sb
    sta sb_screen+1
    // *((word*)sb_screen+1)= uw
    lda #<uw
    sta sb_screen+1*SIZEOF_UNSIGNED_INT
    lda #>uw
    sta sb_screen+1*SIZEOF_UNSIGNED_INT+1
    // *((signed word*)sb_screen+2) = sw
    lda #<sw
    sta sb_screen+2*SIZEOF_INT
    lda #>sw
    sta sb_screen+2*SIZEOF_INT+1
    // *((byte*)uw_screen) = ub
    lda #ub
    sta uw_screen
    // *((signed byte*)uw_screen+1) = sb
    lda #sb
    sta uw_screen+1
    // *((word*)uw_screen+1)= uw
    lda #<uw
    sta uw_screen+1*SIZEOF_UNSIGNED_INT
    lda #>uw
    sta uw_screen+1*SIZEOF_UNSIGNED_INT+1
    // *((signed word*)uw_screen+2) = sw
    lda #<sw
    sta uw_screen+2*SIZEOF_INT
    lda #>sw
    sta uw_screen+2*SIZEOF_INT+1
    // *((byte*)sw_screen) = ub
    lda #ub
    sta sw_screen
    // *((signed byte*)sw_screen+1) = sb
    lda #sb
    sta sw_screen+1
    // *((word*)sw_screen+1)= uw
    lda #<uw
    sta sw_screen+1*SIZEOF_UNSIGNED_INT
    lda #>uw
    sta sw_screen+1*SIZEOF_UNSIGNED_INT+1
    // *((signed word*)sw_screen+2) = sw
    lda #<sw
    sta sw_screen+2*SIZEOF_INT
    lda #>sw
    sta sw_screen+2*SIZEOF_INT+1
    // }
    rts
}
