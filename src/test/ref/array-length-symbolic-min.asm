.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SZ = $f
  jsr main
main: {
    ldx #0
  b1:
    txa
    sta items,x
    inx
    cpx #SZ+1
    bne b1
    rts
}
  items: .fill SZ, 0
