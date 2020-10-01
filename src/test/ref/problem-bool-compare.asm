// Test boolean comparison false!=false
// https://atariage.com/forums/topic/311788-kickc-optimizing-c-compiler-now-supports-atari-8bit-xlxe/?tab=comments#comment-4644101
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // SCREEN[1] = '*'
    lda #'*'
    sta SCREEN+1
    // }
    rts
}
