// Test the functionality of the C64 processor port ($00/$01)
// Tests by setting the value of the processor port - and then printing out values of $00/$01/$a000/$d000/$e000
  // Commodore 64 PRG executable file
.file [name="processor-port-test.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in all three areas 0xA000, 0xD000, 0xE000
  .const PROCPORT_RAM_ALL = 0
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  /// RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
  .const PROCPORT_RAM_CHARROM = 1
  /// RAM in 0xA000, I/O in 0xD000, KERNEL in 0xE000
  .const PROCPORT_KERNEL_IO = 6
  /// BASIC in 0xA000, I/O in 0xD000, KERNEL in 0xE000
  .const PROCPORT_BASIC_KERNEL_IO = 7
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  .label BASIC_ROM = $a000
  .label KERNAL_ROM = $e000
  .label IO_RAM = $d000
  .label SCREEN = $400
  .label print_screen = $400
  .label print_char_cursor = 2
  .label print_line_cursor = 6
.segment Code
main: {
    // asm
    // Avoid interrupts
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Write recognizable values into memory
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_ALL
    lda #PROCPORT_RAM_ALL
    sta.z PROCPORT
    // *BASIC_ROM = $a0
    lda #$a0
    sta BASIC_ROM
    // *KERNAL_ROM = $e0
    lda #$e0
    sta KERNAL_ROM
    // *IO_RAM = $d0
    lda #$d0
    sta IO_RAM
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_BASIC_KERNEL_IO
    lda #PROCPORT_BASIC_KERNEL_IO
    sta.z PROCPORT
    // *IO_RAM = $dd
    lda #$dd
    sta IO_RAM
    // print_cls()
    jsr print_cls
    // print_str("ddr port ddr2 $00 $01 $a000 $d000 $e000")
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
    sta.z print_line_cursor+1
    jsr print_ln
    // testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_RAM_ALL, PROCPORT_DDR_MEMORY_MASK)
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_RAM_ALL
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    // testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_RAM_IO, PROCPORT_DDR_MEMORY_MASK)
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_RAM_IO
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    // testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_RAM_CHARROM, PROCPORT_DDR_MEMORY_MASK)
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_RAM_CHARROM
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    // testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_KERNEL_IO, PROCPORT_DDR_MEMORY_MASK)
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_KERNEL_IO
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    // testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_BASIC_KERNEL_IO, PROCPORT_DDR_MEMORY_MASK)
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_BASIC_KERNEL_IO
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    // testProcport($00, $00, $00)
    lda #0
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    // testProcport($ff, $00, $00)
    lda #0
    sta.z testProcport.ddr2
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    // testProcport($ff, $ff, $00)
    lda #0
    sta.z testProcport.ddr2
    lda #$ff
    sta.z testProcport.port
    tax
    jsr testProcport
    // testProcport($ff, $00, $ff)
    lda #$ff
    sta.z testProcport.ddr2
    lda #0
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    // testProcport($ff, $55, $ff)
    lda #$ff
    sta.z testProcport.ddr2
    lda #$55
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    // testProcport($ff, $aa, $ff)
    lda #$ff
    sta.z testProcport.ddr2
    lda #$aa
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    // testProcport($ff, $ff, $ff)
    lda #$ff
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    // testProcport($55, $00, $55)
    lda #$55
    sta.z testProcport.ddr2
    lda #0
    sta.z testProcport.port
    ldx #$55
    jsr testProcport
    // testProcport($55, $55, $55)
    lda #$55
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    // testProcport($55, $ff, $55)
    lda #$55
    sta.z testProcport.ddr2
    lda #$ff
    sta.z testProcport.port
    ldx #$55
    jsr testProcport
    // testProcport($aa, $00, $aa)
    lda #$aa
    sta.z testProcport.ddr2
    lda #0
    sta.z testProcport.port
    ldx #$aa
    jsr testProcport
    // testProcport($aa, $ff, $aa)
    lda #$aa
    sta.z testProcport.ddr2
    lda #$ff
    sta.z testProcport.port
    ldx #$aa
    jsr testProcport
    // testProcport($aa, $aa, $aa)
    lda #$aa
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    // testProcport($ff, $d0, $00)
    lda #0
    sta.z testProcport.ddr2
    lda #$d0
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    // testProcport($ff, $55, $55)
    lda #$55
    sta.z testProcport.ddr2
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    // testProcport($17, $15, $15)
    lda #$15
    sta.z testProcport.ddr2
    sta.z testProcport.port
    ldx #$17
    jsr testProcport
    // testProcport($17, $15, $17)
    lda #$17
    sta.z testProcport.ddr2
    lda #$15
    sta.z testProcport.port
    ldx #$17
    jsr testProcport
    // testProcport($17, $17, $17)
    lda #$17
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    // asm
    // Enable interrupts
    cli
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Return to normal settings
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_BASIC_KERNEL_IO
    lda #PROCPORT_BASIC_KERNEL_IO
    sta.z PROCPORT
  __b1:
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    jmp __b1
  .segment Data
    str: .text "ddr port ddr2 $00 $01 $a000 $d000 $e000"
    .byte 0
}
.segment Code
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a zero-terminated string
// void print_str(__zp(4) char *str)
print_str: {
    .label str = 4
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // print_char(*(str++))
    ldy #0
    lda (str),y
    jsr print_char
    // print_char(*(str++));
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// void testProcport(__register(X) char ddr, __zp(8) char port, __zp(9) char ddr2)
testProcport: {
    .label port = 8
    .label ddr2 = 9
    // *PROCPORT_DDR = $ff
    lda #$ff
    sta.z PROCPORT_DDR
    // *PROCPORT = $00
    lda #0
    sta.z PROCPORT
    // *PROCPORT_DDR = ddr
    stx.z PROCPORT_DDR
    // *PROCPORT = port
    lda.z port
    sta.z PROCPORT
    // *PROCPORT_DDR = ddr2
    lda.z ddr2
    sta.z PROCPORT_DDR
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str(" ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(ddr)
    jsr print_uchar
    // print_str("   ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(port)
    ldx.z port
    jsr print_uchar
    // print_str("   ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(ddr2)
    ldx.z ddr2
    jsr print_uchar
    // print_str("  ")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*PROCPORT_DDR)
    ldx.z PROCPORT_DDR
    jsr print_uchar
    // print_str("  ")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*PROCPORT)
    ldx.z PROCPORT
    jsr print_uchar
    // print_str("    ")
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*BASIC_ROM)
    ldx BASIC_ROM
    jsr print_uchar
    // print_str("    ")
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*IO_RAM)
    ldx IO_RAM
    jsr print_uchar
    // print_str("    ")
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*KERNAL_ROM)
    ldx KERNAL_ROM
    jsr print_uchar
    // print_ln()
    jsr print_ln
    // }
    rts
  .segment Data
    str: .text " "
    .byte 0
    str1: .text "   "
    .byte 0
    str3: .text "  "
    .byte 0
    str5: .text "    "
    .byte 0
}
.segment Code
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = 4
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Print a single char
// void print_char(__register(A) char ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Print a char as HEX
// void print_uchar(__register(X) char b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
.segment Data
  print_hextab: .text "0123456789abcdef"
