.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label wp = w
    .label w = 2
    lda #<$d03
    sta w
    lda #>$d03
    sta w+1
    lda wp
    sta screen
    lda wp+1
    sta screen+1
    lda #<$210c
    sta wp
    lda #>$210c
    sta wp+1
    lda wp
    sta screen+2
    lda wp+1
    sta screen+3
    rts
}
