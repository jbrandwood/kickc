/**
 * Test banked calls with memory variables.
 * The parameters & return should end up in the shared/common bank.
 */
  .file                               [name="call-banked-phi-memvars.prg", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef RAM_Bank1               [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef RAM_Bank2               [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef ROM_Bank1               [start=$C000, min=$C000, max=$FFFF, align=$100]
.segment Basic
:BasicUpstart(main)
.segment Code
.segment Data


  .label SCREEN = $400
.segment Code
main: {
    ldy #0
  __b1:
    // for(char i=0;i<5; i++)
    cpy #5
    bcc __b2
    // }
    rts
  __b2:
    // plus(100, (int)i)
    tya
    sta plus.b
    lda #0
    sta plus.b+1
    lda #<$64
    sta plus.a
    lda #>$64
    sta plus.a+1
    sta.z $ff
    lda.z 0
    pha
    lda #1
    sta.z 0
    lda.z $ff
    jsr plus
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // plus(100, (int)i)
    // SCREEN[i] = plus(100, (int)i)
    tya
    asl
    tax
    lda __1
    sta SCREEN,x
    lda __1+1
    sta SCREEN+1,x
    // 10+i
    tya
    tax
    axs #-[$a]
    // plus(200, (int)i)
    tya
    sta plus.b
    lda #0
    sta plus.b+1
    lda #<$c8
    sta plus.a
    lda #>$c8
    sta plus.a+1
    sta.z $ff
    lda.z 0
    pha
    lda #1
    sta.z 0
    lda.z $ff
    jsr plus
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // plus(200, (int)i)
    // SCREEN[10+i] = plus(200, (int)i)
    txa
    asl
    tax
    lda __3
    sta SCREEN,x
    lda __3+1
    sta SCREEN+1,x
    // for(char i=0;i<5; i++)
    iny
    jmp __b1
  .segment Data
    .label __1 = plus.return
    .label __3 = plus.return
}
.segment RAM_Bank1
// __mem() int plus(__mem() int a, __mem() int b)
// __bank(cx16_ram, 1) 
plus: {
    // r += a
    clc
    lda a
    adc #<2
    sta r
    lda a+1
    adc #>2
    sta r+1
    // r += b
    clc
    lda r
    adc b
    sta r
    lda r+1
    adc b+1
    sta r+1
    // r += a
    clc
    lda r
    adc a
    sta r
    lda r+1
    adc a+1
    sta r+1
    // r += b
    lda r
    clc
    adc b
    sta return
    lda r+1
    adc b+1
    sta return+1
    // }
    rts
  .segment Data
    b: .word 0
    return: .word 0
  .segment RAM_Bank1
    r: .word 0
  .segment Data
    a: .word 0
}
