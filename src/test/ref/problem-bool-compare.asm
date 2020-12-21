// Test boolean comparison false!=false
// https://atariage.com/forums/topic/311788-kickc-optimizing-c-compiler-now-supports-atari-8bit-xlxe/?tab=comments#comment-4644101
  // Commodore 64 PRG executable file
.file [name="problem-bool-compare.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[1] = '*'
    lda #'*'
    sta SCREEN+1
    // }
    rts
}
