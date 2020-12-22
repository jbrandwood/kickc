// Test a trivial loop head constant
// For trivially constant loop heads for(;;) loops can be written to run body before comparison
// The simplest possible for-loop with a constant loop head.
  // Commodore 64 PRG executable file
.file [name="loophead-trivial-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // for(char i=0;i<40;i++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = '*'
    lda #'*'
    sta SCREEN,x
    // for(char i=0;i<40;i++)
    inx
    jmp __b1
}
