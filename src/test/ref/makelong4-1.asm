// Test MAKELONG4() with constants
  // Commodore 64 PRG executable file
.file [name="makelong4-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = MAKELONG4(1, 2, 3, 4)
    lda #<1*$1000000+2*$10000+3*$100+4
    sta SCREEN
    lda #>1*$1000000+2*$10000+3*$100+4
    sta SCREEN+1
    lda #<1*$1000000+2*$10000+3*$100+4>>$10
    sta SCREEN+2
    lda #>1*$1000000+2*$10000+3*$100+4>>$10
    sta SCREEN+3
    // }
    rts
}
