// Test strncat() implementation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // strncat(build, hello, 5)
    lda #<hello
    sta.z strncat.source
    lda #>hello
    sta.z strncat.source+1
    jsr strncat
    // strncat(build, space, 5)
    lda #<space
    sta.z strncat.source
    lda #>space
    sta.z strncat.source+1
    jsr strncat
    // strncat(build, world, 5)
    lda #<world
    sta.z strncat.source
    lda #>world
    sta.z strncat.source+1
    jsr strncat
    ldx #0
  __b1:
    // while(build[i])
    lda build,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = build[i]
    lda build,x
    sta SCREEN,x
    // i++;
    inx
    jmp __b1
}
// Appends the first num characters of source to destination, plus a terminating null-character.
// If the length of the C string in source is less than num, only the content up to the terminating null-character is copied.
// strncat(byte* zp(2) source, word zp(6) num)
strncat: {
    .label dst = 4
    .label source = 2
    .label num = 6
    lda #<build
    sta.z dst
    lda #>build
    sta.z dst+1
  // Skip the existing string at dest
  __b1:
    // while (*dst)
    ldy #0
    lda (dst),y
    cmp #0
    bne __b2
    lda #<5
    sta.z num
    tya
    sta.z num+1
  // Copy up to num chars from src
  __b3:
    // *dst = *source++
    ldy #0
    lda (source),y
    sta (dst),y
    // while (num && (*dst = *source++))
    inc.z source
    bne !+
    inc.z source+1
  !:
    lda.z num
    ora.z num+1
    beq __b5
    ldy #0
    lda (dst),y
    cmp #0
    bne __b4
  __b5:
    // *dst = 0
    // Add null-character
    lda #0
    tay
    sta (dst),y
    // }
    rts
  __b4:
    // --num;
    lda.z num
    bne !+
    dec.z num+1
  !:
    dec.z num
    // ++dst;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b3
  __b2:
    // dst++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  hello: .text "hello"
  .byte 0
  space: .text " "
  .byte 0
  world: .text "world war 3"
  .byte 0
  build: .fill $28, 0
