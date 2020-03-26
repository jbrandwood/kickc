// Example showing how to use KickAsm segments to compile meant to be transfered to zeropage before execution.
// The linker-file defines the ZpCode segment to be on zeropage and does not include it directly in the PRG-file (by excluding it from the Program segment).
// Instead the compiled code is added as an array of chars in "normal" memory - and transferred to zeropage at the start of the program
  .file [name="zpcode.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef ZpCode [start=$80]
.segment Basic
:BasicUpstart(__bbegin)
.segment Code


  .label RASTER = $d012
  .label BGCOL = $d020
__bbegin:
.segment Code
main: {
    // Transfer ZP-code to zeropage
    .label zpCode = zpLoop
    // asm
    sei
    ldx #0
  __b1:
    // for(char i=0;i<20;i++)
    cpx #$14
    bcc __b2
  __b3:
    // while(*RASTER!=0xff)
    lda #$ff
    cmp RASTER
    bne __b3
    // loop()
  // Call code in normal memory
    jsr loop
    // zpLoop()
  // Call code on zeropage
    jsr zpLoop
    // *BGCOL = 0
    lda #0
    sta BGCOL
    jmp __b3
  __b2:
    // zpCode[i] = zpCodeData[i]
    lda zpCodeData,x
    sta zpCode,x
    // for(char i=0;i<20;i++)
    inx
    jmp __b1
}
.segment ZpCode
zpLoop: {
    ldx #0
  __b1:
    // (*BGCOL)++;
    inc BGCOL
    // for(char i:0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
.segment Code
// Code in "normal" memory
loop: {
    ldx #0
  __b1:
    // (*BGCOL)--;
    dec BGCOL
    // for(char i:0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
.segment Data
// Array containing the zeropage code to be transferred to zeropage before execution
zpCodeData:
.segmentout [segments="ZpCode"]

