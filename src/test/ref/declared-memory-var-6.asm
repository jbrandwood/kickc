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
    ldx #0
    lda #reg_zp_flex
    jsr out
    lda #reg_zp_abs
    jsr out
    lda #reg_mem_flex
    jsr out
    lda #reg_mem_abs
    jsr out
    lda #default_default
    jsr out
    lda #reg_default
    jsr out
    lda #default_zp_flex
    jsr out
    lda #default_zp_abs
    jsr out
    lda #default_mem_flex
    jsr out
    lda #default_mem_abs
    jsr out
    rts
}
// out(byte register(A) c)
out: {
    sta SCREEN,x
    inx
    rts
}
