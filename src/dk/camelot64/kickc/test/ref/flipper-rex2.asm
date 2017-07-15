BBEGIN:
  jsr prepare
B2_from_BBEGIN:
  // (byte) c#2 = (byte) 25  // xby=coby1
  ldx #25
  jmp B2
B2_from_B20:
  // (byte) c#2 = (byte) 25  // xby=coby1
  ldx #25
B2_from_B6:
  // (byte) c#2 = (byte) c#1  // register copy 
B2:
B3:
  // (byte~) $1 ← * (word) 53266  //  aby=_star_cowo1
  lda 53266
  // if((byte~) $1!=(byte) 254) goto @3  //  aby_neq_coby1_then_la1
  cmp #254
  bne B3
B4:
  // (byte~) $3 ← * (word) 53266  //  aby=_star_cowo1
  lda 53266
  // if((byte~) $3!=(byte) 255) goto @4  //  aby_neq_coby1_then_la1
  cmp #255
  bne B4
B6:
  // (byte) c#1 ← -- (byte) c#2  //  xby=_dec_xby
  dex
  // if((byte) c#1!=(byte) 0) goto @2  //  xby_neq_0_then_la1
  cpx #0
  bne B2_from_B6
B7:
  jsr flip
B19:
  jsr plot
B20:
  // if(true) goto @2  //  true_then_la1
  jmp B2_from_B20
BEND:
plot:
plot__B1_from_plot:
  // (byte) plot::y#2 = (byte) 16  // zpby1=coby1
  lda #16
  sta 100
  // (byte*) plot::line#2 = (word) 1236  // zpptrby1=cowo1
  lda #<1236
  sta 101
  lda #>1236
  sta 101+1
  // (byte) plot::i#3 = (byte) 0  // xby=coby1
  ldx #0
plot__B1_from_B15:
  // (byte) plot::y#2 = (byte) plot::y#0  // register copy 
  // (byte*) plot::line#2 = (byte*) plot::line#0  // register copy 
  // (byte) plot::i#3 = (byte) plot::i#0  // register copy 
plot__B1:
plot__B2_from_B1:
  // (byte) plot::x#2 = (byte) 0  // yby=coby1
  ldy #0
  // (byte) plot::i#2 = (byte) plot::i#3  // register copy 
plot__B2_from_B2:
  // (byte) plot::x#2 = (byte) plot::x#0  // register copy 
  // (byte) plot::i#2 = (byte) plot::i#0  // register copy 
plot__B2:
  // (byte~) plot::$3 ← (word) 4096 *idx (byte) plot::i#2  //  aby=cowo1_staridx_xby
  lda 4096,x
  // *((byte*) plot::line#2 + (byte) plot::x#2) ← (byte~) plot::$3  //  ptr_zpptrby1_yby=aby
  sta (101),y
  // (byte) plot::i#0 ← ++ (byte) plot::i#2  //  xby=_inc_xby
  inx
  // (byte) plot::x#0 ← ++ (byte) plot::x#2  //  yby=_inc_yby
  iny
  // if((byte) plot::x#0<(byte) 16) goto plot::@2  //  yby_lt_coby1_then_la1
  cpy #16
  bcc plot__B2_from_B2
B15:
  // (byte*) plot::line#0 ← (byte*) plot::line#2 + (byte) 40  //  zpptrby1=zpptrby1_plus_coby1
  lda 101
  clc
  adc #40
  sta 101
  bcc !+
  inc 101+1
!:
  // (byte) plot::y#0 ← -- (byte) plot::y#2  //  zpby1=_dec_zpby1
  dec 100
  // if((byte) plot::y#0!=(byte) 0) goto plot::@1  //  zpby1_neq_0_then_la1
  lda 100
  bne plot__B1_from_B15
plot__Breturn:
  rts
flip:
flip__B1_from_flip:
  // (byte) flip::r#2 = (byte) 16  // zpby1=coby1
  lda #16
  sta 104
  // (byte) flip::dstIdx#5 = (byte) 15  // yby=coby1
  ldy #15
  // (byte) flip::srcIdx#3 = (byte) 0  // xby=coby1
  ldx #0
flip__B1_from_B11:
  // (byte) flip::r#2 = (byte) flip::r#0  // register copy 
  // (byte) flip::dstIdx#5 = (byte) flip::dstIdx#1  // register copy 
  // (byte) flip::srcIdx#3 = (byte) flip::srcIdx#0  // register copy 
flip__B1:
flip__B2_from_B1:
  // (byte) flip::dstIdx#3 = (byte) flip::dstIdx#5  // register copy 
  // (byte) flip::srcIdx#2 = (byte) flip::srcIdx#3  // register copy 
  // (byte) flip::c#2 = (byte) 16  // zpby1=coby1
  lda #16
  sta 103
flip__B2_from_B2:
  // (byte) flip::dstIdx#3 = (byte) flip::dstIdx#0  // register copy 
  // (byte) flip::srcIdx#2 = (byte) flip::srcIdx#0  // register copy 
  // (byte) flip::c#2 = (byte) flip::c#0  // register copy 
flip__B2:
  // (byte~) flip::$0 ← (word) 4096 *idx (byte) flip::srcIdx#2  //  aby=cowo1_staridx_xby
  lda 4096,x
  // *((word) 4352 + (byte) flip::dstIdx#3) ← (byte~) flip::$0  //  ptr_cowo1_yby=aby
  sta 4352,y
  // (byte) flip::srcIdx#0 ← ++ (byte) flip::srcIdx#2  //  xby=_inc_xby
  inx
  // (byte) flip::dstIdx#0 ← (byte) flip::dstIdx#3 + (byte) 16  //  yby=yby_plus_coby1
  tya
  clc
  adc #16
  tay
  // (byte) flip::c#0 ← -- (byte) flip::c#2  //  zpby1=_dec_zpby1
  dec 103
  // if((byte) flip::c#0!=(byte) 0) goto flip::@2  //  zpby1_neq_0_then_la1
  lda 103
  bne flip__B2_from_B2
B11:
  // (byte) flip::dstIdx#1 ← -- (byte) flip::dstIdx#0  //  yby=_dec_yby
  dey
  // (byte) flip::r#0 ← -- (byte) flip::r#2  //  zpby1=_dec_zpby1
  dec 104
  // if((byte) flip::r#0!=(byte) 0) goto flip::@1  //  zpby1_neq_0_then_la1
  lda 104
  bne flip__B1_from_B11
flip__B3_from_B11:
  // (byte) flip::i#2 = (byte) 0  // xby=coby1
  ldx #0
flip__B3_from_B3:
  // (byte) flip::i#2 = (byte) flip::i#1  // register copy 
flip__B3:
  // (byte~) flip::$4 ← (word) 4352 *idx (byte) flip::i#2  //  aby=cowo1_staridx_xby
  lda 4352,x
  // *((word) 4096 + (byte) flip::i#2) ← (byte~) flip::$4  //  ptr_cowo1_xby=aby
  sta 4096,x
  // (byte) flip::i#1 ← ++ (byte) flip::i#2  //  xby=_inc_xby
  inx
  // if((byte) flip::i#1!=(byte) 0) goto flip::@3  //  xby_neq_0_then_la1
  cpx #0
  bne flip__B3_from_B3
flip__Breturn:
  rts
prepare:
prepare__B1_from_prepare:
  // (byte) prepare::i#2 = (byte) 0  // xby=coby1
  ldx #0
prepare__B1_from_B1:
  // (byte) prepare::i#2 = (byte) prepare::i#0  // register copy 
prepare__B1:
  // *((word) 4096 + (byte) prepare::i#2) ← (byte) prepare::i#2  //  ptr_cowo1_xby=xby
  txa
  sta 4096,x
  // (byte) prepare::i#0 ← ++ (byte) prepare::i#2  //  xby=_inc_xby
  inx
  // if((byte) prepare::i#0!=(byte) 0) goto prepare::@1  //  xby_neq_0_then_la1
  cpx #0
  bne prepare__B1_from_B1
prepare__Breturn:
  rts
