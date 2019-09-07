// Example showing how to use KickAsm segments to compile meant to be transfered to zeropage before execution.
// The linker-file defines the ZpCode segment to be on zeropage and does not include it directly in the PRG-file (by excluding it from the Program segment).
// Instead the compiled code is added as an array of bytes in "normal" memory - and transferred to zeropage at the start of the program
  .file [name="zpcode.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef ZpCode [start=$80]
.segment Basic
:BasicUpstart(main)


  .label RASTER = $d012
  .label BGCOL = $d020
.segment Code
main: {
    .label zpCode = zpLoop
    sei
    ldx #0
  b1:
    cpx #$14
    bcc b2
  b3:
    lda #$ff
    cmp RASTER
    bne b3
    jsr loop
    jsr zpLoop
    lda #0
    sta BGCOL
    jmp b3
  b2:
    lda zpCodeData,x
    sta zpCode,x
    inx
    jmp b1
}
.segment ZpCode
zpLoop: {
    ldx #0
  b1:
    inc BGCOL
    inx
    cpx #$65
    bne b1
    rts
}
.segment Code
// Code in "normal" memory
loop: {
    ldx #0
  b1:
    dec BGCOL
    inx
    cpx #$65
    bne b1
    rts
}
.segment Data
// Array containing the zeropage code to be transferred to zeropage before execution
zpCodeData:
.segmentout [segments="ZpCode"]

