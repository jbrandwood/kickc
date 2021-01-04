// Test declaring a variable as register on a specific ZP address
  // Commodore 64 PRG executable file
.file [name="var-register-zp.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    .label j = 4
    .label __4 = 6
    .label k = 6
    // i=0
    lda #0
    sta.z i
    // j=0
    sta.z j
    sta.z j+1
  __b1:
    // while(i<4)
    lda.z i
    cmp #4
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = j++
    lda.z i
    asl
    tay
    lda.z j
    sta SCREEN,y
    lda.z j+1
    sta SCREEN+1,y
    // SCREEN[i++] = j++;
    inc.z i
    inc.z j
    bne !+
    inc.z j+1
  !:
    // (int)i*2
    lda.z i
    sta.z __4
    lda #0
    sta.z __4+1
    // k = (int)i*2
    asl.z k
    rol.z k+1
    // SCREEN[i++] = k
    lda.z i
    asl
    tay
    lda.z k
    sta SCREEN,y
    lda.z k+1
    sta SCREEN+1,y
    // SCREEN[i++] = k;
    inc.z i
    jmp __b1
}
