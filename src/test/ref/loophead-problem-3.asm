// Program where loop-head optimization produces wrong return value
// Reported by Richard-William Loerakker
  // Commodore 64 PRG executable file
.file [name="loophead-problem-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BORDER_COLOR = $d020
  .label BG_COLOR = $d021
.segment Code
main: {
    .label result = 2
    .label kaputt = $a
    // mul16u(4,123)
    jsr mul16u
    // mul16u(4,123)
    // dword result = mul16u(4,123)
    // word kaputt = WORD0(result)
    lda.z result
    sta.z kaputt
    lda.z result+1
    sta.z kaputt+1
    // BYTE0(kaputt)
    lda.z kaputt
    // *BORDER_COLOR = BYTE0(kaputt)
    sta BORDER_COLOR
    // BYTE1(kaputt)
    lda.z kaputt+1
    // *BG_COLOR = BYTE1(kaputt)
    sta BG_COLOR
    // }
    rts
}
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($a) a)
mul16u: {
    .const b = $7b
    .label a = $a
    .label mb = 6
    .label res = 2
    .label return = 2
    lda #<b
    sta.z mb
    lda #>b
    sta.z mb+1
    lda #<b>>$10
    sta.z mb+2
    lda #>b>>$10
    sta.z mb+3
    lda #<0
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
    lda #<4
    sta.z a
    lda #>4
    sta.z a+1
  __b1:
    // while(a!=0)
    lda.z a
    ora.z a+1
    bne __b2
    // }
    rts
  __b2:
    // a&1
    lda #1
    and.z a
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  __b3:
    // a = a>>1
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
