// Atari Tempest ROM Development Template
// Each function of the kernal is a no-args function
// The functions are placed in the SYSCALLS table surrounded by JMP and NOP
  .file [name="ataritempest.bin", type="bin", segments="AtariTempest"]
.segmentdef AtariTempest [segments="Code, RomData, Vectors"]
.segmentdef Code [start=$9000, min=$9000, max=$Fff9]
.segmentdef RomData [startAfter="Code", min=$9000, max=$Fff9]
.segmentdef RamData [start=$200, min=$200, max=$7ff]
.segmentdef Vectors [start=$FFFA, min=$FFFA, max=$FFFF, fill]
.segment Code
init:
  .label BG_COLOR = $c01a
.segment Code
main: {
    // (*BG_COLOR)++;
    inc BG_COLOR
    // }
    rts
}
nmiHandler: {
    sta rega+1
    stx regx+1
    sty regy+1
    // (*BG_COLOR)++;
    inc BG_COLOR
    // }
  rega:
    lda #00
  regx:
    ldx #00
  regy:
    ldy #00
    rti
}
entryPoint: {
    ldx #0
  __b1:
    // SCREEN[i] = MESSAGE[i]
    lda MESSAGE,x
    sta SCREEN,x
    // for( char i:0..49)
    inx
    cpx #$32
    bne __b1
    // }
    rts
}
.segment RomData
  MESSAGE: .text "hello world"
  .byte 0
.segment RamData
  SCREEN: .fill $32, 0
.segment Vectors
  VECTORS: .word nmiHandler, entryPoint
