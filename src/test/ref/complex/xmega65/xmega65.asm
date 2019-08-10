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
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label COLS = $d800
  .const WHITE = 1
  .const JMP = $4c
  .const NOP = $ea
.segment Code
main: {
    .label msg = 2
    .label sc = 4
    .label cols = 6
    // Initialize screen memory
    lda #$14
    sta VIC_MEMORY
    lda #<COLS
    sta.z cols
    lda #>COLS
    sta.z cols+1
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
    lda #<MESSAGE
    sta.z msg
    lda #>MESSAGE
    sta.z msg+1
  b1:
    ldy #0
    lda (msg),y
    cmp #0
    bne b2
  b3:
  // Loop forever
    jmp b3
  b2:
    ldy #0
    lda (msg),y
    sta (sc),y
    lda #WHITE
    sta (cols),y
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    jmp b1
}
syscall2: {
    .label BGCOL = $d021
    inc BGCOL
    rts
}
syscall1: {
    .label BORDERCOL = $d020
    inc BORDERCOL
    rts
}
.segment Data
  MESSAGE: .text "hello world!"
  .byte 0
.segment Syscall
SYSCALLS:
  .byte JMP
  .word syscall1
  .byte NOP
  .byte JMP
  .word syscall2
  .byte NOP
  .align $100
SYSCALL_RESET:
  .byte JMP
  .word main
  .byte NOP
