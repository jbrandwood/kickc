// Test main() with parameters
  // Commodore 64 PRG executable file
.file [name="main-param-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
// int main(int argc, char **argv)
main: {
    .label SCREEN = $400
    // SCREEN[0] = (char)argc
    lda #0
    sta SCREEN
    // SCREEN[1] = (char) argv
    sta SCREEN+1
    // }
    rts
}
