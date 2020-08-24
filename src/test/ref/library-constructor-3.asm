// Demonstrates Library Constructor Functionality
// Multiple #pragma constructor_for() constructors
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label sym = 2
  .label SCREEN = 3
__start: {
    // sym
    lda #0
    sta.z sym
    // SCREEN
    sta.z SCREEN
    sta.z SCREEN+1
    // #pragma constructor_for(init_1, print)
    //#pragma constructor
    jsr init_1
    // #pragma constructor_for(init_2, print)
    //#pragma constructor
    jsr init_2
    jsr main
    rts
}
init_2: {
    // SCREEN = 0x0400
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
