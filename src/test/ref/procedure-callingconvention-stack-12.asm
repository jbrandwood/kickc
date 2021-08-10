// Test a procedure with calling convention stack
// Test that comments are handled correctly
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-12.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const STACK_BASE = $103
  .label SCREEN = $400
  .label idx = 4
.segment Code
__start: {
    // char idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
// void print(__zp(2) char *str, __zp(5) char spacing)
print: {
    .const OFFSET_STACK_STR = 1
    .const OFFSET_STACK_SPACING = 0
    .label str = 2
    .label spacing = 5
    tsx
    lda STACK_BASE+OFFSET_STACK_STR,x
    sta.z str
    lda STACK_BASE+OFFSET_STACK_STR+1,x
    sta.z str+1
    tsx
    lda STACK_BASE+OFFSET_STACK_SPACING,x
    sta.z spacing
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[idx++] = *(str++)
    ldy #0
    lda (str),y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = *(str++);
    inc.z idx
    inc.z str
    bne !+
    inc.z str+1
  !:
    ldx #0
  __b3:
    // for(char c=0;c<spacing;c++)
    cpx.z spacing
    bcc __b4
    jmp __b1
  __b4:
    // SCREEN[idx++] = ' '
    lda #' '
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = ' ';
    inc.z idx
    // for(char c=0;c<spacing;c++)
    inx
    jmp __b3
}
main: {
    // print("hello", 1)
    // Print "hello"
    lda #>str
    pha
    lda #<str
    pha
    lda #1
    pha
    jsr print
    tsx
    txa
    axs #-3
    txs
    // print("world", 2)
    // Print "world"
    lda #>str1
    pha
    lda #<str1
    pha
    lda #2
    pha
    jsr print
    tsx
    txa
    axs #-3
    txs
    // }
    rts
  .segment Data
    str: .text "hello"
    .byte 0
    str1: .text "world"
    .byte 0
}
