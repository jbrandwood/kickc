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
    lda #<$4fb
    sta setFAC.w
    lda #>$4fb
    sta setFAC.w+1
    jsr setFAC
    jsr divFACby10
    lda #<f_127
    sta setMEMtoFAC.mem
    lda #>f_127
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #1
    sta i
  b1:
    lda i
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    lda #<f_2pi
    sta mulFACbyMEM.mem
    lda #>f_2pi
    sta mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    lda #<f_i
    sta setMEMtoFAC.mem
    lda #>f_i
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #$19
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    jsr divMEMbyFAC
    jsr sinFAC
    lda #<f_127
    sta mulFACbyMEM.mem
    lda #>f_127
    sta mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    jsr addMEMtoFAC
    jsr getFAC
    jsr print_word
    jsr print_ln
    inc i
    lda #$1a
    cmp i
    bne b15
    rts
  b15:
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
    f_i: .byte 0, 0, 0, 0, 0
    f_127: .byte 0, 0, 0, 0, 0
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
// Print a word as HEX
// print_word(word zeropage(7) w)
print_word: {
    .label w = 7
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
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
// word = FAC
// Get the value of the FAC (floating point accumulator) as an integer 16bit word
// Destroys the value in the FAC in the process
getFAC: {
    .label return = 7
    // Load FAC (floating point accumulator) integer part into word register Y,A
    jsr $b1aa
    sty $fe
    sta $ff
    lda memLo
    sta return
    lda memHi
    sta return+1
    rts
}
// FAC = MEM+FAC
// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
// Reads 5 bytes from memory
addMEMtoFAC: {
    lda #<main.f_127
    sta prepareMEM.mem
    lda #>main.f_127
    sta prepareMEM.mem+1
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $b867
    rts
}
// Prepare MEM pointers for operations using MEM
// prepareMEM(byte* zeropage(7) mem)
prepareMEM: {
    .label mem = 7
    lda mem
    sta memLo
    lda mem+1
    sta memHi
    rts
}
// FAC = MEM*FAC
// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
// Reads 5 bytes from memory
// mulFACbyMEM(byte* zeropage(7) mem)
mulFACbyMEM: {
    .label mem = 7
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $ba28
    rts
}
// FAC = sin(FAC)
// Set FAC to sinus of the FAC - sin(FAC)
// Sinus is calculated on radians (0-2*PI)
sinFAC: {
    jsr $e26b
    rts
}
// FAC = MEM/FAC
// Set FAC to MEM (float saved in memory) divided by FAC (float accumulator)
// Reads 5 bytes from memory
divMEMbyFAC: {
    lda #<main.f_i
    sta prepareMEM.mem
    lda #>main.f_i
    sta prepareMEM.mem+1
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $bb0f
    rts
}
// FAC = word
// Set the FAC (floating point accumulator) to the integer value of a 16bit word
// setFAC(word zeropage(7) w)
setFAC: {
    .label w = 7
    jsr prepareMEM
    // Load word register Y,A into FAC (floating point accumulator)
    ldy $fe
    lda $ff
    jsr $b391
    rts
}
// MEM = FAC
// Stores the value of the FAC to memory
// Stores 5 bytes (means it is necessary to allocate 5 bytes to avoid clobbering other data using eg. byte[] mem = {0, 0, 0, 0, 0};)
// setMEMtoFAC(byte* zeropage(7) mem)
setMEMtoFAC: {
    .label mem = 7
    jsr prepareMEM
    ldx $fe
    ldy $ff
    jsr $bbd4
    rts
}
// FAC = FAC/10
// Set FAC to FAC divided by 10
divFACby10: {
    jsr $bafe
    rts
}
  print_hextab: .text "0123456789abcdef"
