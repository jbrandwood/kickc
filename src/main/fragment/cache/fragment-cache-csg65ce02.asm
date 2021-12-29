//KICKC FRAGMENT CACHE 13170826c8 1317084bc5
//FRAGMENT vbuzz=vbuc1
ldz #{c1}
//FRAGMENT vbuzz_lt_vbuc1_then_la1
cpz #{c1}
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbuzz=vbuzz
tza
tax
sta {c1},x
//FRAGMENT vbuzz=_inc_vbuzz
inz
//FRAGMENT vbsz1=_deref_pbsc1
lda {c1}
sta {z1}
//FRAGMENT vbsz1=_neg_vbsz2
lda {z2}
neg
sta {z1}
//FRAGMENT _deref_pbsc1=vbsz1
lda {z1}
sta {c1}
//FRAGMENT vbsz1=vbsz2_ror_2
lda {z2}
asr
asr
sta {z1}
//FRAGMENT vbsaa=_deref_pbsc1
lda {c1}
//FRAGMENT vbsxx=_deref_pbsc1
ldx {c1}
//FRAGMENT vbsz1=_neg_vbsaa
neg
sta {z1}
//FRAGMENT vbsz1=_neg_vbsxx
txa
neg
sta {z1}
//FRAGMENT vbsz1=_neg_vbsyy
tya
neg
sta {z1}
//FRAGMENT vbsz1=_neg_vbszz
tza
neg
sta {z1}
//FRAGMENT vbsaa=_neg_vbsz1
lda {z1}
neg
//FRAGMENT vbsaa=_neg_vbsaa
neg
//FRAGMENT vbsaa=_neg_vbsxx
txa
neg
//FRAGMENT vbsaa=_neg_vbsyy
tya
neg
//FRAGMENT vbsaa=_neg_vbszz
tza
neg
//FRAGMENT vbsxx=_neg_vbsz1
lda {z1}
neg
tax
//FRAGMENT vbsxx=_neg_vbsaa
neg
tax
//FRAGMENT vbsxx=_neg_vbsxx
txa
neg
tax
//FRAGMENT vbsxx=_neg_vbsyy
tya
neg
tax
//FRAGMENT vbsxx=_neg_vbszz
tza
neg
tax
//FRAGMENT vbsyy=_neg_vbsz1
lda {z1}
neg
tay
//FRAGMENT vbsyy=_neg_vbsaa
neg
tay
//FRAGMENT vbsyy=_neg_vbsxx
txa
neg
tay
//FRAGMENT vbsyy=_neg_vbsyy
tya
neg
tay
//FRAGMENT vbsyy=_neg_vbszz
tza
neg
tay
//FRAGMENT vbszz=_neg_vbsz1
lda {z1}
neg
taz
//FRAGMENT vbszz=_neg_vbsaa
neg
taz
//FRAGMENT vbszz=_neg_vbsxx
txa
neg
taz
//FRAGMENT vbszz=_neg_vbsyy
tya
neg
taz
//FRAGMENT vbszz=_neg_vbszz
tza
neg
taz
//FRAGMENT _deref_pbsc1=vbsaa
sta {c1}
//FRAGMENT vbsz1=vbsaa_ror_2
asr
asr
sta {z1}
//FRAGMENT vbsz1=vbsxx_ror_2
txa
asr
asr
sta {z1}
//FRAGMENT vbsz1=vbsyy_ror_2
tya
asr
asr
sta {z1}
//FRAGMENT vbsz1=vbszz_ror_2
tza
asr
asr
sta {z1}
//FRAGMENT vbsaa=vbsz1_ror_2
lda {z1}
asr
asr
//FRAGMENT vbsaa=vbsaa_ror_2
asr
asr
//FRAGMENT vbsaa=vbsxx_ror_2
txa
asr
asr
//FRAGMENT vbsaa=vbsyy_ror_2
tya
asr
asr
//FRAGMENT vbsaa=vbszz_ror_2
tza
asr
asr
//FRAGMENT vbsxx=vbsz1_ror_2
lda {z1}
asr
asr
tax
//FRAGMENT vbsxx=vbsaa_ror_2
asr
asr
tax
//FRAGMENT vbsxx=vbsxx_ror_2
txa
asr
asr
tax
//FRAGMENT vbsxx=vbsyy_ror_2
tya
asr
asr
tax
//FRAGMENT vbsxx=vbszz_ror_2
tza
asr
asr
tax
//FRAGMENT vbsyy=vbsz1_ror_2
lda {z1}
asr
asr
tay
//FRAGMENT vbsyy=vbsaa_ror_2
asr
asr
tay
//FRAGMENT vbsyy=vbsxx_ror_2
txa
asr
asr
tay
//FRAGMENT vbsyy=vbsyy_ror_2
tya
asr
asr
tay
//FRAGMENT vbsyy=vbszz_ror_2
tza
asr
asr
tay
//FRAGMENT vbszz=vbsz1_ror_2
lda {z1}
asr
asr
taz
//FRAGMENT vbszz=vbsaa_ror_2
asr
asr
taz
//FRAGMENT vbszz=vbsxx_ror_2
txa
asr
asr
taz
//FRAGMENT vbszz=vbsyy_ror_2
tya
asr
asr
taz
//FRAGMENT vbszz=vbszz_ror_2
tza
asr
asr
taz
//FRAGMENT vbsyy=_deref_pbsc1
ldy {c1}
//FRAGMENT vbszz=_deref_pbsc1
ldz {c1}
//FRAGMENT _deref_pbsc1=vbsxx
stx {c1}
//FRAGMENT _deref_pbsc1=vbsyy
sty {c1}
//FRAGMENT _deref_pbsc1=vbszz
stz {c1}
