// XMega65 Kernal Development Template
// Each function of the kernal is a no-args function
// The functions are placed in the SYSCALLS table surrounded by JMP and NOP
  .file [name="xmega65.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .const BLACK = 0
  .const WHITE = 1
  .const JMP = $4c
  .const NOP = $ea
  .label RASTER = $d012
  .label VICII_MEMORY = $d018
  .label SCREEN = $400
  .label BG_COLOR = $d021
  .label COLS = $d800
.segment Code
syscall2: {
    // *(SCREEN+78) = '<'
    lda #'<'
    sta SCREEN+$4e
    // }
    rts
}
syscall1: {
    // *(SCREEN+79) = '>'
    lda #'>'
    sta SCREEN+$4f
    // }
    rts
}
main: {
    // Print message
    .label sc = 4
    .label msg = 2
    // *VICII_MEMORY = 0x14
    // Initialize screen memory
    lda #$14
    sta VICII_MEMORY
    // memset(SCREEN, ' ', 40*25)
  // Init screen/colors
    ldx #' '
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    jsr memset
    // memset(COLS, WHITE, 40*25)
    ldx #WHITE
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    jsr memset
    lda #<SCREEN+$28
    sta.z sc
    lda #>SCREEN+$28
    sta.z sc+1
    lda #<MESSAGE
    sta.z msg
    lda #>MESSAGE
    sta.z msg+1
  __b1:
    // while(*msg)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
  __b3:
    // if(*RASTER==54 || *RASTER==66)
    lda #$36
    cmp RASTER
    beq __b4
    lda #$42
    cmp RASTER
    beq __b4
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    jmp __b3
  __b4:
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    jmp __b3
  __b2:
    // *sc++ = *msg++
    ldy #0
    lda (msg),y
    sta (sc),y
    // *sc++ = *msg++;
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(6) str, byte register(X) c)
memset: {
    .label end = 8
    .label dst = 6
    .label str = 6
    // char* end = (char*)str + num
    clc
    lda.z str
    adc #<$28*$19
    sta.z end
    lda.z str+1
    adc #>$28*$19
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
.segment Data
  MESSAGE: .text "hello world!"
  .byte 0
.segment Syscall
  SYSCALLS: .byte JMP
  .word syscall1
  .byte NOP, JMP
  .word syscall2
  .byte NOP
  .align $100
  SYSCALL_RESET: .byte JMP
  .word main
  .byte NOP
