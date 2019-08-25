// Tests the target platform C64BASIC_SEGMENTS
.file  [ name="platform-c64basic_segments.prg",type="prg",segments="Program" ]
.segmentdef Program [ segments="Basic,Code,Data" ]
.segmentdef Basic [ start=$0801 ]
.segmentdef Code [ start=$80d ]
.segmentdef Data [ startAfter="Code" ]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    ldx #0
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    txa
    sta TABLE,x
    inx
    jmp b1
}
.segment Data
  TABLE: .fill $a, 0
