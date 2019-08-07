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
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    jsr print_ln
    lda #PROCPORT_DDR_MEMORY_MASK
    sta testProcport.ddr2
    lda #PROCPORT_RAM_ALL
    sta testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta testProcport.ddr2
    lda #PROCPORT_RAM_IO
    sta testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta testProcport.ddr2
    lda #PROCPORT_RAM_CHARROM
    sta testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta testProcport.ddr2
    lda #PROCPORT_KERNEL_IO
    sta testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #PROCPORT_DDR_MEMORY_MASK
    sta testProcport.ddr2
    lda #PROCPORT_BASIC_KERNEL_IO
    sta testProcport.port
    ldx #PROCPORT_DDR_MEMORY_MASK
    jsr testProcport
    lda #0
    sta testProcport.ddr2
    sta testProcport.port
    tax
    jsr testProcport
    lda #0
    sta testProcport.ddr2
    sta testProcport.port
    ldx #$ff
    jsr testProcport
    lda #0
    sta testProcport.ddr2
    lda #$ff
    sta testProcport.port
    tax
    jsr testProcport
    lda #$ff
    sta testProcport.ddr2
    lda #0
    sta testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$ff
    sta testProcport.ddr2
    lda #$55
    sta testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$ff
    sta testProcport.ddr2
    lda #$aa
    sta testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$ff
    sta testProcport.ddr2
    sta testProcport.port
    tax
    jsr testProcport
    lda #$55
    sta testProcport.ddr2
    lda #0
    sta testProcport.port
    ldx #$55
    jsr testProcport
    lda #$55
    sta testProcport.ddr2
    sta testProcport.port
    tax
    jsr testProcport
    lda #$55
    sta testProcport.ddr2
    lda #$ff
    sta testProcport.port
    ldx #$55
    jsr testProcport
    lda #$aa
    sta testProcport.ddr2
    lda #0
    sta testProcport.port
    ldx #$aa
    jsr testProcport
    lda #$aa
    sta testProcport.ddr2
    lda #$ff
    sta testProcport.port
    ldx #$aa
    jsr testProcport
    lda #$aa
    sta testProcport.ddr2
    sta testProcport.port
    tax
    jsr testProcport
    lda #0
    sta testProcport.ddr2
    lda #$d0
    sta testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$55
    sta testProcport.ddr2
    sta testProcport.port
    ldx #$ff
    jsr testProcport
    lda #$15
    sta testProcport.ddr2
    sta testProcport.port
    ldx #$17
    jsr testProcport
    lda #$17
    sta testProcport.ddr2
    lda #$15
    sta testProcport.port
    ldx #$17
    jsr testProcport
    lda #$17
    sta testProcport.ddr2
    sta testProcport.port
    tax
    jsr testProcport
    // Enable interrupts
    cli
    // Return to normal settings
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
  b1:
    inc SCREEN+$3e7
    jmp b1
    str: .text "ddr port ddr2 $00 $01 $a000 $d000 $e000"
    .byte 0
}
// testProcport(byte register(X) ddr, byte zeropage(2) port, byte zeropage(3) ddr2)
testProcport: {
    .label port = 2
    .label ddr2 = 3
    lda #$ff
    sta PROCPORT_DDR
    lda #0
    sta PROCPORT
    stx PROCPORT_DDR
    lda port
    sta PROCPORT
    lda ddr2
    sta PROCPORT_DDR
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    jsr print_byte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldx port
    jsr print_byte
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldx ddr2
    jsr print_byte
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    ldx PROCPORT_DDR
    jsr print_byte
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    ldx PROCPORT
    jsr print_byte
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    ldx BASIC_ROM
    jsr print_byte
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    ldx IO_RAM
    jsr print_byte
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
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
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
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
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage(6) str)
print_str: {
    .label str = 6
  b1:
    ldy #0
    lda (str),y
    cmp #0
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
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
    sta dst
    lda #>str
    sta dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
}
  print_hextab: .text "0123456789abcdef"
