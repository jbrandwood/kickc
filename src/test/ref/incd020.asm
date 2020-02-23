// Incrementing / decrementing pointer content should result in code modifying the memory location - eg. inc $d020.
// Currently it does not but instead leads to just reading the value a few times.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d020
main: {
  __b1:
    // ++*BGCOL;
    inc BGCOL
    // (*BGCOL)--;
    dec BGCOL
    jmp __b1
}
