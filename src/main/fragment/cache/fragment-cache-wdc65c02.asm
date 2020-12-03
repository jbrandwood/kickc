//KICKC FRAGMENT CACHE 106673312a 1066734e54
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2_plus_1
lda {z2}
inc
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
//FRAGMENT vbuz1=vbuaa_plus_1
inc
sta {z1}
//FRAGMENT vbuz1=vbuxx_plus_1
inx
stx {z1}
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT vbuz1=vbuyy_plus_1
iny
sty {z1}
//FRAGMENT vbuaa=vbuz1_plus_1
lda {z1}
inc
//FRAGMENT vbuaa=vbuaa_plus_1
inc
//FRAGMENT vbuaa=vbuxx_plus_1
txa
inc
//FRAGMENT vbuaa=vbuyy_plus_1
tya
inc
//FRAGMENT vbuxx=vbuz1_plus_1
ldx {z1}
inx
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuxx=vbuaa_plus_1
tax
inx
//FRAGMENT vbuxx=vbuxx_plus_1
inx
//FRAGMENT vbuxx=vbuyy_plus_1
tya
inc
tax
//FRAGMENT vbuyy=vbuz1_plus_1
ldy {z1}
iny
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy=vbuaa_plus_1
tay
iny
//FRAGMENT vbuyy=vbuxx_plus_1
txa
inc
tay
//FRAGMENT vbuyy=vbuyy_plus_1
iny
