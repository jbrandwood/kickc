.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const HOSTS = 0
  .const DEVICES = 1
  .label OUT = $8000
main: {
    .label ss = substate
    .label substate = 2
    // substate = HOSTS
    lda #HOSTS
    sta.z substate
    // *ss == DEVICES ? ORIGIN_DEVICE_SLOTS : ORIGIN_HOST_SLOTS
    lda #DEVICES
    cmp.z ss
    beq __b1
    lda #2
    jmp __b2
  __b1:
    // *ss == DEVICES ? ORIGIN_DEVICE_SLOTS : ORIGIN_HOST_SLOTS
    lda #$d
  __b2:
    // *OUT = x
    sta OUT
    // }
    rts
}
