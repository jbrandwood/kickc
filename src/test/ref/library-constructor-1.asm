// Demonstrates Library Constructor Functionality
// #pragma constructor_for() declares named constructors for other symbols
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label my_value = 2
__start: {
    // my_value
    lda #0
    sta.z my_value
    // #pragma constructor_for(my_init, print)
    //#pragma constructor
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
