// Example of inline kickasm in a function
  // Commodore 64 PRG executable file
.file [name="inline-kasm-loop.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *(SCREEN+1000) = 0
    lda #0
    sta SCREEN+$3e8
    // kickasm
    lda #0
        .for (var i = 0; i < 1000; i++) {
            sta SCREEN+i
        }
    
    // }
    rts
}
