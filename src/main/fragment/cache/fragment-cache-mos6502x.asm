//KICKC FRAGMENT CACHE 11327739d8 113277581a
//FRAGMENT _stackpushbyte_=vbuc1
lda #{c1}
pha
//FRAGMENT _stackpullbyte_1
pla
//FRAGMENT vbuz1=_stackpullbyte_
pla
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT vbuz1=vbuz2_plus_vbuz3
lda {z2}
clc
adc {z3}
sta {z1}
//FRAGMENT _stackidxbyte_vbuc1=vbuz1
lda {z1}
tsx
sta STACK_BASE+{c1},x
//FRAGMENT vbuaa=_stackpullbyte_
pla
//FRAGMENT vbuxx=_stackpullbyte_
pla
tax
//FRAGMENT vbuyy=_stackpullbyte_
pla
tay
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
//FRAGMENT vbuxx=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
tax
//FRAGMENT vbuyy=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
tay
//FRAGMENT vbuaa=vbuz1_plus_vbuz2
lda {z1}
clc
adc {z2}
//FRAGMENT vbuxx=vbuz1_plus_vbuz2
lda {z1}
clc
adc {z2}
tax
//FRAGMENT vbuyy=vbuz1_plus_vbuz2
lda {z1}
clc
adc {z2}
tay
//FRAGMENT vbuz1=vbuyy_plus_vbuz2
tya
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_vbuz1
tya
clc
adc {z1}
//FRAGMENT vbuxx=vbuyy_plus_vbuz1
tya
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuyy_plus_vbuz1
tya
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuz2_plus_vbuaa
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_vbuaa
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus_vbuaa
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_plus_vbuaa
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuyy_plus_vbuaa
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_vbuaa
sty $ff
clc
adc $ff
//FRAGMENT vbuxx=vbuyy_plus_vbuaa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuyy_plus_vbuaa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbuz1=vbuz2_plus_vbuxx
txa
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_vbuxx
txa
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus_vbuxx
txa
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_plus_vbuxx
txa
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuyy_plus_vbuxx
txa
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_vbuxx
txa
sty $ff
clc
adc $ff
//FRAGMENT vbuxx=vbuyy_plus_vbuxx
txa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuyy_plus_vbuxx
txa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbuz1=vbuz2_plus_vbuyy
tya
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_vbuyy
tya
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus_vbuyy
tya
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_plus_vbuyy
tya
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuyy_plus_vbuyy
tya
asl
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_vbuyy
tya
asl
//FRAGMENT vbuxx=vbuyy_plus_vbuyy
tya
asl
tax
//FRAGMENT vbuyy=vbuyy_plus_vbuyy
tya
asl
tay
//FRAGMENT _stackidxbyte_vbuc1=vbuaa
tsx
sta STACK_BASE+{c1},x
//FRAGMENT _stackidxbyte_vbuc1=vbuxx
txa
tsx
sta STACK_BASE+{c1},x
//FRAGMENT _stackidxbyte_vbuc1=vbuyy
tya
tsx
sta STACK_BASE+{c1},x
//FRAGMENT vbuz1=vbuaa_plus_vbuz2
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_vbuz1
clc
adc {z1}
//FRAGMENT vbuxx=vbuaa_plus_vbuz1
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuaa_plus_vbuz1
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuxx_plus_vbuz2
txa
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_vbuz1
txa
clc
adc {z1}
//FRAGMENT vbuxx=vbuxx_plus_vbuz1
txa
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuxx_plus_vbuz1
txa
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuaa_plus_vbuaa
asl
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_vbuaa
asl
//FRAGMENT vbuxx=vbuaa_plus_vbuaa
asl
tax
//FRAGMENT vbuyy=vbuaa_plus_vbuaa
asl
tay
//FRAGMENT vbuz1=vbuxx_plus_vbuaa
stx $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_vbuaa
stx $ff
clc
adc $ff
//FRAGMENT vbuxx=vbuxx_plus_vbuaa
stx $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuxx_plus_vbuaa
stx $ff
clc
adc $ff
tay
//FRAGMENT vbuz1=vbuaa_plus_vbuxx
stx $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_vbuxx
stx $ff
clc
adc $ff
//FRAGMENT vbuxx=vbuaa_plus_vbuxx
stx $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuaa_plus_vbuxx
stx $ff
clc
adc $ff
tay
//FRAGMENT vbuz1=vbuxx_plus_vbuxx
txa
asl
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_vbuxx
txa
asl
//FRAGMENT vbuxx=vbuxx_plus_vbuxx
txa
asl
tax
//FRAGMENT vbuyy=vbuxx_plus_vbuxx
txa
asl
tay
//FRAGMENT vbuz1=vbuaa_plus_vbuyy
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_vbuyy
sty $ff
clc
adc $ff
//FRAGMENT vbuxx=vbuaa_plus_vbuyy
sty $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuaa_plus_vbuyy
sty $ff
clc
adc $ff
tay
//FRAGMENT vbuz1=vbuxx_plus_vbuyy
txa
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_vbuyy
txa
sty $ff
clc
adc $ff
//FRAGMENT vbuxx=vbuxx_plus_vbuyy
txa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuxx_plus_vbuyy
txa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuaa=vbuyy
tya
