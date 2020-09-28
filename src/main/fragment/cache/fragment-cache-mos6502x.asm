//KICKC FRAGMENT CACHE 12fc0379b9 12fc039308
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuc1_eq_vbuz1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT _deref_pbuc1=_dec__deref_pbuc1
dec {c1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
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
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
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
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vwuz1_lt_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuz1=_hi_pvoz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=_lo_pvoz2
lda {z2}
sta {z1}
//FRAGMENT vwuz1_lt_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
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
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuz1=vbuaa_band_vbuc1
and #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuxx_band_vbuc1
lda #{c1}
sax {z1}
//FRAGMENT vbuz1=vbuyy_band_vbuc1
tya
and #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuz1_band_vbuc1
lda #{c1}
and {z1}
//FRAGMENT vbuaa=vbuaa_band_vbuc1
and #{c1}
//FRAGMENT vbuaa=vbuxx_band_vbuc1
txa
and #{c1}
//FRAGMENT vbuaa=vbuyy_band_vbuc1
tya
and #{c1}
//FRAGMENT vbuxx=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbuxx=vbuaa_band_vbuc1
ldx #{c1}
axs #0
//FRAGMENT vbuc1_eq_vbuaa_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbuyy=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tay
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
//FRAGMENT vbuc1_neq_vbuxx_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
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
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT vbuaa=_hi_pvoz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_pvoz1
ldx {z1}+1
//FRAGMENT vbuaa=_lo_pvoz1
lda {z1}
//FRAGMENT vbuxx=_lo_pvoz1
ldx {z1}
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
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
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuyy=_hi_pvoz1
ldy {z1}+1
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy=_lo_pvoz1
ldy {z1}
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
//FRAGMENT vbuc1_neq_vbuyy_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbuc1_eq_vbuxx_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuc1_eq_vbuyy_then_la1
cpy #{c1}
beq {la1}
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
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_vbuc2
lda #{c2}
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuz2_bxor_vbuc1
lda #{c1}
eor {z2}
sta {z1}
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT vbuz1=_inc_vbuz2
ldy {z2}
iny
sty {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz2_rol_3
lda {z2}
asl
asl
asl
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=vbuc2
lda {z1}
ldx #{c2}
tay
txa
sta {c1},y
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_plus_pwuc2_derefidx_vbuz1
ldy {z1}
clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_plus_vbuc2
ldy {z1}
clc
lda {c1},y
adc #{c2}
sta {c1},y
lda {c1}+1,y
adc #0
sta {c1}+1,y
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_ror_8
ldy {z2}
lda #0
sta {z1}+1
lda {c1}+1,y
sta {z1}
//FRAGMENT vwuz1_ge_vbuc1_then_la1
lda {z1}+1
bne {la1}
lda {z1}
cmp #{c1}
bcs {la1}
!:
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_bxor_vwuc2
ldy {z1}
lda {c1},y
eor #<{c2}
sta {c1},y
lda {c1}+1,y
eor #>{c2}
sta {c1}+1,y
//FRAGMENT vbuz1=vbuz2_plus_vbuc1
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT vwuz1_lt_vbuz2_then_la1
lda {z1}+1
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vwuz1_ge_vbuz2_then_la1
lda {z1}+1
bne {la1}
lda {z1}
cmp {z2}
bcs {la1}
!:
//FRAGMENT vbuz1=vbuz2_minus_2
lda {z2}
sec
sbc #2
sta {z1}
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_8
lda {z2}
sta {z1}+1
lda #0
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=vwuz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT vbuz1=vbuz2_rol_2
lda {z2}
asl
asl
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=_byte_vwuz2
ldy {z1}
lda {z2}
sta {c1},y
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_band_vwuc1
lda {z2}
and #<{c1}
sta {z1}
lda {z2}+1
and #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=vwuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=vbuz2
lda {z1}
ldx {z2}
tay
txa
sta {c1},y
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1_lt_vbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwuz1=vwuz2_rol_7
lda {z2}+1
lsr
lda {z2}
ror
sta {z1}+1
lda #0
ror
sta {z1}
//FRAGMENT vwuz1=vwuz2_bxor_vwuz3
lda {z2}
eor {z3}
sta {z1}
lda {z2}+1
eor {z3}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_ror_9
lda {z2}+1
lsr
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_vbuc2
lda #{c2}
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_vbuc2
ldx {z1}
lda {c1},x
tax
axs #-[{c2}]
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_vbuc2
lda #{c2}
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_vbuc2
tay
lda #{c2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_vbuc2
tay
lda #{c2}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_vbuc2
tax
lda {c1},x
tax
axs #-[{c2}]
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_vbuc2
tay
lda #{c2}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_vbuc2
lda #{c2}
clc
adc {c1},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_vbuc2
lda #{c2}
clc
adc {c1},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_vbuc2
lda {c1},x
tax
axs #-[{c2}]
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_vbuc2
lda #{c2}
clc
adc {c1},x
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_vbuc2
lda #{c2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_vbuc2
lda #{c2}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_vbuc2
lda {c1},y
tax
axs #-[{c2}]
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_vbuc2
lda #{c2}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=vbuaa_bxor_vbuc1
eor #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuxx_bxor_vbuc1
txa
eor #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuyy_bxor_vbuc1
tya
eor #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
//FRAGMENT vbuaa=vbuaa_bxor_vbuc1
eor #{c1}
//FRAGMENT vbuaa=vbuxx_bxor_vbuc1
txa
eor #{c1}
//FRAGMENT vbuaa=vbuyy_bxor_vbuc1
tya
eor #{c1}
//FRAGMENT vbuxx=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
tax
//FRAGMENT vbuxx=vbuaa_bxor_vbuc1
eor #{c1}
tax
//FRAGMENT vbuxx=vbuxx_bxor_vbuc1
txa
eor #{c1}
tax
//FRAGMENT vbuxx=vbuyy_bxor_vbuc1
tya
eor #{c1}
tax
//FRAGMENT vbuyy=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
tay
//FRAGMENT vbuyy=vbuaa_bxor_vbuc1
eor #{c1}
tay
//FRAGMENT vbuyy=vbuxx_bxor_vbuc1
txa
eor #{c1}
tay
//FRAGMENT vbuyy=vbuyy_bxor_vbuc1
tya
eor #{c1}
tay
//FRAGMENT vbuxx_ge_vbuc1_then_la1
cpx #{c1}
bcs {la1}
//FRAGMENT vbuaa=_inc_vbuz1
lda {z1}
clc
adc #1
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuaa=vbuz1_rol_3
lda {z1}
asl
asl
asl
//FRAGMENT vbuxx=vbuz1_rol_3
lda {z1}
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_3
lda {z1}
asl
asl
asl
tay
//FRAGMENT vbuz1=vbuxx_rol_3
txa
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuxx_rol_3
txa
asl
asl
asl
//FRAGMENT vbuxx=vbuxx_rol_3
txa
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuxx_rol_3
txa
asl
asl
asl
tay
//FRAGMENT vbuz1=vbuyy_rol_3
tya
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuyy_rol_3
tya
asl
asl
asl
//FRAGMENT vbuxx=vbuyy_rol_3
tya
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuyy_rol_3
tya
asl
asl
asl
tay
//FRAGMENT pwuc1_derefidx_vbuaa=vbuc2
ldx #{c2}
tay
txa
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuxx=vbuc2
lda #{c2}
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=vbuc2
lda #{c2}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT vbuaa_lt_vbuz1_then_la1
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1=vbuaa_rol_3
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuaa_rol_3
asl
asl
asl
//FRAGMENT vbuxx=vbuaa_rol_3
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuaa_rol_3
asl
asl
asl
tay
//FRAGMENT pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_pwuc2_derefidx_vbuaa
tax
tay
clc
lda {c1},y
adc {c2},x
sta {c1},y
lda {c1}+1,y
adc {c2}+1,x
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_pwuc2_derefidx_vbuxx
txa
tay
txa
sty $ff
ldx $ff
tay
clc
lda {c1},y
adc {c2},x
sta {c1},y
lda {c1}+1,y
adc {c2}+1,x
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_plus_pwuc2_derefidx_vbuyy
clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_vbuc2
clc
lda {c1},x
adc #{c2}
sta {c1},x
lda {c1}+1,x
adc #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_plus_vbuc2
clc
lda {c1},y
adc #{c2}
sta {c1},y
lda {c1}+1,y
adc #0
sta {c1}+1,y
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx_ror_8
txa
tay
lda #0
sta {z1}+1
lda {c1}+1,y
sta {z1}
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy_ror_8
lda #0
sta {z1}+1
lda {c1}+1,y
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_bxor_vwuc2
tay
lda {c1},y
eor #<{c2}
sta {c1},y
lda {c1}+1,y
eor #>{c2}
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_bxor_vwuc2
txa
tay
lda {c1},y
eor #<{c2}
sta {c1},y
lda {c1}+1,y
eor #>{c2}
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_bxor_vwuc2
lda {c1},y
eor #<{c2}
sta {c1},y
lda {c1}+1,y
eor #>{c2}
sta {c1}+1,y
//FRAGMENT vwuz1=pwuc1_derefidx_vbuaa_ror_8
tay
lda #0
sta {z1}+1
lda {c1}+1,y
sta {z1}
//FRAGMENT vbuz1=vbuxx_plus_vbuc1
txa
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuz1=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbuaa=vbuxx_plus_vbuc1
txa
clc
adc #{c1}
//FRAGMENT vbuaa=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
//FRAGMENT vbuxx=vbuz1_plus_vbuc1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbuxx=vbuxx_plus_vbuc1
txa
axs #-[{c1}]
//FRAGMENT vbuxx=vbuyy_plus_vbuc1
tya
tax
axs #-[{c1}]
//FRAGMENT vbuyy=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
tay
//FRAGMENT vbuyy=vbuxx_plus_vbuc1
txa
clc
adc #{c1}
tay
//FRAGMENT vbuyy=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
tay
//FRAGMENT vwuz1_lt_vbuxx_then_la1
lda {z1}+1
bne !+
stx $ff
lda {z1}
cmp $ff
bcc {la1}
!:
//FRAGMENT vwuz1_lt_vbuyy_then_la1
lda {z1}+1
bne !+
sty $ff
lda {z1}
cmp $ff
bcc {la1}
!:
//FRAGMENT vwuz1_ge_vbuxx_then_la1
lda {z1}+1
bne {la1}
stx $ff
lda {z1}
cmp $ff
bcs {la1}
!:
//FRAGMENT vwuz1_ge_vbuyy_then_la1
lda {z1}+1
bne {la1}
sty $ff
lda {z1}
cmp $ff
bcs {la1}
!:
//FRAGMENT vbuz1=vbuxx_minus_2
dex
dex
stx {z1}
//FRAGMENT vwuz1=_word_vbuaa
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=_word_vbuxx
txa
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=_word_vbuyy
tya
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT pwuc1_derefidx_vbuxx=vwuz1
lda {z1}
sta {c1},x
lda {z1}+1
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=vwuz1
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
//FRAGMENT vbuaa=vbuz1_rol_2
lda {z1}
asl
asl
//FRAGMENT vbuxx=vbuz1_rol_2
lda {z1}
asl
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_2
lda {z1}
asl
asl
tay
//FRAGMENT vbuz1=vbuxx_rol_2
txa
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuxx_rol_2
txa
asl
asl
//FRAGMENT vbuxx=vbuxx_rol_2
txa
asl
asl
tax
//FRAGMENT vbuyy=vbuxx_rol_2
txa
asl
asl
tay
//FRAGMENT vbuz1=vbuyy_rol_2
tya
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuyy_rol_2
tya
asl
asl
//FRAGMENT vbuxx=vbuyy_rol_2
tya
asl
asl
tax
//FRAGMENT vbuyy=vbuyy_rol_2
tya
asl
asl
tay
//FRAGMENT pbuc1_derefidx_vbuaa=_byte_vwuz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=_byte_vwuz1
lda {z1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=_byte_vwuz1
lda {z1}
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuaa=vwuz1
tay
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
//FRAGMENT vbuaa=vwuz1_band_vbuc1
lda #{c1}
and {z1}
//FRAGMENT vbuxx=vwuz1_band_vbuc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbuyy=vwuz1_band_vbuc1
lda #{c1}
and {z1}
tay
//FRAGMENT pwuc1_derefidx_vbuz1=vbuxx
lda {z1}
tay
txa
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuz1=vbuyy
tya
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=vbuz1
ldx {z1}
tay
txa
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuaa=vbuxx
tay
txa
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuaa=vbuyy
sty $ff
ldx $ff
tay
txa
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuxx=vbuxx
txa
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuxx=vbuyy
tya
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=vbuz1
lda {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuyy=vbuxx
tya
tay
txa
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuyy=vbuyy
tya
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT vbuxx_lt_vbuz1_then_la1
cpx {z1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1_minus_2
lda {z1}
sec
sbc #2
//FRAGMENT vbuxx=vbuz1_minus_2
ldx {z1}
dex
dex
//FRAGMENT vbuyy=vbuz1_minus_2
ldy {z1}
dey
dey
//FRAGMENT vbuxx=_inc_vbuz1
ldx {z1}
inx
//FRAGMENT vbuyy=_inc_vbuz1
ldy {z1}
iny
//FRAGMENT vwuz1=vwuz1_bxor_vwuz2
lda {z1}
eor {z2}
sta {z1}
lda {z1}+1
eor {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_8
lda {z1}
sta {z1}+1
lda #0
sta {z1}
//FRAGMENT vwuz1=vwuz1_band_vwuc1
lda {z1}
and #<{c1}
sta {z1}
lda {z1}+1
and #>{c1}
sta {z1}+1
