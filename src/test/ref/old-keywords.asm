// Test that bytes and cycles are not keywords
  // Commodore 64 PRG executable file
.file [name="old-keywords.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label cycles = 3
    .label bytes = 4
    .label uses = 5
    .label clobbers = 6
    .label resource = 7
    .label i = 2
    lda #0
    sta.z resource
    sta.z clobbers
    sta.z uses
    sta.z bytes
    tay
    sta.z cycles
    sta.z i
  __b1:
    // for(char i=0;i<20;i++)
    lda.z i
    cmp #$14
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[j++] = cycles
    lda.z cycles
    sta SCREEN,y
    // SCREEN[j++] = cycles;
    tya
    tax
    inx
    // SCREEN[j++] = bytes
    lda.z bytes
    sta SCREEN,x
    // SCREEN[j++] = bytes;
    inx
    // SCREEN[j++] = uses
    lda.z uses
    sta SCREEN,x
    // SCREEN[j++] = uses;
    inx
    // SCREEN[j++] = clobbers
    lda.z clobbers
    sta SCREEN,x
    // SCREEN[j++] = clobbers;
    inx
    // SCREEN[j++] = resource
    lda.z resource
    sta SCREEN,x
    // SCREEN[j++] = resource;
    txa
    tay
    iny
    // cycles +=1
    inc.z cycles
    // bytes +=2
    lda.z bytes
    clc
    adc #2
    sta.z bytes
    // uses +=3
    lax.z uses
    axs #-[3]
    stx.z uses
    // clobbers +=4
    lax.z clobbers
    axs #-[4]
    stx.z clobbers
    // resource +=5
    lax.z resource
    axs #-[5]
    stx.z resource
    // for(char i=0;i<20;i++)
    inc.z i
    jmp __b1
}
