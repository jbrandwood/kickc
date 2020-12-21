// Test declaration of intrinsic without body
  // Commodore 64 PRG executable file
.file [name="cstyle-decl-function-intrinsic.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
// Definition of main()
main: {
    // }
    rts
}
