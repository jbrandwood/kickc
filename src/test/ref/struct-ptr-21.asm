// Demonstrates problem with conditions using negated struct references
  // Commodore 64 PRG executable file
.file [name="struct-ptr-21.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_SETTING_BUF = 1
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // for( char i=0;i<setting->len;i++)
    cpx settings
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = setting->buf[i]
    txa
    asl
    tay
    lda settings+OFFSET_STRUCT_SETTING_BUF
    sta.z $fe
    lda settings+OFFSET_STRUCT_SETTING_BUF+1
    sta.z $ff
    lda ($fe),y
    sta SCREEN,y
    iny
    lda ($fe),y
    sta SCREEN,y
    // for( char i=0;i<setting->len;i++)
    inx
    jmp __b1
}
.segment Data
  seq: .word 1, 2, 3
  settings: .byte 3
  .word seq
