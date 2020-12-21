// bubbles64 - Q&D C64 port of the bubbles demo from vbcc6502's NES exmaples
// Coded by Lazycow
// Source https://www.lemon64.com/forum/viewtopic.php?t=75283&start=15
  // Commodore 64 PRG executable file
.file [name="bubbles64.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const lfMC = $10
  .const rfDrop = $fe
  .const maxSprites = $20
  .const maxSprImages = 8
  .const maxC64Images = $100
  .const sprOff = $40
  .const maxDrawObjects = $18
  .const F = 3
.segment Code
//
//
main: {
    .label __27 = $10
    .label __28 = $12
    // main loop
    .label c = 2
    // main loop
    .label c_1 = 4
    .label d1 = $14
    // setup bubbles
    .label type = 6
    // main loop
    .label c_2 = 7
    .label d = $b
    .label i = $a
    .label objects = $d
    // 1 == preallocate 20 sprites (only for better benchmarking)
    //  0 == allocate sprites on the fly (prefered)
    .label oCount = $e
    .label stopIt = 9
    .label __109 = $1a
    .label __110 = $1c
    .label __111 = $16
    .label __112 = $18
    // lcSprMapTab[0]=sprOff+0
    // setup sprite images
    lda #sprOff
    sta lcSprMapTab
    // lcSprMapTab[1]=sprOff+1
    lda #sprOff+1
    sta lcSprMapTab+1
    // lcSprMapTab[2]=sprOff+2
    lda #sprOff+2
    sta lcSprMapTab+2
    // lcSprMapTab[3]=sprOff+3
    lda #sprOff+3
    sta lcSprMapTab+3
    // lcSprMapTab[4]=sprOff+4
    lda #sprOff+4
    sta lcSprMapTab+4
    // lcSprMapTab[5]=sprOff+5
    lda #sprOff+5
    sta lcSprMapTab+5
    // lcSprColTab[sprOff+1]=10|lfMC
    lda #$a|lfMC
    sta lcSprColTab+sprOff+1
    // lcSprColTab[sprOff+0]=lcSprColTab[sprOff+1]=10|lfMC
    // setup sprite colors + flags
    sta lcSprColTab+sprOff
    // lcSprColTab[sprOff+3]=5|lfMC
    lda #5|lfMC
    sta lcSprColTab+sprOff+3
    // lcSprColTab[sprOff+2]=lcSprColTab[sprOff+3]=5|lfMC
    sta lcSprColTab+sprOff+2
    // lcSprColTab[sprOff+5]=14|lfMC
    lda #$e|lfMC
    sta lcSprColTab+sprOff+5
    // lcSprColTab[sprOff+4]=lcSprColTab[sprOff+5]=14|lfMC
    sta lcSprColTab+sprOff+4
    ldx #0
  __b2:
    // for (i=0;i<maxSprites+1;i+=1)
    cpx #maxSprites+1
    bcs !__b3+
    jmp __b3
  !__b3:
    ldx #0
  // clear (i)ndex (t)able
  __b4:
    // for (i=0;i<maxSprites  ;i+=1)
    cpx #maxSprites
    bcs !__b5+
    jmp __b5
  !__b5:
    lda #<0
    sta.z c
    sta.z c+1
  __b6:
    // for (c=0;c<1000;c+=1)
    lda.z c+1
    cmp #>$3e8
    bcs !__b7+
    jmp __b7
  !__b7:
    bne !+
    lda.z c
    cmp #<$3e8
    bcs !__b7+
    jmp __b7
  !__b7:
  !:
    // *onePtr=0x33
    // install IRQ
    lda #$33
    sta 1
    lda #<0
    sta.z c_1
    sta.z c_1+1
  // now it's save to change "01"
  __b8:
    // for (c=0;c<2040;c+=1)
    lda.z c_1+1
    cmp #>$7f8
    bcs !__b9+
    jmp __b9
  !__b9:
    bne !+
    lda.z c_1
    cmp #<$7f8
    bcs !__b9+
    jmp __b9
  !__b9:
  !:
    // *onePtr=0x35
    lda #$35
    sta 1
    // vicPtr[0xd02]|=3
    lda #3
    ora $d000+$d02
    sta $d000+$d02
    // vicPtr[0xd00]&=~3ub
    lda #3^$ff
    and $d000+$d00
    sta $d000+$d00
    // scrPtr[997]='P'-'A'+1
    lda #'P'-'A'+1
    sta $e000+$3e5
    // scrPtr[998]='A'-'A'+1
    lda #1
    sta $e000+$3e6
    // scrPtr[999]='L'-'A'+1
    lda #'L'-'A'+1
    sta $e000+$3e7
    // scrPtr[975+0]='B'-'A'+1
    lda #'B'-'A'+1
    sta $e000+$3cf
    // scrPtr[975+1]='U'-'A'+1
    lda #'U'-'A'+1
    sta $e000+$3cf+1
    // scrPtr[975+2]='B'-'A'+1
    lda #'B'-'A'+1
    sta $e000+$3cf+2
    // scrPtr[975+3]='B'-'A'+1
    sta $e000+$3cf+3
    // scrPtr[975+4]='L'-'A'+1
    lda #'L'-'A'+1
    sta $e000+$3cf+4
    // scrPtr[975+5]='E'-'A'+1
    lda #'E'-'A'+1
    sta $e000+$3cf+5
    // scrPtr[975+6]='S'-'A'+1
    lda #'S'-'A'+1
    sta $e000+$3cf+6
    // scrPtr[975+7]=':'
    lda #':'
    sta $e000+$3cf+7
    lda #0
    sta.z type
    tax
  __b12:
    // for (i=0;i<maxDrawObjects;i+=1)
    cpx #maxDrawObjects
    bcs !__b13+
    jmp __b13
  !__b13:
    lda #<0
    sta.z oCount
    sta.z oCount+1
    sta.z stopIt
    sta.z c_2
    sta.z c_2+1
    sta.z objects
  __b16:
    lda #<dTab
    sta.z d
    lda #>dTab
    sta.z d+1
    lda #0
    sta.z i
  // move objects
  __b17:
    // for (i=0,d=dTab; i<objects ;i+=1,++d)
    lda.z i
    cmp.z objects
    bcs !__b18+
    jmp __b18
  !__b18:
    // c+=1
    // activate new bubble?
    inc.z c_2
    bne !+
    inc.z c_2+1
  !:
    // if (c>=14)
    lda.z c_2+1
    bne !+
    lda.z c_2
    cmp #$e
    bcc __b36
  !:
    // if (0==stopIt && objects<maxDrawObjects)
    lda.z stopIt
    cmp #0
    bne __b11
    lda.z objects
    cmp #maxDrawObjects
    bcc __b31
    jmp __b36
  __b11:
    lda #<0
    sta.z c_2
    sta.z c_2+1
  __b36:
    // if (oCount>0)
    lda.z oCount
    bne !+
    lda.z oCount+1
    beq __b34
  !:
    // oCount-=1
    lda.z oCount
    sec
    sbc #1
    sta.z oCount
    lda.z oCount+1
    sbc #0
    sta.z oCount+1
  __b34:
    // if (oCount>2 && objects>0)
    lda.z oCount+1
    bne !+
    lda.z oCount
    cmp #2+1
    bcc __b35
  !:
    lda.z objects
    bne __b38
    jmp __b35
  __b38:
    // objects-=1
    dec.z objects
    // DelSprite(objects)
    ldx.z objects
    jsr DelSprite
    lda #<0
    sta.z oCount
    sta.z oCount+1
    lda #1
    sta.z stopIt
  __b35:
    // Print00(scr+(char*)983,objects)
    ldx.z objects
    jsr Print00
    jmp __b16
  __b31:
    // objects+=1
    inc.z objects
    // GetSprite()
    jsr GetSprite
    // GetSprite()
    // i=GetSprite()
    // if (0==preset && (i=GetSprite())<128)
    cpx #$80
    bcc __b32
    jmp __b36
  __b32:
    // AddSprite(i)
    jsr AddSprite
    // cmRY[i]=0
    lda #0
    sta cmRY,x
    // cmRF[i]=cmRY[i]=0
    lda cmRY,x
    sta cmRF,x
    // cmRX[i]=cmRF[i]=cmRY[i]=0
    lda cmRF,x
    sta cmRX,x
    // cmSI[i]=cmRX[i]=cmRF[i]=cmRY[i]=0
    lda cmRX,x
    sta cmSI,x
    jmp __b11
  __b18:
    // d->vx+=d->ax
    ldy #7
    lda (d),y
    ldy #5
    tax
    lda (d),y
    stx.z $ff
    clc
    adc.z $ff
    sta (d),y
    // if (d->vx<-32)
    lda (d),y
    sec
    sbc #-$20
    bvc !+
    eor #$80
  !:
    bpl !__b20+
    jmp __b20
  !__b20:
    // if (d->vx>32)
    ldy #5
    lda (d),y
    sec
    sbc #$20+1
    bvc !+
    eor #$80
  !:
    bmi __b21
    // d->ax=-1
    lda #-1
    ldy #7
    sta (d),y
  __b21:
    // if (d->y>248<<F)
    ldy #3
    lda #<$f8<<F
    cmp (d),y
    iny
    lda #>$f8<<F
    sbc (d),y
    bvc !+
    eor #$80
  !:
    bpl !__b22+
    jmp __b22
  !__b22:
  !e:
    // if (d->y<24<<F)
    ldy #3
    lda (d),y
    cmp #<$18<<F
    iny
    lda (d),y
    sbc #>$18<<F
    bvc !+
    eor #$80
  !:
    bpl __b23
    // d->vy=1<<F
    lda #1<<F
    ldy #6
    sta (d),y
  __b23:
    // d->x+=d->vx
    ldy #5
    lda (d),y
    sta.z $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    ldy #1
    clc
    lda (d),y
    adc.z $fe
    sta (d),y
    iny
    lda (d),y
    adc.z $fe
    sta (d),y
    // d->y+=d->vy
    ldy #6
    lda (d),y
    sta.z $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    ldy #3
    clc
    lda (d),y
    adc.z $fe
    sta (d),y
    iny
    lda (d),y
    adc.z $fe
    sta (d),y
    // if (cmRF[i]<128)
    ldy.z i
    lda cmRF,y
    cmp #$80
    bcs __b24
    // cmSI[i]=d->s
    ldy #0
    lda (d),y
    ldy.z i
    sta cmSI,y
    // d->x>>F
    ldx #F
    ldy #1
    lda (d),y
    sta.z __27
    iny
    lda (d),y
    sta.z __27+1
    cpx #0
    beq !e+
  !:
    lda.z __27+1
    cmp #$80
    ror.z __27+1
    ror.z __27
    dex
    bne !-
  !e:
    // cmRX[i]=(ubyte)(d->x>>F)
    ldy.z i
    lda.z __27
    sta cmRX,y
    // d->y>>F
    ldx #F
    ldy #3
    lda (d),y
    sta.z __28
    iny
    lda (d),y
    sta.z __28+1
    cpx #0
    beq !e+
  !:
    lda.z __28+1
    cmp #$80
    ror.z __28+1
    ror.z __28
    dex
    bne !-
  !e:
    // cmRY[i]=(ubyte)(d->y>>F)
    ldy.z i
    lda.z __28
    sta cmRY,y
  __b24:
    // for (i=0,d=dTab; i<objects ;i+=1,++d)
    lda #9
    clc
    adc.z d
    sta.z d
    bcc !+
    inc.z d+1
  !:
    // i+=1
    inc.z i
    jmp __b17
  __b22:
    // d->vy=-1<<F
    lda #-1<<F
    ldy #6
    sta (d),y
    jmp __b23
  __b20:
    // d->ax=1
    lda #1
    ldy #7
    sta (d),y
    jmp __b21
  __b13:
    // &dTab[i]
    txa
    asl
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    // d=&dTab[i]
    clc
    adc #<dTab
    sta.z d1
    lda #>dTab
    adc #0
    sta.z d1+1
    // d->s=type
    lda.z type
    ldy #0
    sta (d1),y
    // type+=1
    inc.z type
    // if (type>=6)
    lda.z type
    cmp #6
    bcc __b14
    tya
    sta.z type
  __b14:
    // d->x=112<<F
    ldy #1
    lda #<$70<<F
    sta (d1),y
    iny
    lda #>$70<<F
    sta (d1),y
    // d->vx=(sbyte)i
    ldy #5
    txa
    sta (d1),y
    // d->ax=1
    lda #1
    ldy #7
    sta (d1),y
    // d->y=24<<F
    ldy #3
    lda #<$18<<F
    sta (d1),y
    iny
    lda #>$18<<F
    sta (d1),y
    // d->vy=1<<F
    lda #1<<F
    ldy #6
    sta (d1),y
    // d->ay=1
    lda #1
    ldy #8
    sta (d1),y
    // i+=1
    inx
    jmp __b12
  __b9:
    // chrPtr[c]=vicPtr[c]
    clc
    lda.z c_1
    adc #<$d000
    sta.z __111
    lda.z c_1+1
    adc #>$d000
    sta.z __111+1
    clc
    lda.z c_1
    adc #<$f800
    sta.z __112
    lda.z c_1+1
    adc #>$f800
    sta.z __112+1
    ldy #0
    lda (__111),y
    sta (__112),y
    // c+=1
    inc.z c_1
    bne !+
    inc.z c_1+1
  !:
    jmp __b8
  __b7:
    // scrPtr[c]=32
    clc
    lda.z c
    adc #<$e000
    sta.z __109
    lda.z c+1
    adc #>$e000
    sta.z __109+1
    lda #$20
    ldy #0
    sta (__109),y
    // colPtr[c]=14
    clc
    lda.z c
    adc #<$d800
    sta.z __110
    lda.z c+1
    adc #>$d800
    sta.z __110+1
    lda #$e
    sta (__110),y
    // c+=1
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b6
  __b5:
    // cmRF[i]=255
    lda #$ff
    sta cmRF,x
    // i+=1
    inx
    jmp __b4
  __b3:
    // cmIT[i]=255
    lda #$ff
    sta cmIT,x
    // i+=1
    inx
    jmp __b2
}
// DelSprite(byte register(X) sn)
DelSprite: {
    // cmRY[sn]=255
    // drop sprite, will be removed from IT in IRQ
    lda #$ff
    sta cmRY,x
    // cmRF[sn]=rfDrop
    lda #rfDrop
    sta cmRF,x
    // }
    rts
}
// Print00(byte register(X) v0)
Print00: {
    ldy #'0'
  __b1:
    // while (v>=10)
    cpx #$a
    bcs __b2
    // *p++=c
    sty $e000+$3d7
    ldy #'0'
  __b4:
    // while (v>=1)
    cpx #1
    bcs __b5
    // *p++=c
    sty $e000+$3d7+1
    // }
    rts
  __b5:
    // ++c;
    iny
    // v-=1
    dex
    jmp __b4
  __b2:
    // ++c;
    iny
    // v-=10
    txa
    axs #$a
    jmp __b1
}
// sprite support functions
//
GetSprite: {
    ldx #0
  __b1:
    // for (t0=0;t0<maxSprites;++t0)
    cpx #maxSprites
    bcc __b2
    ldx #$ff
    // }
    rts
  __b2:
    // if (cmRF[t0]>=rfDrop)
    lda cmRF,x
    cmp #rfDrop
    bcc __b3
    // cmRF[t0]=0
    lda #0
    sta cmRF,x
    rts
  __b3:
    // for (t0=0;t0<maxSprites;++t0)
    inx
    jmp __b1
}
// AddSprite(byte register(X) sn)
AddSprite: {
    // if (rfDrop==cmRF[sn])
    lda cmRF,x
    cmp #rfDrop
    beq __b1
    ldy #0
  __b2:
    // for
    // 		(t0=0;t0<maxSprites;t0+=1)
    cpy #maxSprites
    bcc __b3
    // }
    rts
  __b3:
    // if (cmIT[t0]>=128)
    lda cmIT,y
    cmp #$80
    bcc __b4
    // cmRF[sn]=0
    lda #0
    sta cmRF,x
    // cmIT[t0]=sn
    txa
    sta cmIT,y
    rts
  __b4:
    // t0+=1
    iny
    jmp __b2
  __b1:
    // cmRF[sn]=0
    lda #0
    sta cmRF,x
    rts
}
.segment Data
  lcSprMapTab: .fill maxSprImages, 0
  lcSprColTab: .fill maxC64Images, 0
  cmIT: .fill maxSprites+1, 0
  cmSI: .fill maxSprites, 0
  cmRX: .fill maxSprites, 0
  cmRY: .fill maxSprites, 0
  cmRF: .fill maxSprites, 0
  dTab: .fill 9*maxDrawObjects, 0
