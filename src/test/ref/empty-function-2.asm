// Test removal of empty function
// main() should not be removed!
  // Commodore 64 PRG executable file
.file [name="empty-function-2.prg", type="prg", segments="Program"]
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
