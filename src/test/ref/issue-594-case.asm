  // Commodore 64 PRG executable file
.file [name="issue-594-case.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const HOSTS = 0
  .const DEVICES = 1
  .label OUT = $8000
.segment Code
main: {
    .label ss = substate
    .label substate = 2
    // SubState substate = HOSTS
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
