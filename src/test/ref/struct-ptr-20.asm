// Demonstrates problem with conditions using negated struct references
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_SETTING = 2
  .const OFFSET_STRUCT_SETTING_ID = 1
  .label SCREEN = $400
main: {
    .const len = 3*SIZEOF_STRUCT_SETTING/SIZEOF_STRUCT_SETTING
    .label setting = 2
    ldx #0
    lda #<settings
    sta.z setting
    lda #>settings
    sta.z setting+1
  b1:
    lda.z setting+1
    cmp #>settings+len*SIZEOF_STRUCT_SETTING
    bcc b2
    bne !+
    lda.z setting
    cmp #<settings+len*SIZEOF_STRUCT_SETTING
    bcc b2
  !:
    rts
  b2:
    ldy #0
    lda (setting),y
    cmp #0
    bne b3
    ldy #OFFSET_STRUCT_SETTING_ID
    lda (setting),y
    sta SCREEN,x
    inx
  b3:
    lda #SIZEOF_STRUCT_SETTING
    clc
    adc.z setting
    sta.z setting
    bcc !+
    inc.z setting+1
  !:
    jmp b1
}
settings:
  .byte 0, 'a'
  .byte 1, 'b'
  .byte 0, 'c'
