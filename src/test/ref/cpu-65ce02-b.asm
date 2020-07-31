// Test the 65CE02 CPU
// A program that uses 65CE02 instructions
.cpu _65ce02
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
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
