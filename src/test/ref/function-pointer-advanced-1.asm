// Tests calling advanced functions pointers (with multiple parameters and a return value)
  // Commodore 64 PRG executable file
.file [name="function-pointer-advanced-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const STACK_BASE = $103
  .const SIZEOF_CHAR = 1
  .label line = 5
  .label idx = 2
.segment Code
__start: {
    // __ma char* line = (char*)0x400
    lda #<$400
    sta.z line
    lda #>$400
    sta.z line+1
    jsr main
    rts
}
// __register(A) char xor(__zp(8) char a, __register(A) char b)
xor: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_1 = 1
    .label a = 8
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // a^b
    eor.z a
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
// __register(A) char min(__register(Y) char a, __register(A) char b)
min: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // return a;
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    tay
    // return b;
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // if(a<b)
    sta.z $ff
    cpy.z $ff
    bcc __b1
    jmp __breturn
  __b1:
    tya
  __breturn:
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
// __register(A) char max(__zp(9) char a, __register(A) char b)
max: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_1 = 1
    .label a = 9
    // return a;
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    // return b;
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // if(a>b)
    cmp.z a
    bcc __b1
    jmp __breturn
  __b1:
    lda.z a
  __breturn:
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
// __register(A) char sum(__zp($a) char a, __register(A) char b)
sum: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_1 = 1
    .label a = $a
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // a+b
    clc
    adc.z a
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
main: {
    .label i = 7
    lda #0
    sta.z idx
    sta.z i
  __b1:
    // for(char i=0;i<sizeof(INPUT);i++)
    lda.z i
    cmp #6*SIZEOF_CHAR
    bcc __b2
    // ln()
    jsr ln
    // exec(&sum)
    lda #<sum
    sta.z exec.collect
    lda #>sum
    sta.z exec.collect+1
    jsr exec
    // ln()
    jsr ln
    // exec(&min)
    lda #<min
    sta.z exec.collect
    lda #>min
    sta.z exec.collect+1
    jsr exec
    // ln()
    jsr ln
    // exec(&max)
    lda #<max
    sta.z exec.collect
    lda #>max
    sta.z exec.collect+1
    jsr exec
    // ln()
    jsr ln
    // exec(&xor)
    lda #<xor
    sta.z exec.collect
    lda #>xor
    sta.z exec.collect+1
    jsr exec
    // }
    rts
  __b2:
    // print(INPUT[i])
    ldy.z i
    lda INPUT,y
    sta.z print.i
    jsr print
    // cout(' ')
    ldx #' '
    jsr cout
    // for(char i=0;i<sizeof(INPUT);i++)
    inc.z i
    jmp __b1
}
ln: {
    // line += 40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    // }
    rts
}
// void exec(__zp($b) char (*collect)(char, char))
exec: {
    .label out = 3
    .label i = 4
    .label collect = $b
    // cout(' ')
    lda #0
    sta.z idx
    ldx #' '
    jsr cout
    // cout(' ')
    ldx #' '
    jsr cout
    // cout(' ')
    ldx #' '
    jsr cout
    // char out = INPUT[0]
    lda INPUT
    sta.z out
    lda #1
    sta.z i
  __b1:
    // for(char i=1;i<sizeof(INPUT);i++)
    lda.z i
    cmp #6*SIZEOF_CHAR
    bcc __b2
    // }
    rts
  __b2:
    // (*collect)(out,INPUT[i])
    lda.z out
    pha
    ldy.z i
    lda INPUT,y
    pha
    jsr icall1
    pla
    // out = (*collect)(out,INPUT[i])
    pla
    sta.z out
    // print(out)
    jsr print
    // cout(' ')
    ldx #' '
    jsr cout
    // for(char i=1;i<sizeof(INPUT);i++)
    inc.z i
    jmp __b1
  icall1:
    jmp (collect)
}
// void print(__zp(3) char i)
print: {
    .label i = 3
    // i>>4
    lda.z i
    lsr
    lsr
    lsr
    lsr
    // cout(HEX[i>>4])
    tay
    ldx HEX,y
    jsr cout
    // i&0x0f
    lda #$f
    and.z i
    // cout(HEX[i&0x0f])
    tay
    ldx HEX,y
    jsr cout
    // }
    rts
}
// void cout(__register(X) char c)
cout: {
    // line[idx++] = c
    ldy.z idx
    txa
    sta (line),y
    // line[idx++] = c;
    inc.z idx
    // }
    rts
}
.segment Data
  INPUT: .byte 2, 1, 3, 4, 6, 5
  HEX: .text "0123456789abcdef"
  .byte 0
