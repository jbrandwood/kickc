// Incrementing / decrementing pointer content should result in code modifying the memory location - eg. inc $d020.
// Currently it does not but instead leads to just reading the value a few times.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BG_COLOR = $d020
main: {
  __b1:
    // ++*BG_COLOR;
    inc BG_COLOR
    // (*BG_COLOR)--;
    dec BG_COLOR
    jmp __b1
}
