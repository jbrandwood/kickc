//KICKC FRAGMENT CACHE 131184b631
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbuaa=vbuc2
tay
lda #{c2}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbuc2
lda #{c2}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuc2
lda #{c2}
sta {c1},y
//FRAGMENT vbuaa=vbuz1_band_vbuc1
lda #{c1}
and {z1}
//FRAGMENT vbuxx=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbuyy=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tay
//FRAGMENT vbuz1=vbuxx_band_vbuc1
txa
and #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_band_vbuc1
txa
and #{c1}
//FRAGMENT vbuxx=vbuxx_band_vbuc1
txa
and #{c1}
tax
//FRAGMENT vbuyy=vbuxx_band_vbuc1
txa
and #{c1}
tay
//FRAGMENT vbuz1=vbuyy_band_vbuc1
tya
and #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_band_vbuc1
tya
and #{c1}
//FRAGMENT vbuxx=vbuyy_band_vbuc1
tya
and #{c1}
tax
//FRAGMENT vbuyy=vbuyy_band_vbuc1
tya
and #{c1}
tay
//FRAGMENT vbuaa_neq_0_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuxx=vbuxx_plus_vbuc1
txa
clc
adc #{c1}
tax
//FRAGMENT vbuyy=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
tay
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuyy_lt_vbuc1_then_la1
cpy #{c1}
bcc {la1}
//FRAGMENT vbuyy=_inc_vbuyy
iny
//FRAGMENT vbuxx_neq_0_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuyy_neq_0_then_la1
cpy #0
bne {la1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT vbuc1_eq_vbuz1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbuc1_neq_vbuz1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pvoz1=pvoz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_plus_2
lda {z1}
clc
adc #2
sta {z1}
//FRAGMENT vbuz1=_hi_pvoz2
lda {z2}+1
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vbuz1=_lo_pvoz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT vbuz1=pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1=pbuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_neq_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT _deref_pbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwuz1_lt_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwuz1_lt_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT _deref_pbuc1=_dec__deref_pbuc1
dec {c1}
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
//FRAGMENT vbuxx=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
tax
//FRAGMENT vbuyy=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
tay
//FRAGMENT vbuc1_eq_vbuaa_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbuc1_neq_vbuxx_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT pbuz1=pbuc1_plus_vbuaa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vbuxx
txa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vbuyy
tya
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbuxx=vbuxx_plus_2
inx
inx
//FRAGMENT vbuaa=_hi_pvoz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_pvoz1
ldx {z1}+1
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT vbuaa=_lo_pvoz1
lda {z1}
//FRAGMENT vbuxx=_lo_pvoz1
ldx {z1}
//FRAGMENT vbuaa=_deref_pbuz1
ldy #0
lda ({z1}),y
//FRAGMENT vbuxx=_deref_pbuz1
ldy #0
lda ({z1}),y
tax
//FRAGMENT vbuyy=_deref_pbuz1
ldy #0
lda ({z1}),y
tay
//FRAGMENT vbuaa=pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
//FRAGMENT vbuxx=pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
tay
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuz1=vbuaa_band_vbuc1
and #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_band_vbuc1
and #{c1}
//FRAGMENT vbuxx=vbuaa_band_vbuc1
and #{c1}
tax
//FRAGMENT vbuyy=vbuaa_band_vbuc1
and #{c1}
tay
//FRAGMENT vbuz1=vbuaa_rol_1
asl
sta {z1}
//FRAGMENT vbuz1=vbuxx_rol_1
txa
asl
sta {z1}
//FRAGMENT vbuz1=vbuyy_rol_1
tya
asl
sta {z1}
//FRAGMENT vbuaa=vbuz1_rol_1
lda {z1}
asl
//FRAGMENT vbuaa=vbuaa_rol_1
asl
//FRAGMENT vbuaa=vbuxx_rol_1
txa
asl
//FRAGMENT vbuaa=vbuyy_rol_1
tya
asl
//FRAGMENT vbuxx=vbuz1_rol_1
lda {z1}
asl
tax
//FRAGMENT vbuxx=vbuaa_rol_1
asl
tax
//FRAGMENT vbuxx=vbuxx_rol_1
txa
asl
tax
//FRAGMENT vbuxx=vbuyy_rol_1
tya
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_1
lda {z1}
asl
tay
//FRAGMENT vbuyy=vbuaa_rol_1
asl
tay
//FRAGMENT vbuyy=vbuxx_rol_1
txa
asl
tay
//FRAGMENT vbuyy=vbuyy_rol_1
tya
asl
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuz2
txa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuyy_bor_vbuz2
tya
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuaa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_bor_vbuaa
stx $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuyy_bor_vbuaa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuxx
txa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_bor_vbuxx
stx {z1}
//FRAGMENT vbuyy=_hi_pvoz1
ldy {z1}+1
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy=_lo_pvoz1
ldy {z1}
//FRAGMENT vbuc1_neq_vbuyy_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbuc1_eq_vbuxx_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuc1_eq_vbuyy_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuz1=vbuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuaa=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
//FRAGMENT vbuaa=vbuz1_bor_vbuaa
ora {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuxx
txa
ora {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuyy
tya
ora {z1}
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
tax
//FRAGMENT vbuxx=vbuz1_bor_vbuaa
ora {z1}
tax
//FRAGMENT vbuxx=vbuz1_bor_vbuxx
txa
ora {z1}
tax
//FRAGMENT vbuxx=vbuz1_bor_vbuyy
tya
ora {z1}
tax
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuyy=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
tay
//FRAGMENT vbuyy=vbuz1_bor_vbuaa
ora {z1}
tay
//FRAGMENT vbuyy=vbuz1_bor_vbuxx
txa
ora {z1}
tay
//FRAGMENT vbuyy=vbuz1_bor_vbuyy
tya
ora {z1}
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuz1
txa
ora {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuaa
stx $ff
ora $ff
//FRAGMENT vbuaa=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
//FRAGMENT vbuxx=vbuxx_bor_vbuz1
txa
ora {z1}
tax
//FRAGMENT vbuxx=vbuxx_bor_vbuaa
stx $ff
ora $ff
tax
//FRAGMENT vbuxx=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
tax
//FRAGMENT vbuyy=vbuxx_bor_vbuz1
txa
ora {z1}
tay
//FRAGMENT vbuyy=vbuxx_bor_vbuaa
stx $ff
ora $ff
tay
//FRAGMENT vbuyy=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
tay
//FRAGMENT vbuaa=vbuyy_bor_vbuaa
sty $ff
ora $ff
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
