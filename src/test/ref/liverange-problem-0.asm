// Error where the compiler is reusing the same ZP for two byte* variables.
// SCREEN_1 and SCREEN_2 are both allocated to ZP: 4
// Problem is that outside main() scope statements have zero call-paths and then isStatementAllocationOverlapping() never checks liveranges
// CallPath code must be rewritten to use @begin as the outermost call instead of main()
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label MEM = 2
  .label SCREEN_1 = 4
  .label SCREEN_2 = 6
__b1:
  lda #<$400
  sta.z MEM
  lda #>$400
  sta.z MEM+1
  jsr malloc
  lda.z malloc.return
  sta.z malloc.return_1
  lda.z malloc.return+1
  sta.z malloc.return_1+1
  jsr malloc
  jsr main
  rts
main: {
    lda #0
    tay
    sta (SCREEN_1),y
    sta (SCREEN_2),y
    rts
}
malloc: {
    .label return = 6
    .label return_1 = 4
    inc.z MEM
    bne !+
    inc.z MEM+1
  !:
    lda.z MEM
    sta.z return
    lda.z MEM+1
    sta.z return+1
    rts
}
