// Atari Tempest ROM Development Template
// Each function of the kernal is a no-args function
// The functions are placed in the SYSCALLS table surrounded by JMP and NOP
  .file [name="ataritempest.bin", type="bin", segments="AtariTempest"]
.segmentdef AtariTempest [segments="Code, Data, Vectors"]
.segmentdef Code [start=$4000, min=$4000, max=$bff9]
.segmentdef Data [startAfter="Code"]
.segmentdef Vectors [start=$bffa, min=$bffa, max=$bfff]
  .label BGCOL = $c01a
.segment Code
main: {
    inc BGCOL
    rts
}
nmiHandler: {
    sta rega+1
    stx regx+1
    sty regy+1
    inc BGCOL
  rega:
    lda #00
  regx:
    ldx #00
  regy:
    ldy #00
    rti
}
entryPoint: {
    inc BGCOL
    rts
}
.segment Vectors
  VECTORS: .word nmiHandler, entryPoint
