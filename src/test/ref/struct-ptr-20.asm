// Demonstrates problem with conditions using negated struct references
  // Commodore 64 PRG executable file
.file [name="struct-ptr-20.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_SETTING = 2
  .const OFFSET_STRUCT_SETTING_ID = 1
  .label SCREEN = $400
.segment Code
main: {
    .const len = 3*SIZEOF_STRUCT_SETTING/SIZEOF_STRUCT_SETTING
    .label setting = 2
    ldx #0
    lda #<settings
    sta.z setting
    lda #>settings
    sta.z setting+1
  __b1:
    // for(struct Setting* setting = settings; setting<settings+len; setting++)
    lda.z setting+1
    cmp #>settings+len*SIZEOF_STRUCT_SETTING
    bcc __b2
    bne !+
    lda.z setting
    cmp #<settings+len*SIZEOF_STRUCT_SETTING
    bcc __b2
  !:
    // }
    rts
  __b2:
    // if (! setting->off)
    ldy #0
    lda (setting),y
    cmp #0
    bne __b3
    // SCREEN[idx++] = setting->id
    ldy #OFFSET_STRUCT_SETTING_ID
    lda (setting),y
    sta SCREEN,x
    // SCREEN[idx++] = setting->id;
    inx
  __b3:
    // for(struct Setting* setting = settings; setting<settings+len; setting++)
    lda #SIZEOF_STRUCT_SETTING
    clc
    adc.z setting
    sta.z setting
    bcc !+
    inc.z setting+1
  !:
    jmp __b1
}
.segment Data
  settings: .byte 0, 'a', 1, 'b', 0, 'c'
