// Error where the compiler is reusing the same ZP for two byte* variables.
// SCREEN_1 and SCREEN_2 are both allocated to ZP: 4
// Problem is that outside main() scope statements have zero call-paths and then isStatementAllocationOverlapping() never checks liveranges
// CallPath code must be rewritten to use @begin as the outermost call instead of main()
  // Commodore 64 PRG executable file
.file [name="liverange-problem-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label MEM = 2
  .label SCREEN_1 = 6
  .label SCREEN_2 = 4
.segment Code
__start: {
    // byte* SCREEN_1 = malloc()
    lda #<$400
    sta.z MEM
    lda #>$400
    sta.z MEM+1
    jsr malloc
    // byte* SCREEN_1 = malloc()
    lda.z malloc.return
    sta.z malloc.return_1
    lda.z malloc.return+1
    sta.z malloc.return_1+1
    // byte* SCREEN_2 = malloc()
    jsr malloc
    // byte* SCREEN_2 = malloc()
    jsr main
    rts
}
malloc: {
    .label return = 4
    .label return_1 = 6
    // return ++MEM;
    inc.z MEM
    bne !+
    inc.z MEM+1
  !:
    lda.z MEM
    sta.z return
    lda.z MEM+1
    sta.z return+1
    // }
    rts
}
main: {
    // *SCREEN_1 = 0
    lda #0
    tay
    sta (SCREEN_1),y
    // *SCREEN_2 = 0
    sta (SCREEN_2),y
    // }
    rts
}
