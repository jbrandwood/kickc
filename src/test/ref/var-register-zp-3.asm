// Test declaring a variable as register on a specific ZP address
  // Commodore 64 PRG executable file
.file [name="var-register-zp-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    // print2(screen, "hello")
    lda #<screen
    sta.z print2.at
    lda #>screen
    sta.z print2.at+1
    lda #<msg
    sta.z print2.msg
    lda #>msg
    sta.z print2.msg+1
    jsr print2
    // print2(screen+80, "world")
    lda #<screen+$50
    sta.z print2.at
    lda #>screen+$50
    sta.z print2.at+1
    lda #<msg1
    sta.z print2.msg
    lda #>msg1
    sta.z print2.msg+1
    jsr print2
    // }
    rts
  .segment Data
    msg: .text "hello"
    .byte 0
    msg1: .text "world"
    .byte 0
}
.segment Code
// void print2(__zp(4) char *at, __zp(2) char *msg)
print2: {
    .label i = 6
    .label msg = 2
    .label at = 4
    ldx #0
    txa
    sta.z i
  __b1:
    // for(byte i=0; msg[i]; i++)
    ldy.z i
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // print_char(at, j, msg[i])
    ldy.z i
    lda (msg),y
    jsr print_char
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    inc.z i
    jmp __b1
}
// void print_char(__zp(4) char *at, __register(X) char idx, __register(A) char ch)
print_char: {
    .label at = 4
    // at[idx] = ch
    stx.z $ff
    ldy.z $ff
    sta (at),y
    // }
    rts
}
