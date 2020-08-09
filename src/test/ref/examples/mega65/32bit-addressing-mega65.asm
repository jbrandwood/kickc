// 32-bit addressing using the new addressing mode
.cpu _45gs02
  .file [name="32bit-addressing-mega65.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(__start)                                   //         NNNN
.byte $00, $00, $00                                     // 
  // Absolute 32-bit address to use for storing/loading data
  .label ADDR32 = 2
.segment Code
__start: {
    // ADDR32
    lda #<0
    sta.z ADDR32
    sta.z ADDR32+1
    lda #<0>>$10
    sta.z ADDR32+2
    lda #>0>>$10
    sta.z ADDR32+3
    jsr main
    rts
}
main: {
    // ADDR32 = 0xff80000
    // Modify Color Ram using 32-bit addressing
    lda #<$ff80000
    sta.z ADDR32
    lda #>$ff80000
    sta.z ADDR32+1
    lda #<$ff80000>>$10
    sta.z ADDR32+2
    lda #>$ff80000>>$10
    sta.z ADDR32+3
    // asm
    ldz #0
  !:
    tza
    sta.z ((ADDR32)),z
    inz
    cpz #$50
    bne !-
    // ADDR32 = 0x00000800
    // Modify Screen using 32-bit addressing
    lda #<$800
    sta.z ADDR32
    lda #>$800
    sta.z ADDR32+1
    lda #<$800>>$10
    sta.z ADDR32+2
    lda #>$800>>$10
    sta.z ADDR32+3
    // asm
    lda #'*'
    ldz #$4f
  !:
    sta.z ((ADDR32)),z
    dez
    bpl !-
    // }
    rts
}
