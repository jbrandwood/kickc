// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
  // Commodore 64 PRG executable file
.file [name="declared-memory-var-6.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const reg_zp_flex = '.'
    .const reg_mem_flex = '.'
    .const default_default = '.'
    .const reg_default = '.'
    .const default_zp_flex = '.'
    .const default_mem_flex = '.'
    .label default_zp_abs = $11
    .label default_mem_abs = $1001
    .label reg_zp_abs = $10
    .label reg_mem_abs = $1000
    // reg_zp_abs = '.'
    lda #'.'
    sta.z reg_zp_abs
    // reg_mem_abs = '.'
    sta reg_mem_abs
    // default_zp_abs = '.'
    sta.z default_zp_abs
    // default_mem_abs = '.'
    sta default_mem_abs
    // out(reg_zp_flex)
    ldy #0
    ldx #reg_zp_flex
    jsr out
    // out(reg_zp_abs)
    ldx.z reg_zp_abs
    jsr out
    // out(reg_mem_flex)
    ldx #reg_mem_flex
    jsr out
    // out(reg_mem_abs)
    ldx reg_mem_abs
    jsr out
    // out(default_default)
    ldx #default_default
    jsr out
    // out(reg_default)
    ldx #reg_default
    jsr out
    // out(default_zp_flex)
    ldx #default_zp_flex
    jsr out
    // out(default_zp_abs)
    ldx.z default_zp_abs
    jsr out
    // out(default_mem_flex)
    ldx #default_mem_flex
    jsr out
    // out(default_mem_abs)
    ldx default_mem_abs
    jsr out
    // }
    rts
}
// out(byte register(X) c)
out: {
    // SCREEN[i++] = c
    txa
    sta SCREEN,y
    // SCREEN[i++] = c;
    iny
    // }
    rts
}
