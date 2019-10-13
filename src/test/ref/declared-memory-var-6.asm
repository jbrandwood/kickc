// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const reg_zp_flex = '.'
    .const reg_zp_abs = '.'
    .const reg_mem_flex = '.'
    .const reg_mem_abs = '.'
    .const default_default = '.'
    .const reg_default = '.'
    .const default_zp_flex = '.'
    .const default_zp_abs = '.'
    .const default_mem_flex = '.'
    .const default_mem_abs = '.'
    .label notreg_zp_flex = 2
    .label notreg_zp_abs = $10
    .label notreg_mem_abs = $1000
    .label notreg_default = 3
    lda #'.'
    sta.z notreg_zp_flex
    sta.z notreg_zp_abs
    sta notreg_mem_flex
    sta notreg_mem_abs
    sta.z notreg_default
    ldy #0
    ldx #reg_zp_flex
    jsr out
    ldx #reg_zp_abs
    jsr out
    ldx #reg_mem_flex
    jsr out
    ldx #reg_mem_abs
    jsr out
    ldx.z notreg_zp_flex
    jsr out
    ldx.z notreg_zp_abs
    jsr out
    ldx notreg_mem_flex
    jsr out
    ldx notreg_mem_abs
    jsr out
    ldx #default_default
    jsr out
    ldx #reg_default
    jsr out
    ldx.z notreg_default
    jsr out
    ldx #default_zp_flex
    jsr out
    ldx #default_zp_abs
    jsr out
    ldx #default_mem_flex
    jsr out
    ldx #default_mem_abs
    jsr out
    rts
    notreg_mem_flex: .byte 0
}
// out(byte register(X) c)
out: {
    txa
    sta SCREEN,y
    iny
    rts
}
