// Demonstrates Library Constructor Functionality
// Multiple #pragma constructor_for() constructors
  // Commodore 64 PRG executable file
.file [name="library-constructor-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label sym = 4
  .label SCREEN = 2
.segment Code
__start: {
    // volatile char sym
    lda #0
    sta.z sym
    // char * volatile SCREEN
    sta.z SCREEN
    sta.z SCREEN+1
    // #pragma constructor_for(init_1, print)
    jsr init_1
    // #pragma constructor_for(init_2, print)
    jsr init_2
    jsr main
    rts
}
init_2: {
    // SCREEN = (char*)0x0400
    lda #<$400
    sta.z SCREEN
    lda #>$400
    sta.z SCREEN+1
    // }
    rts
}
init_1: {
    // sym = '*'
    lda #'*'
    sta.z sym
    // }
    rts
}
main: {
    // print()
    jsr print
    // }
    rts
}
print: {
    // *SCREEN = sym
    lda.z sym
    ldy #0
    sta (SCREEN),y
    // }
    rts
}
