// The linker specification of the different segments.
.cpu _65c02
  .segmentdef Program                 [segments="Basic, Code, Data, Bank1, Bank2"]
.segmentdef Basic                   [start=$0801]a
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Bank1                   [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef Bank2                   [start=$C000, min=$C000, max=$FFFF, align=$100]


  // The target computer platform is the Commander X16,
  // which implements banking in ram between 0xA0000 and 0xBFFF,
  // and in rom between 0xC000 and 0xFFFF.
  .label SCREEN = $400
.segment Code
// Practically this means that the main() function is placed in main memory ...
main: {
    // func_ram_bank1_a('0', 7)
    lda #7
    ldx #'0'
    jsr $ff6e
    .byte <func_ram_bank1_a
    .byte >func_ram_bank1_a
    .byte 1
    // func_ram_bank1_a('0', 7)
    // SCREEN[0] = func_ram_bank1_a('0', 7)
    sta SCREEN
    // func_ram_bank1_b('0', 7)
    jsr func_ram_bank1_b
    // SCREEN[0] = func_ram_bank1_b('0', 7)
    // Banked call to ram in bank 1 from main memory.
    lda #func_ram_bank1_b.return
    sta SCREEN
    // func_ram_bank1_c('0', 7)
    jsr $ff6e
    .byte <func_ram_bank1_c
    .byte >func_ram_bank1_c
    .byte 1
    // func_ram_bank1_c('0', 7)
    // SCREEN[0] = func_ram_bank1_c('0', 7)
    // Banked call to ram in bank 1 from main memory.
    sta SCREEN
    // func_ram_bank1_d('0', 7)
    jsr $ff6e
    .byte <func_ram_bank1_d
    .byte >func_ram_bank1_d
    .byte 1
    // func_ram_bank1_d('0', 7)
    // SCREEN[0] = func_ram_bank1_d('0', 7)
    // Banked call to ram in bank 1 from main memory.
    sta SCREEN
    // func_ram_bank1_e('0', 7)
    ldx #7
    lda #'0'
    jsr $ff6e
    .byte <func_ram_bank1_e
    .byte >func_ram_bank1_e
    .byte 1
    // func_ram_bank1_e('0', 7)
    // SCREEN[0] = func_ram_bank1_e('0', 7)
    // Banked call to ram in bank 1 from main memory.
    sta SCREEN
    // func_ram_bank1_f('0', 7)
    jsr $ff6e
    .byte <func_ram_bank1_f
    .byte >func_ram_bank1_f
    .byte 1
    // func_ram_bank1_f('0', 7)
    // SCREEN[0] = func_ram_bank1_f('0', 7)
    // Banked call to ram in bank 1 from main memory.
    sta SCREEN
    // func_rom_bank2_a('0', 7)
    lda #7
    ldx #'0'
    jsr $ff6e
    .byte <func_rom_bank2_a
    .byte >func_rom_bank2_a
    .byte 2
    // func_rom_bank2_a('0', 7)
    // SCREEN[0] = func_rom_bank2_a('0', 7)
    // Banked call to ram in bank 1 from main memory.
    sta SCREEN
    // func_rom_bank2_b('0', 7)
    ldx #7
    lda #'0'
    jsr func_rom_bank2_b
    // func_rom_bank2_b('0', 7)
    // SCREEN[0] = func_rom_bank2_b('0', 7)
    // Banked call to rom in bank 2 from main memory.
    sta SCREEN
    // func_rom_bank2_c('0', 7)
    jsr $ff6e
    .byte <func_rom_bank2_c
    .byte >func_rom_bank2_c
    .byte 2
    // func_rom_bank2_c('0', 7)
    // SCREEN[0] = func_rom_bank2_c('0', 7)
    // Banked call to rom in bank 2 from main memory.
    sta SCREEN
    // func_rom_bank2_d('0', 7)
    jsr $ff6e
    .byte <func_rom_bank2_d
    .byte >func_rom_bank2_d
    .byte 2
    // func_rom_bank2_d('0', 7)
    // SCREEN[0] = func_rom_bank2_d('0', 7)
    // Banked call to rom in bank 2 from main memory.
    sta SCREEN
    // func_rom_bank2_e('0', 7)
    ldx #7
    lda #'0'
    jsr $ff6e
    .byte <func_rom_bank2_e
    .byte >func_rom_bank2_e
    .byte 2
    // func_rom_bank2_e('0', 7)
    // SCREEN[0] = func_rom_bank2_e('0', 7)
    // Banked call to rom in bank 2 from main memory.
    sta SCREEN
    // func_rom_bank2_f('0', 7)
    jsr $ff6e
    .byte <func_rom_bank2_f
    .byte >func_rom_bank2_f
    .byte 2
    // func_rom_bank2_f('0', 7)
    // SCREEN[0] = func_rom_bank2_f('0', 7)
    // banked call to rom in bank 2 from main memory.
    sta SCREEN
    // func_main_a('0', 7)
    ldx #7
    lda #'0'
    jsr func_main_a
    // func_main_a('0', 7)
    // SCREEN[0] = func_main_a('0', 7)
    // banked call to rom in bank 2 from main memory.
    sta SCREEN
    // func_main_b('0', 7)
    jsr func_main_b
    // func_main_b('0', 7)
    // SCREEN[0] = func_main_b('0', 7)
    // Near call in main memory from main memory.
    sta SCREEN
    // }
    rts
}
.segment Bank1
// Functional code
// __register(A) char func_ram_bank1_a(__register(X) char a, __register(A) char b)
func_ram_bank1_a: {
    // a + b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
.segment Bank2
// The sequent functions will consider no banking calculations anymore.
// The __bank directive declares this function to be banked using call method ram in bank number 1 of banked ram.
// char func_ram_bank1_b(char a, char b)
func_ram_bank1_b: {
    .const a = '0'
    .const b = 7
    .label return = a+b
    rts
}
.segment Bank1
// __register(A) char func_ram_bank1_c(char a, char b)
func_ram_bank1_c: {
    .const a = '0'
    .const b = 7
    // func_ram_bank1_a(a, b)
    lda #b
    ldx #a
    jsr func_ram_bank1_a
    // func_ram_bank1_a(a, b)
    // }
    rts
}
// __register(A) char func_ram_bank1_d(char a, char b)
func_ram_bank1_d: {
    .const a = '0'
    .const b = 7
    // func_rom_bank2_a(a, b)
    lda #b
    ldx #a
    jsr $ff6e
    .byte <func_rom_bank2_a
    .byte >func_rom_bank2_a
    .byte 2
    // func_rom_bank2_a(a, b)
    // }
    rts
}
// __register(A) char func_ram_bank1_e(__register(A) char a, __register(X) char b)
func_ram_bank1_e: {
    // func_rom_bank2_b(a, b)
    jsr func_rom_bank2_b
    // func_rom_bank2_b(a, b)
    // }
    rts
}
// __register(A) char func_ram_bank1_f(char a, char b)
func_ram_bank1_f: {
    .const a = '0'
    .const b = 7
    // func_main_a(a, b)
    ldx #b
    lda #a
    jsr func_main_a
    // func_main_a(a, b)
    // }
    rts
}
.segment Bank2
// The sequent functions will be banked using call method rom in bank number 2.
// __register(A) char func_rom_bank2_a(__register(X) char a, __register(A) char b)
func_rom_bank2_a: {
    // a + b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
// The __bank directive declares this function to be banked using call method rom in bank number 2 of banked rom.
// __register(A) char func_rom_bank2_b(__register(A) char a, __register(X) char b)
func_rom_bank2_b: {
    // a + b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
// __register(A) char func_rom_bank2_c(char a, char b)
func_rom_bank2_c: {
    .const a = '0'
    .const b = 7
    // func_ram_bank1_a(a, b)
    lda #b
    ldx #a
    jsr $ff6e
    .byte <func_ram_bank1_a
    .byte >func_ram_bank1_a
    .byte 1
    // func_ram_bank1_a(a, b)
    // }
    rts
}
// __register(A) char func_rom_bank2_d(char a, char b)
func_rom_bank2_d: {
    .const a = '0'
    .const b = 7
    // func_rom_bank2_a(a, b)
    lda #b
    ldx #a
    jsr func_rom_bank2_a
    // func_rom_bank2_a(a, b)
    // }
    rts
}
// __register(A) char func_rom_bank2_e(__register(A) char a, __register(X) char b)
func_rom_bank2_e: {
    // func_rom_bank2_b(a, b)
    jsr func_rom_bank2_b
    // func_rom_bank2_b(a, b)
    // }
    rts
}
// __register(A) char func_rom_bank2_f(char a, char b)
func_rom_bank2_f: {
    .const a = '0'
    .const b = 7
    // func_main_a(a, b)
    ldx #b
    lda #a
    jsr func_main_a
    // func_main_a(a, b)
    // }
    rts
}
.segment Code
// The sequent functions will be addressed in the default main memory location (segment Code).
// Allocated in main memory.
// __register(A) char func_main_a(__register(A) char a, __register(X) char b)
func_main_a: {
    // func_ram_bank1_e(a, b)
    jsr $ff6e
    .byte <func_ram_bank1_e
    .byte >func_ram_bank1_e
    .byte 1
    // func_ram_bank1_e(a, b)
    // }
    rts
}
// Allocated in main memory.
// __register(A) char func_main_b(char a, char b)
func_main_b: {
    .const a = '0'
    .const b = 7
    // func_rom_bank2_e(a, b)
    ldx #b
    lda #a
    jsr $ff6e
    .byte <func_rom_bank2_e
    .byte >func_rom_bank2_e
    .byte 2
    // func_rom_bank2_e(a, b)
    // }
    rts
}
