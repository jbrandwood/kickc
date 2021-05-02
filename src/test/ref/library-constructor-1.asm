// Demonstrates Library Constructor Functionality
// #pragma constructor_for() declares named constructors for other symbols
  // Commodore 64 PRG executable file
.file [name="library-constructor-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label my_value = 2
.segment Code
__start: {
    // volatile char my_value
    lda #0
    sta.z my_value
    // #pragma constructor_for(my_init, print)
    jsr my_init
    jsr main
    rts
}
my_init: {
    // my_value = '*'
    lda #'*'
    sta.z my_value
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
    // *SCREEN = my_value
    lda.z my_value
    sta SCREEN
    // }
    rts
}
