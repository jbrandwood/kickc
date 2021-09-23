// Test MAKELONG()
  // Commodore 64 PRG executable file
.file [name="makelong-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label i = 4
    .label hi = 2
    .label lo = 8
    lda #<0
    sta.z lo
    sta.z lo+1
  __b1:
    // for(unsigned int lo=0;lo<100;lo++)
    lda.z lo+1
    bne !+
    lda.z lo
    cmp #$64
    bcc __b4
  !:
    // }
    rts
  __b4:
    lda #<0
    sta.z hi
    sta.z hi+1
  __b2:
    // for(unsigned int hi=0;hi<100;hi++)
    lda.z hi+1
    bne !+
    lda.z hi
    cmp #$64
    bcc __b3
  !:
    // for(unsigned int lo=0;lo<100;lo++)
    inc.z lo
    bne !+
    inc.z lo+1
  !:
    jmp __b1
  __b3:
    // unsigned long i = MAKELONG(hi, lo)
    lda.z hi
    sta.z i+2
    lda.z hi+1
    sta.z i+3
    lda.z lo
    sta.z i
    lda.z lo+1
    sta.z i+1
    // *SCREEN = i
    lda.z i
    sta SCREEN
    lda.z i+1
    sta SCREEN+1
    lda.z i+2
    sta SCREEN+2
    lda.z i+3
    sta SCREEN+3
    // for(unsigned int hi=0;hi<100;hi++)
    inc.z hi
    bne !+
    inc.z hi+1
  !:
    jmp __b2
}
