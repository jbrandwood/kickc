// Error where the compiler is reusing the same ZP for two byte* variables.
// SCREEN_1 and SCREEN_2 are both allocated to ZP: 4
// Problem is that outside main() scope statements have zero call-paths and then isStatementAllocationOverlapping() never checks liveranges
// CallPath code must be rewritten to use @begin as the outermost call instead of main()
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label MEM = 2
  .label SCREEN_1 = 4
  .label SCREEN_2 = 6
bbegin:
  lda #<$400
  sta MEM
  lda #>$400
  sta MEM+1
  jsr malloc
  lda malloc.return
  sta malloc.return_2
  lda malloc.return+1
  sta malloc.return_2+1
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
    .label return_2 = 4
    inc MEM
    bne !+
    inc MEM+1
  !:
    lda MEM
    sta return
    lda MEM+1
    sta return+1
    rts
}
