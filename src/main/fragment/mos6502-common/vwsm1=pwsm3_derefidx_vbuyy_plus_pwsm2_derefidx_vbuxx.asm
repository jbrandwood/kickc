lda {m2}
sta $fc
lda {m2}+1
sta $fd
lda {m3}
sta $fe
lda {m3}+1
sta $ff
iny
lda ($fe),y
pha
dey
lda ($fe),y
pha
txa
tay
pla
clc
adc ($fc),y
sta {m1}
iny
pla
adc ($fc),y
sta {m1}+1