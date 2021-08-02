// Demonstrates a problem with the preprocessor where a macro with an empty parameter list does not accept an empty list of parameters
  // Commodore 64 PRG executable file
.file [name="preprocessor-16.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // }
    rts
}
