// Example of inline kickasm in a function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #0
    sta SCREEN+$3e8
    lda #0
        .for (var i = 0; i < 1000; i++) {
            sta SCREEN+i
        }
    
    rts
}
