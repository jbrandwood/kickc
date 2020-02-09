// Test the functionality of the C64 processor port ($00/$01)
// Tests by setting the value of the processor port - and then printing out values of $00/$01/$a000/$d000/$e000
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in all three areas $A000, $D000, $E000
  .const PROCPORT_RAM_ALL = 0
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = 5
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = 1
  // RAM in $A000, I/O in $D000, KERNEL in $E000
  .const PROCPORT_KERNEL_IO = 6
  // BASIC in $A000, I/O in $D000, KERNEL in $E000
  .const PROCPORT_BASIC_KERNEL_IO = 7
  .label BASIC_ROM = $a000
  .label KERNAL_ROM = $e000
  .label IO_RAM = $d000
  .label SCREEN = $400
  .label print_char_cursor = 4
  .label print_line_cursor = 8
main: {
    // Avoid interrupts
    sei
    // Write recognizable values into memory
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_ALL
    sta PROCPORT
    lda #$a0
    sta BASIC_ROM
    lda #$e0
    sta KERNAL_ROM
    lda #$d0
    sta IO_RAM
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
    lda #$dd
    sta IO_RAM
    jsr print_cls
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    jsr print_ln
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_RAM_ALL
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_RAM_IO
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_RAM_CHARROM
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_KERNEL_IO
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z testProcport.ddr2
    lda #PROCPORT_BASIC_KERNEL_IO
    sta.z testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #0
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    lda #0
    sta.z testProcport.ddr2
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    lda #0
    sta.z testProcport.ddr2
    lda #$ff
    sta.z testProcport.port
    tax
    jsr testProcport
    lda #$ff
    sta.z testProcport.ddr2
    lda #0
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$ff
    sta.z testProcport.ddr2
    lda #$55
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$ff
    sta.z testProcport.ddr2
    lda #$aa
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$ff
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    lda #$55
    sta.z testProcport.ddr2
    lda #0
    sta.z testProcport.port
    ldx #$55
    jsr testProcport
    lda #$55
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    lda #$55
    sta.z testProcport.ddr2
    lda #$ff
    sta.z testProcport.port
    ldx #$55
    jsr testProcport
    lda #$aa
    sta.z testProcport.ddr2
    lda #0
    sta.z testProcport.port
    ldx #$aa
    jsr testProcport
    lda #$aa
    sta.z testProcport.ddr2
    lda #$ff
    sta.z testProcport.port
    ldx #$aa
    jsr testProcport
    lda #$aa
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    lda #0
    sta.z testProcport.ddr2
    lda #$d0
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$55
    sta.z testProcport.ddr2
    sta.z testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$15
    sta.z testProcport.ddr2
    sta.z testProcport.port
    ldx #$17
    jsr testProcport
    lda #$17
    sta.z testProcport.ddr2
    lda #$15
    sta.z testProcport.port
    ldx #$17
    jsr testProcport
    lda #$17
    sta.z testProcport.ddr2
    sta.z testProcport.port
    tax
    jsr testProcport
    // Enable interrupts
    cli
    // Return to normal settings
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
  __b1:
    inc SCREEN+$3e7
    jmp __b1
    str: .text "ddr port ddr2 $00 $01 $a000 $d000 $e000"
    .byte 0
}
// testProcport(byte register(X) ddr, byte zp(2) port, byte zp(3) ddr2)
testProcport: {
    .label port = 2
    .label ddr2 = 3
    lda #$ff
    sta PROCPORT_DDR
    lda #0
    sta PROCPORT
    stx PROCPORT_DDR
    lda.z port
    sta PROCPORT
    lda.z ddr2
    sta PROCPORT_DDR
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    jsr print_byte
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    ldx.z port
    jsr print_byte
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    ldx.z ddr2
    jsr print_byte
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    ldx PROCPORT_DDR
    jsr print_byte
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    ldx PROCPORT
    jsr print_byte
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    ldx BASIC_ROM
    jsr print_byte
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    ldx IO_RAM
    jsr print_byte
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    ldx KERNAL_ROM
    jsr print_byte
    jsr print_ln
    rts
    str: .text " "
    .byte 0
    str1: .text "   "
    .byte 0
    str3: .text "  "
    .byte 0
    str5: .text "    "
    .byte 0
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Print a zero-terminated string
// print_str(byte* zp(6) str)
print_str: {
    .label str = 6
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = 8
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    rts
  __b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
