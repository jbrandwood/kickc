//KICKC FRAGMENT CACHE a009d17e5 a009d3700
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_plus_vbsc1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_vwuc1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwsz1_lt_0_then_la1
lda {z1}+1
bmi {la1}
//FRAGMENT vwsz1=_neg_vwsz1
sec
lda #0
sbc {z1}
sta {z1}
lda #0
sbc {z1}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1=vbuz2
lda {z2}
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuz1=_byte1_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=_byte0_vwuz2
lda {z2}
sta {z1}
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1_lt_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vbuz1=vbuz2_ror_4
lda {z2}
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT _deref_pbuz1=vbuaa
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=vbuxx
txa
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=vbuyy
tya
ldy #0
sta ({z1}),y
//FRAGMENT vbuaa=_byte1_vwuz1
lda {z1}+1
//FRAGMENT vbuxx=_byte1_vwuz1
ldx {z1}+1
//FRAGMENT vbuaa=_byte0_vwuz1
lda {z1}
//FRAGMENT vbuxx=_byte0_vwuz1
ldx {z1}
//FRAGMENT vbuaa=vbuz1_ror_4
lda {z1}
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuz1_ror_4
lda {z1}
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuz1_ror_4
lda {z1}
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuaa_ror_4
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuaa_ror_4
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuaa_ror_4
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuaa_ror_4
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuxx_ror_4
txa
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuxx_ror_4
txa
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuxx_ror_4
txa
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuxx_ror_4
txa
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1
ldy {z1}
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1
ldx {z1}
ldy {c1},x
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa
tay
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa
tay
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa
tax
ldy {c1},x
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuz1=vbuxx_band_vbuc1
lda #{c1}
sax {z1}
//FRAGMENT vbuaa=vbuz1_band_vbuc1
lda #{c1}
and {z1}
//FRAGMENT vbuaa=vbuxx_band_vbuc1
txa
and #{c1}
//FRAGMENT vbuxx=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbuxx=vbuxx_band_vbuc1
lda #{c1}
axs #0
//FRAGMENT vbuyy=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tay
//FRAGMENT vbuyy=vbuxx_band_vbuc1
txa
and #{c1}
tay
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vwuz1_lt_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwuz1=vwuz2_plus_1
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz2_rol_1
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
//FRAGMENT pwuz1=pwuc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=_deref_pwuz2_plus__deref_pwuz3
ldy #0
clc
lda ({z2}),y
adc ({z3}),y
sta {z1}
iny
lda ({z2}),y
adc ({z3}),y
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_plus__deref_pwuz3
ldy #0
clc
lda {z2}
adc ({z3}),y
sta {z1}
iny
lda {z2}+1
adc ({z3}),y
sta {z1}+1
//FRAGMENT vwuz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwuz1=_deref_pwuz2
ldy #0
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vduz1=vduz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
//FRAGMENT vwuz1=_word0_vduz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pvoz1=_deref_qvoc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vduz1=_dword_vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda #0
sta {z1}+2
sta {z1}+3
//FRAGMENT vduz1=vduc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda #<{c1}>>$10
sta {z1}+2
lda #>{c1}>>$10
sta {z1}+3
//FRAGMENT vwuz1_neq_0_then_la1
lda {z1}
ora {z1}+1
bne {la1}
//FRAGMENT vbuz1=vwuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1_eq_0_then_la1
lda {z1}
beq {la1}
//FRAGMENT vduz1=vduz1_plus_vduz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
lda {z1}+2
adc {z2}+2
sta {z1}+2
lda {z1}+3
adc {z2}+3
sta {z1}+3
//FRAGMENT vwuz1=vwuz1_ror_1
lsr {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz1_rol_1
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vwuz1_le_0_then_la1
lda {z1}
bne !+
lda {z1}+1
beq {la1}
!:
//FRAGMENT pbuz1=pbuz2_plus_vwuz3
clc
lda {z2}
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT pbuz1_neq_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pwuc1=vbuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_(_deref_pbuc2)
ldy {c2}
lda {c1},y
sta {z1}
//FRAGMENT _deref_pwuc1=_inc__deref_pwuc1
inc {c1}
bne !+
inc {c1}+1
!:
//FRAGMENT _deref_pwuc1_eq_vbuc2_then_la1
lda {c1}+1
bne !+
lda {c1}
cmp #{c2}
beq {la1}
!:
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbuz1=_byte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=_inc_pbuz2
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1_ge_vwuz2_then_la1
lda {z2}+1
cmp {z1}+1
bne !+
lda {z2}
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT vbuz1=_byte_vduz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_rol_2
lda {z2}
asl
asl
sta {z1}
//FRAGMENT vduz1=pduc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
lda {c1}+2,y
sta {z1}+2
lda {c1}+3,y
sta {z1}+3
//FRAGMENT vduz1_ge_vduz2_then_la1
lda {z1}+3
cmp {z2}+3
bcc !+
bne {la1}
lda {z1}+2
cmp {z2}+2
bcc !+
bne {la1}
lda {z1}+1
cmp {z2}+1
bcc !+
bne {la1}
lda {z1}
cmp {z2}
bcs {la1}
!:
//FRAGMENT _deref_(_deref_qbuc1)=_deref_pbuc2
lda {c2}
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT _deref_qbuc1=pbuz1
lda {z1}
sta {c1}
lda {z1}+1
sta {c1}+1
//FRAGMENT vbuz1=vbuz2_bxor_vbuc1
lda #{c1}
eor {z2}
sta {z1}
//FRAGMENT _deref_(_deref_qbuc1)=vbuz1
lda {z1}
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT _deref_pbuc1_neq_vbuc2_then_la1
lda #{c2}
cmp {c1}
bne {la1}
//FRAGMENT _deref_(_deref_qbuc1)=_deref_(_deref_qbuc1)_bxor_vbuc2
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
lda ($fe),y
eor #{c2}
sta ($fe),y
//FRAGMENT pbuz1=_deref_qbuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pvoz1=pvoz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_vwuz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT vduz1=vduz1_minus_vduz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
lda {z1}+2
sbc {z2}+2
sta {z1}+2
lda {z1}+3
sbc {z2}+3
sta {z1}+3
//FRAGMENT vwuz1=_word__deref_pbuc1
lda {c1}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_2
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz2_plus_vwuz3
clc
lda {z2}
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_3
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pbuz1=_deref_qbuc1_plus_vwuz2
clc
lda {z2}
adc {c1}
sta {z1}
lda {z2}+1
adc {c1}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus__deref_pwuc1
clc
lda {c1}
adc {z2}
sta {z1}
lda {c1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy #0
sta ({z1}),y
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
//FRAGMENT 0_neq_vbuaa_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
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
//FRAGMENT vbuaa_eq_0_then_la1
cmp #0
beq {la1}
//FRAGMENT vbuaa=pbuc1_derefidx_(_deref_pbuc2)
ldy {c2}
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_(_deref_pbuc2)
ldy {c2}
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_(_deref_pbuc2)
ldx {c2}
ldy {c1},x
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT vbuaa=_byte_vwuz1
lda {z1}
//FRAGMENT vbuxx=_byte_vwuz1
ldx {z1}
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbuaa
tay
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbuxx
lda {c1},x
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbuyy
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT vbuaa=vbuz1_rol_1
lda {z1}
asl
//FRAGMENT vbuxx=vbuz1_rol_1
lda {z1}
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_1
lda {z1}
asl
tay
//FRAGMENT vbuz1=vbuaa_rol_1
asl
sta {z1}
//FRAGMENT vbuaa=vbuaa_rol_1
asl
//FRAGMENT vbuxx=vbuaa_rol_1
asl
tax
//FRAGMENT vbuyy=vbuaa_rol_1
asl
tay
//FRAGMENT vbuz1=vbuxx_rol_1
txa
asl
sta {z1}
//FRAGMENT vbuaa=vbuxx_rol_1
txa
asl
//FRAGMENT vbuxx=vbuxx_rol_1
txa
asl
tax
//FRAGMENT vbuyy=vbuxx_rol_1
txa
asl
tay
//FRAGMENT vbuz1=vbuyy_rol_1
tya
asl
sta {z1}
//FRAGMENT vbuaa=vbuyy_rol_1
tya
asl
//FRAGMENT vbuxx=vbuyy_rol_1
tya
asl
tax
//FRAGMENT vbuyy=vbuyy_rol_1
tya
asl
tay
//FRAGMENT vwuz1=pwuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
//FRAGMENT 0_eq_vbuaa_then_la1
cmp #0
beq {la1}
//FRAGMENT vbuaa=_byte_vduz1
lda {z1}
//FRAGMENT vbuxx=_byte_vduz1
lda {z1}
tax
//FRAGMENT vbuyy=_byte_vduz1
lda {z1}
tay
//FRAGMENT vbuz1=vbuaa_rol_2
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuxx_rol_2
txa
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuyy_rol_2
tya
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuz1_rol_2
lda {z1}
asl
asl
//FRAGMENT vbuaa=vbuaa_rol_2
asl
asl
//FRAGMENT vbuaa=vbuxx_rol_2
txa
asl
asl
//FRAGMENT vbuaa=vbuyy_rol_2
tya
asl
asl
//FRAGMENT vbuxx=vbuz1_rol_2
lda {z1}
asl
asl
tax
//FRAGMENT vbuxx=vbuaa_rol_2
asl
asl
tax
//FRAGMENT vbuxx=vbuxx_rol_2
txa
asl
asl
tax
//FRAGMENT vbuxx=vbuyy_rol_2
tya
asl
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_2
lda {z1}
asl
asl
tay
//FRAGMENT vbuyy=vbuaa_rol_2
asl
asl
tay
//FRAGMENT vbuyy=vbuxx_rol_2
txa
asl
asl
tay
//FRAGMENT vbuyy=vbuyy_rol_2
tya
asl
asl
tay
//FRAGMENT vduz1=pduc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
lda {c1}+2,y
sta {z1}+2
lda {c1}+3,y
sta {z1}+3
//FRAGMENT vduz1=pduc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
lda {c1}+2,x
sta {z1}+2
lda {c1}+3,x
sta {z1}+3
//FRAGMENT vduz1=pduc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
lda {c1}+2,y
sta {z1}+2
lda {c1}+3,y
sta {z1}+3
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT vbuaa=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
//FRAGMENT vbuxx=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
tax
//FRAGMENT vbuyy=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
tay
//FRAGMENT vbuz1=vbuxx_bxor_vbuc1
txa
eor #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_bxor_vbuc1
txa
eor #{c1}
//FRAGMENT vbuxx=vbuxx_bxor_vbuc1
txa
eor #{c1}
tax
//FRAGMENT vbuyy=vbuxx_bxor_vbuc1
txa
eor #{c1}
tay
//FRAGMENT vbuz1=vbuyy_bxor_vbuc1
tya
eor #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_bxor_vbuc1
tya
eor #{c1}
//FRAGMENT vbuxx=vbuyy_bxor_vbuc1
tya
eor #{c1}
tax
//FRAGMENT vbuyy=vbuyy_bxor_vbuc1
tya
eor #{c1}
tay
//FRAGMENT _deref_(_deref_qbuc1)=vbuaa
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_(_deref_qbuc1)=vbuxx
txa
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_(_deref_qbuc1)=vbuyy
tya
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=_inc_vbuyy
iny
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuyy=_byte_vwuz1
ldy {z1}
//FRAGMENT vbuxx_eq_0_then_la1
cpx #0
beq {la1}
//FRAGMENT vbuyy_eq_0_then_la1
cpy #0
beq {la1}
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
beq {la1}
//FRAGMENT vwuz1=_deref_pwuz1
ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT pbuz1=pbuz2_plus_vwuz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=_deref_pwuz1_plus__deref_pwuz2
ldy #0
clc
lda ({z1}),y
adc ({z2}),y
pha
iny
lda ({z1}),y
adc ({z2}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus__deref_pwuz1
ldy #0
clc
lda ({z1}),y
adc {z2}
pha
iny
lda ({z1}),y
adc {z2}+1
sta {z1}+1
pla
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus_vwuz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=_deref_qbuc1_plus_vwuz1
clc
lda {z1}
adc {c1}
sta {z1}
lda {z1}+1
adc {c1}+1
sta {z1}+1
//FRAGMENT pwuz1=pwuc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vwuc1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus__deref_pwuc1
clc
lda {z1}
adc {c1}
sta {z1}
lda {z1}+1
adc {c1}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_3
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pbuz1_derefidx_vbuz2_neq_vbuc1_then_la1
ldy {z2}
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuz2
lda {z1}
clc
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_vbuc1
lax {z1}
axs #{c1}
stx {z1}
//FRAGMENT vbuz1=vbuz2_plus_vbuz3
lda {z2}
clc
adc {z3}
sta {z1}
//FRAGMENT pbuz1=pbuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1_derefidx_vbuxx_neq_vbuc1_then_la1
txa
tay
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuyy_neq_vbuc1_then_la1
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_plus_vbuyy
tya
clc
adc {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_plus_vbuz1
txa
clc
adc {z1}
tax
//FRAGMENT vbuxx=vbuxx_plus_vbuxx
txa
asl
tax
//FRAGMENT vbuxx=vbuxx_plus_vbuyy
txa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbuyy=vbuyy_plus_vbuz1
tya
clc
adc {z1}
tay
//FRAGMENT vbuyy=vbuyy_plus_vbuxx
txa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbuyy=vbuyy_plus_vbuyy
tya
asl
tay
//FRAGMENT vbuxx=vbuxx_minus_vbuc1
txa
axs #{c1}
//FRAGMENT vbuyy=vbuyy_minus_vbuc1
tya
sec
sbc #{c1}
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
//FRAGMENT vbuyy=vbuxx_plus_vbuz1
txa
clc
adc {z1}
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
//FRAGMENT vbuyy=vbuxx_plus_vbuxx
txa
asl
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
//FRAGMENT vbuyy=vbuxx_plus_vbuyy
txa
sty $ff
clc
adc $ff
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
//FRAGMENT pbuz1=pbuz1_plus_vbuaa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1=pbuz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1=pbuz1_plus_vbuyy
tya
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_plus_vbuyy
tya
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuyy_lt_vbuc1_then_la1
cpy #{c1}
bcc {la1}
//FRAGMENT 0_neq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
bne {la1}
//FRAGMENT _deref_pbuz1_neq_vbuc1_then_la1
ldy #0
lda ({z1}),y
cmp #{c1}
bne {la1}
//FRAGMENT 0_eq_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT 0_eq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
beq {la1}
//FRAGMENT _deref_pbuz1_eq_vbuc1_then_la1
lda #{c1}
ldy #0
cmp ({z1}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2_neq_pbuz3_derefidx_vbuz2_then_la1
ldy {z2}
lda ({z1}),y

tax
lda ({z3}),y

tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuaa_eq_vbuc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT 0_eq_pbuc1_derefidx_vbuaa_then_la1
tay
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT 0_eq_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
cmp #0
beq {la1}
//FRAGMENT 0_eq_pbuc1_derefidx_vbuyy_then_la1
lda {c1},y
cmp #0
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuxx=vbuc2
lda #{c2}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuc2
lda #{c2}
sta {c1},y
//FRAGMENT vbuaa_neq_vbuc1_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuaa=vbuc2
tay
lda #{c2}
sta {c1},y
//FRAGMENT pbuz1_derefidx_vbuaa_neq_pbuz2_derefidx_vbuaa_then_la1
tay
lda ({z1}),y

tax
lda ({z2}),y

tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuxx_neq_pbuz2_derefidx_vbuxx_then_la1
txa
tay
lda ({z1}),y

tax
lda ({z2}),y

tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuyy_neq_pbuz2_derefidx_vbuyy_then_la1
lda ({z1}),y

tax
lda ({z2}),y

tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuz1=vbuc1_minus_vbuz2
lda #{c1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuz1_ge_vbuz2_then_la1
lda {z1}
cmp {z2}
bcs {la1}
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_vbuz2_then_la1
lda {z1}
ldy {z2}
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_ge_vbuz1_then_la1
lda {z1}
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1_le_vbuz2_then_la1
lda {z2}
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1_le_pbuc1_derefidx_vbuz2_then_la1
ldy {z2}
lda {c1},y
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1_le_vbuz1_then_la1
lda {z1}
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1_gt_vbuz2_then_la1
lda {z2}
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_gt_pbuc1_derefidx_vbuz2_then_la1
ldy {z2}
lda {c1},y
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_gt_vbuz1_then_la1
lda {z1}
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT vbuz1_lt_pbuc1_derefidx_vbuz2_then_la1
lda {z1}
ldy {z2}
cmp {c1},y
bcc {la1}
//FRAGMENT vbuz1_lt_vbuz1_then_la1
lda {z1}
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_neq_vbuz2_then_la1
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vbuz1_neq_pbuc1_derefidx_vbuz2_then_la1
lda {z1}
ldy {z2}
cmp {c1},y
bne {la1}
//FRAGMENT vbuz1_neq_vbuz1_then_la1
lda {z1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lax {z1}
axs #-[{c1}]
stx {z1}
//FRAGMENT pbuz1_neq_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vbuaa=vbuc1_minus_vbuz1
lda #{c1}
sec
sbc {z1}
//FRAGMENT vbuxx=vbuc1_minus_vbuz1
lda #{c1}
sec
sbc {z1}
tax
//FRAGMENT vbuyy=vbuc1_minus_vbuz1
lda #{c1}
sec
sbc {z1}
tay
//FRAGMENT vbuz1=vbuc1_minus_vbuaa
eor #$ff
sec
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_minus_vbuaa
eor #$ff
sec
adc #{c1}
//FRAGMENT vbuxx=vbuc1_minus_vbuaa
eor #$ff
tax
axs #-{c1}-1
//FRAGMENT vbuyy=vbuc1_minus_vbuaa
eor #$ff
sec
adc #{c1}
tay
//FRAGMENT vbuz1=vbuc1_minus_vbuxx
txa
eor #$ff
sec
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_minus_vbuxx
txa
eor #$ff
sec
adc #{c1}
//FRAGMENT vbuxx=vbuc1_minus_vbuxx
txa
eor #$ff
tax
axs #-{c1}-1
//FRAGMENT vbuyy=vbuc1_minus_vbuxx
txa
eor #$ff
sec
adc #{c1}
tay
//FRAGMENT vbuz1=vbuc1_minus_vbuyy
tya
eor #$ff
sec
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_minus_vbuyy
tya
eor #$ff
sec
adc #{c1}
//FRAGMENT vbuxx=vbuc1_minus_vbuyy
tya
eor #$ff
tax
axs #-{c1}-1
//FRAGMENT vbuyy=vbuc1_minus_vbuyy
tya
eor #$ff
sec
adc #{c1}
tay
//FRAGMENT vbuz1_ge_vbuaa_then_la1
ldy {z1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuc1_then_la1
cpx #{c1}
bcs {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_vbuxx_then_la1
txa
tay
lda {z1}
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_vbuyy_then_la1
lda {z1}
cmp {c1},y
bcs {la1}
//FRAGMENT vbuxx_ge_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
txa
cmp {c1},y
bcs {la1}
//FRAGMENT vbuxx_ge_pbuc1_derefidx_vbuxx_then_la1
txa
tay
cmp {c1},y
bcs {la1}
//FRAGMENT vbuxx_ge_pbuc1_derefidx_vbuyy_then_la1
txa
cmp {c1},y
bcs {la1}
//FRAGMENT vbuyy_ge_pbuc1_derefidx_vbuz1_then_la1
tya
ldy {z1}
cmp {c1},y
bcs {la1}
//FRAGMENT vbuyy_ge_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuyy_ge_pbuc1_derefidx_vbuyy_then_la1
tya
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuxx_ge_vbuxx_then_la1
txa
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy_ge_vbuyy_then_la1
tya
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuz1_le_vbuxx_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuz1_le_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1_le_pbuc1_derefidx_vbuyy_then_la1
lda {c1},y
cmp {z1}
bcs {la1}
//FRAGMENT vbuxx_le_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
txa
cmp {c1},y
bcc {la1}
beq {la1}
//FRAGMENT vbuxx_le_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx_le_pbuc1_derefidx_vbuyy_then_la1
txa
cmp {c1},y
bcc {la1}
beq {la1}
//FRAGMENT vbuyy_le_pbuc1_derefidx_vbuz1_then_la1
tya
ldy {z1}
cmp {c1},y
bcc {la1}
beq {la1}
//FRAGMENT vbuyy_le_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy_le_pbuc1_derefidx_vbuyy_then_la1
tya
cmp {c1},y
bcc {la1}
beq {la1}
//FRAGMENT vbuxx_le_vbuxx_then_la1
txa
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy_le_vbuyy_then_la1
tya
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuz1_gt_vbuxx_then_la1
cpx {z1}
bcc {la1}
//FRAGMENT vbuz1_gt_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_gt_pbuc1_derefidx_vbuyy_then_la1
lda {c1},y
cmp {z1}
bcc {la1}
//FRAGMENT vbuxx_gt_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
txa
cmp {c1},y
beq !+
bcs {la1}
!:
//FRAGMENT vbuxx_gt_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
stx $ff
cmp $ff
bcc {la1}
//FRAGMENT vbuxx_gt_pbuc1_derefidx_vbuyy_then_la1
txa
cmp {c1},y
beq !+
bcs {la1}
!:
//FRAGMENT vbuyy_gt_pbuc1_derefidx_vbuz1_then_la1
tya
ldy {z1}
cmp {c1},y
beq !+
bcs {la1}
!:
//FRAGMENT vbuyy_gt_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
tax
sty $ff
cpx $ff
bcc {la1}
//FRAGMENT vbuyy_gt_pbuc1_derefidx_vbuyy_then_la1
tya
cmp {c1},y
beq !+
bcs {la1}
!:
//FRAGMENT vbuxx_gt_vbuxx_then_la1
txa
sta $ff
cpx $ff
bcc {la1}
//FRAGMENT vbuyy_gt_vbuyy_then_la1
tya
sta $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuz1_lt_vbuxx_then_la1
cpx {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuz1_lt_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
cmp {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuz1_lt_pbuc1_derefidx_vbuyy_then_la1
lda {z1}
cmp {c1},y
bcc {la1}
//FRAGMENT vbuxx_lt_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
txa
cmp {c1},y
bcc {la1}
//FRAGMENT vbuxx_lt_pbuc1_derefidx_vbuxx_then_la1
txa
tay
cmp {c1},y
bcc {la1}
//FRAGMENT vbuxx_lt_pbuc1_derefidx_vbuyy_then_la1
txa
cmp {c1},y
bcc {la1}
//FRAGMENT vbuyy_lt_pbuc1_derefidx_vbuz1_then_la1
tya
ldy {z1}
cmp {c1},y
bcc {la1}
//FRAGMENT vbuyy_lt_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
sta $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuyy_lt_pbuc1_derefidx_vbuyy_then_la1
tya
cmp {c1},y
bcc {la1}
//FRAGMENT vbuxx_lt_vbuxx_then_la1
txa
sta $ff
cpx $ff
bcc {la1}
//FRAGMENT vbuyy_lt_vbuyy_then_la1
tya
sta $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuz1_neq_vbuxx_then_la1
cpx {z1}
bne {la1}
//FRAGMENT vbuz1_neq_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
cmp {z1}
bne {la1}
//FRAGMENT vbuz1_neq_pbuc1_derefidx_vbuyy_then_la1
lda {c1},y
cmp {z1}
bne {la1}
//FRAGMENT vbuxx_neq_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
txa
cmp {c1},y
bne {la1}
//FRAGMENT vbuxx_neq_pbuc1_derefidx_vbuxx_then_la1
txa
tay
cmp {c1},y
bne {la1}
//FRAGMENT vbuxx_neq_pbuc1_derefidx_vbuyy_then_la1
txa
cmp {c1},y
bne {la1}
//FRAGMENT vbuyy_neq_pbuc1_derefidx_vbuz1_then_la1
tya
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT vbuyy_neq_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
tax
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuyy_neq_pbuc1_derefidx_vbuyy_then_la1
tya
cmp {c1},y
bne {la1}
//FRAGMENT vbuxx_neq_vbuxx_then_la1
txa
tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuyy_neq_vbuyy_then_la1
tya
tax
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuxx=vbuxx_plus_vbuc1
txa
axs #-[{c1}]
//FRAGMENT vbuyy=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
tay
//FRAGMENT vbuz1_ge_vbuxx_then_la1
lda {z1}
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuz1_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbsz1=vbsc1
lda #{c1}
sta {z1}
//FRAGMENT pbuz1=pbuc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbsz1=pbsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuc1_plus_vbuz2
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz3
lda {z3}
ldy {z2}
sta ({z1}),y
//FRAGMENT vbsz1=vbsz2
lda {z2}
sta {z1}
//FRAGMENT pbsc1_derefidx_vbuz1=vbsz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT vbsz1=vbsz1_plus_2
inc {z1}
inc {z1}
//FRAGMENT vbsz1=vbsz1_minus_vbsc1
lax {z1}
axs #{c1}
stx {z1}
//FRAGMENT vbsz1_lt_0_then_la1
lda {z1}
bmi {la1}
//FRAGMENT pbuz1=pbuz2_plus_1
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
//FRAGMENT vbsz1=_neg_vbsz1
lda {z1}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbsz1=vbsz2_plus_vbsz3
lda {z2}
clc
adc {z3}
sta {z1}
//FRAGMENT vbsz1=vbsz2_minus_vbsz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_plus_pbsc1_derefidx_vbsz3
ldy {z2}
lda {c1},y
ldy {z3}
clc
adc {c1},y
sta {z1}
//FRAGMENT _deref_pbsc1=vbsz1
lda {z1}
sta {c1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_minus_pbsc1_derefidx_vbsz3
ldy {z2}
lda {c1},y
ldy {z3}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_plus_pbsc1_derefidx_vbsz2
ldy {z2}
clc
lda {c1},y
adc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsz2_plus_pbsc1_derefidx_vbsz3
lda {z2}
ldy {z3}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsz2_minus_pbsc1_derefidx_vbsz3
lda {z2}
ldy {z3}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=_deref_pbsc1
lda {c1}
sta {z1}
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
//FRAGMENT vbsaa=pbsc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbuz1
ldy {z1}
ldx {c1},y
//FRAGMENT vbsyy=pbsc1_derefidx_vbuz1
ldx {z1}
ldy {c1},x
//FRAGMENT vbsz1=pbsc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuz1=vbuc1_plus_vbuxx
txa
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuz1=vbuc1_plus_vbuyy
tya
clc
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_plus_vbuz1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbuaa=vbuc1_plus_vbuxx
txa
clc
adc #{c1}
//FRAGMENT vbuaa=vbuc1_plus_vbuyy
tya
clc
adc #{c1}
//FRAGMENT vbuxx=vbuc1_plus_vbuz1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbuxx=vbuc1_plus_vbuxx
txa
axs #-[{c1}]
//FRAGMENT vbuxx=vbuc1_plus_vbuyy
tya
tax
axs #-[{c1}]
//FRAGMENT vbuyy=vbuc1_plus_vbuz1
lda #{c1}
clc
adc {z1}
tay
//FRAGMENT vbuyy=vbuc1_plus_vbuxx
txa
clc
adc #{c1}
tay
//FRAGMENT vbuyy=vbuc1_plus_vbuyy
tya
clc
adc #{c1}
tay
//FRAGMENT pbuz1_derefidx_vbuxx=vbuz2
txa
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuz2
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuxx
ldy {z2}
txa
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuxx
txa
tay
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuxx
txa
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuyy
tya
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuyy
stx $ff
tya
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuyy
tya
sta ({z1}),y
//FRAGMENT vbsz1=vbsxx
stx {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbuaa
tay
lda {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbuaa
tay
ldx {c1},y
//FRAGMENT vbsyy=pbsc1_derefidx_vbuaa
tax
ldy {c1},x
//FRAGMENT pbsc1_derefidx_vbuaa=vbsz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuxx=vbsz1
lda {z1}
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuyy=vbsz1
lda {z1}
sta {c1},y
//FRAGMENT vbuz1=vbuc1_plus_vbuaa
clc
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_plus_vbuaa
clc
adc #{c1}
//FRAGMENT vbuxx=vbuc1_plus_vbuaa
tax
axs #-[{c1}]
//FRAGMENT pbuc1_derefidx_vbuz1=vbuaa
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuxx
ldy {z1}
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuyy
tya
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuaa
tax
sta {c1},x
//FRAGMENT vbsxx=vbsxx_minus_vbsc1
txa
axs #{c1}
//FRAGMENT vbsyy=vbsyy_minus_vbsc1
tya
sec
sbc #{c1}
tay
//FRAGMENT vbsaa_lt_0_then_la1
cmp #0
bmi {la1}
//FRAGMENT vbsxx=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsyy=_neg_vbsyy
tya
eor #$ff
clc
adc #$01
tay
//FRAGMENT vbsaa=vbsz1
lda {z1}
//FRAGMENT vbsxx=vbsz1
ldx {z1}
//FRAGMENT vbsz1=vbsz2_plus_vbsaa
clc
adc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsz2_plus_vbsxx
txa
clc
adc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsz2_plus_vbsyy
tya
clc
adc {z2}
sta {z1}
//FRAGMENT vbsaa=vbsz1_plus_vbsz2
lda {z1}
clc
adc {z2}
//FRAGMENT vbsaa=vbsz1_plus_vbsaa
clc
adc {z1}
//FRAGMENT vbsaa=vbsz1_plus_vbsxx
txa
clc
adc {z1}
//FRAGMENT vbsaa=vbsz1_plus_vbsyy
tya
clc
adc {z1}
//FRAGMENT vbsxx=vbsz1_plus_vbsz2
lda {z1}
clc
adc {z2}
tax
//FRAGMENT vbsxx=vbsz1_plus_vbsaa
clc
adc {z1}
tax
//FRAGMENT vbsxx=vbsz1_plus_vbsxx
txa
clc
adc {z1}
tax
//FRAGMENT vbsxx=vbsz1_plus_vbsyy
tya
clc
adc {z1}
tax
//FRAGMENT vbsyy=vbsz1_plus_vbsz2
lda {z1}
clc
adc {z2}
tay
//FRAGMENT vbsyy=vbsz1_plus_vbsaa
clc
adc {z1}
tay
//FRAGMENT vbsyy=vbsz1_plus_vbsxx
txa
clc
adc {z1}
tay
//FRAGMENT vbsyy=vbsz1_plus_vbsyy
tya
clc
adc {z1}
tay
//FRAGMENT vbsz1=vbsaa_plus_vbsz2
clc
adc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsaa_plus_vbsaa
asl
sta {z1}
//FRAGMENT vbsz1=vbsaa_plus_vbsxx
stx $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbsz1=vbsaa_plus_vbsyy
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbsaa=vbsaa_plus_vbsz1
clc
adc {z1}
//FRAGMENT vbsaa=vbsaa_plus_vbsaa
asl
//FRAGMENT vbsaa=vbsaa_plus_vbsxx
stx $ff
clc
adc $ff
//FRAGMENT vbsaa=vbsaa_plus_vbsyy
sty $ff
clc
adc $ff
//FRAGMENT vbsxx=vbsaa_plus_vbsz1
clc
adc {z1}
tax
//FRAGMENT vbsxx=vbsaa_plus_vbsaa
asl
tax
//FRAGMENT vbsxx=vbsaa_plus_vbsxx
stx $ff
clc
adc $ff
tax
//FRAGMENT vbsxx=vbsaa_plus_vbsyy
sty $ff
clc
adc $ff
tax
//FRAGMENT vbsyy=vbsaa_plus_vbsz1
clc
adc {z1}
tay
//FRAGMENT vbsyy=vbsaa_plus_vbsaa
asl
tay
//FRAGMENT vbsyy=vbsaa_plus_vbsxx
stx $ff
clc
adc $ff
tay
//FRAGMENT vbsyy=vbsaa_plus_vbsyy
sty $ff
clc
adc $ff
tay
//FRAGMENT vbsz1=vbsxx_plus_vbsz2
txa
clc
adc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsxx_plus_vbsaa
stx $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbsz1=vbsxx_plus_vbsxx
txa
asl
sta {z1}
//FRAGMENT vbsz1=vbsxx_plus_vbsyy
txa
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbsaa=vbsxx_plus_vbsz1
txa
clc
adc {z1}
//FRAGMENT vbsaa=vbsxx_plus_vbsaa
stx $ff
clc
adc $ff
//FRAGMENT vbsaa=vbsxx_plus_vbsxx
txa
asl
//FRAGMENT vbsaa=vbsxx_plus_vbsyy
txa
sty $ff
clc
adc $ff
//FRAGMENT vbsxx=vbsxx_plus_vbsz1
txa
clc
adc {z1}
tax
//FRAGMENT vbsxx=vbsxx_plus_vbsaa
stx $ff
clc
adc $ff
tax
//FRAGMENT vbsxx=vbsxx_plus_vbsxx
txa
asl
tax
//FRAGMENT vbsxx=vbsxx_plus_vbsyy
txa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbsyy=vbsxx_plus_vbsz1
txa
clc
adc {z1}
tay
//FRAGMENT vbsyy=vbsxx_plus_vbsaa
stx $ff
clc
adc $ff
tay
//FRAGMENT vbsyy=vbsxx_plus_vbsxx
txa
asl
tay
//FRAGMENT vbsyy=vbsxx_plus_vbsyy
txa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbsz1=vbsyy_plus_vbsz2
tya
clc
adc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsyy_plus_vbsaa
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbsz1=vbsyy_plus_vbsxx
txa
sty $ff
clc
adc $ff
sta {z1}
//FRAGMENT vbsz1=vbsyy_plus_vbsyy
tya
asl
sta {z1}
//FRAGMENT vbsaa=vbsyy_plus_vbsz1
tya
clc
adc {z1}
//FRAGMENT vbsaa=vbsyy_plus_vbsaa
sty $ff
clc
adc $ff
//FRAGMENT vbsaa=vbsyy_plus_vbsxx
txa
sty $ff
clc
adc $ff
//FRAGMENT vbsaa=vbsyy_plus_vbsyy
tya
asl
//FRAGMENT vbsxx=vbsyy_plus_vbsz1
tya
clc
adc {z1}
tax
//FRAGMENT vbsxx=vbsyy_plus_vbsaa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbsxx=vbsyy_plus_vbsxx
txa
sty $ff
clc
adc $ff
tax
//FRAGMENT vbsxx=vbsyy_plus_vbsyy
tya
asl
tax
//FRAGMENT vbsyy=vbsyy_plus_vbsz1
tya
clc
adc {z1}
tay
//FRAGMENT vbsyy=vbsyy_plus_vbsaa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbsyy=vbsyy_plus_vbsxx
txa
sty $ff
clc
adc $ff
tay
//FRAGMENT vbsyy=vbsyy_plus_vbsyy
tya
asl
tay
//FRAGMENT vbsz1=vbsz2_minus_vbsxx
txa
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsz2_minus_vbsyy
tya
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbsaa=vbsz1_minus_vbsz2
lda {z1}
sec
sbc {z2}
//FRAGMENT vbsaa=vbsz1_minus_vbsxx
txa
eor #$ff
sec
adc {z1}
//FRAGMENT vbsaa=vbsz1_minus_vbsyy
tya
eor #$ff
sec
adc {z1}
//FRAGMENT vbsxx=vbsz1_minus_vbsz2
lda {z1}
sec
sbc {z2}
tax
//FRAGMENT vbsxx=vbsz1_minus_vbsxx
txa
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbsxx=vbsz1_minus_vbsyy
tya
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbsyy=vbsz1_minus_vbsz2
lda {z1}
sec
sbc {z2}
tay
//FRAGMENT vbsyy=vbsz1_minus_vbsxx
txa
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbsyy=vbsz1_minus_vbsyy
tya
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbsz1=vbsxx_minus_vbsz2
txa
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_vbsxx
lda #0
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_vbsyy
txa
sty $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbsaa=vbsxx_minus_vbsz1
txa
sec
sbc {z1}
//FRAGMENT vbsaa=vbsxx_minus_vbsxx
lda #0
//FRAGMENT vbsaa=vbsxx_minus_vbsyy
txa
sty $ff
sec
sbc $ff
//FRAGMENT vbsxx=vbsxx_minus_vbsz1
txa
sec
sbc {z1}
tax
//FRAGMENT vbsxx=vbsxx_minus_vbsxx
lda #0
tax
//FRAGMENT vbsxx=vbsxx_minus_vbsyy
txa
sty $ff
sec
sbc $ff
tax
//FRAGMENT vbsyy=vbsxx_minus_vbsz1
txa
sec
sbc {z1}
tay
//FRAGMENT vbsyy=vbsxx_minus_vbsxx
lda #0
tay
//FRAGMENT vbsyy=vbsxx_minus_vbsyy
txa
sty $ff
sec
sbc $ff
tay
//FRAGMENT vbsz1=vbsyy_minus_vbsz2
tya
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsyy_minus_vbsxx
tya
stx $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbsz1=vbsyy_minus_vbsyy
lda #0
sta {z1}
//FRAGMENT vbsaa=vbsyy_minus_vbsz1
tya
sec
sbc {z1}
//FRAGMENT vbsaa=vbsyy_minus_vbsxx
tya
stx $ff
sec
sbc $ff
//FRAGMENT vbsaa=vbsyy_minus_vbsyy
lda #0
//FRAGMENT vbsxx=vbsyy_minus_vbsz1
tya
sec
sbc {z1}
tax
//FRAGMENT vbsxx=vbsyy_minus_vbsxx
tya
stx $ff
sec
sbc $ff
tax
//FRAGMENT vbsxx=vbsyy_minus_vbsyy
lda #0
tax
//FRAGMENT vbsyy=vbsyy_minus_vbsz1
tya
sec
sbc {z1}
tay
//FRAGMENT vbsyy=vbsyy_minus_vbsxx
tya
stx $ff
sec
sbc $ff
tay
//FRAGMENT vbsyy=vbsyy_minus_vbsyy
lda #0
tay
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsz2
ldy {z1}
lda {c1},y
ldy {z2}
clc
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsz2
ldx {z1}
lda {c1},x
ldx {z2}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsz2
ldy {z1}
lda {c1},y
ldy {z2}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsz2
lda {c1},x
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsz1
lda {c1},x
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsz1
lda {c1},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsz1
lda {c1},x
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsz2
lda {c1},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsz1
lda {c1},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsz1
lda {c1},y
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsz1
lda {c1},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_plus_pbsc1_derefidx_vbsxx
lda {c1},x
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsxx
lda {c1},x
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsxx
lda {c1},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsxx
lda {c1},x
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},x
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},x
//FRAGMENT vbsxx=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},x
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},y
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsxx
clc
lda {c1},x
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_plus_pbsc1_derefidx_vbsyy
lda {c1},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsyy
lda {c1},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsyy
lda {c1},y
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsyy
lda {c1},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},x
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},x
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},x
adc {c1},y
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},x
adc {c1},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},y
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},y
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},y
adc {c1},y
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsyy_plus_pbsc1_derefidx_vbsyy
clc
lda {c1},y
adc {c1},y
tay
//FRAGMENT _deref_pbsc1=vbsaa
sta {c1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsz2
lda {c1},x
ldy {z2}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsz2
lda {c1},y
ldy {z2}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_minus_pbsc1_derefidx_vbsxx
ldy {z2}
lda {c1},y
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsxx
lda {c1},x
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsxx
lda {c1},y
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_minus_pbsc1_derefidx_vbsyy
ldx {z2}
lda {c1},x
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsyy
lda {c1},x
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsyy
lda {c1},y
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsz2
ldy {z1}
lda {c1},y
ldy {z2}
sec
sbc {c1},y
//FRAGMENT vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsz1
lda {c1},x
ldy {z1}
sec
sbc {c1},y
//FRAGMENT vbsaa=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsz1
lda {c1},y
ldy {z1}
sec
sbc {c1},y
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsxx
ldy {z1}
lda {c1},y
sec
sbc {c1},x
//FRAGMENT vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsxx
lda {c1},x
sec
sbc {c1},x
//FRAGMENT vbsaa=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsxx
lda {c1},y
sec
sbc {c1},x
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsyy
ldx {z1}
lda {c1},x
sec
sbc {c1},y
//FRAGMENT vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsyy
lda {c1},x
sec
sbc {c1},y
//FRAGMENT vbsaa=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsyy
lda {c1},y
sec
sbc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsz2
ldx {z1}
lda {c1},x
ldx {z2}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsz1
lda {c1},x
ldx {z1}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsz1
lda {c1},y
ldx {z1}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsxx
ldy {z1}
lda {c1},y
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsxx
lda {c1},x
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsxx
lda {c1},y
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsyy
ldx {z1}
lda {c1},x
sec
sbc {c1},y
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsyy
lda {c1},x
sec
sbc {c1},y
tax
//FRAGMENT vbsxx=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsyy
lda {c1},y
sec
sbc {c1},y
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsz2
ldy {z1}
lda {c1},y
ldy {z2}
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsz1
lda {c1},x
ldy {z1}
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsz1
lda {c1},y
ldy {z1}
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsxx
ldy {z1}
lda {c1},y
sec
sbc {c1},x
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsxx
lda {c1},x
sec
sbc {c1},x
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsxx
lda {c1},y
sec
sbc {c1},x
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsyy
ldx {z1}
lda {c1},x
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsyy
lda {c1},x
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsyy
lda {c1},y
sec
sbc {c1},y
tay
//FRAGMENT vbsaa=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsz1
ldy {z1}
clc
lda {c1},y
adc {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsz1
ldx {z1}
clc
lda {c1},x
adc {c1},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbsz1_plus_pbsc1_derefidx_vbsz1
ldy {z1}
clc
lda {c1},y
adc {c1},y
tay
//FRAGMENT vbsaa=vbsz1_plus_pbsc1_derefidx_vbsz2
lda {z1}
ldy {z2}
clc
adc {c1},y
//FRAGMENT vbsxx=vbsz1_plus_pbsc1_derefidx_vbsz2
lda {z1}
ldx {z2}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsz1_plus_pbsc1_derefidx_vbsz2
lda {z1}
ldy {z2}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsaa_plus_pbsc1_derefidx_vbsz2
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsaa_plus_pbsc1_derefidx_vbsz1
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbsxx=vbsaa_plus_pbsc1_derefidx_vbsz1
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsaa_plus_pbsc1_derefidx_vbsz1
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsxx_plus_pbsc1_derefidx_vbsz2
ldy {z2}
txa
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsxx_plus_pbsc1_derefidx_vbsz1
ldy {z1}
txa
clc
adc {c1},y
//FRAGMENT vbsxx=vbsxx_plus_pbsc1_derefidx_vbsz1
txa
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsxx_plus_pbsc1_derefidx_vbsz1
ldy {z1}
txa
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsyy_plus_pbsc1_derefidx_vbsz2
tya
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsyy_plus_pbsc1_derefidx_vbsz1
tya
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbsxx=vbsyy_plus_pbsc1_derefidx_vbsz1
ldx {z1}
tya
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsyy_plus_pbsc1_derefidx_vbsz1
tya
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsz2_plus_pbsc1_derefidx_vbsxx
lda {c1},x
clc
adc {z2}
sta {z1}
//FRAGMENT vbsaa=vbsz1_plus_pbsc1_derefidx_vbsxx
lda {c1},x
clc
adc {z1}
//FRAGMENT vbsxx=vbsz1_plus_pbsc1_derefidx_vbsxx
lda {c1},x
clc
adc {z1}
tax
//FRAGMENT vbsyy=vbsz1_plus_pbsc1_derefidx_vbsxx
lda {c1},x
clc
adc {z1}
tay
//FRAGMENT vbsz1=vbsaa_plus_pbsc1_derefidx_vbsxx
clc
adc {c1},x
sta {z1}
//FRAGMENT vbsaa=vbsaa_plus_pbsc1_derefidx_vbsxx
clc
adc {c1},x
//FRAGMENT vbsxx=vbsaa_plus_pbsc1_derefidx_vbsxx
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsaa_plus_pbsc1_derefidx_vbsxx
clc
adc {c1},x
tay
//FRAGMENT vbsz1=vbsxx_plus_pbsc1_derefidx_vbsxx
txa
clc
adc {c1},x
sta {z1}
//FRAGMENT vbsaa=vbsxx_plus_pbsc1_derefidx_vbsxx
txa
clc
adc {c1},x
//FRAGMENT vbsxx=vbsxx_plus_pbsc1_derefidx_vbsxx
txa
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsxx_plus_pbsc1_derefidx_vbsxx
txa
clc
adc {c1},x
tay
//FRAGMENT vbsz1=vbsyy_plus_pbsc1_derefidx_vbsxx
tya
clc
adc {c1},x
sta {z1}
//FRAGMENT vbsaa=vbsyy_plus_pbsc1_derefidx_vbsxx
tya
clc
adc {c1},x
//FRAGMENT vbsxx=vbsyy_plus_pbsc1_derefidx_vbsxx
tya
clc
adc {c1},x
tax
//FRAGMENT vbsyy=vbsyy_plus_pbsc1_derefidx_vbsxx
tya
clc
adc {c1},x
tay
//FRAGMENT vbsz1=vbsz2_plus_pbsc1_derefidx_vbsyy
lda {c1},y
clc
adc {z2}
sta {z1}
//FRAGMENT vbsaa=vbsz1_plus_pbsc1_derefidx_vbsyy
lda {c1},y
clc
adc {z1}
//FRAGMENT vbsxx=vbsz1_plus_pbsc1_derefidx_vbsyy
lda {c1},y
clc
adc {z1}
tax
//FRAGMENT vbsyy=vbsz1_plus_pbsc1_derefidx_vbsyy
lda {c1},y
clc
adc {z1}
tay
//FRAGMENT vbsz1=vbsaa_plus_pbsc1_derefidx_vbsyy
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsaa_plus_pbsc1_derefidx_vbsyy
clc
adc {c1},y
//FRAGMENT vbsxx=vbsaa_plus_pbsc1_derefidx_vbsyy
clc
adc {c1},y
tax
//FRAGMENT vbsyy=vbsaa_plus_pbsc1_derefidx_vbsyy
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsxx_plus_pbsc1_derefidx_vbsyy
txa
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsxx_plus_pbsc1_derefidx_vbsyy
txa
clc
adc {c1},y
//FRAGMENT vbsxx=vbsxx_plus_pbsc1_derefidx_vbsyy
txa
clc
adc {c1},y
tax
//FRAGMENT vbsyy=vbsxx_plus_pbsc1_derefidx_vbsyy
txa
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsyy_plus_pbsc1_derefidx_vbsyy
tya
clc
adc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsyy_plus_pbsc1_derefidx_vbsyy
tya
clc
adc {c1},y
//FRAGMENT vbsxx=vbsyy_plus_pbsc1_derefidx_vbsyy
tya
clc
adc {c1},y
tax
//FRAGMENT vbsyy=vbsyy_plus_pbsc1_derefidx_vbsyy
tya
clc
adc {c1},y
tay
//FRAGMENT vbsz1=vbsaa_minus_pbsc1_derefidx_vbsz2
ldy {z2}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_pbsc1_derefidx_vbsz2
ldy {z2}
txa
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsyy_minus_pbsc1_derefidx_vbsz2
tya
ldy {z2}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsz1_minus_pbsc1_derefidx_vbsz2
lda {z1}
ldy {z2}
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsaa_minus_pbsc1_derefidx_vbsz1
ldy {z1}
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsxx_minus_pbsc1_derefidx_vbsz1
ldy {z1}
txa
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsyy_minus_pbsc1_derefidx_vbsz1
tya
ldy {z1}
sec
sbc {c1},y
//FRAGMENT vbsxx=vbsz1_minus_pbsc1_derefidx_vbsz2
lda {z1}
ldx {z2}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=vbsaa_minus_pbsc1_derefidx_vbsz1
ldx {z1}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=vbsxx_minus_pbsc1_derefidx_vbsz1
txa
ldx {z1}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=vbsyy_minus_pbsc1_derefidx_vbsz1
ldx {z1}
tya
sec
sbc {c1},x
tax
//FRAGMENT vbsyy=vbsz1_minus_pbsc1_derefidx_vbsz2
lda {z1}
ldy {z2}
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsaa_minus_pbsc1_derefidx_vbsz1
ldy {z1}
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsxx_minus_pbsc1_derefidx_vbsz1
ldy {z1}
txa
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsyy_minus_pbsc1_derefidx_vbsz1
tya
ldy {z1}
sec
sbc {c1},y
tay
//FRAGMENT vbsz1=vbsz2_minus_pbsc1_derefidx_vbsxx
lda {z2}
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbsz1=vbsaa_minus_pbsc1_derefidx_vbsxx
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_pbsc1_derefidx_vbsxx
txa
tay
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsyy_minus_pbsc1_derefidx_vbsxx
tya
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbsaa=vbsz1_minus_pbsc1_derefidx_vbsxx
lda {z1}
sec
sbc {c1},x
//FRAGMENT vbsaa=vbsaa_minus_pbsc1_derefidx_vbsxx
sec
sbc {c1},x
//FRAGMENT vbsaa=vbsxx_minus_pbsc1_derefidx_vbsxx
txa
tay
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsyy_minus_pbsc1_derefidx_vbsxx
tya
sec
sbc {c1},x
//FRAGMENT vbsxx=vbsz1_minus_pbsc1_derefidx_vbsxx
lda {z1}
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=vbsaa_minus_pbsc1_derefidx_vbsxx
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=vbsxx_minus_pbsc1_derefidx_vbsxx
txa
tax
sec
sbc {c1},x
tax
//FRAGMENT vbsxx=vbsyy_minus_pbsc1_derefidx_vbsxx
tya
sec
sbc {c1},x
tax
//FRAGMENT vbsyy=vbsz1_minus_pbsc1_derefidx_vbsxx
lda {z1}
sec
sbc {c1},x
tay
//FRAGMENT vbsyy=vbsaa_minus_pbsc1_derefidx_vbsxx
sec
sbc {c1},x
tay
//FRAGMENT vbsyy=vbsxx_minus_pbsc1_derefidx_vbsxx
txa
tay
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsyy_minus_pbsc1_derefidx_vbsxx
tya
sec
sbc {c1},x
tay
//FRAGMENT vbsz1=vbsz2_minus_pbsc1_derefidx_vbsyy
lda {z2}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsaa_minus_pbsc1_derefidx_vbsyy
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_pbsc1_derefidx_vbsyy
txa
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsz1=vbsyy_minus_pbsc1_derefidx_vbsyy
tya
tay
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsaa=vbsz1_minus_pbsc1_derefidx_vbsyy
lda {z1}
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsaa_minus_pbsc1_derefidx_vbsyy
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsxx_minus_pbsc1_derefidx_vbsyy
txa
sec
sbc {c1},y
//FRAGMENT vbsaa=vbsyy_minus_pbsc1_derefidx_vbsyy
tya
tay
sec
sbc {c1},y
//FRAGMENT vbsxx=vbsz1_minus_pbsc1_derefidx_vbsyy
lda {z1}
sec
sbc {c1},y
tax
//FRAGMENT vbsxx=vbsaa_minus_pbsc1_derefidx_vbsyy
sec
sbc {c1},y
tax
//FRAGMENT vbsxx=vbsxx_minus_pbsc1_derefidx_vbsyy
txa
sec
sbc {c1},y
tax
//FRAGMENT vbsxx=vbsyy_minus_pbsc1_derefidx_vbsyy
tya
tax
sec
sbc {c1},x
tax
//FRAGMENT vbsyy=vbsz1_minus_pbsc1_derefidx_vbsyy
lda {z1}
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsaa_minus_pbsc1_derefidx_vbsyy
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsxx_minus_pbsc1_derefidx_vbsyy
txa
sec
sbc {c1},y
tay
//FRAGMENT vbsyy=vbsyy_minus_pbsc1_derefidx_vbsyy
tya
tay
sec
sbc {c1},y
tay
//FRAGMENT vbsz1=vbsaa
sta {z1}
//FRAGMENT vbsaa=_deref_pbsc1
lda {c1}
//FRAGMENT vbsxx=_deref_pbsc1
ldx {c1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbsxx_lt_0_then_la1
cpx #0
bmi {la1}
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx
lda {c1},x
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy
ldx {c1},y
//FRAGMENT vbsyy=vbsz1
ldy {z1}
//FRAGMENT vbsz1=vbsyy
sty {z1}
//FRAGMENT vbsyy=_deref_pbsc1
ldy {c1}
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbuyy=vbuc1_plus_vbuaa
clc
adc #{c1}
tay
//FRAGMENT _deref_pbsc1=vbsxx
stx {c1}
//FRAGMENT _deref_pbsc1=vbsyy
sty {c1}
//FRAGMENT pbuc1_derefidx_vbuxx=vbuaa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuaa
sta {c1},y
//FRAGMENT vbsyy=vbsxx
txa
tay
//FRAGMENT pbuz1=pbuz1_plus_1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
bne {la1}
//FRAGMENT vbuaa_neq_0_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuaa=_inc_vbuaa
clc
adc #1
//FRAGMENT vbuaa=vbuyy
tya
//FRAGMENT vbuxx_neq_0_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuxx=vbuyy
tya
tax
//FRAGMENT vbuyy_neq_0_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT vbuyy=vbuxx
txa
tay
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuaa
tay
lda {c2},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1},y
//FRAGMENT pbuz1_lt_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=pbuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
sta {z1}
//FRAGMENT vbuz1=vbuz1_rol_1
asl {z1}
//FRAGMENT vbuz1=vbuz2_ror_3
lda {z2}
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuz3
lda {z2}
ldy {z3}
and {c1},y
sta {z1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
//FRAGMENT vbuz1=_bnot__deref_pbuc1
lda {c1}
eor #$ff
sta {z1}
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
//FRAGMENT vbuaa=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
//FRAGMENT vbuxx=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuaa
tay
lda ({z2}),y
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuaa
tay
lda ({z1}),y
//FRAGMENT vbuxx=pbuz1_derefidx_vbuaa
tay
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuaa
tay
lda ({z1}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuxx
txa
tay
lda ({z1}),y
//FRAGMENT vbuxx=pbuz1_derefidx_vbuxx
txa
tay
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuxx
txa
tay
lda ({z1}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuyy
lda ({z2}),y
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuyy
lda ({z1}),y
//FRAGMENT vbuxx=pbuz1_derefidx_vbuyy
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuyy
lda ({z1}),y
tay
//FRAGMENT vbuz1=vbuaa_band_vbuc1
and #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_band_vbuc1
and #{c1}
//FRAGMENT vbuxx=vbuaa_band_vbuc1
ldx #{c1}
axs #0
//FRAGMENT vbuaa=vbuz1_ror_3
lda {z1}
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuz1_ror_3
lda {z1}
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuz1_ror_3
lda {z1}
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuaa_ror_3
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuaa_ror_3
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuaa_ror_3
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuaa_ror_3
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuxx_ror_3
txa
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuxx_ror_3
txa
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuxx_ror_3
txa
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuxx_ror_3
txa
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuyy_ror_3
tya
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuyy_ror_3
tya
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuyy_ror_3
tya
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuyy_ror_3
tya
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
and {c1},y
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z1}
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z1}
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuz2
lda {z1}
ldx {z2}
and {c1},x
tax
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z1}
tax
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z1}
tax
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
and {c1},y
tay
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z1}
tay
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z1}
tay
//FRAGMENT vbuz1=vbuaa_band_pbuc1_derefidx_vbuz2
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
sta {z1}
//FRAGMENT vbuz1=vbuaa_band_pbuc1_derefidx_vbuyy
and {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuaa_band_pbuc1_derefidx_vbuz1
ldy {z1}
and {c1},y
//FRAGMENT vbuaa=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
//FRAGMENT vbuaa=vbuaa_band_pbuc1_derefidx_vbuyy
and {c1},y
//FRAGMENT vbuxx=vbuaa_band_pbuc1_derefidx_vbuz1
ldx {z1}
and {c1},x
tax
//FRAGMENT vbuxx=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
tax
//FRAGMENT vbuxx=vbuaa_band_pbuc1_derefidx_vbuyy
ldx {c1},y
axs #0
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuaa
tay
lda {c2},y
sta {c1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1}
//FRAGMENT vbuaa=_bnot__deref_pbuc1
lda {c1}
eor #$ff
//FRAGMENT vbuxx=_bnot__deref_pbuc1
lda {c1}
eor #$ff
tax
//FRAGMENT vbuyy=_bnot__deref_pbuc1
lda {c1}
eor #$ff
tay
//FRAGMENT vbuyy=vbuaa_band_vbuc1
and #{c1}
tay
//FRAGMENT vbuz1=vbuxx_band_pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sax {z1}
//FRAGMENT vbuz1=vbuyy_band_pbuc1_derefidx_vbuz2
tya
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuyy_band_vbuc1
tya
and #{c1}
sta {z1}
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx
ldy {c1},x
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy
lda {c1},y
tay
//FRAGMENT vbuyy=vbuaa_band_pbuc1_derefidx_vbuyy
and {c1},y
tay
//FRAGMENT pbuz1=pbuc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=vbuz1_minus_2
dec {z1}
dec {z1}
//FRAGMENT _deref_pbuc1=_dec__deref_pbuc1
dec {c1}
//FRAGMENT vbuz1=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
sta {z1}
//FRAGMENT vbuz1=_inc_vbuz2
ldy {z2}
iny
sty {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=_byte_vwuz3
lda {z3}
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=vbuz2
lda {z2}
ldy #{c1}
sta ({z1}),y
//FRAGMENT vwuz1=_deref_pbuc1_word__deref_pbuc2
lda {c1}
sta {z1}+1
lda {c2}
sta {z1}
//FRAGMENT _deref_pbuz1=_deref_pbuc1
lda {c1}
ldy #0
sta ({z1}),y
//FRAGMENT vwuz1=vwuc1_plus_pbuc2_derefidx_vbuaa
tay
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_pbuc2_derefidx_vbuxx
lda {c2},x
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_pbuc2_derefidx_vbuyy
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbuxx=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
tay
//FRAGMENT vbuz1=vbuz2_bor_vbuaa
ora {z2}
sta {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuaa
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuaa
ora {z1}
tay
//FRAGMENT vbuz1=vbuz2_bor_vbuxx
txa
ora {z2}
sta {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuxx
txa
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuxx
txa
ora {z1}
tay
//FRAGMENT vbuz1=vbuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuyy
tya
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuyy
tya
ora {z1}
tay
//FRAGMENT vbuz1=vbuaa_bor_vbuz2
ora {z2}
sta {z1}
//FRAGMENT vbuxx=vbuaa_bor_vbuz1
ora {z1}
tax
//FRAGMENT vbuyy=vbuaa_bor_vbuz1
ora {z1}
tay
//FRAGMENT vbuz1=vbuaa_bor_vbuaa
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuz1
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuz1
ldx {z1}
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbuxx
txa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuxx
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbuyy
tya
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuyy
tya
sta {c1},y
//FRAGMENT vbuz1=_inc_vbuxx
inx
stx {z1}
//FRAGMENT vbuxx=_inc_vbuz1
ldx {z1}
inx
//FRAGMENT pbuz1_derefidx_vbuxx=_byte_vwuz2
txa
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=_byte_vwuz2
lda {z2}
sta ({z1}),y
//FRAGMENT vbuaa=vbuyy_band_vbuc1
tya
and #{c1}
//FRAGMENT vbuz1=vbuxx_bor_vbuz2
txa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuyy_bor_vbuz2
tya
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuaa_bor_vbuxx
stx $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuxx_bor_vbuxx
stx {z1}
//FRAGMENT pbuz1_derefidx_vbuc1=vbuaa
ldy #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=vbuxx
ldy #{c1}
txa
sta ({z1}),y
//FRAGMENT vbuxx=vbuxx_bor_vbuz1
txa
ora {z1}
tax
//FRAGMENT vbuxx=vbuyy_bor_vbuz1
tya
ora {z1}
tax
//FRAGMENT vbuyy=_byte1_vwuz1
ldy {z1}+1
//FRAGMENT vbuz1=vbuz2_bor__byte1_vwuz3
lda {z2}
ora {z3}+1
sta {z1}
//FRAGMENT vbuyy=_byte0_vwuz1
ldy {z1}
//FRAGMENT vbuaa=_inc_vbuz1
lda {z1}
clc
adc #1
//FRAGMENT vbuz1=_inc_vbuaa
clc
adc #1
sta {z1}
//FRAGMENT vbuyy=_inc_vbuz1
ldy {z1}
iny
//FRAGMENT vbuz1=_inc_vbuyy
iny
sty {z1}
//FRAGMENT vbuaa=_inc_vbuxx
inx
txa
//FRAGMENT vbuxx=_inc_vbuaa
tax
inx
//FRAGMENT vbuyy=_inc_vbuxx
txa
tay
iny
//FRAGMENT vbuxx=_inc_vbuyy
tya
tax
inx
//FRAGMENT vbuaa=_inc_vbuyy
iny
tya
//FRAGMENT vbuyy=_inc_vbuaa
tay
iny
//FRAGMENT vbuz1=vbuxx_bor_vbuaa
stx $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuyy_bor_vbuaa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_2
dex
dex
//FRAGMENT vbuyy=vbuyy_minus_2
dey
dey
//FRAGMENT vbuz1=vbuz1_bor_vbuaa
ora {z1}
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_ror_6
lda {z2}
asl
sta $ff
lda {z2}+1
rol
sta {z1}
lda #0
rol
sta {z1}+1
asl $ff
rol {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_6
lda {z2}+1
lsr
sta $ff
lda {z2}
ror
sta {z1}+1
lda #0
ror
sta {z1}
lsr $ff
ror {z1}+1
ror {z1}
//FRAGMENT vwuz1=vwuz2_minus_vbuc1
sec
lda {z2}
sbc #{c1}
sta {z1}
lda {z2}+1
sbc #0
sta {z1}+1
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vduz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda #0
sta {z1}+2
sta {z1}+3
//FRAGMENT vwsz1_lt_vwuz2_then_la1
lda {z1}+1
bmi {la1}
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT pbuz1=pbuz2_plus_vwsz3
clc
lda {z2}
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT vduz1=pduz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
iny
lda ({z2}),y
sta {z1}+2
iny
lda ({z2}),y
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_vduz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
lda {z2}+2
adc {z3}+2
sta {z1}+2
lda {z2}+3
adc {z3}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_pduc1_derefidx_vbuz3
ldy {z3}
clc
lda {z2}
adc {c1},y
sta {z1}
lda {z2}+1
adc {c1}+1,y
sta {z1}+1
lda {z2}+2
adc {c1}+2,y
sta {z1}+2
lda {z2}+3
adc {c1}+3,y
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_pduz3_derefidx_vbuz4
ldy {z4}
lda {z2}
clc
adc ({z3}),y
sta {z1}
iny
lda {z2}+1
adc ({z3}),y
sta {z1}+1
iny
lda {z2}+2
adc ({z3}),y
sta {z1}+2
iny
lda {z2}+3
adc ({z3}),y
sta {z1}+3
//FRAGMENT vduz1=_bnot_vduz2
lda {z2}
eor #$ff
sta {z1}
lda {z2}+1
eor #$ff
sta {z1}+1
lda {z2}+2
eor #$ff
sta {z1}+2
lda {z2}+3
eor #$ff
sta {z1}+3
//FRAGMENT vduz1=vduz2_bor_vduz3
lda {z2}
ora {z3}
sta {z1}
lda {z2}+1
ora {z3}+1
sta {z1}+1
lda {z2}+2
ora {z3}+2
sta {z1}+2
lda {z2}+3
ora {z3}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_bxor_vduz3
lda {z2}
eor {z3}
sta {z1}
lda {z2}+1
eor {z3}+1
sta {z1}+1
lda {z2}+2
eor {z3}+2
sta {z1}+2
lda {z2}+3
eor {z3}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_band_vduz3
lda {z2}
and {z3}
sta {z1}
lda {z2}+1
and {z3}+1
sta {z1}+1
lda {z2}+2
and {z3}+2
sta {z1}+2
lda {z2}+3
and {z3}+3
sta {z1}+3
//FRAGMENT vbuz1=vbuz2_minus_vbuc1
lax {z2}
axs #{c1}
stx {z1}
//FRAGMENT vduz1=_deref_pduc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
lda {c1}+2
sta {z1}+2
lda {c1}+3
sta {z1}+3
//FRAGMENT vwuz1=vwuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_minus_vwuz2
sec
lda #<{c1}
sbc {z2}
sta {z1}
lda #>{c1}
sbc {z2}+1
sta {z1}+1 
//FRAGMENT vbsz1=_sbyte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vbsz1=_inc_vbsz1
inc {z1}
//FRAGMENT vbsz1=vbsc1_minus_vbsz2
lda #{c1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1_ge_0_then_la1
lda {z1}
cmp #0
bpl {la1}
//FRAGMENT 0_neq_vbsz1_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT _deref_pbuc1=_deref_pbuc2
lda {c2}
sta {c1}
//FRAGMENT vbuz1=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vduz1=pduz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
iny
lda ({z2}),y
sta {z1}+2
iny
lda ({z2}),y
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_pduc1_derefidx_vbuxx
lda {z2}
clc
adc {c1},x
sta {z1}
lda {z2}+1
adc {c1}+1,x
sta {z1}+1
lda {z2}+2
adc {c1}+2,x
sta {z1}+2
lda {z2}+3
adc {c1}+3,x
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_pduz3_derefidx_vbuxx
txa
tay
lda {z2}
clc
adc ({z3}),y
sta {z1}
iny
lda {z2}+1
adc ({z3}),y
sta {z1}+1
iny
lda {z2}+2
adc ({z3}),y
sta {z1}+2
iny
lda {z2}+3
adc ({z3}),y
sta {z1}+3
//FRAGMENT vbuz1=vbuaa_minus_vbuc1
sec
sbc #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuxx_minus_vbuc1
txa
axs #{c1}
stx {z1}
//FRAGMENT vbuz1=vbuyy_minus_vbuc1
tya
sec
sbc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuz1_minus_vbuc1
lda {z1}
sec
sbc #{c1}
//FRAGMENT vbuaa=vbuaa_minus_vbuc1
sec
sbc #{c1}
//FRAGMENT vbuaa=vbuxx_minus_vbuc1
txa
sec
sbc #{c1}
//FRAGMENT vbuaa=vbuyy_minus_vbuc1
tya
sec
sbc #{c1}
//FRAGMENT vbuxx=vbuz1_minus_vbuc1
lax {z1}
axs #{c1}
//FRAGMENT vbuxx=vbuaa_minus_vbuc1
tax
axs #{c1}
//FRAGMENT vbuaa_ge_vbuz1_then_la1
cmp {z1}
bcs {la1}
//FRAGMENT vbsaa=_sbyte_vwuz1
lda {z1}
//FRAGMENT vbsxx=_sbyte_vwuz1
ldx {z1}
//FRAGMENT vbsz1=vbsc1_minus_vbsaa
eor #$ff
sec
adc #{c1}
sta {z1}
//FRAGMENT vbsz1=vbsc1_minus_vbsxx
txa
eor #$ff
sec
adc #{c1}
sta {z1}
//FRAGMENT vbsz1=vbsc1_minus_vbsyy
tya
eor #$ff
sec
adc #{c1}
sta {z1}
//FRAGMENT vbsxx=vbsc1_minus_vbsz1
lda #{c1}
sec
sbc {z1}
tax
//FRAGMENT vbsxx=vbsc1_minus_vbsaa
eor #$ff
tax
axs #-{c1}-1
//FRAGMENT vbsxx=vbsc1_minus_vbsxx
txa
eor #$ff
tax
axs #-{c1}-1
//FRAGMENT vbsxx=vbsc1_minus_vbsyy
tya
eor #$ff
tax
axs #-{c1}-1
//FRAGMENT vbsxx_ge_0_then_la1
cpx #0
bpl {la1}
//FRAGMENT 0_neq_vbsxx_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuxx=vbuxx_minus_vbuz1
txa
sec
sbc {z1}
tax
//FRAGMENT vbuz1=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
tax
//FRAGMENT vbuz1=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_vbuxx
lda #0
tax
//FRAGMENT vbuz1=vbuz1_minus_vbuyy
tya
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_vbuyy
txa
sty $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx_lt_vbuz1_then_la1
cpx {z1}
bcc {la1}
//FRAGMENT vbuxx=vbuyy_minus_vbuc1
tya
tax
axs #{c1}
//FRAGMENT vbuyy=vbuz1_minus_vbuc1
lda {z1}
sec
sbc #{c1}
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuc1
txa
sec
sbc #{c1}
tay
//FRAGMENT vbuz1_ge_vbuyy_then_la1
lda {z1}
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuyy_then_la1
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuyy_ge_vbuz1_then_la1
cpy {z1}
bcs {la1}
//FRAGMENT vbsaa=_inc_vbsaa
clc
adc #1
//FRAGMENT vbsxx=_inc_vbsxx
inx
//FRAGMENT vbsyy=_sbyte_vwuz1
ldy {z1}
//FRAGMENT vbsyy=_inc_vbsyy
iny
//FRAGMENT vbuxx=vbuyy_band_vbuc1
ldx #{c1}
tya
axs #0
//FRAGMENT vbuyy=vbuyy_band_vbuc1
tya
and #{c1}
tay
//FRAGMENT vduz1=vduz2_bxor_vduz1
lda {z1}
eor {z2}
sta {z1}
lda {z1}+1
eor {z2}+1
sta {z1}+1
lda {z1}+2
eor {z2}+2
sta {z1}+2
lda {z1}+3
eor {z2}+3
sta {z1}+3
//FRAGMENT vduz1=vduz1_bxor_vduz2
lda {z1}
eor {z2}
sta {z1}
lda {z1}+1
eor {z2}+1
sta {z1}+1
lda {z1}+2
eor {z2}+2
sta {z1}+2
lda {z1}+3
eor {z2}+3
sta {z1}+3
//FRAGMENT vduz1=vduz1_bor_vduz2
lda {z2}
ora {z1}
sta {z1}
lda {z2}+1
ora {z1}+1
sta {z1}+1
lda {z2}+2
ora {z1}+2
sta {z1}+2
lda {z2}+3
ora {z1}+3
sta {z1}+3
//FRAGMENT vbuz1=vbuz1_rol_2
lda {z1}
asl
asl
sta {z1}
//FRAGMENT vwuz1=vwuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_plus_1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_band_vbuc1
lda #{c1}
and {z1}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_ror_6
lda {z1}
asl
sta $ff
lda {z1}+1
rol
sta {z1}
lda #0
rol
sta {z1}+1
asl $ff
rol {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_6
lda {z1}+1
lsr
sta $ff
lda {z1}
ror
sta {z1}+1
lda #0
ror
sta {z1}
lsr $ff
ror {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz1_plus_pduz2_derefidx_vbuz3
ldy {z3}
lda {z1}
clc
adc ({z2}),y
sta {z1}
iny
lda {z1}+1
adc ({z2}),y
sta {z1}+1
iny
lda {z1}+2
adc ({z2}),y
sta {z1}+2
iny
lda {z1}+3
adc ({z2}),y
sta {z1}+3
//FRAGMENT vduz1=vduz1_band_vduz2
lda {z1}
and {z2}
sta {z1}
lda {z1}+1
and {z2}+1
sta {z1}+1
lda {z1}+2
and {z2}+2
sta {z1}+2
lda {z1}+3
and {z2}+3
sta {z1}+3
//FRAGMENT pbuz1=pbuc1_minus_vwuz1
sec
lda #<{c1}
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_vwuz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vduz1=vduz1_plus_pduc1_derefidx_vbuz2
ldy {z2}
clc
lda {z1}
adc {c1},y
sta {z1}
lda {z1}+1
adc {c1}+1,y
sta {z1}+1
lda {z1}+2
adc {c1}+2,y
sta {z1}+2
lda {z1}+3
adc {c1}+3,y
sta {z1}+3
//FRAGMENT vduz1=vduz2_bor_vduz1
lda {z2}
ora {z1}
sta {z1}
lda {z2}+1
ora {z1}+1
sta {z1}+1
lda {z2}+2
ora {z1}+2
sta {z1}+2
lda {z2}+3
ora {z1}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_vduz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
lda {z1}+2
adc {z2}+2
sta {z1}+2
lda {z1}+3
adc {z2}+3
sta {z1}+3
//FRAGMENT vwuz1=vwuz1_rol_1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbsz1=_neg_vbsz2
lda {z2}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
sta {z1}
//FRAGMENT vwuz1=vwuz1_bor_vbuc1
lda #{c1}
ora {z1}
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
//FRAGMENT vwsz1=_neg_vwsz2
sec
lda #0
sbc {z2}
sta {z1}
lda #0
sbc {z2}+1
sta {z1}+1
//FRAGMENT vbsaa=pbsc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbsaa=pbsc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vwsz1=pwsc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=vbuyy_ror_4
tya
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuyy_ror_4
tya
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuyy_ror_4
tya
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuyy_ror_4
tya
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbsz1=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbsxx=_neg_vbsz1
lda {z1}
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsz1=_neg_vbsyy
tya
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbsaa=_neg_vbsz1
lda {z1}
eor #$ff
clc
adc #$01
//FRAGMENT vbsaa=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
//FRAGMENT vbsaa=_neg_vbsyy
tya
eor #$ff
clc
adc #$01
//FRAGMENT vbsxx=_neg_vbsyy
tya
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsyy=_neg_vbsz1
lda {z1}
eor #$ff
clc
adc #$01
tay
//FRAGMENT vbsyy=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
tay
//FRAGMENT vbsz1=_neg_vbsaa
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbsaa=_neg_vbsaa
eor #$ff
clc
adc #$01
//FRAGMENT vbsxx=_neg_vbsaa
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsyy=_neg_vbsaa
eor #$ff
clc
adc #$01
tay
//FRAGMENT vbuaa=vbuaa_bor_vbuc1
ora #{c1}
//FRAGMENT vbuxx=vbuxx_bor_vbuc1
txa
ora #{c1}
tax
//FRAGMENT vbuyy=vbuyy_bor_vbuc1
tya
ora #{c1}
tay
//FRAGMENT vbuaa=vbuaa_minus_vbuz1
sec
sbc {z1}
//FRAGMENT vbuaa=vbuaa_minus_vbuxx
stx $ff
sec
sbc $ff
//FRAGMENT vbuaa=vbuaa_minus_vbuyy
sty $ff
sec
sbc $ff
//FRAGMENT vbuyy=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
tay
//FRAGMENT vbuyy=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuyy_minus_vbuyy
lda #0
tay
//FRAGMENT vbuyy_lt_vbuz1_then_la1
cpy {z1}
bcc {la1}
//FRAGMENT vbsyy_lt_0_then_la1
cpy #0
bmi {la1}
//FRAGMENT vbsaa=vbsyy
tya
//FRAGMENT vbsyy=vbsaa
tay
//FRAGMENT _deref_pwuc1=vwuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vwuz1=vwuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
ora {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuz1_plus_2
lda {z1}
clc
adc #2
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc2_derefidx_vbuz3
ldy {z2}
lda {c1},y
ldy {z3}
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc1_derefidx_vbuz3
ldy {z2}
lda {c1},y
ldy {z3}
clc
adc {c1},y
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus_vbuxx
txa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_plus_vbuyy
tya
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuaa
tay
lda {c1},y
ora {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ora {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ora {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuz1
txa
ldx {z1}
ora {c1},x
tax
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuaa
tay
txa
ora {c1},y
tax
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuxx
txa
ora {c1},x
tax
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuyy
txa
ora {c1},y
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuz1
tya
ldy {z1}
ora {c1},y
tay
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuaa
tax
tya
ora {c1},x
tay
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuxx
tya
ora {c1},x
tay
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuyy
tya
ora {c1},y
tay
//FRAGMENT vbuxx=vbuxx_plus_2
inx
inx
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz2
ldy {z1}
lda {c1},y
ldy {z2}
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz2
ldx {z1}
lda {c1},x
ldx {z2}
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz2
ldy {z1}
lda {c1},y
ldy {z2}
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuz2
tay
lda {c1},y
ldy {z2}
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuz1
tay
lda {c1},y
ldy {z1}
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuz1
tax
lda {c1},x
ldx {z1}
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuz1
tay
lda {c1},y
ldy {z1}
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuz2
lda {c1},x
ldy {z2}
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuz1
lda {c1},x
ldy {z1}
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuz1
lda {c1},x
ldx {z1}
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuz1
lda {c1},x
ldy {z1}
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuz2
lda {c1},y
ldy {z2}
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuz1
lda {c1},y
ldy {z1}
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuz1
lda {c1},y
ldx {z1}
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuz1
lda {c1},y
ldy {z1}
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuxx
lda {c2},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuxx
tay
lda {c1},y
clc
adc {c2},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuxx
tay
lda {c1},y
clc
adc {c2},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuxx
tay
lda {c1},y
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuxx
tay
lda {c1},y
clc
adc {c2},x
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuxx
lda {c1},x
clc
adc {c2},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuxx
lda {c1},x
clc
adc {c2},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuxx
lda {c1},x
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuxx
lda {c1},x
clc
adc {c2},x
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuxx
lda {c1},y
clc
adc {c2},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuxx
lda {c1},y
clc
adc {c2},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuxx
lda {c1},y
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuxx
lda {c1},y
clc
adc {c2},x
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuyy
lda {c2},y
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c2},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuyy
lda {c1},x
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuyy
lda {c1},x
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuyy
lda {c1},x
clc
adc {c2},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuyy
lda {c1},x
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuyy
lda {c1},y
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuyy
lda {c1},y
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuyy
lda {c1},y
clc
adc {c2},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuyy
lda {c1},y
clc
adc {c2},y
tay
//FRAGMENT pbuz1_derefidx_vbuz2=vbuaa
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuaa
stx $ff
ldy $ff
sta ({z1}),y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuz2
ldy {z1}
lda {c1},y
ldy {z2}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuz2
ldx {z1}
lda {c1},x
ldx {z2}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuz2
ldy {z1}
lda {c1},y
ldy {z2}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuaa
tax
lda {c1},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc1_derefidx_vbuxx
lda {c1},x
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc1_derefidx_vbuyy
lda {c1},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuz2
tay
lda {c1},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuz1
tay
lda {c1},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuz1
tax
lda {c1},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuz1
tay
lda {c1},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuaa
tax
lda {c1},x
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuxx
tay
lda {c1},x
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuxx
tay
lda {c1},x
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuxx
tay
lda {c1},x
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuxx
tay
lda {c1},x
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc1_derefidx_vbuyy
tax
lda {c1},x
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuz2
lda {c1},x
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuz1
lda {c1},x
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuz1
lda {c1},x
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuz1
lda {c1},x
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},x
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},x
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},x
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},x
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},x
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuyy
lda {c1},x
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuyy
lda {c1},x
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuyy
lda {c1},x
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_pbuc1_derefidx_vbuyy
lda {c1},x
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuz2
lda {c1},y
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuz1
lda {c1},y
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuz1
lda {c1},y
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuz1
lda {c1},y
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuaa
tax
lda {c1},x
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuaa
tax
lda {c1},x
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuaa
tax
lda {c1},x
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuaa
tax
lda {c1},x
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {c1},y
tay
//FRAGMENT pbuz1_derefidx_vbuyy=vbuaa
sta ({z1}),y
//FRAGMENT vbuaa_le_vbuz1_then_la1
ldy {z1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuxx_le_vbuz1_then_la1
lda {z1}
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vwsz1=_inc_vwsz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwsz1_neq_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwsz1_neq_vwsc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT _deref_pwuc1=vbuz1
lda {z1}
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT _deref_pbuc1_eq_vbuc2_then_la1
lda #{c2}
cmp {c1}
beq {la1}
//FRAGMENT _deref_pwuc1=vbuaa
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT _deref_pwuc1=vbuxx
txa
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT _deref_pwuc1=vbuyy
tya
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT vbuaa=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
//FRAGMENT vbuaa=vbuxx_bor_vbuz1
txa
ora {z1}
//FRAGMENT vbuyy=vbuxx_bor_vbuz1
txa
ora {z1}
tay
//FRAGMENT vbuz1=vbuz2_plus__deref_pbuc1
lda {c1}
clc
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_minus_vbuz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_vbuc1
clc
adc #{c1}
//FRAGMENT vbuaa=vbuz1_plus__deref_pbuc1
lda {c1}
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus__deref_pbuc1
lda {c1}
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_plus__deref_pbuc1
lda {c1}
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuaa_plus__deref_pbuc1
clc
adc {c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus__deref_pbuc1
clc
adc {c1}
//FRAGMENT vbuxx=vbuaa_plus__deref_pbuc1
clc
adc {c1}
tax
//FRAGMENT vbuyy=vbuaa_plus__deref_pbuc1
clc
adc {c1}
tay
//FRAGMENT vbuz1=vbuxx_plus__deref_pbuc1
txa
clc
adc {c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus__deref_pbuc1
txa
clc
adc {c1}
//FRAGMENT vbuxx=vbuxx_plus__deref_pbuc1
txa
clc
adc {c1}
tax
//FRAGMENT vbuyy=vbuxx_plus__deref_pbuc1
txa
clc
adc {c1}
tay
//FRAGMENT vbuz1=vbuyy_plus__deref_pbuc1
tya
clc
adc {c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus__deref_pbuc1
tya
clc
adc {c1}
//FRAGMENT vbuxx=vbuyy_plus__deref_pbuc1
tya
clc
adc {c1}
tax
//FRAGMENT vbuyy=vbuyy_plus__deref_pbuc1
tya
clc
adc {c1}
tay
//FRAGMENT vbuz1=vbuaa_minus_vbuz2
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_minus_vbuz2
txa
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuyy_minus_vbuz2
tya
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_minus_vbuxx
txa
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuaa_minus_vbuxx
stx $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuxx_minus_vbuxx
lda #0
sta {z1}
//FRAGMENT vbuz1=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuz2_minus_vbuyy
tya
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuaa_minus_vbuyy
sty $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuxx_minus_vbuyy
txa
sty $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuyy_minus_vbuyy
lda #0
sta {z1}
//FRAGMENT vbuaa=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
//FRAGMENT vbuaa=vbuxx_minus_vbuz1
txa
sec
sbc {z1}
//FRAGMENT vbuaa=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
//FRAGMENT vbuaa=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
//FRAGMENT vbuaa=vbuxx_minus_vbuxx
lda #0
//FRAGMENT vbuaa=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
//FRAGMENT vbuaa=vbuz1_minus_vbuyy
tya
eor #$ff
sec
adc {z1}
//FRAGMENT vbuaa=vbuxx_minus_vbuyy
txa
sty $ff
sec
sbc $ff
//FRAGMENT vbuaa=vbuyy_minus_vbuyy
lda #0
//FRAGMENT vbuxx=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
tax
//FRAGMENT vbuxx=vbuaa_minus_vbuz1
sec
sbc {z1}
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
tax
//FRAGMENT vbuxx=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbuxx=vbuaa_minus_vbuxx
stx $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuz1_minus_vbuyy
tya
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbuxx=vbuaa_minus_vbuyy
sty $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuyy
lda #0
tax
//FRAGMENT vbuyy=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
tay
//FRAGMENT vbuyy=vbuaa_minus_vbuz1
sec
sbc {z1}
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuz1
txa
sec
sbc {z1}
tay
//FRAGMENT vbuyy=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbuyy=vbuaa_minus_vbuxx
stx $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuxx
lda #0
tay
//FRAGMENT vbuyy=vbuz1_minus_vbuyy
tya
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbuyy=vbuaa_minus_vbuyy
sty $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuyy
txa
sty $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuyy_plus_2
iny
iny
//FRAGMENT vwuz1=_deref_pwuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vwsz1=_sword_vbsz2
lda {z2}
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_rol_1
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_minus_vwsz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_minus_vwsz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_minus_vwsc1
lda {z1}
sec
sbc #<{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vbsyy_ge_0_then_la1
cpy #0
bpl {la1}
//FRAGMENT vwsz1=_sword_vbsyy
tya
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_rol_1
asl {z1}
rol {z1}+1
