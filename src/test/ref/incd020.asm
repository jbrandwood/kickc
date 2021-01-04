// Incrementing / decrementing pointer content should result in code modifying the memory location - eg. inc $d020.
// Currently it does not but instead leads to just reading the value a few times.
  // Commodore 64 PRG executable file
.file [name="incd020.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BG_COLOR = $d020
.segment Code
main: {
  __b1:
    // ++*BG_COLOR;
    inc BG_COLOR
    // (*BG_COLOR)--;
    dec BG_COLOR
    jmp __b1
}
