// Test main() with parameters
  // Commodore 64 PRG executable file
.file [name="main-param-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
// int main(int argc, char **argv)
main: {
    // }
    rts
}
