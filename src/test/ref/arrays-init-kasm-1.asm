// Test initializing array using KickAssembler
// Place array at hardcoded address
  // Commodore 64 PRG executable file
.file [name="arrays-init-kasm-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = SINTAB[0]
    lda SINTAB
    sta SCREEN
    // }
    rts
}
.segment Data
.pc = $1000 "SINTAB"
// Sine table at an absolute address in memory
SINTAB:
.fill 256, 128 + 128*sin(i*2*PI/256)

