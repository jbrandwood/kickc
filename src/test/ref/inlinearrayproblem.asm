// Arrays / strings allocated inline destroy functions (because they are allocated where the call enters.
// The following places the text at the start of the main-function - and JSR's straight into the text - not the code.
  // Commodore 64 PRG executable file
.file [name="inlinearrayproblem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
.segment Code
main: {
    ldx #0
  __b1:
    // SCREEN[i] = txt[i]
    lda txt,x
    sta SCREEN,x
    // SCREEN2[i] = data[i]
    lda data,x
    sta SCREEN2,x
    // for( byte i : 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
  .segment Data
    txt: .text "qwe"
    data: .byte 1, 2, 3
}
