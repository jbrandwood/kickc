// Test the 65CE02 CPU
// A program that uses 65CE02 instructions
.cpu _65ce02
  // Commodore 64 PRG executable file
.file [name="cpu-65ce02-b.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldz #0
  __b1:
    // for(register(Z) char i=0;i<100;i++)
    cpz #$64
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    tza
    tax
    sta SCREEN,x
    // for(register(Z) char i=0;i<100;i++)
    inz
    jmp __b1
}
