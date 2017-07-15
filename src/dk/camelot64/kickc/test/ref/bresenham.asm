BBEGIN:
B1_from_BBEGIN:
  // (byte) y#2 = (byte) 0  // zpby1=coby1
  lda #0
  sta 14
  // (byte) e#3 = (byte) 12  // zpby1=coby1
  lda #12
  sta 13
  // (byte) x#2 = (byte) 0  // zpby1=coby1
  lda #0
  sta 12
  // (byte*) cursor#3 = (word) 1024  // zpptrby1=cowo1
  lda #<1024
  sta 10
  lda #>1024
  sta 10+1
  jmp B1
B1_from_B3:
  // (byte) y#2 = (byte) y#5  // zpby1=zpby2
  lda 18
  sta 14
  // (byte) e#3 = (byte) e#5  // zpby1=zpby2
  lda 15
  sta 13
  // (byte) x#2 = (byte) x#1  // zpby1=zpby2
  lda 2
  sta 12
  // (byte*) cursor#3 = (byte*) cursor#5  // zpptrby1=zpptrby2
  lda 16
  sta 10
  lda 16+1
  sta 10+1
B1:
  // *((byte*) cursor#3) ← (byte) 81  //  zpiby1=coby1
  ldy #0
  lda #81
  sta (10),y
  // (byte) x#1 ← (byte) x#2 + (byte) 1  //  zpby1=zpby2_plus_1
  lda 12
  clc
  adc #1
  sta 2
  // (byte*) cursor#1 ← (byte*) cursor#3 + (byte) 1  //  zpptrby1=zpptrby2_plus_1
  lda 10
  clc
  adc #1
  sta 3
  lda 10+1
  adc #0
  sta 3+1
  // (byte) e#1 ← (byte) e#3 + (byte) 24  //  zpby1=zpby2_plus_coby1
  lda 13
  clc
  adc #24
  sta 5
  // if((byte) 39<(byte) e#1) goto @2  //  coby1_lt_zpby1_then_la1
  lda #39
  cmp 5
  bcc B2
B3_from_B1:
  // (byte) y#5 = (byte) y#2  // zpby1=zpby2
  lda 14
  sta 18
  // (byte*) cursor#5 = (byte*) cursor#1  // zpptrby1=zpptrby2
  lda 3
  sta 16
  lda 3+1
  sta 16+1
  // (byte) e#5 = (byte) e#1  // zpby1=zpby2
  lda 5
  sta 15
B3:
  // if((byte) x#1<(byte) 40) goto @1  //  zpby1_lt_coby1_then_la1
  lda 2
  cmp #40
  bcc B1_from_B3
BEND:
B2:
  // (byte) y#1 ← (byte) y#2 + (byte) 1  //  zpby1=zpby2_plus_1
  lda 14
  clc
  adc #1
  sta 6
  // (byte*) cursor#2 ← (byte*) cursor#1 + (byte) 40  //  zpptrby1=zpptrby2_plus_coby1
  lda #40
  clc
  adc 3
  sta 7
  lda #0
  adc 3+1
  sta 7+1
  // (byte) e#2 ← (byte) e#1 - (byte) 39  //  zpby1=zpby2_minus_coby1
  lda 5
  sec
  sbc #39
  sta 9
B3_from_B2:
  // (byte) y#5 = (byte) y#1  // zpby1=zpby2
  lda 6
  sta 18
  // (byte*) cursor#5 = (byte*) cursor#2  // zpptrby1=zpptrby2
  lda 7
  sta 16
  lda 7+1
  sta 16+1
  // (byte) e#5 = (byte) e#2  // zpby1=zpby2
  lda 9
  sta 15
  jmp B3
