.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Zeropage addresses used to hold lo/hi-bytes of addresses of float numbers in MEM
  .label memLo = $fe
  .label memHi = $ff
  .label print_line_cursor = 3
  .label print_char_cursor = 5
main: {
    .label f_2pi = $e2e5
    .label i = 2
    // setFAC(1275)
    lda #<$4fb
    sta.z setFAC.prepareMEM1_mem
    lda #>$4fb
    sta.z setFAC.prepareMEM1_mem+1
    jsr setFAC
    // divFACby10()
    jsr divFACby10
    // setMEMtoFAC(f_127)
    lda #<f_127
    sta.z setMEMtoFAC.mem
    lda #>f_127
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    lda #1
    sta.z i
  __b1:
    // setFAC((word)i)
    lda.z i
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
    jsr setFAC
    // mulFACbyMEM(f_2pi)
    lda #<f_2pi
    sta.z mulFACbyMEM.mem
    lda #>f_2pi
    sta.z mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    // setMEMtoFAC(f_i)
    lda #<f_i
    sta.z setMEMtoFAC.mem
    lda #>f_i
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    // setFAC(25)
    lda #<$19
    sta.z setFAC.prepareMEM1_mem
    lda #>$19
    sta.z setFAC.prepareMEM1_mem+1
    jsr setFAC
    // divMEMbyFAC(f_i)
    jsr divMEMbyFAC
    // sinFAC()
    jsr sinFAC
    // mulFACbyMEM(f_127)
    lda #<f_127
    sta.z mulFACbyMEM.mem
    lda #>f_127
    sta.z mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    // addMEMtoFAC(f_127)
    jsr addMEMtoFAC
    // getFAC()
    jsr getFAC
    // print_word(getFAC())
    jsr print_word
    // print_ln()
    jsr print_ln
    // for(byte i : 1..25)
    inc.z i
    lda #$1a
    cmp.z i
    bne __b15
    // }
    rts
  __b15:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
    f_i: .byte 0, 0, 0, 0, 0
    f_127: .byte 0, 0, 0, 0, 0
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
// Print a word as HEX
// print_word(word zp(7) w)
print_word: {
    .label w = 7
    // print_byte(>w)
    lda.z w+1
    tax
    jsr print_byte
    // print_byte(<w)
    lda.z w
    tax
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
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
// Print a single char
// print_char(byte register(A) ch)
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
// word = FAC
// Get the value of the FAC (floating point accumulator) as an integer 16bit word
// Destroys the value in the FAC in the process
getFAC: {
    .label return = 7
    // asm
    // Load FAC (floating point accumulator) integer part into word register Y,A
    jsr $b1aa
    sty memLo
    sta memHi
    // w = { *memHi, *memLo }
    tya
    sta.z return
    lda memHi
    sta.z return+1
    // }
    rts
}
// FAC = MEM+FAC
// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
// Reads 5 bytes from memory
addMEMtoFAC: {
    .const prepareMEM1_mem = main.f_127
    // *memLo = <mem
    lda #<prepareMEM1_mem
    sta memLo
    // *memHi = >mem
    lda #>prepareMEM1_mem
    sta memHi
    // asm
    lda memLo
    ldy memHi
    jsr $b867
    // }
    rts
}
// FAC = MEM*FAC
// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
// Reads 5 bytes from memory
// mulFACbyMEM(byte* zp(7) mem)
mulFACbyMEM: {
    .label mem = 7
    // <mem
    lda.z mem
    // *memLo = <mem
    sta memLo
    // >mem
    lda.z mem+1
    // *memHi = >mem
    sta memHi
    // asm
    lda memLo
    ldy memHi
    jsr $ba28
    // }
    rts
}
// FAC = sin(FAC)
// Set FAC to sinus of the FAC - sin(FAC)
// Sinus is calculated on radians (0-2*PI)
sinFAC: {
    // asm
    jsr $e26b
    // }
    rts
}
// FAC = MEM/FAC
// Set FAC to MEM (float saved in memory) divided by FAC (float accumulator)
// Reads 5 bytes from memory
divMEMbyFAC: {
    .const prepareMEM1_mem = main.f_i
    // *memLo = <mem
    lda #<prepareMEM1_mem
    sta memLo
    // *memHi = >mem
    lda #>prepareMEM1_mem
    sta memHi
    // asm
    lda memLo
    ldy memHi
    jsr $bb0f
    // }
    rts
}
// FAC = word
// Set the FAC (floating point accumulator) to the integer value of a 16bit word
// setFAC(word zp(7) w)
setFAC: {
    .label prepareMEM1_mem = 7
    .label w = 7
    // <mem
    lda.z prepareMEM1_mem
    // *memLo = <mem
    sta memLo
    // >mem
    lda.z prepareMEM1_mem+1
    // *memHi = >mem
    sta memHi
    // asm
    // Load word register Y,A into FAC (floating point accumulator)
    ldy memLo
    jsr $b391
    // }
    rts
}
// MEM = FAC
// Stores the value of the FAC to memory
// Stores 5 bytes (means it is necessary to allocate 5 bytes to avoid clobbering other data using eg. byte[] mem = {0, 0, 0, 0, 0};)
// setMEMtoFAC(byte* zp(7) mem)
setMEMtoFAC: {
    .label mem = 7
    // <mem
    lda.z mem
    // *memLo = <mem
    sta memLo
    // >mem
    lda.z mem+1
    // *memHi = >mem
    sta memHi
    // asm
    ldx memLo
    tay
    jsr $bbd4
    // }
    rts
}
// FAC = FAC/10
// Set FAC to FAC divided by 10
divFACby10: {
    // asm
    jsr $bafe
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
