//KICKC FRAGMENT CACHE 10dedb3bb9 10dedb58e1
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuc1_neq_vbuz1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuc1_neq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #{c1}
bne {la1}
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
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
//FRAGMENT vwuz1=vwuz2_plus_1
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
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
//FRAGMENT pvoz1=pvoz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
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
//FRAGMENT vduz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda #0
sta {z1}+2
sta {z1}+3
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vduz1=vduc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda #<{c1}>>$10
sta {z1}+2
lda #>{c1}>>$10
sta {z1}+3
//FRAGMENT vwsz1=vwsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
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
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
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
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vduz1=vduz1_plus_vduz2
lda {z1}
clc
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
//FRAGMENT vwsz1=vwsz1_plus_vbsc1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_ror_4
lda {z2}
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1_eq_0_then_la1
lda {z1}
cmp #0
beq {la1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbuz1=vbuz2_rol_2
lda {z2}
asl
asl
sta {z1}
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
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
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
lda {z2}
clc
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
//FRAGMENT vduz1=vduz2_rol_pbuc1_derefidx_vbuz3
ldx {z3}
ldy {c1},x
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e:
//FRAGMENT vbuz1=vbuc1_minus_pbuc2_derefidx_vbuz2
lda #{c1}
ldy {z2}
sec
sbc {c2},y
sta {z1}
//FRAGMENT vduz1=vduz2_ror_vbuz3
ldx {z3}
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
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
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
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
//FRAGMENT _deref_pwuc1=vbuc2
lda #0
sta {c1}+1
lda #<{c2}
sta {c1}
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_neq_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT _deref_pbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbsz1=vbsc1
lda #{c1}
sta {z1}
//FRAGMENT vbsz1_gt_0_then_la1
lda {z1}
cmp #0
beq !+
bpl {la1}
!:
//FRAGMENT vbsz1=_dec_vbsz1
dec {z1}
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_1
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuz1=vwuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vwuz1=vwuz2_rol_2
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT _deref_(_deref_qbuc1)=_deref_pbuc2
lda {c2}
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_pbuz1=vbuz2
lda {z2}
ldy #0
sta ({z1}),y
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
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_minus_vwuz2
sec
lda #<{c1}
sbc {z2}
sta {z1}
lda #>{c1}
sbc {z2}+1
sta {z1}+1 
//FRAGMENT vwuz1_le_0_then_la1
lda {z1}
bne !+
lda {z1}+1
beq {la1}
!:
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
//FRAGMENT vbuz1_ge_vbuz2_then_la1
lda {z1}
cmp {z2}
bcs {la1}
//FRAGMENT vbsz1=_sbyte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vbuc1_eq_vbuz1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
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
//FRAGMENT vbsc1_neq_vbsz1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vwuz1=_word__deref_pbuc1
lda {c1}
sta {z1}
lda #0
sta {z1}+1
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
//FRAGMENT vbuz1=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
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
//FRAGMENT vbuc1_neq_vbuaa_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
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
//FRAGMENT vbuaa_eq_0_then_la1
cmp #0
beq {la1}
//FRAGMENT vbuaa_eq_vbuc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuz1=vbuxx_rol_2
txa
asl
asl
sta {z1}
//FRAGMENT vbuxx=vbuz1_rol_2
lda {z1}
asl
asl
tax
//FRAGMENT vbuxx=vbuxx_rol_2
txa
asl
asl
tax
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
//FRAGMENT vduz1=pduc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
lda {c1}+2,x
sta {z1}+2
lda {c1}+3,x
sta {z1}+3
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1
ldy {z1}
ldx {c1},y
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
//FRAGMENT vduz1=vduz2_rol_pbuc1_derefidx_vbuxx
ldy {c1},x
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e:
//FRAGMENT vbuaa=vbuc1_minus_pbuc2_derefidx_vbuz1
lda #{c1}
ldy {z1}
sec
sbc {c2},y
//FRAGMENT vbuxx=vbuc1_minus_pbuc2_derefidx_vbuz1
lda #{c1}
ldx {z1}
sec
sbc {c2},x
tax
//FRAGMENT vbuyy=vbuc1_minus_pbuc2_derefidx_vbuz1
lda #{c1}
ldy {z1}
sec
sbc {c2},y
tay
//FRAGMENT vbuz1=vbuc1_minus_pbuc2_derefidx_vbuxx
lda #{c1}
sec
sbc {c2},x
sta {z1}
//FRAGMENT vbuaa=vbuc1_minus_pbuc2_derefidx_vbuxx
lda #{c1}
sec
sbc {c2},x
//FRAGMENT vbuxx=vbuc1_minus_pbuc2_derefidx_vbuxx
lda #{c1}
sec
sbc {c2},x
tax
//FRAGMENT vbuyy=vbuc1_minus_pbuc2_derefidx_vbuxx
lda #{c1}
sec
sbc {c2},x
tay
//FRAGMENT vduz1=vduz2_ror_vbuaa
tax
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_ror_vbuxx
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_ror_vbuyy
tya
tax
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vbuaa=pbuc1_derefidx_(_deref_pbuc2)
ldy {c2}
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_(_deref_pbuc2)
ldy {c2}
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_(_deref_pbuc2)
ldx {c2}
ldy {c1},x
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
//FRAGMENT vbsaa_gt_0_then_la1
cmp #0
beq !+
bpl {la1}
!:
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
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
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
//FRAGMENT vbuaa_ge_vbuz1_then_la1
cmp {z1}
bcs {la1}
//FRAGMENT vbsaa=_sbyte_vwuz1
lda {z1}
//FRAGMENT vbsxx=_sbyte_vwuz1
ldx {z1}
//FRAGMENT vbuc1_eq_vbuxx_then_la1
cpx #{c1}
beq {la1}
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
//FRAGMENT vbuc1_neq_vbuxx_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbsc1_neq_vbsxx_then_la1
cpx #{c1}
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
//FRAGMENT vbsxx_gt_0_then_la1
txa
cmp #0
beq !+
bpl {la1}
!:
//FRAGMENT vbsyy_gt_0_then_la1
tya
cmp #0
beq !+
bpl {la1}
!:
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuxx_ge_vbuz1_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuyy=_inc_vbuyy
iny
//FRAGMENT vbuz1_ge_vbuxx_then_la1
lda {z1}
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuz1_ge_vbuyy_then_la1
lda {z1}
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuyy_then_la1
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuyy=vbuxx
txa
tay
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy_ge_vbuz1_then_la1
cpy {z1}
bcs {la1}
//FRAGMENT vbuxx=vbuyy
tya
tax
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuc1_neq_vbuyy_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbsxx=vbsc1
ldx #{c1}
//FRAGMENT vbsxx=_dec_vbsxx
dex
//FRAGMENT vbsyy=vbsc1
ldy #{c1}
//FRAGMENT vbsyy=_dec_vbsyy
dey
//FRAGMENT vbsaa=_inc_vbsaa
clc
adc #1
//FRAGMENT vbsxx=_inc_vbsxx
inx
//FRAGMENT vbsyy=_sbyte_vwuz1
ldy {z1}
//FRAGMENT vbsyy=_inc_vbsyy
iny
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT vbuxx_eq_0_then_la1
cpx #0
beq {la1}
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuxx=vbuxx_band_vbuc1
lda #{c1}
axs #0
//FRAGMENT vbuxx=vbuyy_band_vbuc1
ldx #{c1}
tya
axs #0
//FRAGMENT vbuyy=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tay
//FRAGMENT vbuyy_eq_0_then_la1
cpy #0
beq {la1}
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuyy=vbuaa_band_vbuc1
and #{c1}
tay
//FRAGMENT vbuaa=vbuyy
tya
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuyy=vbuaa
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
//FRAGMENT pbuz1=pbuz2_plus_vwuz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
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
//FRAGMENT vwuz1=vwuz2_plus_vwuz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_vwuz2
lda {z1}
clc
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
//FRAGMENT vduz1=vduz1_plus_pduc1_derefidx_vbuz2
ldy {z2}
lda {z1}
clc
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
//FRAGMENT pbuz1=pbuz1_plus_vwuc1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vduz1=vduz1_rol_pbuc1_derefidx_vbuz2
ldy {z2}
ldx {c1},y
cpx #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dex
bne !-
!e:
//FRAGMENT vwuz1=vwuz1_rol_1
asl {z1}
rol {z1}+1
//FRAGMENT pbuz1=pbuz1_plus__deref_pwuc1
clc
lda {c1}
adc {z1}
sta {z1}
lda {c1}+1
adc {z1}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_3
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vduz1=vduz1_ror_vbuaa
tay
cpy #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dey
bne !-
!e:
//FRAGMENT vwuz1=vwuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT pbuz1_lt_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vbuz1=vbuz2_plus_1
ldy {z2}
iny
sty {z1}
//FRAGMENT pbuz1_derefidx_vbuc1=pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
ldy #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=vbuc2
lda #{c2}
ldy #{c1}
sta ({z1}),y
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=vbuaa_plus_1
clc
adc #1
sta {z1}
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
//FRAGMENT vbuyy=vbuxx_band_vbuc1
txa
and #{c1}
tay
//FRAGMENT pbuz1_derefidx_vbuc1=pbuc2_derefidx_vbuaa
tay
lda {c2},y
ldy #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=pbuc2_derefidx_vbuxx
lda {c2},x
ldy #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=pbuc2_derefidx_vbuyy
lda {c2},y
ldy #{c1}
sta ({z1}),y
//FRAGMENT vbuz1=vbuxx_plus_1
inx
stx {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_vbuz3
ldy {z3}
lda {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_vbuaa
tay
lda {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_vbuxx
lda {c1},x
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_vbuyy
lda {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuc1_eq_vbuaa_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbuc1_eq_vbuyy_then_la1
cpy #{c1}
beq {la1}
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
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
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
//FRAGMENT vbuz1=_hi_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=_lo_vwuz2
lda {z2}
sta {z1}
//FRAGMENT pbuz1_lt_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuaa=_hi_vwuz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_vwuz1
ldx {z1}+1
//FRAGMENT vbuaa=_lo_vwuz1
lda {z1}
//FRAGMENT vbuxx=_lo_vwuz1
ldx {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=vbuz1_plus_2
lda {z1}
clc
adc #2
sta {z1}
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
//FRAGMENT vbuxx=vbuxx_plus_2
inx
inx
//FRAGMENT vbuyy_lt_vbuc1_then_la1
cpy #{c1}
bcc {la1}
//FRAGMENT vbuyy=vbuyy_plus_2
iny
iny
//FRAGMENT vwuz1_lt_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vbsz1=vbsz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_hi_vwsz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=vbuc1_plus_vbuz2
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT pbuz1_neq_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwuz1=vwuz1_minus_vwuc1
lda {z1}
sec
sbc #<{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_minus_vwuz1
sec
lda #<{c1}
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_minus_vbuz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbuz1=vbuz2_plus_vbuz3
lda {z2}
clc
adc {z3}
sta {z1}
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT vbsz1=_neg_vbsz2
lda {z2}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbuz1=vbuz2_minus_vbuc1
lax {z2}
axs #{c1}
stx {z1}
//FRAGMENT vwuz1=vwuz1_sethi_vbuz2
lda {z2}
sta {z1}+1
//FRAGMENT vbsz1_lt_0_then_la1
lda {z1}
bmi {la1}
//FRAGMENT vbsz1=_neg_vbsz1
lda {z1}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vwuz1=vwuz1_bor_vbuc1
lda #{c1}
ora {z1}
sta {z1}
//FRAGMENT vwuz1=vwuz2_rol_vbuz3
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
ldy {z3}
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vbuz1=vbuz1_ror_1
lsr {z1}
//FRAGMENT vbsaa=vbsz1
lda {z1}
//FRAGMENT vbsxx=vbsz1
ldx {z1}
//FRAGMENT vbsz1=vbsaa
sta {z1}
//FRAGMENT vbuaa=_hi_vwsz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_vwsz1
ldx {z1}+1
//FRAGMENT vbuaa=vbuc1_plus_vbuz1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbuxx=vbuc1_plus_vbuz1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbuyy=vbuc1_plus_vbuz1
lda #{c1}
clc
adc {z1}
tay
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
//FRAGMENT vbuyy=vbuyy_band_vbuc1
tya
and #{c1}
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
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
//FRAGMENT vbuz1=vbuz2_minus_vbuaa
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuaa_minus_vbuaa
lda #0
sta {z1}
//FRAGMENT vbuz1=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
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
//FRAGMENT vbuaa=vbuaa_minus_vbuz1
sec
sbc {z1}
//FRAGMENT vbuaa=vbuxx_minus_vbuz1
txa
sec
sbc {z1}
//FRAGMENT vbuaa=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
//FRAGMENT vbuaa=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
//FRAGMENT vbuaa=vbuaa_minus_vbuaa
lda #0
//FRAGMENT vbuaa=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
//FRAGMENT vbuaa=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
//FRAGMENT vbuaa=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
//FRAGMENT vbuaa=vbuaa_minus_vbuxx
stx $ff
sec
sbc $ff
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
//FRAGMENT vbuaa=vbuaa_minus_vbuyy
sty $ff
sec
sbc $ff
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
//FRAGMENT vbuxx=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbuxx=vbuaa_minus_vbuaa
lda #0
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
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
//FRAGMENT vbuyy=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
tay
//FRAGMENT vbuyy=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbuyy=vbuaa_minus_vbuaa
lda #0
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
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
//FRAGMENT vbuyy=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
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
//FRAGMENT vbuyy=vbuyy_minus_vbuyy
lda #0
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
//FRAGMENT vbsaa=_neg_vbsz1
lda {z1}
eor #$ff
clc
adc #$01
//FRAGMENT vbsxx=_neg_vbsz1
lda {z1}
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
//FRAGMENT vbsz1=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbsaa=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
//FRAGMENT vbsxx=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsyy=_neg_vbsxx
txa
eor #$ff
clc
adc #$01
tay
//FRAGMENT vbsz1=_neg_vbsyy
tya
eor #$ff
clc
adc #$01
sta {z1}
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
//FRAGMENT vbsyy=_neg_vbsyy
tya
eor #$ff
clc
adc #$01
tay
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
//FRAGMENT vwuz1=vwuz1_sethi_vbuaa
sta {z1}+1
//FRAGMENT vbsaa_lt_0_then_la1
cmp #0
bmi {la1}
//FRAGMENT vwuz1=vwuz2_rol_vbuxx
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
cpx #0
beq !e+
!:
asl {z1}
rol {z1}+1
dex
bne !-
!e:
//FRAGMENT vwuz1=vwuz2_rol_vbuyy
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vbuxx_neq_0_then_la1
cpx #0
bne {la1}
//FRAGMENT vbsz1=vbsxx
stx {z1}
//FRAGMENT vbuxx=vbuxx_ror_1
txa
lsr
tax
//FRAGMENT vbuyy_neq_0_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuyy=vbuyy_ror_1
tya
lsr
tay
//FRAGMENT vbuyy=_hi_vwuz1
ldy {z1}+1
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbuaa=_dec_vbuaa
sec
sbc #1
//FRAGMENT vbuxx=_dec_vbuxx
dex
//FRAGMENT vbuyy=_dec_vbuyy
dey
//FRAGMENT vbsz1=vbsyy
sty {z1}
//FRAGMENT vbsaa=vbsxx
txa
//FRAGMENT vbsaa=vbsyy
tya
//FRAGMENT vbsxx=vbsaa
tax
//FRAGMENT vbsxx=vbsyy
tya
tax
//FRAGMENT vbsyy=vbsz1
ldy {z1}
//FRAGMENT vbsyy=vbsaa
tay
//FRAGMENT vbsyy=vbsxx
txa
tay
//FRAGMENT vwuz1=vwuz1_sethi_vbuxx
stx {z1}+1
//FRAGMENT vbuxx=vbuxx_minus_vbuc1
txa
axs #{c1}
//FRAGMENT vbuxx=vbuyy_minus_vbuc1
tya
tax
axs #{c1}
//FRAGMENT vbuyy=vbuz1_minus_vbuc1
lda {z1}
sec
sbc #{c1}
tay
//FRAGMENT vwuz1=vwuz1_sethi_vbuyy
sty {z1}+1
//FRAGMENT vbuyy=vbuaa_minus_vbuc1
sec
sbc #{c1}
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuc1
txa
sec
sbc #{c1}
tay
//FRAGMENT vbuyy=vbuyy_minus_vbuc1
tya
sec
sbc #{c1}
tay
//FRAGMENT vbsyy_ge_0_then_la1
cpy #0
bpl {la1}
//FRAGMENT vbsxx_lt_0_then_la1
cpx #0
bmi {la1}
//FRAGMENT vbuz1=vbuc1_plus_vbuxx
txa
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuyy=_hi_vwsz1
ldy {z1}+1
//FRAGMENT vbuz1=vbuc1_plus_vbuyy
tya
clc
adc #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_plus__hi_vwsz2
lda #{c1}
clc
adc {z2}+1
sta {z1}
//FRAGMENT vwuz1=vwuz1_rol_vbuz2
ldy {z2}
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vbuz1_eq_vbuz2_then_la1
lda {z1}
cmp {z2}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1_eq_vbuaa_then_la1
cmp {z1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuxx
ldy {z1}
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuyy
tya
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=vbuxx
txa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=vbuyy
tya
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuz1
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=vbuxx
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=vbuyy
tya
sta {c1},y
//FRAGMENT vbuz1_eq_vbuyy_then_la1
tya
cmp {z1}
beq {la1}
//FRAGMENT vbuyy_eq_vbuz1_then_la1
tya
cmp {z1}
beq {la1}
//FRAGMENT vbuyy_eq_vbuaa_then_la1
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT vbuaa_ge_vbuc1_then_la1
cmp #{c1}
bcs {la1}
//FRAGMENT vbuaa_neq_0_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuxx_ge_vbuc1_then_la1
cpx #{c1}
bcs {la1}
//FRAGMENT vbuyy_ge_vbuc1_then_la1
cpy #{c1}
bcs {la1}
//FRAGMENT vbuc1_neq_pbuz1_derefidx_vbuz2_then_la1
ldy {z2}
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuaa
stx $ff
ldy $ff
sta ({z1}),y
//FRAGMENT vbuc1_neq_pbuz1_derefidx_vbuaa_then_la1
tay
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT vbuc1_neq_pbuz1_derefidx_vbuxx_then_la1
txa
tay
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT vbuc1_neq_pbuz1_derefidx_vbuyy_then_la1
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuxx
txa
tay
lda ({z1}),y
//FRAGMENT vbuaa=pbuz1_derefidx_vbuyy
lda ({z1}),y
//FRAGMENT vbuz1_neq_vbuz2_then_la1
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vbuz1_gt_vbuz2_then_la1
lda {z2}
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_neq_vbuaa_then_la1
cmp {z1}
bne {la1}
//FRAGMENT vbuz1_gt_vbuaa_then_la1
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_neq_vbuxx_then_la1
cpx {z1}
bne {la1}
//FRAGMENT vbuz1_gt_vbuxx_then_la1
cpx {z1}
bcc {la1}
//FRAGMENT vbuz1_neq_vbuyy_then_la1
cpy {z1}
bne {la1}
//FRAGMENT vbuz1_gt_vbuyy_then_la1
cpy {z1}
bcc {la1}
//FRAGMENT vbuxx_neq_vbuz1_then_la1
cpx {z1}
bne {la1}
//FRAGMENT vbuxx_gt_vbuz1_then_la1
cpx {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuxx_neq_vbuyy_then_la1
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuxx_gt_vbuyy_then_la1
stx $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuyy_neq_vbuz1_then_la1
cpy {z1}
bne {la1}
//FRAGMENT vbuyy_gt_vbuz1_then_la1
cpy {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuyy_neq_vbuxx_then_la1
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuyy_gt_vbuxx_then_la1
sty $ff
cpx $ff
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz1
ldy {z1}
tya
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuaa
tax
sta {c1},x
//FRAGMENT vbuaa_neq_vbuc1_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbuaa=_inc_vbuaa
clc
adc #1
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_plus_vbuc2
ldy {z1}
clc
lda {c1},y
adc #{c2}
sta {c1},y
lda {c1}+1,y
adc #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_plus_pwuc2_derefidx_vbuz1
ldy {z1}
clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
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
//FRAGMENT pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_vbuc2
tay
clc
lda {c1},y
adc #{c2}
sta {c1},y
lda {c1}+1,y
adc #0
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
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT _deref_pbuc1_lt_vbuc2_then_la1
lda {c1}
cmp #{c2}
bcc {la1}
//FRAGMENT qbuz1=qbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbsz1=pbsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vwsz1=vwsz2_plus_vwsc1
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_rol_1
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lax {z1}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbsz1=vbsz1_plus_vbsc1
lax {z1}
axs #-[{c1}]
stx {z1}
//FRAGMENT _deref_pbuc1=_deref_pbuc2
lda {c2}
sta {c1}
//FRAGMENT vbuz1=vbuz1_plus_vbuz2
lda {z1}
clc
adc {z2}
sta {z1}
//FRAGMENT vwuz1=vwuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1=pbuc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pwuc1_derefidx_vbuz1=vwuz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT qbuc1_derefidx_vbuz1=pbuc2
ldy {z1}
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT pbuz1=qbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_ror_2
lda {z2}
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuz2_ror_3
lda {z2}
lsr
lsr
lsr
sta {z1}
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT _deref_qbuz1=pbuz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT qbuz1=qbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=vbuz2_band__deref_pbuc1
lda {c1}
and {z2}
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz3_derefidx_vbuz2
ldy {z2}
lda ({z3}),y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2_eq_pbuz3_derefidx_vbuz2_then_la1
ldy {z2}
lda ({z1}),y

cmp ({z3}),y
beq {la1}
//FRAGMENT vbuz1_gt_0_then_la1
lda {z1}
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},y
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_band_vbuc2
lda #{c2}
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_ror_1
ldy {z2}
lda {c1},y
lsr
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_vbuc1
lax {z1}
axs #{c1}
stx {z1}
//FRAGMENT _deref_pbuz1=_deref_pbuc1
lda {c1}
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbsc1_ge_0_then_la1
lda {c1}
cmp #0
bpl {la1}
//FRAGMENT vbuz1=vbuz2_minus__deref_pbuc1
lda {z2}
sec
sbc {c1}
sta {z1}
//FRAGMENT vbuz1=_bnot__deref_pbuc1
lda {c1}
eor #$ff
sta {z1}
//FRAGMENT vwuz1=_deref_pbuc1_word__deref_pbuc2
lda {c2}
sta {z1}
lda {c1}
sta {z1}+1
//FRAGMENT vbsz1=pbsc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbsaa=pbsc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbsaa=pbsc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbuz1
ldy {z1}
ldx {c1},y
//FRAGMENT vbuxx=vbuxx_plus_vbuc1
txa
axs #-[{c1}]
//FRAGMENT vbuyy=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
tay
//FRAGMENT vbsxx=vbsxx_plus_vbsc1
txa
axs #-[{c1}]
//FRAGMENT vbsyy=vbsyy_plus_vbsc1
tya
clc
adc #{c1}
tay
//FRAGMENT vbuz1=vbuz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
//FRAGMENT vwuz1=vwuz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
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
//FRAGMENT pwuc1_derefidx_vbuaa=vwuz1
tay
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
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
//FRAGMENT qbuc1_derefidx_vbuaa=pbuc2
tay
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT qbuc1_derefidx_vbuxx=pbuc2
lda #<{c2}
sta {c1},x
lda #>{c2}
sta {c1}+1,x
//FRAGMENT qbuc1_derefidx_vbuyy=pbuc2
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT pbuz1=qbuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT pbuz1=qbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
//FRAGMENT pbuz1=qbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=vbuaa_ror_2
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuxx_ror_2
txa
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuyy_ror_2
tya
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuz1_ror_2
lda {z1}
lsr
lsr
//FRAGMENT vbuaa=vbuaa_ror_2
lsr
lsr
//FRAGMENT vbuaa=vbuxx_ror_2
txa
lsr
lsr
//FRAGMENT vbuaa=vbuyy_ror_2
tya
lsr
lsr
//FRAGMENT vbuxx=vbuz1_ror_2
lda {z1}
lsr
lsr
tax
//FRAGMENT vbuxx=vbuaa_ror_2
lsr
lsr
tax
//FRAGMENT vbuxx=vbuxx_ror_2
txa
lsr
lsr
tax
//FRAGMENT vbuxx=vbuyy_ror_2
tya
lsr
lsr
tax
//FRAGMENT vbuyy=vbuz1_ror_2
lda {z1}
lsr
lsr
tay
//FRAGMENT vbuyy=vbuaa_ror_2
lsr
lsr
tay
//FRAGMENT vbuyy=vbuxx_ror_2
txa
lsr
lsr
tay
//FRAGMENT vbuyy=vbuyy_ror_2
tya
lsr
lsr
tay
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
//FRAGMENT pbuz1=pbuz2_plus_vbuxx
txa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbuyy
tya
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuaa_rol_2
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
//FRAGMENT vbuxx=vbuaa_rol_2
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
//FRAGMENT vbuaa=vbuz1_band__deref_pbuc1
lda {c1}
and {z1}
//FRAGMENT vbuxx=vbuz1_band__deref_pbuc1
lda {c1}
and {z1}
tax
//FRAGMENT vbuyy=vbuz1_band__deref_pbuc1
lda {c1}
and {z1}
tay
//FRAGMENT vbuz1=vbuaa_band__deref_pbuc1
and {c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_band__deref_pbuc1
and {c1}
//FRAGMENT vbuxx=vbuaa_band__deref_pbuc1
ldx {c1}
axs #0
//FRAGMENT vbuaa_neq_vbuz1_then_la1
cmp {z1}
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuaa=pbuz2_derefidx_vbuaa
tay
lda ({z2}),y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz2_derefidx_vbuyy
lda ({z2}),y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa_eq_pbuz2_derefidx_vbuaa_then_la1
tay
lda ({z1}),y

cmp ({z2}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuxx_eq_pbuz2_derefidx_vbuxx_then_la1
txa
tay
lda ({z1}),y

cmp ({z2}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuyy_eq_pbuz2_derefidx_vbuyy_then_la1
lda ({z1}),y

cmp ({z2}),y
beq {la1}
//FRAGMENT vbuaa_gt_0_then_la1
cmp #0
bne {la1}
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
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldx {z1}
and {c1},x
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_band_vbuc2
tax
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
tay
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
tay
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
tay
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_ror_1
ldy {z1}
lda {c1},y
lsr
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_ror_1
ldx {z1}
lda {c1},x
lsr
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_ror_1
ldy {z1}
lda {c1},y
lsr
tay
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
tay
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
tay
//FRAGMENT vbuaa=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
//FRAGMENT vbuxx=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuz2
lda {z1}
ora {z2}
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuz2
txa
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuz1
txa
ora {z1}
//FRAGMENT vbuxx=vbuxx_bor_vbuz1
txa
ora {z1}
tax
//FRAGMENT vbuyy=vbuxx_bor_vbuz1
txa
ora {z1}
tay
//FRAGMENT vbuz1=vbuyy_bor_vbuz2
tya
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuyy_bor_vbuz1
tya
ora {z1}
//FRAGMENT vbuxx=vbuyy_bor_vbuz1
tya
ora {z1}
tax
//FRAGMENT vbuyy=vbuyy_bor_vbuz1
tya
ora {z1}
tay
//FRAGMENT vbuz1=vbuz2_bor_vbuaa
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuaa
ora {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuaa
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuaa
ora {z1}
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuaa
stx $ff
ora $ff
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuaa
stx $ff
ora $ff
//FRAGMENT vbuxx=vbuxx_bor_vbuaa
stx $ff
ora $ff
tax
//FRAGMENT vbuyy=vbuxx_bor_vbuaa
stx $ff
ora $ff
tay
//FRAGMENT vbuz1=vbuyy_bor_vbuaa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuaa=vbuyy_bor_vbuaa
sty $ff
ora $ff
//FRAGMENT vbuxx=vbuyy_bor_vbuaa
sty $ff
ora $ff
tax
//FRAGMENT vbuyy=vbuyy_bor_vbuaa
sty $ff
ora $ff
tay
//FRAGMENT vbuz1=vbuz2_bor_vbuxx
txa
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuxx
txa
ora {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuxx
txa
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuxx
txa
ora {z1}
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuxx
stx {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuaa
ldy {z1}
sta {c1},y
//FRAGMENT vbuaa=vbuz1_minus__deref_pbuc1
lda {z1}
sec
sbc {c1}
//FRAGMENT vbuxx=vbuz1_minus__deref_pbuc1
lda {z1}
sec
sbc {c1}
tax
//FRAGMENT vbuyy=vbuz1_minus__deref_pbuc1
lda {z1}
sec
sbc {c1}
tay
//FRAGMENT vbuz1=vbuaa_minus__deref_pbuc1
sec
sbc {c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_minus__deref_pbuc1
sec
sbc {c1}
//FRAGMENT vbuxx=vbuaa_minus__deref_pbuc1
sec
sbc {c1}
tax
//FRAGMENT vbuyy=vbuaa_minus__deref_pbuc1
sec
sbc {c1}
tay
//FRAGMENT vbuz1=vbuxx_minus__deref_pbuc1
txa
sec
sbc {c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_minus__deref_pbuc1
txa
sec
sbc {c1}
//FRAGMENT vbuxx=vbuxx_minus__deref_pbuc1
txa
sec
sbc {c1}
tax
//FRAGMENT vbuyy=vbuxx_minus__deref_pbuc1
txa
sec
sbc {c1}
tay
//FRAGMENT vbuz1=vbuyy_minus__deref_pbuc1
tya
sec
sbc {c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_minus__deref_pbuc1
tya
sec
sbc {c1}
//FRAGMENT vbuxx=vbuyy_minus__deref_pbuc1
tya
sec
sbc {c1}
tax
//FRAGMENT vbuyy=vbuyy_minus__deref_pbuc1
tya
sec
sbc {c1}
tay
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
//FRAGMENT vbsyy=pbsc1_derefidx_vbuz1
ldx {z1}
ldy {c1},x
//FRAGMENT vbuxx_gt_0_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuz1=vbuyy_bor_vbuxx
txa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuyy_gt_0_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuyy=_lo_vwuz1
ldy {z1}
//FRAGMENT vbuz1=vbuxx_band__deref_pbuc1
lda {c1}
sax {z1}
//FRAGMENT vbuz1=vbuyy_band__deref_pbuc1
tya
and {c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_band__deref_pbuc1
txa
and {c1}
//FRAGMENT vbuaa=vbuyy_band__deref_pbuc1
tya
and {c1}
//FRAGMENT vbuxx=vbuxx_band__deref_pbuc1
lda {c1}
axs #0
//FRAGMENT vbuxx=vbuyy_band__deref_pbuc1
ldx {c1}
tya
axs #0
//FRAGMENT vbuyy=vbuaa_band__deref_pbuc1
and {c1}
tay
//FRAGMENT vbuyy=vbuxx_band__deref_pbuc1
txa
and {c1}
tay
//FRAGMENT vbuyy=vbuyy_band__deref_pbuc1
tya
and {c1}
tay
//FRAGMENT pbuc1_derefidx_vbuxx=vbuaa
sta {c1},x
//FRAGMENT vwsz1=vwsz1_plus_vwsc1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwsz1=vwsz1_rol_1
asl {z1}
rol {z1}+1
//FRAGMENT vbuz1=vbuz2_plus_vbuc1
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuaa=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus_vbuc1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbuyy=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuaa_plus_vbuc1
clc
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_vbuc1
clc
adc #{c1}
//FRAGMENT vbuxx=vbuaa_plus_vbuc1
tax
axs #-[{c1}]
//FRAGMENT pbuc1_derefidx_vbuaa=vbuz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=vbuaa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuxx
tay
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuyy
tax
tya
sta {c1},x
//FRAGMENT vbuyy=vbuaa_plus_vbuc1
clc
adc #{c1}
tay
//FRAGMENT vbuz1=vbuxx_plus_vbuc1
txa
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuaa=vbuxx_plus_vbuc1
txa
clc
adc #{c1}
//FRAGMENT vbuyy=vbuxx_plus_vbuc1
txa
clc
adc #{c1}
tay
//FRAGMENT vbuz1=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
//FRAGMENT vbuxx=vbuyy_plus_vbuc1
tya
tax
axs #-[{c1}]
//FRAGMENT vbuz1=_inc_vbuz2
ldy {z2}
iny
sty {z1}
//FRAGMENT vbuz1=_inc_vbuaa
clc
adc #1
sta {z1}
//FRAGMENT vbuz1=_inc_vbuxx
inx
stx {z1}
//FRAGMENT vbuz1=_inc_vbuyy
iny
sty {z1}
//FRAGMENT vbuaa=_inc_vbuz1
lda {z1}
clc
adc #1
//FRAGMENT vbuaa=_inc_vbuxx
inx
txa
//FRAGMENT vbuaa=_inc_vbuyy
iny
tya
//FRAGMENT vbuxx=_inc_vbuz1
ldx {z1}
inx
//FRAGMENT vbuxx=_inc_vbuaa
tax
inx
//FRAGMENT vbuxx=_inc_vbuyy
tya
tax
inx
//FRAGMENT vbuyy=_inc_vbuz1
ldy {z1}
iny
//FRAGMENT vbuyy=_inc_vbuaa
tay
iny
//FRAGMENT vbuyy=_inc_vbuxx
txa
tay
iny
//FRAGMENT vwsz1=vwsz2_minus_vbsc1
lda {z2}
sec
sbc #{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_minus_vbsc1
lda {z1}
sec
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT pwsc1_derefidx_vbuz1=vwsz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT pwsc1_derefidx_vbuaa=vwsz1
tay
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
//FRAGMENT pwsc1_derefidx_vbuxx=vwsz1
lda {z1}
sta {c1},x
lda {z1}+1
sta {c1}+1,x
//FRAGMENT pwsc1_derefidx_vbuyy=vwsz1
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
//FRAGMENT vbuz1=_bnot_vbuz2
lda {z2}
eor #$ff
sta {z1}
//FRAGMENT vbuaa=_bnot_vbuz1
lda {z1}
eor #$ff
//FRAGMENT vbuxx=_bnot_vbuz1
lda {z1}
eor #$ff
tax
//FRAGMENT vbuyy=_bnot_vbuz1
lda {z1}
eor #$ff
tay
//FRAGMENT vbuz1=_bnot_vbuaa
eor #$ff
sta {z1}
//FRAGMENT vbuaa=_bnot_vbuaa
eor #$ff
//FRAGMENT vbuxx=_bnot_vbuaa
eor #$ff
tax
//FRAGMENT vbuyy=_bnot_vbuaa
eor #$ff
tay
//FRAGMENT vbuz1=_bnot_vbuxx
txa
eor #$ff
sta {z1}
//FRAGMENT vbuaa=_bnot_vbuxx
txa
eor #$ff
//FRAGMENT vbuxx=_bnot_vbuxx
txa
eor #$ff
tax
//FRAGMENT vbuyy=_bnot_vbuxx
txa
eor #$ff
tay
//FRAGMENT vbuz1=_bnot_vbuyy
tya
eor #$ff
sta {z1}
//FRAGMENT vbuaa=_bnot_vbuyy
tya
eor #$ff
//FRAGMENT vbuxx=_bnot_vbuyy
tya
eor #$ff
tax
//FRAGMENT vbuyy=_bnot_vbuyy
tya
eor #$ff
tay
//FRAGMENT _deref_pbuc1_neq_0_then_la1
lda {c1}
cmp #0
bne {la1}
//FRAGMENT pbum1=pbuc1
lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
//FRAGMENT vbum1=vbuc1
lda #{c1}
sta {m1}
//FRAGMENT _deref_pbum1=vbuc1
lda #{c1}
ldy {m1}
sty $fe
ldy {m1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT pbum1=_inc_pbum1
inc {m1}
bne !+
inc {m1}+1
!:
//FRAGMENT vbum1=_inc_vbum1
inc {m1}
//FRAGMENT vbum1_neq_vbuc1_then_la1
lda #{c1}
cmp {m1}
bne {la1}
//FRAGMENT pbuz1_lt_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vboz1=vbuz2_eq_vbuc1
lda {z2}
eor #{c1}
beq !+
lda #1
!:
eor #1
sta {z1}
//FRAGMENT vboz1=vboz2
lda {z2}
sta {z1}
//FRAGMENT vboz1_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vboz1=vbuz2_neq_vbuc1
lda {z2}
eor #{c1}
beq !+
lda #1
!:
sta {z1}
//FRAGMENT vboz1=vboz2_or_vboz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vboaa=vbuz1_eq_vbuc1
lda {z1}
eor #{c1}
beq !+
lda #1
!:
eor #1
//FRAGMENT vboxx=vbuz1_eq_vbuc1
lda {z1}
eor #{c1}
beq !+
lda #1
!:
eor #1
tax
//FRAGMENT vboyy=vbuz1_eq_vbuc1
lda {z1}
eor #{c1}
beq !+
lda #1
!:
eor #1
tay
//FRAGMENT vboz1=vbuaa_eq_vbuc1
eor #{c1}
beq !+
lda #1
!:
eor #1
sta {z1}
//FRAGMENT vboaa=vbuaa_eq_vbuc1
eor #{c1}
beq !+
lda #1
!:
eor #1
//FRAGMENT vboxx=vbuaa_eq_vbuc1
eor #{c1}
beq !+
lda #1
!:
eor #1
tax
//FRAGMENT vboyy=vbuaa_eq_vbuc1
eor #{c1}
beq !+
lda #1
!:
eor #1
tay
//FRAGMENT vboz1=vbuxx_eq_vbuc1
lda #1
cpx #{c1}
beq !+
lda #0
!:
sta {z1}
//FRAGMENT vboaa=vbuxx_eq_vbuc1
lda #1
cpx #{c1}
beq !+
lda #0
!:
//FRAGMENT vboxx=vbuxx_eq_vbuc1
lda #1
cpx #{c1}
beq !+
lda #0
!:
tax
//FRAGMENT vboyy=vbuxx_eq_vbuc1
lda #1
cpx #{c1}
beq !+
lda #0
!:
tay
//FRAGMENT vboz1=vbuyy_eq_vbuc1
lda #1
cpy #{c1}
beq !+
lda #0
!:
sta {z1}
//FRAGMENT vboaa=vbuyy_eq_vbuc1
lda #1
cpy #{c1}
beq !+
lda #0
!:
//FRAGMENT vboxx=vbuyy_eq_vbuc1
lda #1
cpy #{c1}
beq !+
lda #0
!:
tax
//FRAGMENT vboyy=vbuyy_eq_vbuc1
lda #1
cpy #{c1}
beq !+
lda #0
!:
tay
//FRAGMENT vboz1=vboaa
sta {z1}
//FRAGMENT vboaa=vboz1
lda {z1}
//FRAGMENT vboxx=vboz1
ldx {z1}
//FRAGMENT vboaa_then_la1
cmp #0
bne {la1}
//FRAGMENT vboaa=vbuz1_neq_vbuc1
lda {z1}
eor #{c1}
beq !+
lda #1
!:
//FRAGMENT vboxx=vbuz1_neq_vbuc1
lda {z1}
eor #{c1}
beq !+
lda #1
!:
tax
//FRAGMENT vboyy=vbuz1_neq_vbuc1
lda {z1}
eor #{c1}
beq !+
lda #1
!:
tay
//FRAGMENT vboz1=vbuaa_neq_vbuc1
eor #{c1}
beq !+
lda #1
!:
sta {z1}
//FRAGMENT vboaa=vbuaa_neq_vbuc1
eor #{c1}
beq !+
lda #1
!:
//FRAGMENT vboxx=vbuaa_neq_vbuc1
eor #{c1}
beq !+
lda #1
!:
tax
//FRAGMENT vboyy=vbuaa_neq_vbuc1
eor #{c1}
beq !+
lda #1
!:
tay
//FRAGMENT vboz1=vbuxx_neq_vbuc1
lda #0
cpx #{c1}
beq !+
lda #1
!:
sta {z1}
//FRAGMENT vboaa=vbuxx_neq_vbuc1
lda #0
cpx #{c1}
beq !+
lda #1
!:
//FRAGMENT vboxx=vbuxx_neq_vbuc1
lda #0
cpx #{c1}
beq !+
lda #1
!:
tax
//FRAGMENT vboyy=vbuxx_neq_vbuc1
lda #0
cpx #{c1}
beq !+
lda #1
!:
tay
//FRAGMENT vboz1=vbuyy_neq_vbuc1
lda #0
cpy #{c1}
beq !+
lda #1
!:
sta {z1}
//FRAGMENT vboaa=vbuyy_neq_vbuc1
lda #0
cpy #{c1}
beq !+
lda #1
!:
//FRAGMENT vboxx=vbuyy_neq_vbuc1
lda #0
cpy #{c1}
beq !+
lda #1
!:
tax
//FRAGMENT vboyy=vbuyy_neq_vbuc1
lda #0
cpy #{c1}
beq !+
lda #1
!:
tay
//FRAGMENT vboz1=vboz2_or_vboaa
ora {z2}
sta {z1}
//FRAGMENT vboz1=vboz2_or_vboxx
txa
ora {z2}
sta {z1}
//FRAGMENT vboz1=vboz2_or_vboyy
tya
ora {z2}
sta {z1}
//FRAGMENT vboz1=vboxx_or_vboz2
txa
ora {z2}
sta {z1}
//FRAGMENT vboz1=vboxx_or_vboaa
stx $ff
ora $ff
sta {z1}
//FRAGMENT vboz1=vboxx_or_vboxx
txa
stx $ff
ora $ff
sta {z1}
//FRAGMENT vboz1=vboxx_or_vboyy
txa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vboz1=vboyy_or_vboz2
tya
ora {z2}
sta {z1}
//FRAGMENT vboz1=vboyy_or_vboaa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vboz1=vboyy_or_vboxx
txa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vboz1=vboyy_or_vboyy
tya
sty $ff
ora $ff
sta {z1}
//FRAGMENT vboaa=vboz1_or_vboz2
lda {z1}
ora {z2}
//FRAGMENT vboaa=vboz1_or_vboaa
ora {z1}
//FRAGMENT vboaa=vboz1_or_vboxx
txa
ora {z1}
//FRAGMENT vboaa=vboz1_or_vboyy
tya
ora {z1}
//FRAGMENT vboaa=vboxx_or_vboz1
txa
ora {z1}
//FRAGMENT vboaa=vboxx_or_vboaa
stx $ff
ora $ff
//FRAGMENT vboaa=vboxx_or_vboxx
txa
stx $ff
ora $ff
//FRAGMENT vboaa=vboxx_or_vboyy
txa
sty $ff
ora $ff
//FRAGMENT vboaa=vboyy_or_vboz1
tya
ora {z1}
//FRAGMENT vboaa=vboyy_or_vboaa
sty $ff
ora $ff
//FRAGMENT vboaa=vboyy_or_vboxx
txa
sty $ff
ora $ff
//FRAGMENT vboaa=vboyy_or_vboyy
tya
sty $ff
ora $ff
//FRAGMENT vboxx=vboz1_or_vboz2
lda {z1}
ora {z2}
tax
//FRAGMENT vboxx=vboz1_or_vboaa
ora {z1}
tax
//FRAGMENT vboxx=vboz1_or_vboxx
txa
ora {z1}
tax
//FRAGMENT vboxx=vboz1_or_vboyy
tya
ora {z1}
tax
//FRAGMENT vboxx=vboxx_or_vboz1
txa
ora {z1}
tax
//FRAGMENT vboxx=vboxx_or_vboaa
stx $ff
ora $ff
tax
//FRAGMENT vboxx=vboxx_or_vboxx
txa
stx $ff
ora $ff
tax
//FRAGMENT vboxx=vboxx_or_vboyy
txa
sty $ff
ora $ff
tax
//FRAGMENT vboxx=vboyy_or_vboz1
tya
ora {z1}
tax
//FRAGMENT vboxx=vboyy_or_vboaa
sty $ff
ora $ff
tax
//FRAGMENT vboxx=vboyy_or_vboxx
txa
sty $ff
ora $ff
tax
//FRAGMENT vboxx=vboyy_or_vboyy
tya
sty $ff
ora $ff
tax
//FRAGMENT vboyy=vboz1_or_vboz2
lda {z1}
ora {z2}
tay
//FRAGMENT vboyy=vboz1_or_vboaa
ora {z1}
tay
//FRAGMENT vboyy=vboz1_or_vboxx
txa
ora {z1}
tay
//FRAGMENT vboyy=vboz1_or_vboyy
tya
ora {z1}
tay
//FRAGMENT vboyy=vboxx_or_vboz1
txa
ora {z1}
tay
//FRAGMENT vboyy=vboxx_or_vboaa
stx $ff
ora $ff
tay
//FRAGMENT vboyy=vboxx_or_vboxx
txa
stx $ff
ora $ff
tay
//FRAGMENT vboyy=vboxx_or_vboyy
txa
sty $ff
ora $ff
tay
//FRAGMENT vboyy=vboyy_or_vboz1
tya
ora {z1}
tay
//FRAGMENT vboyy=vboyy_or_vboaa
sty $ff
ora $ff
tay
//FRAGMENT vboyy=vboyy_or_vboxx
txa
sty $ff
ora $ff
tay
//FRAGMENT vboyy=vboyy_or_vboyy
tya
sty $ff
ora $ff
tay
//FRAGMENT vboxx_then_la1
cpx #0
bne {la1}
//FRAGMENT vboyy=vboz1
ldy {z1}
//FRAGMENT vboyy_then_la1
cpy #0
bne {la1}
//FRAGMENT vboyy=vboaa
tay
//FRAGMENT vboaa=vboyy
tya
//FRAGMENT vbuz1=vbuc1_rol_vbuz2
lda #{c1}
ldy {z2}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {z1}
//FRAGMENT vbuaa=vbuc1_rol_vbuz1
lda #{c1}
ldy {z1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
//FRAGMENT vbuxx=vbuc1_rol_vbuz1
lda #{c1}
ldx {z1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
tax
//FRAGMENT vbuyy=vbuc1_rol_vbuz1
lda #{c1}
ldy {z1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
tay
//FRAGMENT vbuz1=vbuc1_rol_vbuaa
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {z1}
//FRAGMENT vbuaa=vbuc1_rol_vbuaa
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
//FRAGMENT vbuxx=vbuc1_rol_vbuaa
tax
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
tax
//FRAGMENT vbuyy=vbuc1_rol_vbuaa
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
tay
//FRAGMENT vbuz1=vbuc1_rol_vbuxx
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
sta {z1}
//FRAGMENT vbuaa=vbuc1_rol_vbuxx
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
//FRAGMENT vbuxx=vbuc1_rol_vbuxx
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
tax
//FRAGMENT vbuyy=vbuc1_rol_vbuxx
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
tay
//FRAGMENT vbuz1=vbuc1_rol_vbuyy
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {z1}
//FRAGMENT vbuaa=vbuc1_rol_vbuyy
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
//FRAGMENT vbuxx=vbuc1_rol_vbuyy
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
tax
//FRAGMENT vbuyy=vbuc1_rol_vbuyy
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
tay
//FRAGMENT pprz1=pprc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pwsc1=vbsc2
NO_SYNTHESIS
//FRAGMENT _deref_pwsc1=vwuc2
NO_SYNTHESIS
//FRAGMENT _deref_pwsc1=vwsc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vwsz1=vbsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pwsz1=pwsc1_plus_vwsz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=_deref_pwsz2
ldy #0
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vdsz1=vdsz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
//FRAGMENT vwsz1=_sword_vdsz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwsz1_le_vwsz2_then_la1
lda {z2}
cmp {z1}
lda {z2}+1
sbc {z1}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT vwsz1=_inc_vwsz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwsz1_neq_0_then_la1
lda {z1}+1
bne {la1}
lda {z1}
bne {la1}
//FRAGMENT _deref_pwsz1=vwsz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT vwsz1_lt_vwsc1_then_la1
lda {z1}
cmp #<{c1}
lda {z1}+1
sbc #>{c1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsz1_ge_0_then_la1
lda {z1}+1
bpl {la1}
//FRAGMENT vwuz1=_hi_vduz2
lda {z2}+2
sta {z1}
lda {z2}+3
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_minus_vwuz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT vduz1=vduz1_sethi_vwuz2
lda {z2}
sta {z1}+2
lda {z2}+1
sta {z1}+3
//FRAGMENT vduz1=_dword_vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda #0
sta {z1}+2
sta {z1}+3
//FRAGMENT vwuz1_neq_0_then_la1
lda {z1}
bne {la1}
lda {z1}+1
bne {la1}
//FRAGMENT vwuz1=vwuz1_ror_1
lsr {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz1_rol_1
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vwsz1=_neg_vwsz2
sec
lda #0
sbc {z2}
sta {z1}
lda #0
sbc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_bxor_vbuc1
lda #{c1}
eor {z1}
sta {z1}
//FRAGMENT vbuz1=_byte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vwuz1_ge_vwuz2_then_la1
lda {z2}+1
cmp {z1}+1
bne !+
lda {z2}
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT vwuz1_lt_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vwuz1=vwuz1_minus_vwuz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT vbuaa=_byte_vwuz1
lda {z1}
//FRAGMENT vbuxx=_byte_vwuz1
lda {z1}
tax
//FRAGMENT vbuyy=_byte_vwuz1
lda {z1}
tay
//FRAGMENT pwsz1=pwsc1_plus_vwsz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=_deref_pwsz1
ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT pprz1=pprz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pprz1=qprc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT pprz1=qprc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT pprz1=qprc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda {c1}+1,x
sta {z1}+1
//FRAGMENT pprz1=qprc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT _deref_pbuz1=_inc__deref_pbuz1
ldy #0
lda ({z1}),y
clc
adc #1
ldy #0
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuz1_then_la1
lda #{c1}
ldy {z1}
cmp {c2},y
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuaa
tay
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuxx_then_la1
lda {c2},x
cmp #{c1}
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuz3
ldx {z1}
ldy {z3}
lda ({z2}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuaa
ldx {z1}
tay
lda ({z2}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuxx
txa
ldx {z1}
tay
lda ({z2}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuyy
lda ({z2}),y
ldx {z1}
sta {c1},x
//FRAGMENT pbuz1_derefidx_(pbsc1_derefidx_vbuz2)=vbuc2
lda #{c2}
ldx {z2}
ldy {c1},x
sta ({z1}),y
//FRAGMENT pbsc1_derefidx_vbuz1=pbsc1_derefidx_vbuz1_plus_pbsc2_derefidx_vbuz1
ldy {z1}
clc
lda {c1},y
adc {c2},y
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuz1_lt_0_then_la1
ldy {z1}
lda {c1},y
cmp #0
bmi {la1}
//FRAGMENT pbsc1_derefidx_vbuz1_lt_vbsc2_then_la1
ldy {z1}
lda {c1},y
sec
sbc #{c2}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsz1=_neg_pbsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT pbsc1_derefidx_vbuz1=vbsz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT pbuz1_derefidx_(pbsc1_derefidx_vbuz2)=pbuc2_derefidx_vbuz2
ldx {z2}
lda {c2},x
ldy {c1},x
sta ({z1}),y
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
//FRAGMENT pbuz1_derefidx_(pbsc1_derefidx_vbuaa)=vbuc2
tax
lda #{c2}
ldy {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_(pbsc1_derefidx_vbuxx)=vbuc2
lda #{c2}
ldy {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_(pbsc1_derefidx_vbuyy)=vbuc2
tya
tax
lda #{c2}
ldy {c1},x
sta ({z1}),y
//FRAGMENT pbsc1_derefidx_vbuxx=pbsc1_derefidx_vbuxx_plus_pbsc2_derefidx_vbuxx
clc
lda {c1},x
adc {c2},x
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuxx_lt_0_then_la1
lda {c1},x
cmp #0
bmi {la1}
//FRAGMENT pbsc1_derefidx_vbuxx_lt_vbsc2_then_la1
lda {c1},x
sec
sbc #{c2}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsz1=_neg_pbsc1_derefidx_vbuxx
lda {c1},x
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbsaa=_neg_pbsc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
eor #$ff
clc
adc #$01
//FRAGMENT vbsaa=_neg_pbsc1_derefidx_vbuxx
lda {c1},x
eor #$ff
clc
adc #$01
//FRAGMENT vbsxx=_neg_pbsc1_derefidx_vbuz1
ldx {z1}
lda {c1},x
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsxx=_neg_pbsc1_derefidx_vbuxx
lda {c1},x
eor #$ff
clc
adc #$01
tax
//FRAGMENT vbsyy=_neg_pbsc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
eor #$ff
clc
adc #$01
tay
//FRAGMENT vbsyy=_neg_pbsc1_derefidx_vbuxx
lda {c1},x
eor #$ff
clc
adc #$01
tay
//FRAGMENT pbsc1_derefidx_vbuxx=vbsz1
lda {z1}
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuz1=vbsaa
ldy {z1}
sta {c1},y
//FRAGMENT pbuz1_derefidx_(pbsc1_derefidx_vbuxx)=pbuc2_derefidx_vbuxx
lda {c2},x
ldy {c1},x
sta ({z1}),y
//FRAGMENT pbsc1_derefidx_vbuz1=vbsxx
ldy {z1}
txa
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuz1=vbsyy
tya
ldy {z1}
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuaa=vbsz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuaa=vbsxx
tay
txa
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuaa=vbsyy
tax
tya
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuxx=vbsxx
txa
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuxx=vbsyy
tya
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuyy=vbsz1
lda {z1}
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuyy=vbsxx
txa
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuyy=vbsyy
tya
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuxx=vbsaa
sta {c1},x
//FRAGMENT vbuz1=vbuz2_plus_vbuz2
lda {z2}
asl
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1=pbuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2_neq_vbuc1_then_la1
ldy {z2}
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuz2_eq_vbuc1_then_la1
lda #{c1}
ldy {z2}
cmp ({z1}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2_neq_0_then_la1
ldy {z2}
lda ({z1}),y

cmp #0
bne {la1}
//FRAGMENT vwuz1=vbuz2_rol_3
lda {z2}
sta {z1}
lda #0
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vbuz1=vbuaa_plus_vbuaa
asl
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_vbuz1
lda {z1}
asl
//FRAGMENT vbuaa=vbuaa_plus_vbuaa
asl
//FRAGMENT vbuxx=vbuz1_plus_vbuz1
lda {z1}
asl
tax
//FRAGMENT vbuxx=vbuaa_plus_vbuaa
asl
tax
//FRAGMENT vbuyy=vbuz1_plus_vbuz1
lda {z1}
asl
tay
//FRAGMENT vbuyy=vbuaa_plus_vbuaa
asl
tay
//FRAGMENT vbuaa=vbuz1_plus_1
lda {z1}
clc
adc #1
//FRAGMENT vbuxx_eq_vbuz1_then_la1
cpx {z1}
beq {la1}
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
//FRAGMENT _deref_pbuz1=pbuz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=pbuz2_derefidx_vbuyy
lda ({z2}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx_neq_vbuc1_then_la1
txa
tay
lda ({z1}),y

cmp #{c1}
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuaa_eq_vbuc1_then_la1
tay
lda #{c1}
cmp ({z1}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuxx_eq_vbuc1_then_la1
txa
tay
lda #{c1}
cmp ({z1}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuyy_eq_vbuc1_then_la1
lda #{c1}
cmp ({z1}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuxx_neq_0_then_la1
txa
tay
lda ({z1}),y

cmp #0
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuyy_neq_0_then_la1
lda ({z1}),y

cmp #0
bne {la1}
//FRAGMENT vbuxx=vbuz1_plus_1
ldx {z1}
inx
//FRAGMENT vwuz1=vbuaa_rol_3
sta {z1}
lda #0
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vbuxx_rol_3
txa
sta {z1}
lda #0
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vbuyy_rol_3
tya
sta {z1}
lda #0
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vbuaa_lt_vbuz1_then_la1
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_lt_vbuxx_then_la1
cpx {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vwuz1=vwuz2_plus_vbuaa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuyy=vbuz1_plus_1
ldy {z1}
iny
//FRAGMENT vbuyy_lt_vbuz1_then_la1
cpy {z1}
bcc {la1}
//FRAGMENT vbuz1=vbuyy_plus_1
iny
sty {z1}
//FRAGMENT vbuxx_lt_vbuaa_then_la1
sta $ff
cpx $ff
bcc {la1}
//FRAGMENT vbuz1=vbuz1_plus_1
inc {z1}
//FRAGMENT vbuz1=_lo__deref_pwuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1=_hi__deref_pwuc1
lda {c1}+1
sta {z1}
//FRAGMENT vbuaa=_lo__deref_pwuc1
lda {c1}
//FRAGMENT vbuxx=_lo__deref_pwuc1
ldx {c1}
//FRAGMENT vbuaa=_hi__deref_pwuc1
lda {c1}+1
//FRAGMENT vbuxx=_hi__deref_pwuc1
ldx {c1}+1
//FRAGMENT vbuyy=_lo__deref_pwuc1
ldy {c1}
//FRAGMENT vbuyy=_hi__deref_pwuc1
ldy {c1}+1
//FRAGMENT vwsz1=vbsc1_minus_vwsz2
NO_SYNTHESIS
//FRAGMENT vwsz1=vwuc1_minus_vwsz2
sec
lda #<{c1}
sbc {z2}
sta {z1}
lda #>{c1}
sbc {z2}+1
sta {z1}+1 
//FRAGMENT vwsz1=vwsz1_minus_1
sec
lda {z1}
sbc #1
sta {z1}
bcs !+
dec {z1}+1
!:
//FRAGMENT vwsz1=vwsz2_minus_vwsz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_rol_2
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwsz1=vwsz2_plus_vwsz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_plus_vbsc1
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsc1_plus_vwsz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsc1_minus_vwsz2
lda #<{c1}
sec
sbc {z2}
sta {z1}
lda #>{c1}
sbc {z2}+1
sta {z1}+1
//FRAGMENT vwsz1_gt_vwsc1_then_la1
lda #<{c1}
cmp {z1}
lda #>{c1}
sbc {z1}+1
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsz1_ge_vwsc1_then_la1
lda {z1}
cmp #<{c1}
lda {z1}+1
sbc #>{c1}
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT vwsz1=vwsz2_band_vdsc1
lda {z2}
and #<{c1}
sta {z1}
lda {z2}+1
and #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwsz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_lo_vwsz2
lda {z2}
sta {z1}
//FRAGMENT vwsz1=vwsz2_ror_3
lda {z2}+1
cmp #$80
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
//FRAGMENT vwsz1=vwsz2_rol_6
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
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vbsz1=vwsz2_band_vbsc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbsz3
ldy #0
lda ({z2}),y
ldy {z3}
ora {c1},y
sta {z1}
//FRAGMENT vbuaa=_lo_vwsz1
lda {z1}
//FRAGMENT vbuxx=_lo_vwsz1
ldx {z1}
//FRAGMENT pbuz1=pbuz2_plus_vbuaa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbsaa=vwsz1_band_vbsc1
lda #{c1}
and {z1}
//FRAGMENT vbsxx=vwsz1_band_vbsc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbsyy=vwsz1_band_vbsc1
lda #{c1}
and {z1}
tay
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbsaa
tay
lda {c1},y
ldy #0
ora ({z2}),y
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbsxx
lda {c1},x
ldy #0
ora ({z2}),y
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbsyy
lda {c1},y
ldy #0
ora ({z2}),y
sta {z1}
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbsz2
ldy #0
lda ({z1}),y
ldy {z2}
ora {c1},y
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbsaa
tay
lda {c1},y
ldy #0
ora ({z1}),y
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbsxx
lda {c1},x
ldy #0
ora ({z1}),y
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbsyy
lda {c1},y
ldy #0
ora ({z1}),y
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbsz2
ldx {z2}
lda {c1},x
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbsaa
tax
lda {c1},x
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbsxx
lda {c1},x
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbsyy
lda {c1},y
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbsz2
ldy #0
lda ({z1}),y
ldy {z2}
ora {c1},y
tay
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbsaa
tay
lda {c1},y
ldy #0
ora ({z1}),y
tay
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbsxx
lda {c1},x
ldy #0
ora ({z1}),y
tay
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbsyy
lda {c1},y
ldy #0
ora ({z1}),y
tay
//FRAGMENT vbuyy=_lo_vwsz1
ldy {z1}
//FRAGMENT vwsz1=vwsz1_plus_vwsz2
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vwsz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vwsz1=vbsc1_minus_vwsz1
NO_SYNTHESIS
//FRAGMENT vwsz1=vwuc1_minus_vwsz1
sec
lda #<{c1}
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_ror_3
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
//FRAGMENT vwsz1=vwsz1_rol_2
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwsz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vwsz2
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuaa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwsz1=vwsz1_rol_6
lda {z1}+1
sta $ff
lda {z1}
sta {z1}+1
lda #0
sta {z1}
lsr $ff
ror {z1}+1
ror {z1}
lsr $ff
ror {z1}+1
ror {z1}
//FRAGMENT _deref_pwuc1=vwuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vbuc1_eq_vwuz1_then_la1
lda #{c1}
cmp {z1}
bne !+
lda {z1}+1
bne !+
jmp {la1}
!:
//FRAGMENT vwuz1=_dec_vwuz1
lda {z1}
bne !+
dec {z1}+1
!:
dec {z1}
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuaa_then_la1
tay
lda #{c1}
cmp {c2},y
bne {la1}
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuyy_then_la1
lda #{c1}
cmp {c2},y
bne {la1}
//FRAGMENT _deref_pwuc1=_deref_pwuc2
lda {c2}
sta {c1}
lda {c2}+1
sta {c1}+1
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuz1
ldx {z1}
tay
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuxx
tay
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuyy
tax
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuaa
tay
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuz1
ldx {z1}
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuaa
tax
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuz1_derefidx_vbuxx
txa
tay
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuz1_derefidx_vbuyy
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuz1_derefidx_vbuz2
tya
ldy {z2}
tax
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuz1_derefidx_vbuxx
sty $ff

txa
tay
lda ({z1}),y
ldy $ff
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=pbuz1_derefidx_vbuyy
lda ({z1}),y
sta {c1},y
//FRAGMENT _deref_pbuc1=_deref_qbuc2_memcpy_vbuc3
ldy #{c3}
!:
lda {c2}-1,y
sta {c1}-1,y
dey
bne !-
//FRAGMENT _deref_pssc1=_memset_vbuc2
ldy #{c2}
lda #0
!:
dey
sta {c1},y
bne !-
//FRAGMENT _deref_pssc1=_deref_pssc2_memcpy_vbuc3
ldy #{c3}
!:
lda {c2}-1,y
sta {c1}-1,y
dey
bne !-
//FRAGMENT vbuz1=vbuz2_rol_3
lda {z2}
asl
asl
asl
sta {z1}
//FRAGMENT vwsz1=pwsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=vbuaa_rol_3
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuxx_rol_3
txa
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuyy_rol_3
tya
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuz1_rol_3
lda {z1}
asl
asl
asl
//FRAGMENT vbuaa=vbuaa_rol_3
asl
asl
asl
//FRAGMENT vbuaa=vbuxx_rol_3
txa
asl
asl
asl
//FRAGMENT vbuaa=vbuyy_rol_3
tya
asl
asl
asl
//FRAGMENT vbuxx=vbuz1_rol_3
lda {z1}
asl
asl
asl
tax
//FRAGMENT vbuxx=vbuaa_rol_3
asl
asl
asl
tax
//FRAGMENT vbuxx=vbuxx_rol_3
txa
asl
asl
asl
tax
//FRAGMENT vbuxx=vbuyy_rol_3
tya
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
//FRAGMENT vbuyy=vbuaa_rol_3
asl
asl
asl
tay
//FRAGMENT vbuyy=vbuxx_rol_3
txa
asl
asl
asl
tay
//FRAGMENT vbuyy=vbuyy_rol_3
tya
asl
asl
asl
tay
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
//FRAGMENT _deref_pssc1=pssc2_derefidx_vbuz1_memcpy_vbuc3
ldx {z1}
ldy #0
!:
lda {c2},x
sta {c1},y
inx
iny
cpy #{c3}
bne !-
//FRAGMENT pwsc1_derefidx_vbuz1=_deref_pwsc2
ldy {z1}
lda {c2}
sta {c1},y
lda {c2}+1
sta {c1}+1,y
//FRAGMENT _deref_pssc1=pssc2_derefidx_vbuaa_memcpy_vbuc3
tax
ldy #0
!:
lda {c2},x
sta {c1},y
inx
iny
cpy #{c3}
bne !-
//FRAGMENT _deref_pssc1=pssc2_derefidx_vbuxx_memcpy_vbuc3
ldy #0
!:
lda {c2},x
sta {c1},y
inx
iny
cpy #{c3}
bne !-
//FRAGMENT _deref_pssc1=pssc2_derefidx_vbuyy_memcpy_vbuc3
ldx #0
!:
lda {c2},y
sta {c1},x
iny
inx
cpx #{c3}
bne !-
//FRAGMENT pwsc1_derefidx_vbuaa=_deref_pwsc2
tay
lda {c2}
sta {c1},y
lda {c2}+1
sta {c1}+1,y
//FRAGMENT pwsc1_derefidx_vbuxx=_deref_pwsc2
lda {c2}
sta {c1},x
lda {c2}+1
sta {c1}+1,x
//FRAGMENT pwsc1_derefidx_vbuyy=_deref_pwsc2
lda {c2}
sta {c1},y
lda {c2}+1
sta {c1}+1,y
//FRAGMENT pssc1_derefidx_vbuz1=_deref_pssc2_memcpy_vbuc3
ldx {z1}
ldy #0
!:
lda {c2},y
sta {c1},x
inx
iny
cpy #{c3}
bne !-
//FRAGMENT pssc1_derefidx_vbuaa=_deref_pssc2_memcpy_vbuc3
tax
ldy #0
!:
lda {c2},y
sta {c1},x
inx
iny
cpy #{c3}
bne !-
//FRAGMENT pssc1_derefidx_vbuxx=_deref_pssc2_memcpy_vbuc3
ldy #0
!:
lda {c2},y
sta {c1},x
inx
iny
cpy #{c3}
bne !-
//FRAGMENT pssc1_derefidx_vbuyy=_deref_pssc2_memcpy_vbuc3
ldx #0
!:
lda {c2},x
sta {c1},y
iny
inx
cpx #{c3}
bne !-
//FRAGMENT _deref_pbuc1=_byte_pprz1
lda {z1}
sta {c1}
//FRAGMENT vwuz1=_deref_pwuc1_minus_vwuc2
sec
lda {c1}
sbc #<{c2}
sta {z1}
lda {c1}+1
sbc #>{c2}
sta {z1}+1
//FRAGMENT _deref_pwuc1=vwuz1
lda {z1}
sta {c1}
lda {z1}+1
sta {c1}+1
//FRAGMENT pbuz1=_deref_qbuc1_plus_vwuc2
clc
lda {c1}
adc #<{c2}
sta {z1}
lda {c1}+1
adc #>{c2}
sta {z1}+1
//FRAGMENT vbuc1_neq__deref_pbuc2_then_la1
lda #{c1}
cmp {c2}
bne {la1}
//FRAGMENT vwuz1=vbuz2_word_vbuc1
lda {z2}
ldy #{c1}
sta {z1}+1
sty {z1}
//FRAGMENT vbuz1=vbuz2_minus__deref_pbuz3
lda {z2}
sec
ldy #0
sbc ({z3}),y
sta {z1}
//FRAGMENT vbsz1_neq_vbsc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=pbuz2_derefidx_vbuz3_rol_4
ldy {z3}
lda ({z2}),y
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=pbuz2_derefidx_vbuz3_rol_1
ldy {z3}
lda ({z2}),y
asl
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz3
lda {z3}
ldy {z2}
sta ({z1}),y
//FRAGMENT vwuz1=vwuz2_ror_1
lda {z2}+1
lsr
sta {z1}+1
lda {z2}
ror
sta {z1}
//FRAGMENT vwuz1=_neg_vwuz1
sec
lda #0
sbc {z1}
sta {z1}
lda #0
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_ror_1
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
//FRAGMENT vwsz1=vwsz1_minus_vwsz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_pwuc1_derefidx_vbuz2
ldy {z2}
sec
lda {z1}
sbc {c1},y
sta {z1}
lda {z1}+1
sbc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_pwuc1_derefidx_vbuz2
ldy {z2}
clc
lda {z1}
adc {c1},y
sta {z1}
lda {z1}+1
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_ror_2
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
//FRAGMENT vbuz1=vbuz1_minus_2
dec {z1}
dec {z1}
//FRAGMENT vwuz1=vbuaa_word_vbuc1
ldy #{c1}
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuxx_word_vbuc1
ldy #{c1}
txa
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuyy_word_vbuc1
tya
ldy #{c1}
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vwuz1_plus_vbuaa
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
//FRAGMENT vbuz1=vbuxx_minus__deref_pbuz2
txa
sec
ldy #0
sbc ({z2}),y
sta {z1}
//FRAGMENT vbuaa=vbuz1_minus__deref_pbuz2
lda {z1}
sec
ldy #0
sbc ({z2}),y
//FRAGMENT vbuaa=vbuxx_minus__deref_pbuz1
txa
sec
ldy #0
sbc ({z1}),y
//FRAGMENT vbuxx=vbuz1_minus__deref_pbuz2
lda {z1}
sec
ldy #0
sbc ({z2}),y
tax
//FRAGMENT vbuxx=vbuxx_minus__deref_pbuz1
txa
sec
ldy #0
sbc ({z1}),y
tax
//FRAGMENT vbuyy=vbuz1_minus__deref_pbuz2
lda {z1}
sec
ldy #0
sbc ({z2}),y
tay
//FRAGMENT vbuyy=vbuxx_minus__deref_pbuz1
txa
sec
ldy #0
sbc ({z1}),y
tay
//FRAGMENT vbsxx_neq_vbsc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuz2_rol_4
ldy {z2}
lda ({z1}),y
asl
asl
asl
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuz2_rol_4
ldy {z2}
lda ({z1}),y
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuz2_rol_4
ldy {z2}
lda ({z1}),y
asl
asl
asl
asl
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuaa_rol_4
tay
lda ({z2}),y
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuaa_rol_4
tay
lda ({z1}),y
asl
asl
asl
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuaa_rol_4
tay
lda ({z1}),y
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuaa_rol_4
tay
lda ({z1}),y
asl
asl
asl
asl
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuxx_rol_4
txa
tay
lda ({z2}),y
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuxx_rol_4
txa
tay
lda ({z1}),y
asl
asl
asl
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuxx_rol_4
txa
tay
lda ({z1}),y
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuxx_rol_4
txa
tay
lda ({z1}),y
asl
asl
asl
asl
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuyy_rol_4
lda ({z2}),y
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuyy_rol_4
lda ({z1}),y
asl
asl
asl
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuyy_rol_4
lda ({z1}),y
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuyy_rol_4
lda ({z1}),y
asl
asl
asl
asl
tay
//FRAGMENT vbuaa=pbuz1_derefidx_vbuz2_rol_1
ldy {z2}
lda ({z1}),y
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuz2_rol_1
ldy {z2}
lda ({z1}),y
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuz2_rol_1
ldy {z2}
lda ({z1}),y
asl
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuxx_rol_1
txa
tay
lda ({z2}),y
asl
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuxx_rol_1
txa
tay
lda ({z1}),y
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuxx_rol_1
txa
tay
lda ({z1}),y
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuxx_rol_1
txa
tay
lda ({z1}),y
asl
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuyy_rol_1
lda ({z2}),y
asl
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_vbuyy_rol_1
lda ({z1}),y
asl
//FRAGMENT vbuxx=pbuz1_derefidx_vbuyy_rol_1
lda ({z1}),y
asl
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuyy_rol_1
lda ({z1}),y
asl
tay
//FRAGMENT pbuz1_derefidx_vbuxx=vbuz2
txa
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuz2
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuaa
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuc1
txa
tay
lda #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuc1
lda #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=vbuc1
tay
lda #{c1}
sta ({z1}),y
//FRAGMENT vwuz1=vwuz1_minus_pwuc1_derefidx_vbuaa
tay
sec
lda {z1}
sbc {c1},y
sta {z1}
lda {z1}+1
sbc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_pwuc1_derefidx_vbuxx
sec
lda {z1}
sbc {c1},x
sta {z1}
lda {z1}+1
sbc {c1}+1,x
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_pwuc1_derefidx_vbuyy
sec
lda {z1}
sbc {c1},y
sta {z1}
lda {z1}+1
sbc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_pwuc1_derefidx_vbuaa
tay
clc
lda {z1}
adc {c1},y
sta {z1}
lda {z1}+1
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_pwuc1_derefidx_vbuxx
clc
lda {z1}
adc {c1},x
sta {z1}
lda {z1}+1
adc {c1}+1,x
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_pwuc1_derefidx_vbuyy
clc
lda {z1}
adc {c1},y
sta {z1}
lda {z1}+1
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1_lt_vbuaa_then_la1
cmp {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuxx=vbuxx_minus_2
dex
dex
//FRAGMENT vbuyy=vbuyy_minus_2
dey
dey
//FRAGMENT vbuz1=vbuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuyy
tya
ora {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuxx
ldy {z2}
txa
sta ({z1}),y
//FRAGMENT vbuxx=vbuz1_bor_vbuyy
tya
ora {z1}
tax
//FRAGMENT pbuz1_derefidx_vbuz2=vbuyy
tya
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuyy=vbuz1_bor_vbuyy
tya
ora {z1}
tay
//FRAGMENT pbuz1_derefidx_vbuxx=vbuyy
stx $ff
tya
ldy $ff
sta ({z1}),y
//FRAGMENT vbuz1_lt_vbuyy_then_la1
cpy {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuxx_lt_vbuyy_then_la1
sty $ff
cpx $ff
bcc {la1}
//FRAGMENT pbuz1_derefidx_vbuyy=vbuaa
sta ({z1}),y
//FRAGMENT vbuz1_eq_vbuxx_then_la1
cpx {z1}
beq {la1}
//FRAGMENT vbuxx_eq_vbuaa_then_la1
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT vbuxx_eq_vbuyy_then_la1
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT vbuyy_eq_vbuxx_then_la1
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_vbuz2
txa
ldx {z2}
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_vbuz2
ldx {z2}
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_vbuxx
txa
tay
lda {c1},y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_vbuxx
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_vbuyy
lda {c1},y
stx $ff
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_vbuyy
lda {c1},y
sta ({z1}),y
//FRAGMENT vwsz1=_sword_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {c1}
//FRAGMENT vboz1=vbuz2_lt_vbuc1
lda {z2}
cmp #{c1}
lda #0
rol
eor #1
sta {z1}
//FRAGMENT vboaa=vbuz1_lt_vbuc1
lda {z1}
cmp #{c1}
lda #0
rol
eor #1
//FRAGMENT vboxx=vbuz1_lt_vbuc1
lda {z1}
cmp #{c1}
lda #0
rol
eor #1
tax
//FRAGMENT vboyy=vbuz1_lt_vbuc1
lda {z1}
cmp #{c1}
lda #0
rol
eor #1
tay
//FRAGMENT vboz1=vbuaa_lt_vbuc1
cmp #{c1}
lda #0
rol
eor #1
sta {z1}
//FRAGMENT vboaa=vbuaa_lt_vbuc1
cmp #{c1}
lda #0
rol
eor #1
//FRAGMENT vboxx=vbuaa_lt_vbuc1
cmp #{c1}
lda #0
rol
eor #1
tax
//FRAGMENT vboyy=vbuaa_lt_vbuc1
cmp #{c1}
lda #0
rol
eor #1
tay
//FRAGMENT vboz1=vbuxx_lt_vbuc1
cpx #{c1}
lda #0
rol
eor #1
sta {z1}
//FRAGMENT vboaa=vbuxx_lt_vbuc1
cpx #{c1}
lda #0
rol
eor #1
//FRAGMENT vboxx=vbuxx_lt_vbuc1
cpx #{c1}
lda #0
rol
eor #1
tax
//FRAGMENT vboyy=vbuxx_lt_vbuc1
cpx #{c1}
lda #0
rol
eor #1
tay
//FRAGMENT vboz1=vbuyy_lt_vbuc1
cpy #{c1}
lda #0
rol
eor #1
sta {z1}
//FRAGMENT vboaa=vbuyy_lt_vbuc1
cpy #{c1}
lda #0
rol
eor #1
//FRAGMENT vboxx=vbuyy_lt_vbuc1
cpy #{c1}
lda #0
rol
eor #1
tax
//FRAGMENT vboyy=vbuyy_lt_vbuc1
cpy #{c1}
lda #0
rol
eor #1
tay
//FRAGMENT vbuaa=vbuc1_plus_vbuxx
txa
clc
adc #{c1}
//FRAGMENT vbuaa=vbuc1_plus_vbuyy
tya
clc
adc #{c1}
//FRAGMENT vbuxx=vbuc1_plus_vbuxx
txa
axs #-[{c1}]
//FRAGMENT vbuxx=vbuc1_plus_vbuyy
tya
tax
axs #-[{c1}]
//FRAGMENT vbuyy=vbuc1_plus_vbuaa
clc
adc #{c1}
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
//FRAGMENT vbuz1=vbuz2_rol_4
lda {z2}
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuaa_rol_4
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuxx_rol_4
txa
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuyy_rol_4
tya
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuz1_rol_4
lda {z1}
asl
asl
asl
asl
//FRAGMENT vbuaa=vbuaa_rol_4
asl
asl
asl
asl
//FRAGMENT vbuaa=vbuxx_rol_4
txa
asl
asl
asl
asl
//FRAGMENT vbuaa=vbuyy_rol_4
tya
asl
asl
asl
asl
//FRAGMENT vbuxx=vbuz1_rol_4
lda {z1}
asl
asl
asl
asl
tax
//FRAGMENT vbuxx=vbuaa_rol_4
asl
asl
asl
asl
tax
//FRAGMENT vbuxx=vbuxx_rol_4
txa
asl
asl
asl
asl
tax
//FRAGMENT vbuxx=vbuyy_rol_4
tya
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuz1_rol_4
lda {z1}
asl
asl
asl
asl
tay
//FRAGMENT vbuyy=vbuaa_rol_4
asl
asl
asl
asl
tay
//FRAGMENT vbuyy=vbuxx_rol_4
txa
asl
asl
asl
asl
tay
//FRAGMENT vbuyy=vbuyy_rol_4
tya
asl
asl
asl
asl
tay
//FRAGMENT vbuz1=vbuaa_bor_vbuz2
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuaa_bor_vbuxx
stx $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuaa_bor_vbuyy
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuaa=vbuaa_bor_vbuz1
ora {z1}
//FRAGMENT vbuaa=vbuaa_bor_vbuxx
stx $ff
ora $ff
//FRAGMENT vbuaa=vbuaa_bor_vbuyy
sty $ff
ora $ff
//FRAGMENT vbuxx=vbuaa_bor_vbuz1
ora {z1}
tax
//FRAGMENT vbuxx=vbuaa_bor_vbuxx
stx $ff
ora $ff
tax
//FRAGMENT vbuxx=vbuaa_bor_vbuyy
sty $ff
ora $ff
tax
//FRAGMENT vbuyy=vbuaa_bor_vbuz1
ora {z1}
tay
//FRAGMENT vbuyy=vbuaa_bor_vbuxx
stx $ff
ora $ff
tay
//FRAGMENT vbuyy=vbuaa_bor_vbuyy
sty $ff
ora $ff
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
//FRAGMENT vbuaa=vbuyy_bor_vbuxx
txa
sty $ff
ora $ff
//FRAGMENT pbuz1_derefidx_vbuyy=vbuxx
txa
sta ({z1}),y
//FRAGMENT vbuxx=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
tax
//FRAGMENT vbuyy=vbuyy_bor_vbuxx
txa
sty $ff
ora $ff
tay
//FRAGMENT vboz1=vboyy
tya
sta {z1}
//FRAGMENT vbuz1=_byte_pwuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_plus_1
ldx {z1}
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT pwuc1_derefidx_vbuz1_lt_vbuc2_then_la1
ldy {z1}
lda {c1}+1,y
bne !+
lda {c1},y
cmp #{c2}
bcc {la1}
!:
//FRAGMENT pwuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pbuz1=pbuz2_plus_pwuc1_derefidx_vbuz3
ldy {z3}
clc
lda {z2}
adc {c1},y
sta {z1}
lda {z2}+1
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vbuaa=_byte_pwuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbuxx=_byte_pwuc1_derefidx_vbuz1
ldx {z1}
lda {c1},x
tax
//FRAGMENT vbuyy=_byte_pwuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
tay
//FRAGMENT vbuz1=_byte_pwuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=_byte_pwuc1_derefidx_vbuaa
tay
lda {c1},y
//FRAGMENT vbuxx=_byte_pwuc1_derefidx_vbuaa
tax
lda {c1},x
tax
//FRAGMENT vbuyy=_byte_pwuc1_derefidx_vbuaa
tay
lda {c1},y
tay
//FRAGMENT vbuz1=_byte_pwuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuaa=_byte_pwuc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbuxx=_byte_pwuc1_derefidx_vbuxx
lda {c1},x
tax
//FRAGMENT vbuyy=_byte_pwuc1_derefidx_vbuxx
lda {c1},x
tay
//FRAGMENT vbuz1=_byte_pwuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=_byte_pwuc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vbuxx=_byte_pwuc1_derefidx_vbuyy
lda {c1},y
tax
//FRAGMENT vbuyy=_byte_pwuc1_derefidx_vbuyy
lda {c1},y
tay
//FRAGMENT pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_1
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT pwuc1_derefidx_vbuxx_lt_vbuc2_then_la1
lda {c1}+1,x
bne !+
lda {c1},x
cmp #{c2}
bcc {la1}
!:
//FRAGMENT pwuc1_derefidx_vbuyy_lt_vbuc2_then_la1
lda {c1}+1,y
bne !+
lda {c1},y
cmp #{c2}
bcc {la1}
!:
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
//FRAGMENT pbuz1=pbuz2_plus_pwuc1_derefidx_vbuxx
clc
lda {z2}
adc {c1},x
sta {z1}
lda {z2}+1
adc {c1}+1,x
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_pwuc1_derefidx_vbuyy
clc
lda {z2}
adc {c1},y
sta {z1}
lda {z2}+1
adc {c1}+1,y
sta {z1}+1
//FRAGMENT pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_plus_1
tya
tax
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT vbuz1=vbuc1_bor_vbuz2
lda #{c1}
ora {z2}
sta {z1}
//FRAGMENT pbuz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwuz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vbuz1=vbuc1_bor_vbuaa
ora #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_bor_vbuxx
txa
ora #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_bor_vbuyy
tya
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_bor_vbuz1
lda #{c1}
ora {z1}
//FRAGMENT vbuaa=vbuc1_bor_vbuaa
ora #{c1}
//FRAGMENT vbuaa=vbuc1_bor_vbuxx
txa
ora #{c1}
//FRAGMENT vbuaa=vbuc1_bor_vbuyy
tya
ora #{c1}
//FRAGMENT vbuxx=vbuc1_bor_vbuz1
lda #{c1}
ora {z1}
tax
//FRAGMENT vbuxx=vbuc1_bor_vbuaa
ora #{c1}
tax
//FRAGMENT vbuxx=vbuc1_bor_vbuxx
txa
ora #{c1}
tax
//FRAGMENT vbuxx=vbuc1_bor_vbuyy
tya
ora #{c1}
tax
//FRAGMENT vbuyy=vbuc1_bor_vbuz1
lda #{c1}
ora {z1}
tay
//FRAGMENT vbuyy=vbuc1_bor_vbuaa
ora #{c1}
tay
//FRAGMENT vbuyy=vbuc1_bor_vbuxx
txa
ora #{c1}
tay
//FRAGMENT vbuyy=vbuc1_bor_vbuyy
tya
ora #{c1}
tay
//FRAGMENT vwuz1_gt_vbuc1_then_la1
lda {z1}+1
bne {la1}
lda {z1}
cmp #{c1}
beq !+
bcs {la1}
!:
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuz1
lda {c1}
and {z1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuz1
lda {c1}
ora {z1}
sta {c1}
//FRAGMENT vbuz1=vbuaa_bxor_vbuc1
eor #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_bxor_vbuc1
eor #{c1}
//FRAGMENT vbuxx=vbuaa_bxor_vbuc1
eor #{c1}
tax
//FRAGMENT vbuyy=vbuaa_bxor_vbuc1
eor #{c1}
tay
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuaa
and {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuxx
txa
and {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuyy
tya
and {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuaa
ora {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuxx
txa
ora {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuyy
tya
ora {c1}
sta {c1}
//FRAGMENT pbuz1=pbuc1_plus_vbsz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2_band_vbuc1
lda #{c1}
ldy #0
and ({z2}),y
sta {z1}
//FRAGMENT vbsaa_ge_0_then_la1
cmp #0
bpl {la1}
//FRAGMENT pbuz1=pbuc1_plus_vbsaa
pha
clc
adc #<{c1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vbsxx
txa
pha
clc
adc #<{c1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vbsyy
tya
pha
clc
adc #<{c1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuaa=_deref_pbuz1_band_vbuc1
lda #{c1}
ldy #0
and ({z1}),y
//FRAGMENT vbuxx=_deref_pbuz1_band_vbuc1
lda #{c1}
ldy #0
and ({z1}),y
tax
//FRAGMENT vbuyy=_deref_pbuz1_band_vbuc1
lda #{c1}
ldy #0
and ({z1}),y
tay
//FRAGMENT vbuyy=vbuxx_bor_vbuyy
txa
sty $ff
ora $ff
tay
//FRAGMENT vbuxx=vbuyy_bor_vbuxx
txa
sty $ff
ora $ff
tax
//FRAGMENT vduz1=vduz2_minus_vduc1
lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
lda {z2}+2
sbc #<{c1}>>$10
sta {z1}+2
lda {z2}+3
sbc #>{c1}>>$10
sta {z1}+3
//FRAGMENT _deref_pduc1=vduc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
lda #<{c2}>>$10
sta {c1}+2
lda #>{c2}>>$10
sta {c1}+3
//FRAGMENT vbuz1=vbuc1_minus_vbuz2
lda #{c1}
sec
sbc {z2}
sta {z1}
//FRAGMENT pbuz1=pbuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT vduz1=vduc1_minus__deref_pduc2
lda #<{c1}
sec
sbc {c2}
sta {z1}
lda #>{c1}
sbc {c2}+1
sta {z1}+1
lda #<{c1}>>$10
sbc {c2}+2
sta {z1}+2
lda #>{c1}>>$10
sbc {c2}+3
sta {z1}+3
//FRAGMENT vwuz1=_lo_vduz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pwuz1=pwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pwuz1=vwuz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT pwuz1=pwuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pwuz1=pwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=pwuz2_minus_pwuc1
lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pwuz1_le_vwuz2_then_la1
ldy #1
lda ({z1}),y
cmp {z2}+1
bne !+
dey
lda ({z1}),y
cmp {z2}
beq {la1}
!:
bcc {la1}
//FRAGMENT pwuz1=pwuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_ror_1
lda {z2}
lsr
sta {z1}
//FRAGMENT pwuz1=pwuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_minus__deref_pwsz3
sec
lda {z2}
ldy #0
sbc ({z3}),y
sta {z1}
lda {z2}+1
iny
sbc ({z3}),y
sta {z1}+1
//FRAGMENT vwsz1_le_0_then_la1
lda {z1}+1
bmi {la1}
bne !+
lda {z1}
beq {la1}
!:
//FRAGMENT pwuz1=pwuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_1
clc
lda {z2}
adc #1
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
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
//FRAGMENT pbuz1_derefidx_vbuxx=vbuxx
txa
tay
sta ({z1}),y
//FRAGMENT vbuaa=vbuz1_ror_1
lda {z1}
lsr
//FRAGMENT vbuxx=vbuz1_ror_1
lda {z1}
lsr
tax
//FRAGMENT vbuyy=vbuz1_ror_1
lda {z1}
lsr
tay
//FRAGMENT vbuz1=vbuaa_ror_1
lsr
sta {z1}
//FRAGMENT vbuaa=vbuaa_ror_1
lsr
//FRAGMENT vbuxx=vbuaa_ror_1
lsr
tax
//FRAGMENT vbuyy=vbuaa_ror_1
lsr
tay
//FRAGMENT vbuz1=vbuxx_ror_1
txa
lsr
sta {z1}
//FRAGMENT vbuaa=vbuxx_ror_1
txa
lsr
//FRAGMENT vbuyy=vbuxx_ror_1
txa
lsr
tay
//FRAGMENT vbuz1=vbuyy_ror_1
tya
lsr
sta {z1}
//FRAGMENT vbuaa=vbuyy_ror_1
tya
lsr
//FRAGMENT vbuxx=vbuyy_ror_1
tya
lsr
tax
//FRAGMENT pwuz1=pwuz2_plus_vbuaa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pwuz1=pwuz2_plus_vbuxx
txa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pwuz1=pwuz2_plus_vbuyy
tya
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuaa=vbuaa_plus_1
clc
adc #1
//FRAGMENT vbuaa=vbuxx_plus_1
inx
txa
//FRAGMENT vbuaa=vbuyy_plus_1
iny
tya
//FRAGMENT vbuxx=vbuaa_plus_1
tax
inx
//FRAGMENT vbuxx=vbuxx_plus_1
inx
//FRAGMENT vbuxx=vbuyy_plus_1
tya
tax
inx
//FRAGMENT vbuyy=vbuaa_plus_1
tay
iny
//FRAGMENT vbuyy=vbuxx_plus_1
txa
tay
iny
//FRAGMENT vbuyy=vbuyy_plus_1
iny
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx
lda {c1},x
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy
ldx {c1},y
//FRAGMENT vwuz1=pwuz1_minus_pwuc1
lda {z1}
sec
sbc #<{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vduz1=vduz1_minus_vduc1
lda {z1}
sec
sbc #<{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
lda {z1}+2
sbc #<{c1}>>$10
sta {z1}+2
lda {z1}+3
sbc #>{c1}>>$10
sta {z1}+3
//FRAGMENT pbuz1=_dec_pbuz1
lda {z1}
bne !+
dec {z1}+1
!:
dec {z1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT _stackidxbyte_vbuc1=vbuz1
lda {z1}
tsx
sta STACK_BASE+{c1},x
//FRAGMENT _stackpushbyte_=vbuz1
lda {z1}
pha
//FRAGMENT _stackpushbyte_1
pha
//FRAGMENT vbuz1=_stackpullbyte_
pla
sta {z1}
//FRAGMENT _stackpullbyte_2
pla
pla
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
//FRAGMENT _stackidxbyte_vbuc1=vbuxx
txa
tsx
sta STACK_BASE+{c1},x
//FRAGMENT _stackidxbyte_vbuc1=vbuyy
tya
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
//FRAGMENT _stackpushbyte_=vbuxx
txa
pha
//FRAGMENT _stackpushbyte_=vbuyy
tya
pha
//FRAGMENT _stackpushbyte_3
pha
pha
pha
//FRAGMENT _stackpullbyte_4
tsx
txa
axs #-4
txs
//FRAGMENT pbuz1=_stackidxptr_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
lda STACK_BASE+{c1}+1,x
sta {z1}+1
//FRAGMENT pbuc1_derefidx_vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
ldy {z1}
sta {c1},y
//FRAGMENT _stackpushptr_=pbuc1
lda #>{c1}
pha
lda #<{c1}
pha
//FRAGMENT _stackpushbyte_=vbuc1
lda #{c1}
pha
//FRAGMENT _stackpullbyte_3
tsx
txa
axs #-3
txs
//FRAGMENT vbuz1=vbuz2_minus_1
ldx {z2}
dex
stx {z1}
//FRAGMENT vbuaa=vbuz1_minus_1
lda {z1}
sec
sbc #1
//FRAGMENT _stackpushbyte_=vbuaa
pha
//FRAGMENT _stackidxbyte_vbuc1=vbuaa
tsx
sta STACK_BASE+{c1},x
//FRAGMENT vbuxx=vbuz1_minus_1
ldx {z1}
dex
//FRAGMENT vbuyy=vbuz1_minus_1
lda {z1}
tay
dey
//FRAGMENT vbuz1=vbuaa_minus_1
sec
sbc #1
sta {z1}
//FRAGMENT vbuaa=vbuaa_minus_1
sec
sbc #1
//FRAGMENT vbuxx=vbuaa_minus_1
tax
dex
//FRAGMENT vbuz1=_lo_pbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_hi_pbuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuc1_lt_vbuz1_then_la1
lda #{c1}
cmp {z1}
bcc {la1}
//FRAGMENT vbuc1_ge_vbuz1_then_la1
lda #{c1}
cmp {z1}
bcs {la1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuz2_word_pbuc2_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}+1
lda {c2},y
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbuz3
ldy #0
lda ({z2}),y
ldy {z3}
ora {c1},y
sta {z1}
//FRAGMENT vbuaa=_lo_pbuz1
lda {z1}
//FRAGMENT vbuxx=_lo_pbuz1
ldx {z1}
//FRAGMENT vbuz1=vbuaa_bor_vbuaa
sta {z1}
//FRAGMENT vbuaa=_hi_pbuz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_pbuz1
ldx {z1}+1
//FRAGMENT vbuc1_lt_vbuaa_then_la1
cmp #{c1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuz1=vbuz1_plus_vbuyy
tya
clc
adc {z1}
sta {z1}
//FRAGMENT vbuc1_ge_vbuaa_then_la1
cmp #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuz1_ge_vbuaa_then_la1
ldy {z1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuaa_word_pbuc2_derefidx_vbuaa
tay
lda {c1},y
sta {z1}+1
lda {c2},y
sta {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuxx_word_pbuc2_derefidx_vbuxx
lda {c1},x
sta {z1}+1
lda {c2},x
sta {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuyy_word_pbuc2_derefidx_vbuyy
lda {c1},y
sta {z1}+1
lda {c2},y
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ldy #0
ora ({z2}),y
sta {z1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ldy #0
ora ({z2}),y
sta {z1}
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbuz2
ldy #0
lda ({z1}),y
ldy {z2}
ora {c1},y
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ldy #0
ora ({z1}),y
//FRAGMENT vbuaa=_deref_pbuz1_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ldy #0
ora ({z1}),y
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbuz2
ldx {z2}
lda {c1},x
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuxx=_deref_pbuz1_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbuz2
ldy #0
lda ({z1}),y
ldy {z2}
ora {c1},y
tay
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ldy #0
ora ({z1}),y
tay
//FRAGMENT vbuyy=_deref_pbuz1_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ldy #0
ora ({z1}),y
tay
//FRAGMENT vbuc1_ge_vbuxx_then_la1
cpx #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuc1_lt_vbuxx_then_la1
cpx #{c1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuc1_lt_vbuyy_then_la1
cpy #{c1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuyy=_lo_pbuz1
ldy {z1}
//FRAGMENT vbuz1=vbuz2_bor__lo_pbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vbuyy=_hi_pbuz1
ldy {z1}+1
//FRAGMENT vwuz1_eq_0_then_la1
lda {z1}
bne !+
lda {z1}+1
beq {la1}
!:
//FRAGMENT vwuz1_gt_vwuz2_then_la1
lda {z2}+1
cmp {z1}+1
bcc {la1}
bne !+
lda {z2}
cmp {z1}
bcc {la1}
!:
//FRAGMENT vwuz1_neq_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vwuz1=vwuz2_band_vwuc1
lda {z2}
and #<{c1}
sta {z1}
lda {z2}+1
and #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuz1=_deref_pbuz1_bor_pbuc1_derefidx_vbuz2
ldy #0
lda ({z1}),y
ldy {z2}
ora {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=_deref_pbuz1_bor_pbuc1_derefidx_vbuaa
tay
lda {c1},y
ldy #0
ora ({z1}),y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=_deref_pbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ldy #0
ora ({z1}),y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=_deref_pbuz1_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ldy #0
ora ({z1}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=pbuz1_plus_vwuz2
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuc1_derefidx_vbuz1_neq_0_then_la1
ldy {z1}
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuaa_neq_0_then_la1
tay
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_neq_0_then_la1
lda {c1},x
cmp #0
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_neq_0_then_la1
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT pbuz1=pbuz2_minus_vwuc1
lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT pssz1=pssc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuc1_rol_pbuz2_derefidx_vbuc2
ldy #{c2}
lda ({z2}),y
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuc1_eq_vbuc2_then_la1
lda #{c2}
ldy #{c1}
cmp ({z1}),y
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuc1_neq_vbuc2_then_la1
ldy #{c1}
lda ({z1}),y

cmp #{c2}
bne {la1}
//FRAGMENT _deref_(qbuz1_derefidx_vbuc1)=vbuc2
ldx #{c2}
ldy #{c1}
lda ({z1}),y
sta !+ +1
iny
lda ({z1}),y
sta !+ +2
!: stx $ffff
//FRAGMENT pbuc1_derefidx_(pbuz1_derefidx_vbuc2)=pbuz1_derefidx_vbuc3
ldy #{c3}
lda ({z1}),y
ldy #{c2}
pha
lda ({z1}),y
tay
pla
sta {c1},y
//FRAGMENT vwuz1=_deref_pwuz2_ror_4
ldy #0
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT vbuz1=vbuc1_bxor_vbuz2
lda #{c1}
eor {z2}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=_byte_vwuz2
ldy {z1}
lda {z2}
sta {c1},y
//FRAGMENT vwuz1=pwuz2_derefidx_vbuc1_ror_4
ldy #{c1}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT _deref_pwuz1_lt_vwuc1_then_la1
ldy #1
lda ({z1}),y
cmp #>{c1}
bcc {la1}
bne !+
dey
lda ({z1}),y
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT _deref_pwuz1_gt_vwuc1_then_la1
ldy #1
lda #>{c1}
cmp ({z1}),y
bcc {la1}
bne !+
dey
lda #<{c1}
cmp ({z1}),y
bcc {la1}
!:
//FRAGMENT pwuz1_derefidx_vbuc1_lt_vwuc2_then_la1
ldy #{c1}
iny
lda ({z1}),y
cmp #>{c2}
bcc {la1}
bne !+
dey
lda ({z1}),y
cmp #<{c2}
bcc {la1}
!:
//FRAGMENT pwuz1_derefidx_vbuc1_gt_vwuc2_then_la1
ldy #{c1}
iny
lda #>{c2}
cmp ({z1}),y
bcc {la1}
bne !+
dey
lda #<{c2}
cmp ({z1}),y
bcc {la1}
!:
//FRAGMENT vwuz1=vwuz2_ror_3
lda {z2}+1
lsr
sta {z1}+1
lda {z2}
ror
sta {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_plus_pwuc2_derefidx_vbuz2
ldx {z2}
ldy #{c1}
clc
lda ({z1}),y
adc {c2},x
sta ({z1}),y
iny
lda ({z1}),y
adc {c2}+1,x
sta ({z1}),y
//FRAGMENT _deref_pwuz1=_deref_pwuz1_plus_pwuz1_derefidx_vbuc1
ldy #{c1}
sty $ff
clc
lda ({z1}),y
ldy #0
adc ({z1}),y
sta ({z1}),y
ldy $ff
iny
lda ({z1}),y
ldy #1
adc ({z1}),y
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_plus_pwuz1_derefidx_vbuc2
ldy #{c2}
clc
lda ({z1}),y
ldy #{c1}
adc ({z1}),y
sta ({z1}),y
ldy #{c2}+1
lda ({z1}),y
ldy #{c1}+1
adc ({z1}),y
sta ({z1}),y
//FRAGMENT vbuz1=_neg_vbuz2
lda {z2}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbuz1=pbuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1_neq_vbuc2_then_la1
lda #{c2}
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT vwuz1=vbuc1_plus_vwuz2
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_rol_4
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
asl {z1}
rol {z1}+1
//FRAGMENT pwuc1_derefidx_vbuz1=_word_vbuz2
lda {z2}
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuz1=vwuc2
ldy {z1}
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT qbuc1_derefidx_vbuz1=pbuz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT pssz1=pssc1_plus_vbuaa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pssz1=pssc1_plus_vbuxx
txa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pssz1=pssc1_plus_vbuyy
tya
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbuaa=vbuc1_rol_pbuz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
//FRAGMENT vbuxx=vbuc1_rol_pbuz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
tax
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
tax
//FRAGMENT vbuyy=vbuc1_rol_pbuz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
tay
//FRAGMENT vbuaa=vbuc1_bxor_vbuz1
lda #{c1}
eor {z1}
//FRAGMENT vbuxx=vbuc1_bxor_vbuz1
lda #{c1}
eor {z1}
tax
//FRAGMENT vbuyy=vbuc1_bxor_vbuz1
lda #{c1}
eor {z1}
tay
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_plus_pwuc2_derefidx_vbuaa
ldy #{c1}
tax
clc
lda ({z1}),y
adc {c2},x
sta ({z1}),y
iny
lda ({z1}),y
adc {c2}+1,x
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_plus_pwuc2_derefidx_vbuxx
ldy #{c1}
clc
lda ({z1}),y
adc {c2},x
sta ({z1}),y
iny
lda ({z1}),y
adc {c2}+1,x
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_plus_pwuc2_derefidx_vbuyy
tya
ldy #{c1}
tax
clc
lda ({z1}),y
adc {c2},x
sta ({z1}),y
iny
lda ({z1}),y
adc {c2}+1,x
sta ({z1}),y
//FRAGMENT vbuz1=_neg_vbuaa
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbuz1=_neg_vbuxx
dex
txa
eor #$ff
sta {z1}
//FRAGMENT vbuaa=_neg_vbuz1
lda {z1}
eor #$ff
clc
adc #$01
//FRAGMENT vbuaa=_neg_vbuaa
eor #$ff
clc
adc #$01
//FRAGMENT vbuaa=_neg_vbuxx
dex
txa
eor #$ff
//FRAGMENT vbuxx=_neg_vbuz1
lda {z1}
eor #$ff
tax
inx
//FRAGMENT vbuxx=_neg_vbuaa
eor #$ff
tax
inx
//FRAGMENT vbuxx=_neg_vbuxx
dex
txa
eor #$ff
tax
//FRAGMENT vbuyy=_neg_vbuz1
lda {z1}
eor #$ff
tay
iny
//FRAGMENT vbuyy=_neg_vbuaa
eor #$ff
tay
iny
//FRAGMENT vbuyy=_neg_vbuxx
txa
eor #$ff
tay
iny
//FRAGMENT vbuxx=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
sta {z1}
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
//FRAGMENT vbuxx=pbuz1_derefidx_vbuyy
lda ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuyy
lda ({z1}),y
tay
//FRAGMENT pbuc1_derefidx_vbuaa_neq_vbuc2_then_la1
tay
lda #{c2}
cmp {c1},y
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_neq_vbuc2_then_la1
lda {c1},x
cmp #{c2}
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_neq_vbuc2_then_la1
lda #{c2}
cmp {c1},y
bne {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=_word_vbuxx
ldy {z1}
txa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuz1=_word_vbuyy
tya
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=_word_vbuz1
lda {z1}
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuxx=_word_vbuxx
txa
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuxx=_word_vbuyy
tya
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=_word_vbuz1
lda {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuyy=_word_vbuxx
txa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuyy=_word_vbuyy
tya
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=vwuc2
lda #<{c2}
sta {c1},x
lda #>{c2}
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=vwuc2
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT qbuc1_derefidx_vbuxx=pbuz1
lda {z1}
sta {c1},x
lda {z1}+1
sta {c1}+1,x
//FRAGMENT qbuc1_derefidx_vbuyy=pbuz1
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
//FRAGMENT vbuyy_ge_vbuxx_then_la1
stx $ff
cpy $ff
bcs {la1}
//FRAGMENT vwuz1=vwuz1_ror_3
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT vwuz1=vwuz1_rol_4
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vbuc1_plus_vwuz1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pbuz1=pbuz2_minus_vwuz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT pwuz1=qwuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vbuz1_le_0_then_la1
lda {z1}
cmp #0
beq {la1}
//FRAGMENT vwuz1_eq_vwuc1_then_la1
lda {z1}
cmp #<{c1}
bne !+
lda {z1}+1
cmp #>{c1}
beq {la1}
!:
//FRAGMENT _deref_pbuc1=_dec__deref_pbuc1
dec {c1}
//FRAGMENT vwuz1=pwuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT _deref_pbuz1_eq_vbuc1_then_la1
lda #{c1}
ldy #0
cmp ({z1}),y
beq {la1}
//FRAGMENT _deref_pbuz1_gt_vbuz2_then_la1
ldy #0
lda ({z1}),y
cmp {z2}
beq !+
bcs {la1}
!:
//FRAGMENT pbuz1_derefidx_(_deref_pbuz2)=_inc_pbuz1_derefidx_(_deref_pbuz2)
ldy #0
lda ({z2}),y
tay
lda ({z1}),y
clc
adc #1
sta ({z1}),y
//FRAGMENT vwuz1=_deref_pbuz2_rol_1
ldy #0
lda ({z2}),y
asl
sta {z1}
lda #0
rol
sta {z1}+1
//FRAGMENT qwuz1=qwuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT _deref_qwuz1=pwuz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT vwuz1_neq_vbuc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwuz1_neq_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT pwuz1=_deref_qwuz2
ldy #0
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vwuz1=pbuz2_minus_pbuz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT pwuz1_derefidx_vbuz2=vwuz3
ldy {z2}
lda {z3}
sta ({z1}),y
iny
lda {z3}+1
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=_inc_pbuz1_derefidx_vbuz2
ldy {z2}
lda ({z1}),y
clc
adc #1
sta ({z1}),y
//FRAGMENT vwuz1=pwuz2_minus_pwuz3
lda {z2}
sec
sbc {z3}
sta {z1}
lda {z2}+1
sbc {z3}+1
sta {z1}+1
//FRAGMENT pwuz1=qwuz2_derefidx_vbuaa
tay
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT pwuz1=qwuz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT pwuz1=qwuz2_derefidx_vbuyy
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vbuaa_le_0_then_la1
cmp #0
beq {la1}
//FRAGMENT vwuz1=pwuz2_derefidx_vbuaa
tay
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vwuz1=pwuz2_derefidx_vbuxx
txa
tay
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vwuz1=pwuz2_derefidx_vbuyy
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT _deref_pbuz1_gt_vbuxx_then_la1
ldy #0
lda ({z1}),y
sta $ff
cpx $ff
bcc {la1}
//FRAGMENT pwuz1_derefidx_vbuaa=vwuz2
tay
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuxx=vwuz2
txa
tay
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuyy=vwuz2
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=_inc_pbuz1_derefidx_vbuxx
txa
tay
lda ({z1}),y
clc
adc #1
sta ({z1}),y
//FRAGMENT vbuxx_le_0_then_la1
cpx #0
beq {la1}
//FRAGMENT pbuz1=pbuz2_minus_vwuz1
lda {z2}
sec
sbc {z1}
sta {z1}
lda {z2}+1
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwuz1=_deref_pbuz1_rol_1
ldy #0
lda ({z1}),y
asl
sta {z1}
lda #0
rol
sta {z1}+1
//FRAGMENT qwuz1=qwuz2_plus_vwuz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pwuz1=_deref_qwuz1
ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT vwuz1=pwuz1_minus_pwuz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx
ldy {c1},x
//FRAGMENT _stackpullbyte_1
pla
//FRAGMENT vduz1=_inc_vduz1
inc {z1}
bne !+
inc {z1}+1
bne !+
inc {z1}+2
bne !+
inc {z1}+3
!:
//FRAGMENT vbuz1_le_vbuz2_then_la1
lda {z2}
cmp {z1}
bcs {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuz2_then_la1
ldy {z1}
lda {c1},y
cmp {z2}
beq {la1}
//FRAGMENT vbsz1=vbsz2_minus_vbsz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbuz1=_byte_vduz2
lda {z2}
sta {z1}
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
//FRAGMENT vbuz1_le_vbuc1_then_la1
lda #{c1}
cmp {z1}
bcs {la1}
//FRAGMENT vbuaa_le_vbuz1_then_la1
ldy {z1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT pbuc1_derefidx_vbuaa_eq_vbuz1_then_la1
tay
lda {c1},y
cmp {z1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_eq_vbuz1_then_la1
lda {c1},x
cmp {z1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_eq_vbuz1_then_la1
lda {c1},y
cmp {z1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuaa_then_la1
ldx {z1}
tay
lda {c1},x
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuaa_eq_vbuaa_then_la1
tax
lda {c1},x
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_eq_vbuaa_then_la1
tay
lda {c1},x
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_eq_vbuaa_then_la1
tax
lda {c1},y
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuxx_then_la1
ldy {z1}
lda {c1},y
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuaa_eq_vbuxx_then_la1
tay
lda {c1},y
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_eq_vbuxx_then_la1
lda {c1},x
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_eq_vbuxx_then_la1
lda {c1},y
tay
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuyy_then_la1
ldx {z1}
lda {c1},x
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuaa_eq_vbuyy_then_la1
tax
lda {c1},x
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_eq_vbuyy_then_la1
lda {c1},x
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_eq_vbuyy_then_la1
lda {c1},y
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT vbsz1=vbsz2_minus_vbsaa
eor #$ff
sec
adc {z2}
sta {z1}
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
//FRAGMENT vbsxx=vbsz1_minus_vbsz2
lda {z1}
sec
sbc {z2}
tax
//FRAGMENT vbsxx=vbsz1_minus_vbsaa
eor #$ff
sec
adc {z1}
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
//FRAGMENT vbsz1=vbsxx_minus_vbsz2
txa
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_vbsaa
sta $ff
txa
sec
sbc $ff
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
//FRAGMENT vbsxx=vbsxx_minus_vbsz1
txa
sec
sbc {z1}
tax
//FRAGMENT vbsxx=vbsxx_minus_vbsaa
sta $ff
txa
sec
sbc $ff
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
//FRAGMENT vbsz1=vbsyy_minus_vbsz2
tya
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1=vbsyy_minus_vbsaa
sta $ff
tya
sec
sbc $ff
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
//FRAGMENT vbsxx=vbsyy_minus_vbsz1
tya
sec
sbc {z1}
tax
//FRAGMENT vbsxx=vbsyy_minus_vbsaa
sta $ff
tya
sec
sbc $ff
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
//FRAGMENT vbuaa=_byte_vduz1
lda {z1}
//FRAGMENT vbuxx=_byte_vduz1
lda {z1}
tax
//FRAGMENT vbuyy=_byte_vduz1
lda {z1}
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
//FRAGMENT vduz1=pduc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
lda {c1}+2,y
sta {z1}+2
lda {c1}+3,y
sta {z1}+3
//FRAGMENT vbuaa_le_vbuc1_then_la1
cmp #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuz1=vbuxx_minus_1
dex
stx {z1}
//FRAGMENT vbuz1=vbuyy_minus_1
tya
sec
sbc #1
sta {z1}
//FRAGMENT vbuxx_le_vbuz1_then_la1
lda {z1}
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy_le_vbuz1_then_la1
lda {z1}
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuz1_le_vbuaa_then_la1
cmp {z1}
bcs {la1}
//FRAGMENT vbuxx_le_vbuc1_then_la1
cpx #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuyy_le_vbuc1_then_la1
cpy #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuaa_lt_vbuxx_then_la1
stx $ff
cmp $ff
bcc {la1}
//FRAGMENT vbuaa_lt_vbuyy_then_la1
tax
sty $ff
cpx $ff
bcc {la1}
//FRAGMENT vbuyy_lt_vbuaa_then_la1
sta $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuyy_lt_vbuxx_then_la1
stx $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuxx_le_vbuaa_then_la1
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy_le_vbuaa_then_la1
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuz1_le_vbuxx_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuyy_le_vbuxx_then_la1
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuz1_le_vbuyy_then_la1
cpy {z1}
bcs {la1}
//FRAGMENT vbuxx_le_vbuyy_then_la1
stx $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuz1=vbuz2_minus_vbuz1
lda {z2}
sec
sbc {z1}
sta {z1}
//FRAGMENT vbsz1=vbsz1_minus_vbsz2
lda {z1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuc1_plus_vbuz1
lax {z1}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuz1=vbuz1_band_vbuc1
lda #{c1}
and {z1}
sta {z1}
//FRAGMENT pbuz1_le_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne !+
lda {z1}
cmp #<{c1}
!:
bcc {la1}
beq {la1}
//FRAGMENT pbuz1_gt_pbuc1_then_la1
lda #>{c1}
cmp {z1}+1
bcc {la1}
bne !+
lda #<{c1}
cmp {z1}
bcc {la1}
!:
//FRAGMENT vbuz1=vbuz1_rol_1
asl {z1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1
ldy {z1}
lda {c1},y
cmp #{c2}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1
ldx {z1}
inc {c1},x
//FRAGMENT pbuc1_derefidx_vbuaa_eq_vbuc2_then_la1
tay
lda {c1},y
cmp #{c2}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_eq_vbuc2_then_la1
lda {c1},x
cmp #{c2}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_eq_vbuc2_then_la1
lda {c1},y
cmp #{c2}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuxx=_inc_pbuc1_derefidx_vbuxx
inc {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=_inc_pbuc1_derefidx_vbuyy
tya
tax
inc {c1},x
//FRAGMENT vduz1=vduc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
lda #<{c1}>>$10
adc #0
sta {z1}+2
lda #>{c1}>>$10
adc #0
sta {z1}+3
//FRAGMENT vduz1=vduc1_plus_vbuaa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
lda #<{c1}>>$10
adc #0
sta {z1}+2
lda #>{c1}>>$10
adc #0
sta {z1}+3
//FRAGMENT vduz1=vduc1_plus_vbuxx
txa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
lda #<{c1}>>$10
adc #0
sta {z1}+2
lda #>{c1}>>$10
adc #0
sta {z1}+3
//FRAGMENT vduz1=vduc1_plus_vbuyy
tya
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
lda #<{c1}>>$10
adc #0
sta {z1}+2
lda #>{c1}>>$10
adc #0
sta {z1}+3
//FRAGMENT pbuz1_derefidx_vbuaa=vbuz2
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=vbuaa
tay
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=vbuxx
tay
txa
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=vbuyy
sta $ff
tya
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuyy
tya
sta ({z1}),y
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
//FRAGMENT vwuz1=vwuz2_rol_8
lda {z2}
sta {z1}+1
lda #0
sta {z1}
//FRAGMENT vwuz1=vwuz1_bxor_vwuz2
lda {z1}
eor {z2}
sta {z1}
lda {z1}+1
eor {z2}+1
sta {z1}+1
//FRAGMENT vwuz1_lt_vbuc1_then_la1
lda {z1}+1
bne !+
lda {z1}
cmp #{c1}
bcc {la1}
!:
//FRAGMENT vwuz1=_word_vduz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vduz1=vwuz2_dword_vwuz3
lda {z2}
sta {z1}+2
lda {z2}+1
sta {z1}+3
lda {z3}
sta {z1}
lda {z3}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1_eq_vbuz2_then_la1
lda {z2}
ldy #0
cmp ({z1}),y
beq {la1}
//FRAGMENT _deref_pbuz1_neq_0_then_la1
ldy #0
lda ({z1}),y
cmp #0
bne {la1}
//FRAGMENT _deref_pbuz1_eq_vbuxx_then_la1
txa
ldy #0
cmp ({z1}),y
beq {la1}
//FRAGMENT _deref_pbuz1_eq_vbuyy_then_la1
tya
ldy #0
cmp ({z1}),y
beq {la1}
//FRAGMENT vwuz1=vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuz1=pwuc1_derefidx_vbuz2_band_vbuc2
lda #{c2}
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT vwuz1=vbuaa
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vbuxx
txa
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=vbuyy
tya
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuaa=pwuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
//FRAGMENT vbuxx=pwuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldx {z1}
and {c1},x
tax
//FRAGMENT vbuyy=pwuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
tay
//FRAGMENT vbuz1=pwuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=pwuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
//FRAGMENT vbuxx=pwuc1_derefidx_vbuaa_band_vbuc2
tax
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuyy=pwuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
tay
//FRAGMENT vbuz1=pwuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
sta {z1}
//FRAGMENT vbuaa=pwuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
//FRAGMENT vbuxx=pwuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuyy=pwuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
tay
//FRAGMENT vbuz1=pwuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=pwuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
//FRAGMENT vbuxx=pwuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
tax
//FRAGMENT vbuyy=pwuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
tay
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_vbuz2
ldx {z2}
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_vbuxx
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_vbuyy
ldx {c1},y
tay
txa
sta ({z1}),y
//FRAGMENT _deref_pbuz1_neq_vbuc1_then_la1
ldy #0
lda ({z1}),y
cmp #{c1}
bne {la1}
//FRAGMENT vwsz1=vwsz2_plus_pbuz3_derefidx_vbuz4
ldy {z4}
clc
lda {z2}
adc ({z3}),y
sta {z1}
bcc !+
inc {z2}+1
!:
//FRAGMENT vwsz1=vwsz2_minus_vbuc1
sec
lda {z2}
sbc #{c1}
sta {z1}
lda {z2}+1
sbc #0
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_plus_pbuz3_derefidx_vbuxx
txa
tay
clc
lda {z2}
adc ({z3}),y
sta {z1}
bcc !+
inc {z2}+1
!:
//FRAGMENT vwsz1=vwsz2_plus_pbuz3_derefidx_vbuyy
clc
lda {z2}
adc ({z3}),y
sta {z1}
bcc !+
inc {z2}+1
!:
//FRAGMENT vwsz1=vwsz2_plus_vwsz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
bcs !+
dec {z1}+1
!:
//FRAGMENT vwsz1=vwsz1_plus_pbuz2_derefidx_vbuyy
clc
lda {z1}
adc ({z2}),y
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=vbuz1_plus_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuz1=pbuz2_derefidx_vbuc1_plus_pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
clc
adc ({z2}),y
sta {z1}
//FRAGMENT vbuz1=vbuz2_plus_pbuz3_derefidx_vbuc1
lda {z2}
ldy #{c1}
clc
adc ({z3}),y
sta {z1}
//FRAGMENT vbuyy=vbuyy_plus_pbuc1_derefidx_vbuz1
tya
ldy {z1}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=vbuz1_plus_pbuc1_derefidx_vbuaa
tay
lda {c1},y
clc
adc {z1}
sta {z1}
//FRAGMENT vbuyy=vbuyy_plus_pbuc1_derefidx_vbuaa
tax
tya
clc
adc {c1},x
tay
//FRAGMENT vbuz1=vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {z1}
sta {z1}
//FRAGMENT vbuyy=vbuyy_plus_pbuc1_derefidx_vbuxx
tya
clc
adc {c1},x
tay
//FRAGMENT vbuz1=vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {z1}
sta {z1}
//FRAGMENT vbuyy=vbuyy_plus_pbuc1_derefidx_vbuyy
tya
clc
adc {c1},y
tay
//FRAGMENT vbuaa=pbuz1_derefidx_vbuc1_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
clc
adc ({z1}),y
//FRAGMENT vbuxx=pbuz1_derefidx_vbuc1_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
clc
adc ({z1}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_vbuc1_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
clc
adc ({z1}),y
tay
//FRAGMENT vbuaa=vbuz1_plus_pbuz2_derefidx_vbuc1
lda {z1}
ldy #{c1}
clc
adc ({z2}),y
//FRAGMENT vbuxx=vbuz1_plus_pbuz2_derefidx_vbuc1
lda {z1}
ldy #{c1}
clc
adc ({z2}),y
tax
//FRAGMENT vbuyy=vbuz1_plus_pbuz2_derefidx_vbuc1
lda {z1}
ldy #{c1}
clc
adc ({z2}),y
tay
//FRAGMENT vbuz1=vbuaa_plus_pbuz2_derefidx_vbuc1
ldy #{c1}
clc
adc ({z2}),y
sta {z1}
//FRAGMENT vbuaa=vbuaa_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
clc
adc ({z1}),y
//FRAGMENT vbuxx=vbuaa_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
clc
adc ({z1}),y
tax
//FRAGMENT vbuyy=vbuaa_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
clc
adc ({z1}),y
tay
//FRAGMENT vbuz1=vbuxx_plus_pbuz2_derefidx_vbuc1
ldy #{c1}
txa
clc
adc ({z2}),y
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
txa
clc
adc ({z1}),y
//FRAGMENT vbuxx=vbuxx_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
txa
clc
adc ({z1}),y
tax
//FRAGMENT vbuyy=vbuxx_plus_pbuz1_derefidx_vbuc1
ldy #{c1}
txa
clc
adc ({z1}),y
tay
//FRAGMENT vbuz1=vbuyy_plus_pbuz2_derefidx_vbuc1
tya
ldy #{c1}
clc
adc ({z2}),y
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_pbuz1_derefidx_vbuc1
tya
ldy #{c1}
clc
adc ({z1}),y
//FRAGMENT vbuxx=vbuyy_plus_pbuz1_derefidx_vbuc1
tya
ldy #{c1}
clc
adc ({z1}),y
tax
//FRAGMENT vbuyy=vbuyy_plus_pbuz1_derefidx_vbuc1
tya
ldy #{c1}
clc
adc ({z1}),y
tay
//FRAGMENT vwuz1=vbuz2_word_vbuz3
lda {z2}
sta {z1}+1
lda {z3}
sta {z1}
//FRAGMENT vwuz1=vbuaa_word_vbuz2
sta {z1}+1
lda {z2}
sta {z1}
//FRAGMENT vwuz1=vbuxx_word_vbuz2
txa
sta {z1}+1
lda {z2}
sta {z1}
//FRAGMENT vwuz1=vbuyy_word_vbuz2
tya
sta {z1}+1
lda {z2}
sta {z1}
//FRAGMENT vwuz1=vbuz2_word_vbuaa
tay
lda {z2}
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuaa_word_vbuaa
tay
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuxx_word_vbuaa
tay
txa
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuyy_word_vbuaa
tax
tya
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=vbuz2_word_vbuxx
lda {z2}
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=vbuaa_word_vbuxx
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=vbuyy_word_vbuxx
tya
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=vbuz2_word_vbuyy
lda {z2}
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuaa_word_vbuyy
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=vbuxx_word_vbuyy
txa
sta {z1}+1
sty {z1}
//FRAGMENT _deref_qbuc1=pbuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT _deref_pbsc1=vbsc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_dec_vbuz2
ldy {z2}
dey
sty {z1}
//FRAGMENT vbuz1=_dec_vbuaa
sec
sbc #1
sta {z1}
//FRAGMENT vbuz1=_dec_vbuxx
dex
stx {z1}
//FRAGMENT vbuz1=_dec_vbuyy
dey
sty {z1}
//FRAGMENT vbuaa=_dec_vbuz1
lda {z1}
sec
sbc #1
//FRAGMENT vbuaa=_dec_vbuxx
txa
sec
sbc #1
//FRAGMENT vbuaa=_dec_vbuyy
tya
sec
sbc #1
//FRAGMENT vbuxx=_dec_vbuz1
ldx {z1}
dex
//FRAGMENT vbuxx=_dec_vbuaa
tax
dex
//FRAGMENT vbuxx=_dec_vbuyy
tya
tax
dex
//FRAGMENT vbuyy=_dec_vbuz1
ldy {z1}
dey
//FRAGMENT vbuyy=_dec_vbuaa
tay
dey
//FRAGMENT vbuyy=_dec_vbuxx
txa
tay
dey
//FRAGMENT vwuz1=vwuz2_bor_vbuz3
lda {z3}
ora {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
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
//FRAGMENT vwuz1=vwuz2_bor_vbuxx
txa
ora {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_bor_vbuxx
txa
ora {z1}
sta {z1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_vbuz2_then_la1
lda {z1}
ldy {z2}
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_ge_vbuz1_then_la1
lda {z1}
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
//FRAGMENT vbuz1_gt_pbuc1_derefidx_vbuz2_then_la1
ldy {z2}
lda {c1},y
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_gt_vbuz1_then_la1
lda {z1}
cmp {z1}
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
//FRAGMENT vbuz1_neq_pbuc1_derefidx_vbuz2_then_la1
lda {z1}
ldy {z2}
cmp {c1},y
bne {la1}
//FRAGMENT vbuz1_neq_vbuz1_then_la1
lda {z1}
cmp {z1}
bne {la1}
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
//FRAGMENT pwuz1_derefidx_vbuc1=vwuz2
ldy #{c1}
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT vbuz1=vbuz2_plus_2
lda {z2}
clc
adc #2
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_2
lda {z1}
clc
adc #2
//FRAGMENT vbuxx=vbuz1_plus_2
ldx {z1}
inx
inx
//FRAGMENT vbuyy=vbuz1_plus_2
ldy {z1}
iny
iny
//FRAGMENT vbuxx=vbuaa_plus_2
tax
inx
inx
//FRAGMENT vbuxx=vbuyy_plus_2
tya
clc
adc #2
tax
//FRAGMENT vbsz1_lt_vbsc1_then_la1
lda {z1}
sec
sbc #{c1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsaa_lt_vbsc1_then_la1
sec
sbc #{c1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsxx_lt_vbsc1_then_la1
txa
sec
sbc #{c1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsyy_lt_vbsc1_then_la1
tya
sec
sbc #{c1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsz1=vwsz2_ror_7
lda {z2}+1
sta {z1}
and #$80
beq !+
lda #$ff
!:
sta {z1}+1
lda {z2}
rol
rol {z1}
rol {z1}+1
//FRAGMENT vwsz1=vwsz2_ror_5
lda {z2}
sta $ff
lda {z2}+1
sta {z1}
lda #0
bit {z2}+1
bpl !+
lda #$ff
!:
sta {z1}+1
rol $ff
rol {z1}
rol {z1}+1
rol $ff
rol {z1}
rol {z1}+1
rol $ff
rol {z1}
rol {z1}+1
//FRAGMENT _deref_pbuc1=_byte_vwsz1
lda {z1}
sta {c1}
//FRAGMENT vwsz1=vwsc1_minus_vwsz1
lda #<{c1}
sec
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
//FRAGMENT _deref_pbsc1=vbsz1
lda {z1}
sta {c1}
//FRAGMENT pwuc1_derefidx_vbuaa=_word_vbuz1
tay
lda {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=_word_vbuxx
tay
txa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=_word_vbuyy
tax
tya
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT vbuxx_neq_vbuaa_then_la1
tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT _deref_pbuc1=_deref_pbuz1
ldy #0
lda ({z1}),y
sta {c1}
//FRAGMENT vwuz1=pbuc1_minus_pbuz2
sec
lda #<{c1}
sbc {z2}
sta {z1}
lda #>{c1}
sbc {z2}+1
sta {z1}+1 
//FRAGMENT vwuz1=pbuc1_minus_pbuz1
sec
lda #<{c1}
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
//FRAGMENT pbuc1_derefidx_vbuaa=_deref_pbuz1
tax
ldy #0
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=_deref_pbuz1
ldy #0
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=_deref_pbuz1
tya
tax
ldy #0
lda ({z1}),y
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuz1=_deref_pbsc2
lda {c2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=vbuc1_plus__deref_pbuc2
lda #{c1}
clc
adc {c2}
sta {z1}
//FRAGMENT vbsz1=vbsz1_plus_2
inc {z1}
inc {z1}
//FRAGMENT vbsz1=vbsz1_minus_vbsc1
lax {z1}
axs #{c1}
stx {z1}
//FRAGMENT vbsz1=vbsz2_plus_vbsz3
lda {z2}
clc
adc {z3}
sta {z1}
//FRAGMENT vbsz1=pbsc1_derefidx_vbsz2_plus_pbsc1_derefidx_vbsz3
ldy {z2}
lda {c1},y
ldy {z3}
clc
adc {c1},y
sta {z1}
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
//FRAGMENT pbsc1_derefidx_vbuaa=_deref_pbsc2
tay
lda {c2}
sta {c1},y
//FRAGMENT pbsc1_derefidx_vbuxx=_deref_pbsc2
lda {c2}
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuyy=_deref_pbsc2
lda {c2}
sta {c1},y
//FRAGMENT vbuaa=vbuc1_plus__deref_pbuc2
lda #{c1}
clc
adc {c2}
//FRAGMENT vbuxx=vbuc1_plus__deref_pbuc2
lda {c2}
tax
axs #-[{c1}]
//FRAGMENT vbuyy=vbuc1_plus__deref_pbuc2
lda #{c1}
clc
adc {c2}
tay
//FRAGMENT vbsxx=vbsxx_minus_vbsc1
txa
axs #{c1}
//FRAGMENT vbsyy=vbsyy_minus_vbsc1
tya
sec
sbc #{c1}
tay
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
//FRAGMENT vbsaa=_deref_pbsc1
lda {c1}
//FRAGMENT vbsxx=_deref_pbsc1
ldx {c1}
//FRAGMENT vbsyy=_deref_pbsc1
ldy {c1}
//FRAGMENT _deref_pbsc1=vbsxx
stx {c1}
//FRAGMENT _deref_pbsc1=vbsyy
sty {c1}
//FRAGMENT pbuz1=pbuz1_plus_1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT pbuz1_derefidx_vbuc1=vbuz2
lda {z2}
ldy #{c1}
sta ({z1}),y
//FRAGMENT vbuz1=pbuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuc1=vbuaa
ldy #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=vbuxx
ldy #{c1}
txa
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=vbuyy
tya
ldy #{c1}
sta ({z1}),y
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
//FRAGMENT vwuz1=vwuc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT qbuz1_derefidx_vbuc1=pbuz2
ldy #{c1}
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT qwuz1_derefidx_vbuc1=pwuz2
ldy #{c1}
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT vwuz1=_deref_pwuz2
ldy #0
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vwuz1=pwuz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_vbuaa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_vbuxx
txa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_vbuyy
tya
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vwsz1_neq_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwuz1=vwuz2_ror_4
lda {z2}+1
lsr
sta {z1}+1
lda {z2}
ror
sta {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT vwuz1=vwuz2_ror_8
lda {z2}+1
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1_ge_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {z1}
cmp #<{c1}
bcs {la1}
!:
//FRAGMENT vwuz1_ge_vbuc1_then_la1
lda {z1}+1
bne {la1}
lda {z1}
cmp #{c1}
bcs {la1}
!:
//FRAGMENT pbuc1_derefidx_vbuxx=_byte_vwuz1
lda {z1}
sta {c1},x
//FRAGMENT vwuz1=vwuz1_rol_8
lda {z1}
sta {z1}+1
lda #0
sta {z1}
//FRAGMENT vwuz1=vwuz1_ror_4
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT pwsc1_derefidx_vbuz1=vwsc2
ldy {z1}
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT _deref_pwsc1=_deref_pwsc2
lda {c2}
sta {c1}
lda {c2}+1
sta {c1}+1
//FRAGMENT pwsc1_derefidx_vbuaa=vwsc2
tay
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT pwsc1_derefidx_vbuxx=vwsc2
lda #<{c2}
sta {c1},x
lda #>{c2}
sta {c1}+1,x
//FRAGMENT pwsc1_derefidx_vbuyy=vwsc2
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT _deref_pbuc1=_byte_vwuz1
lda {z1}
sta {c1}
//FRAGMENT vbuz1_eq__deref_pbuc1_then_la1
lda {c1}
cmp {z1}
beq {la1}
//FRAGMENT _deref_pbuc1_eq_0_then_la1
lda {c1}
cmp #0
beq {la1}
//FRAGMENT vbuz1=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1_rol_4
lda {c1}
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor__deref_pbuc1
lda {c1}
ora {z2}
sta {z1}
//FRAGMENT vduz1=vduz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
lda {z2}+2
adc #0
sta {z1}+2
lda {z2}+3
adc #0
sta {z1}+3
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_(pbuc2_derefidx_vbuz3)
ldx {z3}
ldy {c2},x
lda {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1
ldx {z1}
dec {c1},x
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_(pbuc2_derefidx_vbuz2)
ldx {z2}
ldy {c2},x
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1_le_pbuc2_derefidx_vbuz1_then_la1
ldy {z1}
lda {c2},y
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1=_deref_pbuz2_bor_vbuc1
lda #{c1}
ldy #0
ora ({z2}),y
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuz1
ldy {z1}
lda ({z2}),y
sta {c1},y
//FRAGMENT vbuz1=vbuz2_bxor_pbuc1_derefidx_vbuz3
lda {z2}
ldy {z3}
eor {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuz3
lda {z2}
ldy {z3}
and {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuc1
lda #{c1}
ora {z2}
sta {z1}
//FRAGMENT vduz1=vduz2_rol_2
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
lda {z2}+2
rol
sta {z1}+2
lda {z2}+3
rol
sta {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vwuz1=vwuc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
//FRAGMENT vbuxx_eq__deref_pbuc1_then_la1
cpx {c1}
beq {la1}
//FRAGMENT vbuxx=vbuxx_bor_vbuc1
txa
ora #{c1}
tax
//FRAGMENT vbuyy=vbuyy_bor_vbuc1
tya
ora #{c1}
tay
//FRAGMENT vbuaa=_deref_pbuc1_rol_4
lda {c1}
asl
asl
asl
asl
//FRAGMENT vbuxx=_deref_pbuc1_rol_4
lda {c1}
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=_deref_pbuc1_rol_4
lda {c1}
asl
asl
asl
asl
tay
//FRAGMENT vbuaa=vbuz1_bor__deref_pbuc1
lda {c1}
ora {z1}
//FRAGMENT vbuxx=vbuz1_bor__deref_pbuc1
lda {c1}
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor__deref_pbuc1
lda {c1}
ora {z1}
tay
//FRAGMENT vbuz1=vbuaa_bor__deref_pbuc1
ora {c1}
sta {z1}
//FRAGMENT vbuaa=vbuaa_bor__deref_pbuc1
ora {c1}
//FRAGMENT vbuxx=vbuaa_bor__deref_pbuc1
ora {c1}
tax
//FRAGMENT vbuyy=vbuaa_bor__deref_pbuc1
ora {c1}
tay
//FRAGMENT vbuz1=vbuxx_bor__deref_pbuc1
txa
ora {c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor__deref_pbuc1
txa
ora {c1}
//FRAGMENT vbuxx=vbuxx_bor__deref_pbuc1
txa
ora {c1}
tax
//FRAGMENT vbuyy=vbuxx_bor__deref_pbuc1
txa
ora {c1}
tay
//FRAGMENT vbuz1=vbuyy_bor__deref_pbuc1
tya
ora {c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_bor__deref_pbuc1
tya
ora {c1}
//FRAGMENT vbuxx=vbuyy_bor__deref_pbuc1
tya
ora {c1}
tax
//FRAGMENT vbuyy=vbuyy_bor__deref_pbuc1
tya
ora {c1}
tay
//FRAGMENT vduz1=vduz2_plus_vbuxx
txa
clc
adc {z2}
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
lda {z2}+2
adc #0
sta {z1}+2
lda {z2}+3
adc #0
sta {z1}+3
//FRAGMENT vduz1=vduz2_plus_vbuyy
tya
clc
adc {z2}
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
lda {z2}+2
adc #0
sta {z1}+2
lda {z2}+3
adc #0
sta {z1}+3
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_(pbuc2_derefidx_vbuaa)
tax
ldy {c2},x
lda {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_(pbuc2_derefidx_vbuxx)
ldy {c2},x
lda {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_(pbuc2_derefidx_vbuyy)
ldx {c2},y
lda {c1},x
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_(pbuc2_derefidx_vbuz2)
ldy {z2}
ldx {c2},y
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_(pbuc2_derefidx_vbuaa)
tay
ldx {c2},y
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_(pbuc2_derefidx_vbuxx)
ldy {c2},x
ldx {c1},y
tay
txa
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_(pbuc2_derefidx_vbuyy)
ldx {c2},y
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbuz2)
ldy {z2}
txa
ldx {c2},y
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbuaa)
tay
txa
ldx {c2},y
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbuxx)
txa
tay
ldx {c2},y
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbuyy)
txa
ldx {c2},y
tay
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_(pbuc2_derefidx_vbuz2)
ldx {z2}
lda {c2},x
tax
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_(pbuc2_derefidx_vbuaa)
tax
lda {c2},x
tax
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_(pbuc2_derefidx_vbuxx)
lda {c2},x
tax
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_(pbuc2_derefidx_vbuyy)
ldx {c2},y
lda {c1},x
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuxx=_dec_pbuc1_derefidx_vbuxx
dec {c1},x
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_(pbuc2_derefidx_vbuxx)
ldy {c2},x
lda {c1},y
ldy #0
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuxx_le_pbuc2_derefidx_vbuxx_then_la1
txa
tay
lda {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuaa=_deref_pbuz1_bor_vbuc1
lda #{c1}
ldy #0
ora ({z1}),y
//FRAGMENT vbuxx=_deref_pbuz1_bor_vbuc1
lda #{c1}
ldy #0
ora ({z1}),y
tax
//FRAGMENT vbuyy=_deref_pbuz1_bor_vbuc1
lda #{c1}
ldy #0
ora ({z1}),y
tay
//FRAGMENT pbuc1_derefidx_vbuaa=pbuz1_derefidx_vbuaa
tay
lda ({z1}),y
sta {c1},y
//FRAGMENT vbuz1_neq_pbuc1_derefidx_vbuaa_then_la1
tay
lda {c1},y
cmp {z1}
bne {la1}
//FRAGMENT vbuaa_neq_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT vbuaa=vbuz1_bxor_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
eor {c1},y
//FRAGMENT vbuxx=vbuz1_bxor_pbuc1_derefidx_vbuz2
lda {z1}
ldx {z2}
eor {c1},x
tax
//FRAGMENT vbuyy=vbuz1_bxor_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
eor {c1},y
tay
//FRAGMENT vbuz1=vbuz2_bxor_pbuc1_derefidx_vbuxx
lda {c1},x
eor {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bxor_pbuc1_derefidx_vbuxx
lda {c1},x
eor {z1}
//FRAGMENT vbuxx=vbuz1_bxor_pbuc1_derefidx_vbuxx
lda {c1},x
eor {z1}
tax
//FRAGMENT vbuyy=vbuz1_bxor_pbuc1_derefidx_vbuxx
lda {c1},x
eor {z1}
tay
//FRAGMENT vbuz1=vbuz2_bxor_pbuc1_derefidx_vbuyy
lda {c1},y
eor {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bxor_pbuc1_derefidx_vbuyy
lda {c1},y
eor {z1}
//FRAGMENT vbuxx=vbuz1_bxor_pbuc1_derefidx_vbuyy
lda {c1},y
eor {z1}
tax
//FRAGMENT vbuyy=vbuz1_bxor_pbuc1_derefidx_vbuyy
lda {c1},y
eor {z1}
tay
//FRAGMENT vbuz1=vbuaa_bxor_pbuc1_derefidx_vbuz2
ldy {z2}
eor {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuaa_bxor_pbuc1_derefidx_vbuz1
ldy {z1}
eor {c1},y
//FRAGMENT vbuxx=vbuaa_bxor_pbuc1_derefidx_vbuz1
ldx {z1}
eor {c1},x
tax
//FRAGMENT vbuyy=vbuaa_bxor_pbuc1_derefidx_vbuz1
ldy {z1}
eor {c1},y
tay
//FRAGMENT vbuz1=vbuaa_bxor_pbuc1_derefidx_vbuxx
eor {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuaa_bxor_pbuc1_derefidx_vbuxx
eor {c1},x
//FRAGMENT vbuxx=vbuaa_bxor_pbuc1_derefidx_vbuxx
eor {c1},x
tax
//FRAGMENT vbuyy=vbuaa_bxor_pbuc1_derefidx_vbuxx
eor {c1},x
tay
//FRAGMENT vbuz1=vbuaa_bxor_pbuc1_derefidx_vbuyy
eor {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuaa_bxor_pbuc1_derefidx_vbuyy
eor {c1},y
//FRAGMENT vbuxx=vbuaa_bxor_pbuc1_derefidx_vbuyy
eor {c1},y
tax
//FRAGMENT vbuyy=vbuaa_bxor_pbuc1_derefidx_vbuyy
eor {c1},y
tay
//FRAGMENT vbuz1=vbuxx_bxor_pbuc1_derefidx_vbuz2
ldy {z2}
txa
eor {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuxx_bxor_pbuc1_derefidx_vbuz1
ldy {z1}
txa
eor {c1},y
//FRAGMENT vbuxx=vbuxx_bxor_pbuc1_derefidx_vbuz1
txa
ldx {z1}
eor {c1},x
tax
//FRAGMENT vbuyy=vbuxx_bxor_pbuc1_derefidx_vbuz1
ldy {z1}
txa
eor {c1},y
tay
//FRAGMENT vbuz1=vbuxx_bxor_pbuc1_derefidx_vbuxx
txa
eor {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuxx_bxor_pbuc1_derefidx_vbuxx
txa
eor {c1},x
//FRAGMENT vbuxx=vbuxx_bxor_pbuc1_derefidx_vbuxx
txa
eor {c1},x
tax
//FRAGMENT vbuyy=vbuxx_bxor_pbuc1_derefidx_vbuxx
txa
eor {c1},x
tay
//FRAGMENT vbuz1=vbuxx_bxor_pbuc1_derefidx_vbuyy
txa
eor {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuxx_bxor_pbuc1_derefidx_vbuyy
txa
eor {c1},y
//FRAGMENT vbuxx=vbuxx_bxor_pbuc1_derefidx_vbuyy
txa
eor {c1},y
tax
//FRAGMENT vbuyy=vbuxx_bxor_pbuc1_derefidx_vbuyy
txa
eor {c1},y
tay
//FRAGMENT vbuz1=vbuyy_bxor_pbuc1_derefidx_vbuz2
tya
ldy {z2}
eor {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuyy_bxor_pbuc1_derefidx_vbuz1
tya
ldy {z1}
eor {c1},y
//FRAGMENT vbuxx=vbuyy_bxor_pbuc1_derefidx_vbuz1
ldx {z1}
tya
eor {c1},x
tax
//FRAGMENT vbuyy=vbuyy_bxor_pbuc1_derefidx_vbuz1
tya
ldy {z1}
eor {c1},y
tay
//FRAGMENT vbuz1=vbuyy_bxor_pbuc1_derefidx_vbuxx
tya
eor {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuyy_bxor_pbuc1_derefidx_vbuxx
tya
eor {c1},x
//FRAGMENT vbuxx=vbuyy_bxor_pbuc1_derefidx_vbuxx
tya
eor {c1},x
tax
//FRAGMENT vbuyy=vbuyy_bxor_pbuc1_derefidx_vbuxx
tya
eor {c1},x
tay
//FRAGMENT vbuz1=vbuyy_bxor_pbuc1_derefidx_vbuyy
tya
eor {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuyy_bxor_pbuc1_derefidx_vbuyy
tya
eor {c1},y
//FRAGMENT vbuxx=vbuyy_bxor_pbuc1_derefidx_vbuyy
tya
eor {c1},y
tax
//FRAGMENT vbuyy=vbuyy_bxor_pbuc1_derefidx_vbuyy
tya
eor {c1},y
tay
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
and {c1},y
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuz2
lda {z1}
ldx {z2}
and {c1},x
tax
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
and {c1},y
tay
//FRAGMENT vbuz1=vbuaa_band_pbuc1_derefidx_vbuz2
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuaa_band_pbuc1_derefidx_vbuz1
ldy {z1}
and {c1},y
//FRAGMENT vbuxx=vbuaa_band_pbuc1_derefidx_vbuz1
ldx {z1}
and {c1},x
tax
//FRAGMENT vbuyy=vbuaa_band_pbuc1_derefidx_vbuz1
ldy {z1}
and {c1},y
tay
//FRAGMENT vbuz1=vbuxx_band_pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sax {z1}
//FRAGMENT vbuaa=vbuxx_band_pbuc1_derefidx_vbuz1
ldy {z1}
txa
and {c1},y
//FRAGMENT vbuxx=vbuxx_band_pbuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
axs #0
//FRAGMENT vbuyy=vbuxx_band_pbuc1_derefidx_vbuz1
ldy {z1}
txa
and {c1},y
tay
//FRAGMENT vbuz1=vbuyy_band_pbuc1_derefidx_vbuz2
tya
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuyy_band_pbuc1_derefidx_vbuz1
tya
ldy {z1}
and {c1},y
//FRAGMENT vbuxx=vbuyy_band_pbuc1_derefidx_vbuz1
ldx {z1}
tya
and {c1},x
tax
//FRAGMENT vbuyy=vbuyy_band_pbuc1_derefidx_vbuz1
tya
ldy {z1}
and {c1},y
tay
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z1}
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z1}
tax
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuxx
lda {c1},x
and {z1}
tay
//FRAGMENT vbuz1=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
//FRAGMENT vbuxx=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
tax
//FRAGMENT vbuyy=vbuaa_band_pbuc1_derefidx_vbuxx
and {c1},x
tay
//FRAGMENT vbuz1=vbuxx_band_pbuc1_derefidx_vbuxx
lda {c1},x
sax {z1}
//FRAGMENT vbuaa=vbuxx_band_pbuc1_derefidx_vbuxx
txa
and {c1},x
//FRAGMENT vbuxx=vbuxx_band_pbuc1_derefidx_vbuxx
lda {c1},x
axs #0
//FRAGMENT vbuyy=vbuxx_band_pbuc1_derefidx_vbuxx
txa
and {c1},x
tay
//FRAGMENT vbuz1=vbuyy_band_pbuc1_derefidx_vbuxx
tya
and {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuyy_band_pbuc1_derefidx_vbuxx
tya
and {c1},x
//FRAGMENT vbuxx=vbuyy_band_pbuc1_derefidx_vbuxx
tya
and {c1},x
tax
//FRAGMENT vbuyy=vbuyy_band_pbuc1_derefidx_vbuxx
tya
and {c1},x
tay
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z1}
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z1}
tax
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuyy
lda {c1},y
and {z1}
tay
//FRAGMENT vbuz1=vbuaa_band_pbuc1_derefidx_vbuyy
and {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuaa_band_pbuc1_derefidx_vbuyy
and {c1},y
//FRAGMENT vbuxx=vbuaa_band_pbuc1_derefidx_vbuyy
ldx {c1},y
axs #0
//FRAGMENT vbuz1=vbuxx_band_pbuc1_derefidx_vbuyy
lda {c1},y
sax {z1}
//FRAGMENT vbuz1=vbuyy_band_pbuc1_derefidx_vbuyy
tya
and {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuxx_band_pbuc1_derefidx_vbuyy
txa
and {c1},y
//FRAGMENT vbuaa=vbuyy_band_pbuc1_derefidx_vbuyy
tya
and {c1},y
//FRAGMENT vbuxx=vbuxx_band_pbuc1_derefidx_vbuyy
lda {c1},y
axs #0
//FRAGMENT vbuxx=vbuyy_band_pbuc1_derefidx_vbuyy
ldx {c1},y
tya
axs #0
//FRAGMENT vbuyy=vbuxx_band_pbuc1_derefidx_vbuyy
txa
and {c1},y
tay
//FRAGMENT vbuyy=vbuyy_band_pbuc1_derefidx_vbuyy
tya
and {c1},y
tay
//FRAGMENT vbuaa=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuc1
txa
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuc1
txa
ora #{c1}
//FRAGMENT vbuyy=vbuxx_bor_vbuc1
txa
ora #{c1}
tay
//FRAGMENT vbuz1=vbuyy_bor_vbuc1
tya
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuyy_bor_vbuc1
tya
ora #{c1}
//FRAGMENT vbuxx=vbuyy_bor_vbuc1
tya
ora #{c1}
tax
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
//FRAGMENT vbuz1=vbuz2_band_pbuc1_derefidx_vbuaa
tay
lda {c1},y
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_band_pbuc1_derefidx_vbuaa
tay
lda {c1},y
sax {z1}
//FRAGMENT vbuz1=vbuyy_band_pbuc1_derefidx_vbuaa
tax
tya
and {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuz1_band_pbuc1_derefidx_vbuaa
tay
lda {c1},y
and {z1}
//FRAGMENT vbuaa=vbuxx_band_pbuc1_derefidx_vbuaa
tay
txa
and {c1},y
//FRAGMENT vbuaa=vbuyy_band_pbuc1_derefidx_vbuaa
tax
tya
and {c1},x
//FRAGMENT vbuxx=vbuz1_band_pbuc1_derefidx_vbuaa
tax
lda {c1},x
and {z1}
tax
//FRAGMENT vbuxx=vbuxx_band_pbuc1_derefidx_vbuaa
tay
lda {c1},y
axs #0
//FRAGMENT vbuxx=vbuyy_band_pbuc1_derefidx_vbuaa
tax
tya
and {c1},x
tax
//FRAGMENT vbuyy=vbuz1_band_pbuc1_derefidx_vbuaa
tay
lda {c1},y
and {z1}
tay
//FRAGMENT vbuyy=vbuxx_band_pbuc1_derefidx_vbuaa
tay
txa
and {c1},y
tay
//FRAGMENT vbuyy=vbuyy_band_pbuc1_derefidx_vbuaa
tax
tya
and {c1},x
tay
//FRAGMENT vduz1=vduz1_plus_vbuxx
txa
clc
adc {z1}
sta {z1}
lda {z1}+1
adc #0
sta {z1}+1
lda {z1}+2
adc #0
sta {z1}+2
lda {z1}+3
adc #0
sta {z1}+3
//FRAGMENT vwuz1=vwuz1_band_vwuc1
lda {z1}
and #<{c1}
sta {z1}
lda {z1}+1
and #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=pbuz2_bxor_vwuc1
lda #<{c1}
eor {z2}
sta {z1}
lda #>{c1}
eor {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz1_derefidx_vbuz2_bor_pbuc1_derefidx_vbuz3
ldy {z2}
lda ({z1}),y
ldy {z3}
ora {c1},y
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuz1=vbuz1_bxor_pbuz2_derefidx_vbuz3
lda {z1}
ldy {z3}
eor ({z2}),y
sta {z1}
//FRAGMENT vbuz1=_neg_vbuz1
lda {z1}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz1_derefidx_vbuz2_bor_pbuc1_derefidx_vbuaa
ldy {z2}
tax
lda ({z1}),y
ora {c1},x
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz1_derefidx_vbuz2_bor_pbuc1_derefidx_vbuxx
ldy {z2}
lda ({z1}),y
ora {c1},x
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz1_derefidx_vbuz2_bor_pbuc1_derefidx_vbuyy
tya
ldy {z2}
tax
lda ({z1}),y
ora {c1},x
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz1_derefidx_vbuxx_bor_pbuc1_derefidx_vbuz2
txa
tay
lda ({z1}),y
ldy {z2}
stx $ff
ora {c1},y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz1_derefidx_vbuxx_bor_pbuc1_derefidx_vbuaa
tay
txa
ldx {c1},y
tay
lda ({z1}),y
sty $ff

stx $ff
ora $ff
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz1_derefidx_vbuxx_bor_pbuc1_derefidx_vbuxx
txa
tay
lda ({z1}),y
stx $ff
ora {c1},x
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz1_derefidx_vbuxx_bor_pbuc1_derefidx_vbuyy
txa
ldx {c1},y
tay
lda ({z1}),y
sty $ff

stx $ff
ora $ff
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz1_derefidx_vbuyy_bor_pbuc1_derefidx_vbuz2
lda ({z1}),y
sty $ff

ldy {z2}
ora {c1},y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz1_derefidx_vbuyy_bor_pbuc1_derefidx_vbuaa
tax
lda ({z1}),y
sty $ff

ora {c1},x
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz1_derefidx_vbuyy_bor_pbuc1_derefidx_vbuxx
lda ({z1}),y
sty $ff

ora {c1},x
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz1_derefidx_vbuyy_bor_pbuc1_derefidx_vbuyy
lda ({z1}),y
sty $ff

ora {c1},y
ldy $ff
sta ({z1}),y
//FRAGMENT vbuz1=vbuz1_bxor_pbuz2_derefidx_vbuaa
tay
lda {z1}
eor ({z2}),y
sta {z1}
//FRAGMENT vbuz1=vbuz1_bxor_pbuz2_derefidx_vbuxx
txa
tay
lda {z1}
eor ({z2}),y
sta {z1}
//FRAGMENT vbuz1=vbuz1_bxor_pbuz2_derefidx_vbuyy
lda {z1}
eor ({z2}),y
sta {z1}
//FRAGMENT vbuaa=vbuaa_bxor_pbuz1_derefidx_vbuz2
ldy {z2}
eor ({z1}),y
//FRAGMENT vbuaa=vbuaa_bxor_pbuz1_derefidx_vbuaa
tay
eor ({z1}),y
//FRAGMENT vbuaa=vbuaa_bxor_pbuz1_derefidx_vbuxx
stx $ff
ldy $ff
eor ({z1}),y
//FRAGMENT vbuaa=vbuaa_bxor_pbuz1_derefidx_vbuyy
eor ({z1}),y
//FRAGMENT vbuxx=vbuxx_bxor_pbuz1_derefidx_vbuz2
ldy {z2}
txa
eor ({z1}),y
tax
//FRAGMENT vbuxx=vbuxx_bxor_pbuz1_derefidx_vbuaa
tay
txa
eor ({z1}),y
tax
//FRAGMENT vbuxx=vbuxx_bxor_pbuz1_derefidx_vbuxx
txa
tay
eor ({z1}),y
tax
//FRAGMENT vbuxx=vbuxx_bxor_pbuz1_derefidx_vbuyy
txa
eor ({z1}),y
tax
//FRAGMENT vbuyy=_neg_vbuyy
dey
tya
eor #$ff
tay
//FRAGMENT vwuz1=pbuz1_bxor_vwuc1
lda #<{c1}
eor {z1}
sta {z1}
lda #>{c1}
eor {z1}+1
sta {z1}+1
//FRAGMENT vbsz1=vbsz2_plus_vbsc1
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbsz1=vbsc1_plus_vbsz2
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbsz1=vbsz2_plus_vbsz2
lda {z2}
asl
sta {z1}
//FRAGMENT vbsaa=vbsz1_plus_vbsc1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbsxx=vbsz1_plus_vbsc1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbsyy=vbsz1_plus_vbsc1
lda #{c1}
clc
adc {z1}
tay
//FRAGMENT vbsaa=vbsc1_plus_vbsz1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbsxx=vbsc1_plus_vbsz1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbsyy=vbsc1_plus_vbsz1
lda #{c1}
clc
adc {z1}
tay
//FRAGMENT vbsaa=vbsz1_plus_vbsz1
lda {z1}
asl
//FRAGMENT vbsxx=vbsz1_plus_vbsz1
lda {z1}
asl
tax
//FRAGMENT vbsyy=vbsz1_plus_vbsz1
lda {z1}
asl
tay
//FRAGMENT vbsz1=vbsz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vbsz1=vbsz2_minus_vbsc1
lax {z2}
axs #{c1}
stx {z1}
//FRAGMENT vbsaa=vbsz1_rol_1
lda {z1}
asl
//FRAGMENT vbsxx=vbsz1_rol_1
lda {z1}
asl
tax
//FRAGMENT vbsyy=vbsz1_rol_1
lda {z1}
asl
tay
//FRAGMENT vbsz1=vbsxx_rol_1
txa
asl
sta {z1}
//FRAGMENT vbsaa=vbsxx_rol_1
txa
asl
//FRAGMENT vbsxx=vbsxx_rol_1
txa
asl
tax
//FRAGMENT vbsyy=vbsxx_rol_1
txa
asl
tay
//FRAGMENT vbsz1=vbsyy_rol_1
tya
asl
sta {z1}
//FRAGMENT vbsaa=vbsyy_rol_1
tya
asl
//FRAGMENT vbsxx=vbsyy_rol_1
tya
asl
tax
//FRAGMENT vbsyy=vbsyy_rol_1
tya
asl
tay
//FRAGMENT vbsz1=vbsaa_minus_vbsc1
sec
sbc #{c1}
sta {z1}
//FRAGMENT vbsz1=vbsxx_minus_vbsc1
txa
axs #{c1}
stx {z1}
//FRAGMENT vbsz1=vbsyy_minus_vbsc1
tya
sec
sbc #{c1}
sta {z1}
//FRAGMENT vbsaa=vbsz1_minus_vbsc1
lda {z1}
sec
sbc #{c1}
//FRAGMENT vbsaa=vbsaa_minus_vbsc1
sec
sbc #{c1}
//FRAGMENT vbsaa=vbsxx_minus_vbsc1
txa
sec
sbc #{c1}
//FRAGMENT vbsaa=vbsyy_minus_vbsc1
tya
sec
sbc #{c1}
//FRAGMENT vbsxx=vbsz1_minus_vbsc1
lax {z1}
axs #{c1}
//FRAGMENT vbsxx=vbsaa_minus_vbsc1
tax
axs #{c1}
//FRAGMENT vbsxx=vbsyy_minus_vbsc1
tya
tax
axs #{c1}
//FRAGMENT vbsyy=vbsz1_minus_vbsc1
lda {z1}
sec
sbc #{c1}
tay
//FRAGMENT vbsyy=vbsaa_minus_vbsc1
sec
sbc #{c1}
tay
//FRAGMENT vbsyy=vbsxx_minus_vbsc1
txa
sec
sbc #{c1}
tay
//FRAGMENT vbuc1_gt_vbuz1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbuc1_gt_vbuxx_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vwuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
lda #0
rol
sta {z1}+1
//FRAGMENT vwuz1=vbuxx_rol_1
txa
asl
sta {z1}
lda #0
rol
sta {z1}+1
//FRAGMENT vwuz1=vbuyy_rol_1
tya
asl
sta {z1}
lda #0
rol
sta {z1}+1
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy
lda {c1},y
tay
//FRAGMENT vbsaa=vbsc1_minus_vbsz1
lda #{c1}
sec
sbc {z1}
//FRAGMENT vbsaa=vbsc1_minus_vbsaa
eor #$ff
sec
adc #{c1}
//FRAGMENT vbsaa=vbsc1_minus_vbsxx
txa
eor #$ff
sec
adc #{c1}
//FRAGMENT vbsaa=vbsc1_minus_vbsyy
tya
eor #$ff
sec
adc #{c1}
//FRAGMENT vbsyy=vbsc1_minus_vbsz1
lda #{c1}
sec
sbc {z1}
tay
//FRAGMENT vbsyy=vbsc1_minus_vbsaa
eor #$ff
sec
adc #{c1}
tay
//FRAGMENT vbsyy=vbsc1_minus_vbsxx
txa
eor #$ff
sec
adc #{c1}
tay
//FRAGMENT vbsyy=vbsc1_minus_vbsyy
tya
eor #$ff
sec
adc #{c1}
tay
//FRAGMENT vbsc1_neq_vbsaa_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbsyy=vbsz1_minus_vbsaa
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbsyy=vbsxx_minus_vbsaa
sta $ff
txa
sec
sbc $ff
tay
//FRAGMENT vbsyy=vbsyy_minus_vbsaa
sta $ff
tya
sec
sbc $ff
tay
//FRAGMENT vbsyy_lt_0_then_la1
cpy #0
bmi {la1}
//FRAGMENT vbsz1_neq_0_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vwsz1=vbsz2
lda {z2}
sta {z1}
and #$80
beq !+
lda #$ff
!:
sta {z1}+1
//FRAGMENT vbsaa_neq_0_then_la1
cmp #0
bne {la1}
//FRAGMENT vwsz1=vbsaa
sta {z1}
and #$80
beq !+
lda #$ff
!:
sta {z1}+1
//FRAGMENT vwsz1=vbsxx
txa
sta {z1}
and #$80
beq !+
lda #$ff
!:
sta {z1}+1
//FRAGMENT vwsz1=vbsyy
tya
sta {z1}
and #$80
beq !+
lda #$ff
!:
sta {z1}+1
//FRAGMENT vbsxx_neq_0_then_la1
txa
cmp #0
bne {la1}
//FRAGMENT pwsz1=pwsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=_hi_vdsz2
lda {z2}+2
sta {z1}
lda {z2}+3
sta {z1}+1
//FRAGMENT pwsz1=pwsz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pwsz1=pwsc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vduz1_lt_vduc1_then_la1
lda {z1}+3
cmp #>{c1}>>$10
bcc {la1}
bne !+
lda {z1}+2
cmp #<{c1}>>$10
bcc {la1}
bne !+
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vduz1=vduc1_minus_vduz1
lda #<{c1}
sec
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
lda #<{c1}>>$10
sbc {z1}+2
sta {z1}+2
lda #>{c1}>>$10
sbc {z1}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_rol_3
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
lda {z2}+2
rol
sta {z1}+2
lda {z2}+3
rol
sta {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vwuz1=vwuz2_minus_vwuc1
lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_byte_vwsz2
lda {z2}
sta {z1}
//FRAGMENT vbsz1=_sbyte_vwsz2
lda {z2}
sta {z1}
//FRAGMENT vduz1=vduz2_rol_vbuz3
ldy {z3}
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e:
//FRAGMENT vbuaa=_byte_vwsz1
lda {z1}
//FRAGMENT vbuxx=_byte_vwsz1
lda {z1}
tax
//FRAGMENT vbuyy=_byte_vwsz1
lda {z1}
tay
//FRAGMENT vbsaa=_sbyte_vwsz1
lda {z1}
//FRAGMENT vbsxx=_sbyte_vwsz1
lda {z1}
tax
//FRAGMENT vbsyy=_sbyte_vwsz1
lda {z1}
tay
//FRAGMENT vduz1=vduz2_rol_vbuxx
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_rol_vbuyy
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e:
//FRAGMENT vduz1=vduz1_rol_3
ldy #3
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
//FRAGMENT pwsz1=pwsc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vduz1=vduz1_rol_vbuxx
cpx #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dex
bne !-
!e:
//FRAGMENT pssz1=pssc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_minus_1
lda {z1}
sec
sbc #1
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_minus_1
dec {z1}
//FRAGMENT pbsz1_derefidx_vbuc1=pbsz1_derefidx_vbuc1_plus_pbsz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
ldy #{c1}
tax
lda ({z1}),y
sty $ff

stx $ff
clc
adc $ff
ldy $ff
sta ({z1}),y
//FRAGMENT pbsz1_derefidx_vbuc1_lt_vbsc2_then_la1
ldy #{c1}
lda ({z1}),y

sec
sbc #{c2}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT pbsz1_derefidx_vbuc1=vbsc2
lda #{c1}
tay
lda #{c2}
sta ({z1}),y
//FRAGMENT pwsz1_derefidx_vbuc1_gt_vwsc2_then_la1
ldy #{c1}
lda #<{c2}
cmp ({z1}),y
iny
lda #>{c2}
sbc ({z1}),y
bvc !+
eor #$80
!:
bmi {la1}
!e:
//FRAGMENT pwsz1_derefidx_vbuc1_ge_vwsc2_then_la1
ldy #{c1}
lda ({z1}),y
cmp #<{c2}
iny
lda ({z1}),y
sbc #>{c2}
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT pwsz1_derefidx_vbuc1=pwsz1_derefidx_vbuc1_plus_pbsz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
ldy #{c1}
clc
lda ({z1}),y
adc $fe
sta ({z1}),y
iny
lda ({z1}),y
adc $fe
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1_ge_vbuc2_then_la1
ldy {z1}
lda {c1},y
cmp #{c2}
bcs {la1}
//FRAGMENT vwsz1=pwsz2_derefidx_vbuc1_ror_vbuc2
ldx #{c2}
ldy #{c1}
lda ({z2}),y
sta {z1}
iny
lda ({z2}),y
sta {z1}+1
cpx #0
beq !e+
!:
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT pbuc1_derefidx_vbuz1=_byte_vwsz2
ldy {z1}
lda {z2}
sta {c1},y
//FRAGMENT pssz1=pssz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pwsz1_derefidx_vbuc1=vwsc2
ldy #{c1}
lda #<{c2}
sta ({z1}),y
iny
lda #>{c2}
sta ({z1}),y
//FRAGMENT pbsz1_derefidx_vbuc1=vbsz2
lda #{c1}
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1_lt_vbuc2_then_la1
ldy {z1}
lda {c1},y
cmp #{c2}
bcc {la1}
//FRAGMENT vbuc1_eq_pbuc2_derefidx_vbuz1_then_la1
ldy {z1}
lda {c2},y
cmp #{c1}
beq {la1}
//FRAGMENT pbsz1_derefidx_vbuc1=vbsxx
lda #{c1}
tay
txa
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuaa_lt_vbuc2_then_la1
tay
lda {c1},y
cmp #{c2}
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_lt_vbuc2_then_la1
lda {c1},x
cmp #{c2}
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_lt_vbuc2_then_la1
lda {c1},y
cmp #{c2}
bcc {la1}
//FRAGMENT vbuc1_eq_pbuc2_derefidx_vbuaa_then_la1
tay
lda {c2},y
cmp #{c1}
beq {la1}
//FRAGMENT vbuc1_eq_pbuc2_derefidx_vbuxx_then_la1
lda {c2},x
cmp #{c1}
beq {la1}
//FRAGMENT vbuc1_eq_pbuc2_derefidx_vbuyy_then_la1
lda {c2},y
cmp #{c1}
beq {la1}
//FRAGMENT vbuxx=vbuxx_minus_1
dex
//FRAGMENT vbuyy=vbuyy_minus_1
tya
tay
dey
//FRAGMENT vwsz1_neq_vwsc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT _deref_pbuc1_lt_vbuz1_then_la1
lda {c1}
cmp {z1}
bcc {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuz2)_then_la1
lda {z1}
ldx {z2}
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuz2)_then_la1
lda {z1}
ldx {z2}
ldy {c2},x
cmp {c1},y
bcc {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_(pbuc2_derefidx_vbuz2)
ldx {z2}
ldy {c2},x
ldx {c1},y
stx {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz2)
ldx {z2}
ldy {c3},x
lda {c2},y
ldx {z1}
sta {c1},x
//FRAGMENT vbuz1=_lo_pwuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vbuz1=_hi_pwuc1_derefidx_vbuz2
ldy {z2}
lda {c1}+1,y
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=vbuxx
ldy {z1}
txa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuz1=vbuyy
tya
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=vbuz1
tay
lda {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=vbuxx
tay
txa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=vbuyy
tax
tya
sta {c1},x
lda #0
sta {c1}+1,x
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
txa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuyy=vbuyy
tya
sta {c1},y
lda #0
sta {c1}+1,y
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
//FRAGMENT _deref_pbuc1_lt_vbuaa_then_la1
ldy {c1}
sta $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuaa)_then_la1
tax
lda {z1}
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuxx)_then_la1
lda {z1}
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuyy)_then_la1
lda {z1}
ldx {c2},y
cmp {c1},x
bcs {la1}
//FRAGMENT vbuaa_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuz1)_then_la1
ldx {z1}
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuz1_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuxx)_then_la1
lda {z1}
ldy {c2},x
cmp {c1},y
bcc {la1}
//FRAGMENT vbuz1_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuyy)_then_la1
lda {z1}
ldx {c2},y
cmp {c1},x
bcc {la1}
//FRAGMENT vbuxx_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuz1)_then_la1
ldy {z1}
txa
ldx {c2},y
cmp {c1},x
bcc {la1}
//FRAGMENT vbuxx_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuxx)_then_la1
txa
ldy {c2},x
cmp {c1},y
bcc {la1}
//FRAGMENT vbuxx_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuyy)_then_la1
txa
ldx {c2},y
cmp {c1},x
bcc {la1}
//FRAGMENT vbuyy_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuz1)_then_la1
ldx {z1}
tya
ldy {c2},x
cmp {c1},y
bcc {la1}
//FRAGMENT vbuyy_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuxx)_then_la1
tya
ldy {c2},x
cmp {c1},y
bcc {la1}
//FRAGMENT vbuyy_lt_pbuc1_derefidx_(pbuc2_derefidx_vbuyy)_then_la1
tya
ldx {c2},y
cmp {c1},x
bcc {la1}
//FRAGMENT vbuaa=pbuc1_derefidx_(pbuc2_derefidx_vbuz1)
ldx {z1}
ldy {c2},x
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbuz1)
ldx {z1}
ldy {c2},x
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_(pbuc2_derefidx_vbuz1)
ldy {z1}
ldx {c2},y
ldy {c1},x
//FRAGMENT vbuaa=_lo_pwuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbuxx=_lo_pwuc1_derefidx_vbuz1
ldx {z1}
lda {c1},x
tax
//FRAGMENT vbuyy=_lo_pwuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
tay
//FRAGMENT vbuz1=_lo_pwuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=_lo_pwuc1_derefidx_vbuaa
tay
lda {c1},y
//FRAGMENT vbuxx=_lo_pwuc1_derefidx_vbuaa
tax
lda {c1},x
tax
//FRAGMENT vbuyy=_lo_pwuc1_derefidx_vbuaa
tay
lda {c1},y
tay
//FRAGMENT vbuz1=_lo_pwuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuaa=_lo_pwuc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbuxx=_lo_pwuc1_derefidx_vbuxx
lda {c1},x
tax
//FRAGMENT vbuyy=_lo_pwuc1_derefidx_vbuxx
lda {c1},x
tay
//FRAGMENT vbuz1=_lo_pwuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=_lo_pwuc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vbuxx=_lo_pwuc1_derefidx_vbuyy
lda {c1},y
tax
//FRAGMENT vbuyy=_lo_pwuc1_derefidx_vbuyy
lda {c1},y
tay
//FRAGMENT vbuz1=_hi_pwuc1_derefidx_vbuxx
lda {c1}+1,x
sta {z1}
//FRAGMENT vbuaa=_hi_pwuc1_derefidx_vbuz1
ldy {z1}
lda {c1}+1,y
//FRAGMENT vbuaa=_hi_pwuc1_derefidx_vbuxx
lda {c1}+1,x
//FRAGMENT vbuxx=_hi_pwuc1_derefidx_vbuz1
ldx {z1}
lda {c1}+1,x
tax
//FRAGMENT vbuxx=_hi_pwuc1_derefidx_vbuxx
lda {c1}+1,x
tax
//FRAGMENT vbuyy=_hi_pwuc1_derefidx_vbuz1
ldy {z1}
lda {c1}+1,y
tay
//FRAGMENT vbuyy=_hi_pwuc1_derefidx_vbuxx
lda {c1}+1,x
tay
//FRAGMENT vbuxx_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuz1)_then_la1
ldy {z1}
txa
ldx {c2},y
cmp {c1},x
bcs {la1}
//FRAGMENT vbuxx_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuxx)_then_la1
txa
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuxx_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuyy)_then_la1
txa
ldx {c2},y
cmp {c1},x
bcs {la1}
//FRAGMENT vbuyy_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuz1)_then_la1
ldx {z1}
tya
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuyy_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuxx)_then_la1
tya
ldy {c2},x
cmp {c1},y
bcs {la1}
//FRAGMENT vbuyy_ge_pbuc1_derefidx_(pbuc2_derefidx_vbuyy)_then_la1
tya
ldx {c2},y
cmp {c1},x
bcs {la1}
//FRAGMENT _deref_pbuc1_lt_vbuxx_then_la1
lda {c1}
stx $ff
cmp $ff
bcc {la1}
//FRAGMENT _deref_pbuc1_lt_vbuyy_then_la1
ldx {c1}
sty $ff
cpx $ff
bcc {la1}
//FRAGMENT vbsxx=pbsc1_derefidx_vbuyy
ldx {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuc2
ldx {z1}
ldy #{c2}
lda ({z2}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuz1_derefidx_vbuc2
tya
ldy #{c2}
tax
lda ({z1}),y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuaa=pbuz1_derefidx_vbuc2
ldy #{c2}
tax
lda ({z1}),y
sta {c1},x
//FRAGMENT _deref_qssc1=pssc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT pssc1_neq_pssz1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vbuz1=vbuc1_plus__deref_pbuz2
lda #{c1}
clc
ldy #0
adc ({z2}),y
sta {z1}
//FRAGMENT vbuz1=_lo_qssz2_derefidx_vbuc1
ldy #{c1}
lda ({z2}),y
sta {z1}
//FRAGMENT vbuz1=_hi_qssz2_derefidx_vbuc1
ldy #{c1}+1
lda ({z2}),y
sta {z1}
//FRAGMENT pssz1=qssz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT vbuaa=vbuc1_plus__deref_pbuz1
lda #{c1}
clc
ldy #0
adc ({z1}),y
//FRAGMENT vbuxx=vbuc1_plus__deref_pbuz1
ldy #0
lda ({z1}),y
tax
axs #-[{c1}]
//FRAGMENT vbuyy=vbuc1_plus__deref_pbuz1
lda #{c1}
clc
ldy #0
adc ({z1}),y
tay
//FRAGMENT vbuaa=_lo_qssz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
//FRAGMENT vbuxx=_lo_qssz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
tax
//FRAGMENT vbuyy=_lo_qssz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
tay
//FRAGMENT vbuaa=_hi_qssz1_derefidx_vbuc1
ldy #{c1}+1
lda ({z1}),y
//FRAGMENT vbuxx=_hi_qssz1_derefidx_vbuc1
ldy #{c1}+1
lda ({z1}),y
tax
//FRAGMENT vbuyy=_hi_qssz1_derefidx_vbuc1
ldy #{c1}+1
lda ({z1}),y
tay
//FRAGMENT pssc1_derefidx_vbuz1=pssc2_derefidx_vbuz1_memcpy_vbuc3
ldx #{c3}
ldy {z1}
!:
lda {c2},y
sta {c1},y
iny
dex
bne !-
//FRAGMENT pssc1_derefidx_vbuaa=pssc2_derefidx_vbuaa_memcpy_vbuc3
ldx #{c3}
tay
!:
lda {c2},y
sta {c1},y
iny
dex
bne !-
//FRAGMENT pssc1_derefidx_vbuxx=pssc2_derefidx_vbuxx_memcpy_vbuc3
ldy #{c3}
!:
lda {c2},x
sta {c1},x
inx
dey
bne !-
//FRAGMENT pssc1_derefidx_vbuyy=pssc2_derefidx_vbuyy_memcpy_vbuc3
ldx #{c3}
!:
lda {c2},y
sta {c1},y
iny
dex
bne !-
//FRAGMENT vbum1_lt_vbuc1_then_la1
lda {m1}
cmp #{c1}
bcc {la1}
//FRAGMENT pbuc1_derefidx_vbum1=vbum1
ldy {m1}
tya
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuaa=vwuc2
tay
lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
//FRAGMENT _deref_pbuc1_ge_vbuc2_then_la1
lda {c1}
cmp #{c2}
bcs {la1}
//FRAGMENT vboz1=vboxx
txa
sta {z1}
//FRAGMENT vboaa=vboxx
txa
//FRAGMENT vboxx=vboaa
tax
//FRAGMENT vboxx=vboyy
tya
tax
//FRAGMENT vboyy=vboxx
txa
tay
//FRAGMENT vbsz1=vbsz1_minus_vbsxx
txa
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vwsz1=vwsz1_minus_vwsc1
lda {z1}
sec
sbc #<{c1}
sta {z1}
lda {z1}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vbsz1=pbsc1_derefidx_vbuz2_minus_pbsc2_derefidx_vbuz2
ldy {z2}
lda {c1},y
sec
sbc {c2},y
sta {z1}
//FRAGMENT pbsz1=pbsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbsz1=vbsz2
lda {z2}
ldy #0
sta ({z1}),y
//FRAGMENT pbsz1=_inc_pbsz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbsaa=pbsc1_derefidx_vbuz1_minus_pbsc2_derefidx_vbuz1
ldy {z1}
lda {c1},y
sec
sbc {c2},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbuz1_minus_pbsc2_derefidx_vbuz1
ldx {z1}
lda {c1},x
sec
sbc {c2},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbuz1_minus_pbsc2_derefidx_vbuz1
ldy {z1}
lda {c1},y
sec
sbc {c2},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbuaa_minus_pbsc2_derefidx_vbuaa
tay
lda {c1},y
sec
sbc {c2},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbuaa_minus_pbsc2_derefidx_vbuaa
tay
lda {c1},y
sec
sbc {c2},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbuaa_minus_pbsc2_derefidx_vbuaa
tax
lda {c1},x
sec
sbc {c2},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbuaa_minus_pbsc2_derefidx_vbuaa
tay
lda {c1},y
sec
sbc {c2},y
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbuxx_minus_pbsc2_derefidx_vbuxx
lda {c1},x
sec
sbc {c2},x
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbuxx_minus_pbsc2_derefidx_vbuxx
lda {c1},x
sec
sbc {c2},x
//FRAGMENT vbsxx=pbsc1_derefidx_vbuxx_minus_pbsc2_derefidx_vbuxx
lda {c1},x
sec
sbc {c2},x
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbuxx_minus_pbsc2_derefidx_vbuxx
lda {c1},x
sec
sbc {c2},x
tay
//FRAGMENT vbsz1=pbsc1_derefidx_vbuyy_minus_pbsc2_derefidx_vbuyy
lda {c1},y
sec
sbc {c2},y
sta {z1}
//FRAGMENT vbsaa=pbsc1_derefidx_vbuyy_minus_pbsc2_derefidx_vbuyy
lda {c1},y
sec
sbc {c2},y
//FRAGMENT vbsxx=pbsc1_derefidx_vbuyy_minus_pbsc2_derefidx_vbuyy
lda {c1},y
sec
sbc {c2},y
tax
//FRAGMENT vbsyy=pbsc1_derefidx_vbuyy_minus_pbsc2_derefidx_vbuyy
lda {c1},y
sec
sbc {c2},y
tay
//FRAGMENT _deref_pbsz1=vbsaa
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbsz1=vbsxx
txa
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbsz1=vbsyy
tya
ldy #0
sta ({z1}),y
//FRAGMENT vwuz1=_deref_pwuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_minus_1
ldx {z1}
lda {c1},x
bne !+
dec {c1}+1,x
!:
dec {c1},x
//FRAGMENT pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_minus_1
tax
lda {c1},x
bne !+
dec {c1}+1,x
!:
dec {c1},x
//FRAGMENT pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_minus_1
lda {c1},x
bne !+
dec {c1}+1,x
!:
dec {c1},x
//FRAGMENT pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_minus_1
sec
lda {c1},y
sbc #$01
sta {c1},y
lda {c1}+1,y
sbc #$00
sta {c1}+1,y
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_1
ldx {z2}
ldy {c1},x
iny
sty {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_1
ldy {z1}
lda {c1},y
clc
adc #1
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_1
ldy {z1}
ldx {c1},y
inx
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_1
ldx {z1}
ldy {c1},x
iny
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_1
tax
ldy {c1},x
iny
sty {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_1
tay
lda {c1},y
clc
adc #1
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_1
tay
ldx {c1},y
inx
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_1
tax
ldy {c1},x
iny
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_plus_1
ldy {c1},x
iny
sty {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_plus_1
lda {c1},x
clc
adc #1
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_plus_1
ldy {c1},x
iny
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_plus_1
ldx {c1},y
inx
stx {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_plus_1
lda {c1},y
clc
adc #1
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_plus_1
ldx {c1},y
inx
//FRAGMENT vwuz1_eq_vwuz2_then_la1
lda {z1}
cmp {z2}
bne !+
lda {z1}+1
cmp {z2}+1
beq {la1}
!:
//FRAGMENT vwuz1_le_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne !+
lda {z1}
cmp {z2}
beq {la1}
!:
bcc {la1}
//FRAGMENT vduz1=vwuz2_dword_vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda {z2}
sta {z1}+2
lda {z2}+1
sta {z1}+3
//FRAGMENT vbuz1=vbuz2_plus_pbuc1_derefidx_vbuz3
lda {z2}
ldy {z3}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
clc
adc {c1},y
//FRAGMENT vbuxx=vbuz1_plus_pbuc1_derefidx_vbuz2
lda {z1}
ldx {z2}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=vbuz1_plus_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
clc
adc {c1},y
tay
//FRAGMENT vbuz1=vbuxx_plus_pbuc1_derefidx_vbuz2
ldy {z2}
txa
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_pbuc1_derefidx_vbuz1
ldy {z1}
txa
clc
adc {c1},y
//FRAGMENT vbuxx=vbuxx_plus_pbuc1_derefidx_vbuz1
txa
ldx {z1}
clc
adc {c1},x
tax
//FRAGMENT vbuyy=vbuxx_plus_pbuc1_derefidx_vbuz1
ldy {z1}
txa
clc
adc {c1},y
tay
//FRAGMENT vbuz1=vbuyy_plus_pbuc1_derefidx_vbuz2
tya
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_pbuc1_derefidx_vbuz1
tya
ldy {z1}
clc
adc {c1},y
//FRAGMENT vbuxx=vbuyy_plus_pbuc1_derefidx_vbuz1
ldx {z1}
tya
clc
adc {c1},x
tax
//FRAGMENT vbuz1=vbuz2_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_plus_pbuc1_derefidx_vbuxx
lda {c1},x
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuxx_plus_pbuc1_derefidx_vbuxx
txa
clc
adc {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_pbuc1_derefidx_vbuxx
txa
clc
adc {c1},x
//FRAGMENT vbuxx=vbuxx_plus_pbuc1_derefidx_vbuxx
txa
clc
adc {c1},x
tax
//FRAGMENT vbuyy=vbuxx_plus_pbuc1_derefidx_vbuxx
txa
clc
adc {c1},x
tay
//FRAGMENT vbuz1=vbuyy_plus_pbuc1_derefidx_vbuxx
tya
clc
adc {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_pbuc1_derefidx_vbuxx
tya
clc
adc {c1},x
//FRAGMENT vbuxx=vbuyy_plus_pbuc1_derefidx_vbuxx
tya
clc
adc {c1},x
tax
//FRAGMENT vbuz1=vbuz2_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {z1}
//FRAGMENT vbuxx=vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_plus_pbuc1_derefidx_vbuyy
lda {c1},y
clc
adc {z1}
tay
//FRAGMENT vbuz1=vbuxx_plus_pbuc1_derefidx_vbuyy
txa
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuxx_plus_pbuc1_derefidx_vbuyy
txa
clc
adc {c1},y
//FRAGMENT vbuxx=vbuxx_plus_pbuc1_derefidx_vbuyy
txa
clc
adc {c1},y
tax
//FRAGMENT vbuyy=vbuxx_plus_pbuc1_derefidx_vbuyy
txa
clc
adc {c1},y
tay
//FRAGMENT vbuz1=vbuyy_plus_pbuc1_derefidx_vbuyy
tya
clc
adc {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuyy_plus_pbuc1_derefidx_vbuyy
tya
clc
adc {c1},y
//FRAGMENT vbuxx=vbuyy_plus_pbuc1_derefidx_vbuyy
tya
clc
adc {c1},y
tax
//FRAGMENT vduz1_lt_vwuc1_then_la1
NO_SYNTHESIS
//FRAGMENT vduz1_lt_vwsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vduz1=vduz2_rol_4
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
lda {z2}+2
rol
sta {z1}+2
lda {z2}+3
rol
sta {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vduz1=vduz2_rol_1
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
lda {z2}+2
rol
sta {z1}+2
lda {z2}+3
rol
sta {z1}+3
//FRAGMENT vduz1=vduz1_plus_vwuc1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
lda {z1}+2
adc #0
sta {z1}+2
lda {z1}+3
adc #0
sta {z1}+3
//FRAGMENT vduz1=vduz1_rol_2
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vbuz1=vbuc1_minus_vbuz1
lda #{c1}
sec
sbc {z1}
sta {z1}
//FRAGMENT vbsz1=vbsz2_ror_vbuz3
lda {z2}
ldy {z3}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sta {z1}
//FRAGMENT vbsz1=vbsz1_plus_vbsz2
lda {z1}
clc
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbsaa_neq_vbsc1_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbsyy_neq_0_then_la1
tya
cmp #0
bne {la1}
//FRAGMENT vbsaa=vbsz1_ror_vbuz2
lda {z1}
ldy {z2}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
//FRAGMENT vbsxx=vbsz1_ror_vbuz2
lda {z1}
ldx {z2}
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsz1_ror_vbuz2
lda {z1}
ldy {z2}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsxx_ror_vbuz2
ldy {z2}
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsxx_ror_vbuz1
ldy {z1}
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
//FRAGMENT vbsxx=vbsxx_ror_vbuz1
txa
ldx {z1}
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsxx_ror_vbuz1
ldy {z1}
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsyy_ror_vbuz2
tya
ldy {z2}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsyy_ror_vbuz1
tya
ldy {z1}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
//FRAGMENT vbsxx=vbsyy_ror_vbuz1
ldx {z1}
tya
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsyy_ror_vbuz1
tya
ldy {z1}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsz2_ror_vbuxx
lda {z2}
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsz1_ror_vbuxx
lda {z1}
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
//FRAGMENT vbsxx=vbsz1_ror_vbuxx
lda {z1}
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsz1_ror_vbuxx
lda {z1}
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsxx_ror_vbuxx
txa
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsxx_ror_vbuxx
txa
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
//FRAGMENT vbsxx=vbsxx_ror_vbuxx
txa
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsxx_ror_vbuxx
txa
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsyy_ror_vbuxx
tya
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsyy_ror_vbuxx
tya
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
//FRAGMENT vbsxx=vbsyy_ror_vbuxx
tya
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsyy_ror_vbuxx
tya
cpx #0
beq !e+
!l:
cmp #$80
ror
dex
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsz2_ror_vbuyy
lda {z2}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsz1_ror_vbuyy
lda {z1}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
//FRAGMENT vbsxx=vbsz1_ror_vbuyy
lda {z1}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsz1_ror_vbuyy
lda {z1}
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsxx_ror_vbuyy
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsxx_ror_vbuyy
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
//FRAGMENT vbsxx=vbsxx_ror_vbuyy
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsxx_ror_vbuyy
txa
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsyy_ror_vbuyy
tya
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sta {z1}
//FRAGMENT vbsaa=vbsyy_ror_vbuyy
tya
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
//FRAGMENT vbsxx=vbsyy_ror_vbuyy
tya
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tax
//FRAGMENT vbsyy=vbsyy_ror_vbuyy
tya
cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
tay
//FRAGMENT vbsz1=vbsz1_minus_vbsyy
tya
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbsz1=vbsz1_plus_vbsxx
txa
clc
adc {z1}
sta {z1}
//FRAGMENT vbsz1=vbsz1_plus_vbsyy
tya
clc
adc {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_pbuc1_derefidx_vbuz1
txa
ldx {z1}
sec
sbc {c1},x
tax
//FRAGMENT vbuyy=vbuyy_minus_pbuc1_derefidx_vbuz1
tya
ldy {z1}
sec
sbc {c1},y
tay
//FRAGMENT vbuz1=vbuz1_minus_pbuc1_derefidx_vbuxx
lda {z1}
sec
sbc {c1},x
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_pbuc1_derefidx_vbuxx
txa
tax
sec
sbc {c1},x
tax
//FRAGMENT vbuyy=vbuyy_minus_pbuc1_derefidx_vbuxx
tya
sec
sbc {c1},x
tay
//FRAGMENT vbuz1=vbuz1_minus_pbuc1_derefidx_vbuyy
lda {z1}
sec
sbc {c1},y
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_pbuc1_derefidx_vbuyy
txa
sec
sbc {c1},y
tax
//FRAGMENT vbuyy=vbuyy_minus_pbuc1_derefidx_vbuyy
tya
tay
sec
sbc {c1},y
tay
//FRAGMENT _deref_pduc1=vduz1
lda {z1}
sta {c1}
lda {z1}+1
sta {c1}+1
lda {z1}+2
sta {c1}+2
lda {z1}+3
sta {c1}+3
//FRAGMENT vduz1=_dec_vduz2
lda {z2}
sec
sbc #1
sta {z1}
lda {z2}+1
sbc #0
sta {z1}+1
lda {z2}+2
sbc #0
sta {z1}+2
lda {z2}+3
sbc #0
sta {z1}+3
//FRAGMENT vduz1=vduz1_plus_vbuc1
lda {z1}
clc
adc #{c1}
sta {z1}
bcc !+
inc {z1}+1
bne !+
inc {z1}+2
bne !+
inc {z1}+3
!:
//FRAGMENT vduz1=_dec_vduz1
lda {z1}
sec
sbc #1
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
lda {z1}+2
sbc #0
sta {z1}+2
lda {z1}+3
sbc #0
sta {z1}+3
//FRAGMENT vwuz1=_stackidxword_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
lda STACK_BASE+{c1}+1,x
sta {z1}+1
//FRAGMENT _stackidxword_vbuc1=vwuz1
tsx
lda {z1}
sta STACK_BASE+{c1},x
lda {z1}+1
sta STACK_BASE+{c1}+1,x
//FRAGMENT _stackpushword_=vwuc1
lda #>{c1}
pha
lda #<{c1}
pha
//FRAGMENT vwuz1=_stackpullword_
pla
sta {z1}
pla
sta {z1}+1
//FRAGMENT _stackpushword_=vbuc1
lda #0
pha
lda #<{c1}
pha
//FRAGMENT _stackidxsword_vbuc1=vwsz1
tsx
lda {z1}
sta STACK_BASE+{c1},x
lda {z1}+1
sta STACK_BASE+{c1}+1,x
//FRAGMENT _stackpushbyte_2
pha
pha
//FRAGMENT vwsz1=_stackpullsword_
pla
sta {z1}
pla
sta {z1}+1
//FRAGMENT _deref_pwsc1=vwsz1
lda {z1}
sta {c1}
lda {z1}+1
sta {c1}+1
//FRAGMENT pbuc1_derefidx_vbuaa=_inc_pbuc1_derefidx_vbuaa
tax
inc {c1},x
//FRAGMENT vbuaa=vbuaa_bor_vbuc1
ora #{c1}
//FRAGMENT vbuz1=_deref_pbuz2_rol_1
ldy #0
lda ({z2}),y
asl
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=_inc_pwuc1_derefidx_vbuz1
ldx {z1}
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT vbuaa=_deref_pbuz1_rol_1
ldy #0
lda ({z1}),y
asl
//FRAGMENT vbuxx=_deref_pbuz1_rol_1
ldy #0
lda ({z1}),y
asl
tax
//FRAGMENT vbuyy=_deref_pbuz1_rol_1
ldy #0
lda ({z1}),y
asl
tay
//FRAGMENT pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa
tax
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT pwuc1_derefidx_vbuxx=_inc_pwuc1_derefidx_vbuxx
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT pwuc1_derefidx_vbuyy=_inc_pwuc1_derefidx_vbuyy
tya
tax
inc {c1},x
bne !+
inc {c1}+1,x
!:
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_(pbuc3_derefidx_vbuz1)
ldx {z1}
ldy {c3},x
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_(pbuc3_derefidx_vbuxx)
ldy {c3},x
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_(pbuc3_derefidx_vbuyy)
ldx {c3},y
lda {c2},x
sta {c1},y
//FRAGMENT pwsz1_lt_pwsc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vbsaa=vbsz1_minus_vbsaa
eor #$ff
sec
adc {z1}
//FRAGMENT vbsaa=vbsxx_minus_vbsaa
sta $ff
txa
sec
sbc $ff
//FRAGMENT vbuz1=_deref_pbuc1_bxor_vbuc2
lda #{c2}
eor {c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_bxor_vbuaa
eor #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_bxor_vbuxx
txa
eor #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuc1_bxor_vbuyy
tya
eor #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_bxor_vbuaa
eor #{c1}
//FRAGMENT vbuaa=vbuc1_bxor_vbuxx
txa
eor #{c1}
//FRAGMENT vbuaa=vbuc1_bxor_vbuyy
tya
eor #{c1}
//FRAGMENT vbuxx=vbuc1_bxor_vbuaa
eor #{c1}
tax
//FRAGMENT vbuxx=vbuc1_bxor_vbuxx
txa
eor #{c1}
tax
//FRAGMENT vbuxx=vbuc1_bxor_vbuyy
tya
eor #{c1}
tax
//FRAGMENT vbuyy=vbuc1_bxor_vbuaa
eor #{c1}
tay
//FRAGMENT vbuyy=vbuc1_bxor_vbuxx
txa
eor #{c1}
tay
//FRAGMENT vbuyy=vbuc1_bxor_vbuyy
tya
eor #{c1}
tay
//FRAGMENT vbuaa=_deref_pbuc1_bxor_vbuc2
lda #{c2}
eor {c1}
//FRAGMENT vbuxx=_deref_pbuc1_bxor_vbuc2
lda #{c2}
eor {c1}
tax
//FRAGMENT vbuyy=_deref_pbuc1_bxor_vbuc2
lda #{c2}
eor {c1}
tay
//FRAGMENT vbuz1=vbuz1_plus_vbuaa
clc
adc {z1}
sta {z1}
//FRAGMENT vduz1_neq_vduc1_then_la1
lda {z1}+3
cmp #>{c1}>>$10
bne {la1}
lda {z1}+2
cmp #<{c1}>>$10
bne {la1}
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vwuz1=vwuz2_plus_vwuc1
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vduz1=vduz2_sethi_vwuz3
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z3}
sta {z1}+2
lda {z3}+1
sta {z1}+3
//FRAGMENT vduz1=vduz2_setlo_vwuz3
lda {z3}
sta {z1}
lda {z3}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
//FRAGMENT vduz1=vduz1_setlo_vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuaa=vbuaa_plus_2
clc
adc #2
//FRAGMENT vbuz1_ge__deref_pbuc1_then_la1
lda {c1}
ldy {z1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuxx_ge__deref_pbuc1_then_la1
ldy {c1}
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuyy_ge__deref_pbuc1_then_la1
lda {c1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vduz1=_deref_pduc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
lda {c1}+2
sta {z1}+2
lda {c1}+3
sta {z1}+3
//FRAGMENT vwuz1=pbuc1_derefidx_vbuz2_word_vbuz3
ldy {z2}
lda {c1},y
sta {z1}+1
lda {z3}
sta {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuaa_word_vbuz2
tay
lda {c1},y
sta {z1}+1
lda {z2}
sta {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuxx_word_vbuz2
lda {c1},x
sta {z1}+1
lda {z2}
sta {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuyy_word_vbuz2
lda {c1},y
sta {z1}+1
lda {z2}
sta {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuz2_word_vbuaa
ldx {z2}
tay
lda {c1},x
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuaa_word_vbuaa
tay
lda {c1},y
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuxx_word_vbuaa
tay
lda {c1},x
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuyy_word_vbuaa
tax
lda {c1},y
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuz2_word_vbuxx
ldy {z2}
lda {c1},y
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuaa_word_vbuxx
tay
lda {c1},y
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuxx_word_vbuxx
lda {c1},x
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuyy_word_vbuxx
lda {c1},y
sta {z1}+1
stx {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuz2_word_vbuyy
ldx {z2}
lda {c1},x
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuaa_word_vbuyy
tax
lda {c1},x
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuxx_word_vbuyy
lda {c1},x
sta {z1}+1
sty {z1}
//FRAGMENT vwuz1=pbuc1_derefidx_vbuyy_word_vbuyy
lda {c1},y
sta {z1}+1
sty {z1}
//FRAGMENT _deref_(_deref_qwuc1)=_deref_(_deref_qwuc2)
ldy {c2}
sty $fe
ldy {c2}+1
sty $ff
ldy #0
lda ($fe),y
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT vbuyy=vbuaa_band_pbuc1_derefidx_vbuyy
and {c1},y
tay
//FRAGMENT _deref_pbuc1_eq__deref_pbuc2_then_la1
lda {c1}
cmp {c2}
beq {la1}
//FRAGMENT _deref_pbsc1=_deref_pbsc2
lda {c2}
sta {c1}
//FRAGMENT vwsz1_eq_vwsz2_then_la1
lda {z1}
cmp {z2}
bne !+
lda {z1}+1
cmp {z2}+1
beq {la1}
!:
//FRAGMENT vwsz1_neq_vwsz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vwsz1_lt_vwsz2_then_la1
lda {z1}
cmp {z2}
lda {z1}+1
sbc {z2}+1
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsz1_gt_vwsz2_then_la1
lda {z2}
cmp {z1}
lda {z2}+1
sbc {z1}+1
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsz1_ge_vwsz2_then_la1
lda {z1}
cmp {z2}
lda {z1}+1
sbc {z2}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT vbuz1=_deref_pbuc1_plus_1
ldy {c1}
iny
sty {z1}
//FRAGMENT vbuz1=_deref_pbuc1_minus_1
ldx {c1}
dex
stx {z1}
//FRAGMENT vbuz1=_deref_pbuc1_plus_vbuc2
lda #{c2}
clc
adc {c1}
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1_minus_vbuc2
lda {c1}
sec
sbc #{c2}
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1_plus_1
lda {c1}
clc
adc #1
//FRAGMENT vbuaa=_deref_pbuc1_minus_1
lda {c1}
sec
sbc #1
//FRAGMENT vbuaa=_deref_pbuc1_plus_vbuc2
lda #{c2}
clc
adc {c1}
//FRAGMENT vbuxx=_deref_pbuc1_plus_vbuc2
lda {c1}
tax
axs #-[{c2}]
//FRAGMENT vbuyy=_deref_pbuc1_plus_vbuc2
lda #{c2}
clc
adc {c1}
tay
//FRAGMENT vbuaa=_deref_pbuc1_minus_vbuc2
lda {c1}
sec
sbc #{c2}
//FRAGMENT vbuxx=_deref_pbuc1_minus_vbuc2
lda {c1}
tax
axs #{c2}
//FRAGMENT vbuyy=_deref_pbuc1_minus_vbuc2
lda {c1}
sec
sbc #{c2}
tay
//FRAGMENT vbuaa_ge_vbuxx_then_la1
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuaa_ge_vbuyy_then_la1
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx=_deref_pbuc1_plus_1
ldx {c1}
inx
//FRAGMENT vbuyy=_deref_pbuc1_plus_1
ldy {c1}
iny
//FRAGMENT vbuxx=_deref_pbuc1_minus_1
ldx {c1}
dex
//FRAGMENT vbuyy=_deref_pbuc1_minus_1
lda {c1}
tay
dey
//FRAGMENT vbsz1_neq_vbsz2_then_la1
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vbsz1_neq_vbsxx_then_la1
cpx {z1}
bne {la1}
//FRAGMENT vbsxx_neq_vbsz1_then_la1
cpx {z1}
bne {la1}
//FRAGMENT pwuz1=pwuc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pwuz1=pwuc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_vbuc2
lda #{c2}
ldy {z2}
clc
adc {c1},y
sta {z1}
//FRAGMENT _deref_pwuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
tya
iny
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=vbuc2
lda #{c2}
ldy #{c1}
sta ({z1}),y
lda #0
iny
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_plus_vbuc2
lda #{c2}
ldy #{c1}
clc
adc ({z1}),y
sta ({z1}),y
iny
lda #0
adc ({z1}),y
sta ({z1}),y
//FRAGMENT vwuz1=_deref_pwuz2_ror_8
ldy #1
lda ({z2}),y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT pwuz1_derefidx_vbuc1=pwuz1_derefidx_vbuc1_bxor_vwuc2
ldy #{c1}
lda #<{c2}
eor ({z1}),y
sta ({z1}),y
iny
lda #>{c2}
eor ({z1}),y
sta ({z1}),y
//FRAGMENT vwuz1=pwuz2_derefidx_vbuc1_ror_8
ldy #{c1}
lda #0
sta {z1}+1
iny
lda ({z2}),y
sta {z1}
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
//FRAGMENT pwuz1_derefidx_vbuc1=vbuz2
lda {z2}
ldy #{c1}
sta ({z1}),y
lda #0
iny
sta ({z1}),y
//FRAGMENT vbuz1=_hi_pvoz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=_lo_pvoz2
lda {z2}
sta {z1}
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
//FRAGMENT vwuz1_lt_vbuxx_then_la1
lda {z1}+1
bne !+
stx $ff
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
//FRAGMENT pbuc1_derefidx_vbuaa=_byte_vwuz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=_byte_vwuz1
lda {z1}
sta {c1},y
//FRAGMENT pwuz1_derefidx_vbuc1=vbuxx
txa
ldy #{c1}
sta ({z1}),y
lda #0
iny
sta ({z1}),y
//FRAGMENT pwuz1_derefidx_vbuc1=vbuyy
tya
ldy #{c1}
sta ({z1}),y
lda #0
iny
sta ({z1}),y
//FRAGMENT vbuaa=_hi_pvoz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_pvoz1
ldx {z1}+1
//FRAGMENT vbuaa=_lo_pvoz1
lda {z1}
//FRAGMENT vbuxx=_lo_pvoz1
ldx {z1}
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
//FRAGMENT vbuyy=_hi_pvoz1
ldy {z1}+1
//FRAGMENT vbuyy=_lo_pvoz1
ldy {z1}
//FRAGMENT vwuz1=_deref_pwuz1_ror_8
ldy #1
lda ({z1}),y
sta {z1}
dey
sty {z1}+1
//FRAGMENT vwuz1=pwuz1_derefidx_vbuc1_ror_8
ldy #{c1}
iny
lda ({z1}),y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT _deref_pbuz1=vbum2
lda {m2}
ldy #0
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbum1=vbuc2
lda #{c2}
ldy {m1}
sta {c1},y
//FRAGMENT vbuz1=vbum2
lda {m2}
sta {z1}
//FRAGMENT vbuaa=vbum1
lda {m1}
//FRAGMENT vbuxx=vbum1
ldx {m1}
//FRAGMENT vbuyy=vbum1
ldy {m1}
//FRAGMENT vwuz1=vwuc1_plus_pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbuz2=_byte_vwuz3
lda {z3}
ldy {z2}
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
//FRAGMENT pbuz1_derefidx_vbuxx=_byte_vwuz2
txa
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=_byte_vwuz2
lda {z2}
sta ({z1}),y
//FRAGMENT vbuz1=vbuz2_bor__hi_vwuz3
lda {z2}
ora {z3}+1
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_vbuaa
ora {z1}
sta {z1}
//FRAGMENT pbuz1_ge_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {z1}
cmp #<{c1}
bcs {la1}
!:
//FRAGMENT vbuz1=_deref_pbuc1_ror_1
lda {c1}
lsr
sta {z1}
//FRAGMENT vwuz1_ge_pwuc1_derefidx_vbuz2_then_la1
ldy {z2}
lda {c1}+1,y
cmp {z1}+1
bne !+
lda {c1},y
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT _deref_(_deref_qbuc1)=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_qbuc1=_inc__deref_qbuc1
inc {c1}
bne !+
inc {c1}+1
!:
//FRAGMENT vbuaa=_deref_pbuc1_ror_1
lda {c1}
lsr
//FRAGMENT vbuxx=_deref_pbuc1_ror_1
lda {c1}
lsr
tax
//FRAGMENT vbuyy=_deref_pbuc1_ror_1
lda {c1}
lsr
tay
//FRAGMENT vwuz1_ge_pwuc1_derefidx_vbuaa_then_la1
tay
lda {c1}+1,y
cmp {z1}+1
bne !+
lda {c1},y
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT vwuz1_ge_pwuc1_derefidx_vbuxx_then_la1
lda {c1}+1,x
cmp {z1}+1
bne !+
lda {c1},x
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT vwuz1_ge_pwuc1_derefidx_vbuyy_then_la1
lda {c1}+1,y
cmp {z1}+1
bne !+
lda {c1},y
cmp {z1}
beq {la1}
!:
bcc {la1}
//FRAGMENT _deref_(_deref_qbuc1)=pbuc2_derefidx_vbuaa
tay
lda {c2},y
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_(_deref_qbuc1)=pbuc2_derefidx_vbuxx
lda {c2},x
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_(_deref_qbuc1)=pbuc2_derefidx_vbuyy
lda {c2},y
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT _deref_pwuz1=vbuz2
lda {z2}
ldy #0
sta ({z1}),y
tya
iny
sta ({z1}),y
//FRAGMENT _deref_pwuz1=vbuaa
ldy #0
sta ({z1}),y
tya
iny
sta ({z1}),y
//FRAGMENT _deref_pwuz1=vbuxx
txa
ldy #0
sta ({z1}),y
tya
iny
sta ({z1}),y
//FRAGMENT _deref_pwuz1=vbuyy
tya
ldy #0
sta ({z1}),y
tya
iny
sta ({z1}),y
//FRAGMENT vboz1=vboc1
lda #{c1}
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz3_derefidx_vbuz4
ldy {z4}
lda ({z3}),y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuz2_derefidx_vbuz3
ldy {z3}
sta $ff
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz2_derefidx_vbuz3
ldy {z3}
stx $ff
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz2_derefidx_vbuz3
sty $ff

ldy {z3}
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz3_derefidx_vbuaa
tay
lda ({z3}),y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz2_derefidx_vbuaa
stx $ff
tay
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz2_derefidx_vbuaa
sty $ff

tay
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz3_derefidx_vbuxx
txa
tay
lda ({z3}),y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuz2_derefidx_vbuxx
sta $ff
txa
tay
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuz2_derefidx_vbuxx
sty $ff

txa
tay
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=pbuz3_derefidx_vbuyy
lda ({z3}),y
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuaa=pbuz2_derefidx_vbuyy
sta $ff
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuz2_derefidx_vbuyy
stx $ff
lda ({z2}),y
ldy $ff
sta ({z1}),y
//FRAGMENT vbsz1=vbsaa_rol_1
asl
sta {z1}
//FRAGMENT vbsaa=vbsaa_rol_1
asl
//FRAGMENT vbsxx=vbsaa_rol_1
asl
tax
//FRAGMENT vbsyy=vbsaa_rol_1
asl
tay
//FRAGMENT pwsz1=pwsc1_plus_vbuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pwsc1_derefidx_vbuz1=_deref_pwsz2
ldx {z1}
ldy #0
lda ({z2}),y
sta {c1},x
iny
lda ({z2}),y
sta {c1}+1,x
//FRAGMENT pwsz1=pwsc1_plus_vbuaa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pwsz1=pwsc1_plus_vbuxx
txa
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pwsz1=pwsc1_plus_vbuyy
tya
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pwsc1_derefidx_vbuaa=_deref_pwsz1
tax
ldy #0
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
//FRAGMENT pwsc1_derefidx_vbuxx=_deref_pwsz1
ldy #0
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
//FRAGMENT pwsc1_derefidx_vbuyy=_deref_pwsz1
tya
tax
ldy #0
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
//FRAGMENT vbuz1=_hi_pwuc1_derefidx_vbuyy
lda {c1}+1,y
sta {z1}
//FRAGMENT vbuaa=_hi_pwuc1_derefidx_vbuyy
lda {c1}+1,y
//FRAGMENT vbuxx=_hi_pwuc1_derefidx_vbuyy
lda {c1}+1,y
tax
//FRAGMENT vbuyy=_hi_pwuc1_derefidx_vbuyy
lda {c1}+1,y
tay
//FRAGMENT vbuz1=_lo_pwsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vbuz1=_hi_pwsc1_derefidx_vbuz2
ldy {z2}
lda {c1}+1,y
sta {z1}
//FRAGMENT vbuaa=_lo_pwsc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbuxx=_lo_pwsc1_derefidx_vbuz1
ldx {z1}
lda {c1},x
tax
//FRAGMENT vbuyy=_lo_pwsc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
tay
//FRAGMENT vbuz1=_lo_pwsc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuaa=_lo_pwsc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbuxx=_lo_pwsc1_derefidx_vbuxx
lda {c1},x
tax
//FRAGMENT vbuyy=_lo_pwsc1_derefidx_vbuxx
lda {c1},x
tay
//FRAGMENT vbuz1=_lo_pwsc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=_lo_pwsc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vbuxx=_lo_pwsc1_derefidx_vbuyy
lda {c1},y
tax
//FRAGMENT vbuyy=_lo_pwsc1_derefidx_vbuyy
lda {c1},y
tay
//FRAGMENT vbuaa=_hi_pwsc1_derefidx_vbuz1
ldy {z1}
lda {c1}+1,y
//FRAGMENT vbuxx=_hi_pwsc1_derefidx_vbuz1
ldx {z1}
lda {c1}+1,x
tax
//FRAGMENT vbuyy=_hi_pwsc1_derefidx_vbuz1
ldy {z1}
lda {c1}+1,y
tay
//FRAGMENT vbuz1=_hi_pwsc1_derefidx_vbuxx
lda {c1}+1,x
sta {z1}
//FRAGMENT vbuaa=_hi_pwsc1_derefidx_vbuxx
lda {c1}+1,x
//FRAGMENT vbuxx=_hi_pwsc1_derefidx_vbuxx
lda {c1}+1,x
tax
//FRAGMENT vbuyy=_hi_pwsc1_derefidx_vbuxx
lda {c1}+1,x
tay
//FRAGMENT vbuz1=_hi_pwsc1_derefidx_vbuyy
lda {c1}+1,y
sta {z1}
//FRAGMENT vbuaa=_hi_pwsc1_derefidx_vbuyy
lda {c1}+1,y
//FRAGMENT vbuxx=_hi_pwsc1_derefidx_vbuyy
lda {c1}+1,y
tax
//FRAGMENT vbuyy=_hi_pwsc1_derefidx_vbuyy
lda {c1}+1,y
tay
//FRAGMENT vwuc1_le_vwuc2_then_la1
lda #>{c1}
cmp #>{c2}
bne !+
lda #<{c1}
cmp #<{c2}
beq {la1}
!:
bcc {la1}
//FRAGMENT _deref_pboc1=vboc2
lda #{c2}
sta {c1}
//FRAGMENT _deref_pboc1_then_la1
lda {c1}
cmp #0
bne {la1}
//FRAGMENT pbuz1_derefidx_vbuc1=_byte_vwuz2
ldy #{c1}
lda {z2}
sta ({z1}),y
//FRAGMENT pssz1=pssc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pssz1=_deref_pssz2_memcpy_vbuc1
ldy #00
!:
lda ({z2}),y
sta ({z1}),y
iny
cpy #{c1}
bne !-
//FRAGMENT pssz1=pssc1_plus_vwuz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuc1=_deref_pbuc1_plus_vbuc2
lda #{c2}
clc
adc {c1}
sta {c1}
//FRAGMENT pssz1=pssz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pssz1_lt_pssc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vbuz1_lt__deref_pbuc1_then_la1
lda {z1}
cmp {c1}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=(_deref_qwuc2)_derefidx_vbuz1
ldy {z1}
lda {c2}
sta $fe
lda {c2}+1
sta $ff
lda ($fe),y
sta {c1},y
iny
lda ($fe),y
sta {c1},y
//FRAGMENT vbuaa_lt__deref_pbuc1_then_la1
cmp {c1}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbuaa=(_deref_qwuc2)_derefidx_vbuaa
tay
lda {c2}
sta $fe
lda {c2}+1
sta $ff
lda ($fe),y
sta {c1},y
iny
lda ($fe),y
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuxx=(_deref_qwuc2)_derefidx_vbuxx
txa
tay
lda {c2}
sta $fe
lda {c2}+1
sta $ff
lda ($fe),y
sta {c1},y
iny
lda ($fe),y
sta {c1},y
//FRAGMENT pwuc1_derefidx_vbuyy=(_deref_qwuc2)_derefidx_vbuyy
lda {c2}
sta $fe
lda {c2}+1
sta $ff
lda ($fe),y
sta {c1},y
iny
lda ($fe),y
sta {c1},y
//FRAGMENT vbuxx_lt__deref_pbuc1_then_la1
cpx {c1}
bcc {la1}
//FRAGMENT (_deref_qbuc1)_derefidx_vbuc2=vbuc3
lda #{c3}
ldy #{c2}
ldx {c1}
stx $fe
ldx {c1}+1
stx $ff
sta ($fe),y
//FRAGMENT pssz1_neq_pssc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT pssz1=pssz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=(_deref_qwuc1)_derefidx_vbuc2
ldy #{c2}
lda {c1}
sta $fe
lda {c1}+1
sta $ff
lda ($fe),y
sta {z1}
iny
lda ($fe),y
sta {z1}+1
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_(_deref_pbuz2)
ldy #0
lda ({z2}),y
tay
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_(_deref_pbuz1)
ldy #0
lda ({z1}),y
tay
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_(_deref_pbuz1)
tax
ldy #0
lda ({z1}),y
tay
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_(_deref_pbuz1)
tya
tax
ldy #0
lda ({z1}),y
tay
lda {c2},y
sta {c1},x
//FRAGMENT vboaa=vboc1
lda #{c1}
//FRAGMENT vboxx=vboc1
lda #{c1}
tax
//FRAGMENT vboyy=vboc1
lda #{c1}
tay
//FRAGMENT vbuyy_neq_vbuaa_then_la1
tax
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vwuz1=_deref_pbuz2_word__deref_pbuz3
ldy #0
lda ({z3}),y
sta {z1}
lda ({z2}),y
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuc1_plus_2
lda {c1}
clc
adc #2
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1_plus_2
lda {c1}
clc
adc #2
//FRAGMENT vbuxx=_deref_pbuc1_plus_2
ldx {c1}
inx
inx
//FRAGMENT vbuyy=_deref_pbuc1_plus_2
ldy {c1}
iny
iny
//FRAGMENT _deref_pbuz1=_byte_vwsz2
lda {z2}
ldy #0
sta ({z1}),y
//FRAGMENT vduz1=vduz2_plus_vduz1
lda {z1}
clc
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
//FRAGMENT vbuz1=vbuxx_band_pbuz2_derefidx_vbuc1
ldy #{c1}
txa
and ({z2}),y
sta {z1}
//FRAGMENT vbuaa=vbuxx_band_pbuz1_derefidx_vbuc1
ldy #{c1}
txa
and ({z1}),y
//FRAGMENT vbuxx=vbuxx_band_pbuz1_derefidx_vbuc1
ldy #{c1}
lda ({z1}),y
axs #0
//FRAGMENT vbuyy=vbuxx_band_pbuz1_derefidx_vbuc1
ldy #{c1}
txa
and ({z1}),y
tay
//FRAGMENT pbuz1=pbuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT _deref_pbuc1_eq_vbuc2_then_la1
lda #{c2}
cmp {c1}
beq {la1}
//FRAGMENT vbsz1=vbsz2_ror_1
lda {z2}
cmp #$80
ror
sta {z1}
//FRAGMENT vbsaa=vbsz1_ror_1
lda {z1}
cmp #$80
ror
//FRAGMENT vbsxx=vbsz1_ror_1
lda {z1}
cmp #$80
ror
tax
//FRAGMENT vbsyy=vbsz1_ror_1
lda {z1}
cmp #$80
ror
tay
//FRAGMENT vbsz1=vbsaa_ror_1
cmp #$80
ror
sta {z1}
//FRAGMENT vbsaa=vbsaa_ror_1
cmp #$80
ror
//FRAGMENT vbsxx=vbsaa_ror_1
cmp #$80
ror
tax
//FRAGMENT vbsyy=vbsaa_ror_1
cmp #$80
ror
tay
//FRAGMENT vbsz1=vbsxx_ror_1
txa
cmp #$80
ror
sta {z1}
//FRAGMENT vbsaa=vbsxx_ror_1
txa
cmp #$80
ror
//FRAGMENT vbsxx=vbsxx_ror_1
txa
cmp #$80
ror
tax
//FRAGMENT vbsyy=vbsxx_ror_1
txa
cmp #$80
ror
tay
//FRAGMENT vbsz1=vbsyy_ror_1
tya
cmp #$80
ror
sta {z1}
//FRAGMENT vbsaa=vbsyy_ror_1
tya
cmp #$80
ror
//FRAGMENT vbsxx=vbsyy_ror_1
tya
cmp #$80
ror
tax
//FRAGMENT vbsyy=vbsyy_ror_1
tya
cmp #$80
ror
tay
//FRAGMENT vbuz1=_neg_vbuyy
dey
tya
eor #$ff
sta {z1}
//FRAGMENT vbuaa=_neg_vbuyy
dey
tya
eor #$ff
//FRAGMENT vbuxx=_neg_vbuyy
tya
eor #$ff
tax
inx
//FRAGMENT vbuz1=vbuz2_band_vbuz3
lda {z2}
and {z3}
sta {z1}
//FRAGMENT vbuz1=vbuaa_band_vbuz2
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_band_vbuz2
lda {z2}
sax {z1}
//FRAGMENT vbuz1=vbuyy_band_vbuz2
tya
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuxx
lda {z2}
sax {z1}
//FRAGMENT vbuz1=vbuaa_band_vbuxx
sax {z1}
//FRAGMENT vbuaa=vbuz1_band_vbuz2
lda {z1}
and {z2}
//FRAGMENT vbuaa=vbuaa_band_vbuz1
and {z1}
//FRAGMENT vbuaa=vbuxx_band_vbuz1
txa
and {z1}
//FRAGMENT vbuaa=vbuyy_band_vbuz1
tya
and {z1}
//FRAGMENT vbuxx=vbuz1_band_vbuz2
lda {z1}
and {z2}
tax
//FRAGMENT vbuxx=vbuaa_band_vbuz1
ldx {z1}
axs #0
//FRAGMENT vbuxx=vbuxx_band_vbuz1
lda {z1}
axs #0
//FRAGMENT vbuxx=vbuyy_band_vbuz1
ldx {z1}
tya
axs #0
//FRAGMENT vbuyy=vbuz1_band_vbuz2
lda {z1}
and {z2}
tay
//FRAGMENT vbuyy=vbuaa_band_vbuz1
and {z1}
tay
//FRAGMENT vbuyy=vbuxx_band_vbuz1
txa
and {z1}
tay
//FRAGMENT vbuyy=vbuyy_band_vbuz1
tya
and {z1}
tay
//FRAGMENT vdsz1=vdsz2_rol_4
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vwuz1=vbuc1_plus__hi_vdsz2
NO_SYNTHESIS
//FRAGMENT vwuz1=vwuc1_plus__hi_vdsz2
clc
lda #<{c1}
adc {z2}+2
sta {z1}
lda #>{c1}
adc {z2}+3
sta {z1}+1
//FRAGMENT vwuz1=vbsc1_plus__hi_vdsz2
NO_SYNTHESIS
//FRAGMENT vwuz1=vwuz2_minus_vwuz1
lda {z2}
sec
sbc {z1}
sta {z1}
lda {z2}+1
sbc {z1}+1
sta {z1}+1
//FRAGMENT vdsz1=vdsz1_rol_4
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vwsz1=vwsz2_ror_2
lda {z2}+1
cmp #$80
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
//FRAGMENT vwsz1=vbsc1_plus_vwsz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_plus_vbuz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc #0
sta {z1}+1
//FRAGMENT vwsz1=vwsc1_plus_vwsz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vbsc1_plus_vwsz1
clc
lda {z1}
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=_word_pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=_word_pbuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=_word_pbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=_word_pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT pbuz1_ge_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {z1}
cmp #<{c1}
bcs {la1}
!:
//FRAGMENT pbuc1_derefidx_vbuz1=vbum2
lda {m2}
ldy {z1}
sta {c1},y
//FRAGMENT vbum1=vbum1_plus_vbuz2
lda {m1}
clc
adc {z2}
sta {m1}
//FRAGMENT pbuc1_derefidx_vbuaa=vbum1
tay
lda {m1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbum1
lda {m1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbum1
lda {m1}
sta {c1},y
//FRAGMENT vbum1=vbum1_plus_vbuxx
txa
clc
adc {m1}
sta {m1}
//FRAGMENT vbum1=vbum1_plus_vbuyy
tya
clc
adc {m1}
sta {m1}
//FRAGMENT pbuc1_derefidx_vbuz1=_deref_pbuc2
lda {c2}
ldy {z1}
sta {c1},y
//FRAGMENT _deref_pbuc1=_deref_pbuc1_plus_vbuz1
lda {c1}
clc
adc {z1}
sta {c1}
//FRAGMENT pbuc1_derefidx_vbuaa=_deref_pbuc2
tay
lda {c2}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=_deref_pbuc2
lda {c2}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=_deref_pbuc2
lda {c2}
sta {c1},y
//FRAGMENT _deref_pbuc1=_deref_pbuc1_plus_vbuxx
txa
clc
adc {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_plus_vbuyy
tya
clc
adc {c1}
sta {c1}
//FRAGMENT pbum1=pbum1_plus_vbuc1
lda #{c1}
clc
adc {m1}
sta {m1}
bcc !+
inc {m1}+1
!:
//FRAGMENT vwsz1=vwsz1_plus_vbsz2
lda {z2}
pha
clc
adc {z1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_plus_vbsaa
pha
clc
adc {z1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_plus_vbsxx
txa
pha
clc
adc {z1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_plus_vbsyy
tya
pha
clc
adc {z1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z1}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_sethi_vbuz2
lda {z2}
sta {z1}+1
lda #<{c1}
sta {z1}
//FRAGMENT pbuz1=pbuz2_setlo_vbuz3
lda {z3}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_sethi_vbuz2
lda {z2}
sta {z1}+1
lda #<{c1}
sta {z1}
//FRAGMENT vwuz1=vwuz2_setlo_vbuz3
lda {z3}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_sethi_vbuaa
sta {z1}+1
lda #<{c1}
sta {z1}
//FRAGMENT pbuz1=pbuc1_sethi_vbuxx
stx {z1}+1
ldx #<{c1}
stx {z1}
//FRAGMENT pbuz1=pbuz2_setlo_vbuaa
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_setlo_vbuxx
stx {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_setlo_vbuyy
sty {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_sethi_vbuaa
sta {z1}+1
lda #<{c1}
sta {z1}
//FRAGMENT vwuz1=vwuc1_sethi_vbuxx
stx {z1}+1
ldx #<{c1}
stx {z1}
//FRAGMENT vwuz1=vwuz2_setlo_vbuaa
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_setlo_vbuxx
stx {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz2_setlo_vbuyy
sty {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_sethi_vbuyy
sty {z1}+1
ldy #<{c1}
sty {z1}
//FRAGMENT vwuz1=vwuc1_sethi_vbuyy
sty {z1}+1
ldy #<{c1}
sty {z1}
//FRAGMENT pbuz1=pbuz1_setlo_vbuaa
sta {z1}
//FRAGMENT vwuz1=vwuz1_setlo_vbuaa
sta {z1}
//FRAGMENT vdsz1=vdsc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda #<{c1}>>$10
sta {z1}+2
lda #>{c1}>>$10
sta {z1}+3
//FRAGMENT vdsz1_lt_0_then_la1
lda {z1}+3
bmi {la1}
//FRAGMENT vdsz1=_neg_vdsz1
sec
lda {z1}
eor #$ff
adc #$0
sta {z1}
lda {z1}+1
eor #$ff
adc #$0
sta {z1}+1
lda {z1}+2
eor #$ff
adc #$0
sta {z1}+2
lda {z1}+3
eor #$ff
adc #$0
sta {z1}+3
//FRAGMENT pwsc1_derefidx_vbuz1_ge_vwsz2_then_la1
ldy {z1}
lda {c1},y
cmp {z2}
lda {c1}+1,y
sbc {z2}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT vbuz1=_lo_pwsc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=_lo_pwsc1_derefidx_vbuaa
tay
lda {c1},y
//FRAGMENT vbuxx=_lo_pwsc1_derefidx_vbuaa
tax
lda {c1},x
tax
//FRAGMENT vbuyy=_lo_pwsc1_derefidx_vbuaa
tay
lda {c1},y
tay
//FRAGMENT pwsc1_derefidx_vbuaa_ge_vwsz1_then_la1
tay
lda {c1},y
cmp {z1}
lda {c1}+1,y
sbc {z1}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT pwsc1_derefidx_vbuxx_ge_vwsz1_then_la1
lda {c1},x
cmp {z1}
lda {c1}+1,x
sbc {z1}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT pwsc1_derefidx_vbuyy_ge_vwsz1_then_la1
lda {c1},y
cmp {z1}
lda {c1}+1,y
sbc {z1}+1
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz2
lda {z2}
tay
sta ({z1}),y
//FRAGMENT pbuz1=pbuz2_minus_vbuc1
sec
lda {z2}
sbc #{c1}
sta {z1}
lda {z2}+1
sbc #0
sta {z1}+1
//FRAGMENT _deref_qssz1=pssz2
ldy #0
lda {z2}
sta ({z1}),y
iny
lda {z2}+1
sta ({z1}),y
//FRAGMENT vwuz1=vwuz1_plus_pwuz2_derefidx_vbuc1
ldy #{c1}
clc
lda {z1}
adc ({z2}),y
sta {z1}
iny
lda {z1}+1
adc ({z2}),y
sta {z1}+1
//FRAGMENT pssz1=_deref_qssz1
ldy #0
lda ({z1}),y
pha
iny
lda ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT _deref_pbuz1_eq__deref_pbuz2_then_la1
ldy #0
lda ({z1}),y
ldy #0
cmp ({z2}),y
beq {la1}
//FRAGMENT vbsz1_le_0_then_la1
lda {z1}
cmp #1
bmi {la1}
//FRAGMENT vwsz1=vwsz1_minus_vbsz2
lda {z2}
sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {z1}
sbc $fe
sta {z1}
lda {z1}+1
sbc $ff
sta {z1}+1
//FRAGMENT vbsaa_le_0_then_la1
cmp #1
bmi {la1}
//FRAGMENT vbsaa_neq_vbsz1_then_la1
cmp {z1}
bne {la1}
//FRAGMENT vwsz1=vwsz1_minus_vbsxx
txa
sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {z1}
sbc $fe
sta {z1}
lda {z1}+1
sbc $ff
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_minus_vbsyy
tya
sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {z1}
sbc $fe
sta {z1}
lda {z1}+1
sbc $ff
sta {z1}+1
//FRAGMENT vbsyy_neq_vbsc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbsxx_le_0_then_la1
cpx #1
bmi {la1}
//FRAGMENT vbsyy_neq_vbsz1_then_la1
cpy {z1}
bne {la1}
//FRAGMENT vbsyy_neq_vbsxx_then_la1
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbsyy_le_0_then_la1
cpy #1
bmi {la1}
//FRAGMENT vbsz1_neq_vbsyy_then_la1
cpy {z1}
bne {la1}
//FRAGMENT vbsxx_neq_vbsyy_then_la1
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuc1_neq_vwuz1_then_la1
NO_SYNTHESIS
//FRAGMENT vbsc1_neq_vwuz1_then_la1
NO_SYNTHESIS
//FRAGMENT vwuc1_neq_vwuz1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
ora {c1},y
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
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuz1
txa
ldx {z1}
ora {c1},x
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuz1
tya
ldy {z1}
ora {c1},y
tay
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ora {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuxx
txa
ora {c1},x
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuxx
tya
ora {c1},x
tay
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuyy
lda {c1},y
ora {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuyy
txa
ora {c1},y
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuyy
tya
ora {c1},y
tay
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
//FRAGMENT vbuaa_le_vbuxx_then_la1
tay
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc2_derefidx_vbuz2
ldy {z2}
lda {c1},y
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz1
ldy {z1}
lda {c1},y
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz1
ldx {z1}
lda {c1},x
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz1
ldy {z1}
lda {c1},y
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuaa
tay
lda {c1},y
clc
adc {c2},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuaa
tay
lda {c1},y
clc
adc {c2},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuaa
tax
lda {c1},x
clc
adc {c2},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuaa
tay
lda {c1},y
clc
adc {c2},y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_(pbuz3_derefidx_vbuz4)_plus_pbuz5_derefidx_(pbuz6_derefidx_vbuz4)
ldy {z4}
lda ({z6}),y
sta $ff
lda ({z3}),y
tay
lda ({z2}),y
ldy $ff
clc
adc ({z5}),y
sta {z1}
//FRAGMENT vbuz1=vbuz1_bor_pbuc1_derefidx_vbuaa
tay
lda {c1},y
ora {z1}
sta {z1}
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuaa
tay
txa
ora {c1},y
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuaa
tax
tya
ora {c1},x
tay
//FRAGMENT vbuaa=pbuz1_derefidx_(pbuz2_derefidx_vbuz3)_plus_pbuz4_derefidx_(pbuz5_derefidx_vbuz3)
ldy {z3}
lda ({z5}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z4}),y
//FRAGMENT vbuxx=pbuz1_derefidx_(pbuz2_derefidx_vbuz3)_plus_pbuz4_derefidx_(pbuz5_derefidx_vbuz3)
ldy {z3}
lda ({z5}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z4}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_(pbuz2_derefidx_vbuz3)_plus_pbuz4_derefidx_(pbuz5_derefidx_vbuz3)
ldy {z3}
lda ({z5}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z4}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_(pbuz3_derefidx_vbuaa)_plus_pbuz4_derefidx_(pbuz5_derefidx_vbuaa)
tay
lda ({z5}),y
sta $ff
lda ({z3}),y
tay
lda ({z2}),y
ldy $ff
clc
adc ({z4}),y
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_(pbuz2_derefidx_vbuaa)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuaa)
tay
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
//FRAGMENT vbuxx=pbuz1_derefidx_(pbuz2_derefidx_vbuaa)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuaa)
tay
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_(pbuz2_derefidx_vbuaa)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuaa)
tay
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_(pbuz3_derefidx_vbuxx)_plus_pbuz4_derefidx_(pbuz5_derefidx_vbuxx)
txa
tay
lda ({z5}),y
sta $ff
lda ({z3}),y
tay
lda ({z2}),y
ldy $ff
clc
adc ({z4}),y
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_(pbuz2_derefidx_vbuxx)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuxx)
txa
tay
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
//FRAGMENT vbuxx=pbuz1_derefidx_(pbuz2_derefidx_vbuxx)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuxx)
txa
tay
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_(pbuz2_derefidx_vbuxx)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuxx)
txa
tay
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
tay
//FRAGMENT vbuz1=pbuz2_derefidx_(pbuz3_derefidx_vbuyy)_plus_pbuz4_derefidx_(pbuz5_derefidx_vbuyy)
lda ({z5}),y
sta $ff
lda ({z3}),y
tay
lda ({z2}),y
ldy $ff
clc
adc ({z4}),y
sta {z1}
//FRAGMENT vbuaa=pbuz1_derefidx_(pbuz2_derefidx_vbuyy)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuyy)
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
//FRAGMENT vbuxx=pbuz1_derefidx_(pbuz2_derefidx_vbuyy)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuyy)
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
tax
//FRAGMENT vbuyy=pbuz1_derefidx_(pbuz2_derefidx_vbuyy)_plus_pbuz3_derefidx_(pbuz4_derefidx_vbuyy)
lda ({z4}),y
sta $ff
lda ({z2}),y
tay
lda ({z1}),y
ldy $ff
clc
adc ({z3}),y
tay
//FRAGMENT _deref_pbuc1=_deref_(_deref_qbuc2)
ldy {c2}
sty $fe
ldy {c2}+1
sty $ff
ldy #0
lda ($fe),y
sta {c1}
//FRAGMENT vbsz1_eq_vbsc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbsc1_eq_vbsz1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT pbuz1=pbuz2_plus_vbsz3
lda {z3}
pha
clc
adc {z2}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z2}+1
sta {z1}+1
//FRAGMENT vbsaa_eq_vbsc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbsaa=vbsyy_minus_vbsaa
sta $ff
tya
sec
sbc $ff
//FRAGMENT vbsc1_eq_vbsaa_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT pbuz1=pbuz2_plus_vbsaa
pha
clc
adc {z2}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbsxx
txa
pha
clc
adc {z2}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vbsyy
tya
pha
clc
adc {z2}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z2}+1
sta {z1}+1
//FRAGMENT vbsc1_eq_vbsxx_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbsxx_eq_vbsc1_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbsc1_eq_vbsyy_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT pbuz1=pbuz1_plus_vbsxx
txa
pha
clc
adc {z1}
sta {z1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {z1}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_2
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT _deref_pwsz1=vwsc1
ldy #0
lda #<{c1}
sta ({z1}),y
iny
lda #>{c1}
sta ({z1}),y
//FRAGMENT vwsz1=_deref_pwsz2_band_vwsc1
ldy #0
lda ({z2}),y
and #<{c1}
sta {z1}
iny
lda ({z2}),y
and #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_hi__deref_pwsz2
ldy #1
lda ({z2}),y
sta {z1}
//FRAGMENT vbuaa=_hi__deref_pwsz1
ldy #1
lda ({z1}),y
//FRAGMENT vbuxx=_hi__deref_pwsz1
ldy #1
lda ({z1}),y
tax
//FRAGMENT vbuyy=_hi__deref_pwsz1
ldy #1
lda ({z1}),y
tay
//FRAGMENT pwsc1_derefidx_vbuz1=pwsc1_derefidx_vbuz1_minus_vbuz2
ldx {z1}
sec
lda {c1},x
sbc {z2}
sta {c1},x
bcs !+
dec {c1}+1,x
!:
//FRAGMENT pwsc1_derefidx_vbuz1=pwsc1_derefidx_vbuz1_minus_vbuxx
ldy {z1}
stx $ff
sec
lda {c1},y
sbc $ff
sta {c1},y
lda {c1}+1,y
sbc #0
sta {c1},y
//FRAGMENT pwsc1_derefidx_vbuz1=pwsc1_derefidx_vbuz1_minus_vbuyy
tya
ldy {z1}
clc
sbc {c1},y 
eor #$ff
sta {c1},y
bcc !+
lda {c1}+1,y
sbc #$01
sta {c1}+1,y
!:
//FRAGMENT pwsc1_derefidx_vbuaa=pwsc1_derefidx_vbuaa_minus_vbuz1
tax
sec
lda {c1},x
sbc {z1}
sta {c1},x
bcs !+
dec {c1}+1,x
!:
//FRAGMENT pwsc1_derefidx_vbuaa=pwsc1_derefidx_vbuaa_minus_vbuxx
sec
stx $ff
tax
lda {c1},x
sbc $ff
sta {c1},x
bcs !+
dec {c1}+1,x
!:
//FRAGMENT pwsc1_derefidx_vbuaa=pwsc1_derefidx_vbuaa_minus_vbuyy
sec
sty $ff
tay
lda {c1},y
sbc $ff
sta {c1},y
lda {c1}+1,y
sbc #$00
sta {c1}+1,y
//FRAGMENT pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_minus_vbuz1
sec
lda {c1},x
sbc {z1}
sta {c1},x
bcs !+
dec {c1}+1,x
!:
//FRAGMENT pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_minus_vbuxx
txa
clc
sbc {c1},x
eor #$ff
sta {c1},x
bcc !+
lda {c1}+1,x
sbc #$01
sta {c1}+1,x
!:
//FRAGMENT pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_minus_vbuyy
tya
clc
sbc {c1},x
eor #$ff
sta {c1},x
bcc !+
lda {c1}+1,x
sbc #$01
sta {c1}+1,x
!:
//FRAGMENT pwsc1_derefidx_vbuyy=pwsc1_derefidx_vbuyy_minus_vbuz1
sec
lda {c1},y
sbc {z1}
sta {c1},y
lda {c1}+1,y
sbc #0
sta {c1}+1,y
//FRAGMENT pwsc1_derefidx_vbuyy=pwsc1_derefidx_vbuyy_minus_vbuxx
stx $ff
sec
lda {c1},y
sbc $ff
sta {c1},y
lda {c1}+1,y
sbc #0
sta {c1},y
//FRAGMENT pwsc1_derefidx_vbuyy=pwsc1_derefidx_vbuyy_minus_vbuyy
tya
clc
sbc {c1},y 
eor #$ff
sta {c1},y
bcc !+
lda {c1}+1,y
sbc #$01
sta {c1}+1,y
!:
//FRAGMENT pwuc1_derefidx_vbuaa=vbuc2
tay
lda #{c2}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_plus_pwuc1_derefidx_vbuz3
ldx {z2}
ldy {z3}
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx_plus_pwuc1_derefidx_vbuz2
ldy {z2}
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy_plus_pwuc1_derefidx_vbuz2
ldx {z2}
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_plus_pwuc1_derefidx_vbuaa
ldx {z2}
tay
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx_plus_pwuc1_derefidx_vbuaa
tay
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy_plus_pwuc1_derefidx_vbuaa
tax
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_plus_pwuc1_derefidx_vbuxx
ldy {z2}
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx_plus_pwuc1_derefidx_vbuxx
txa
tay
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy_plus_pwuc1_derefidx_vbuxx
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_plus_pwuc1_derefidx_vbuyy
ldx {z2}
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx_plus_pwuc1_derefidx_vbuyy
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy_plus_pwuc1_derefidx_vbuyy
tya
tax
clc
lda {c1},x
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=vbuxx_plus_2
inx
inx
stx {z1}
//FRAGMENT vbuz1=vbuyy_plus_2
iny
iny
sty {z1}
//FRAGMENT vbuz1=_deref_pbuz2_plus__deref_pbuz3
ldy #0
lda ({z2}),y
clc
ldy #0
adc ({z3}),y
sta {z1}
//FRAGMENT vbuaa=_deref_pbuz1_plus__deref_pbuz2
ldy #0
lda ({z1}),y
clc
ldy #0
adc ({z2}),y
//FRAGMENT vbuxx=_deref_pbuz1_plus__deref_pbuz2
ldy #0
lda ({z1}),y
clc
ldy #0
adc ({z2}),y
tax
//FRAGMENT vbuyy=_deref_pbuz1_plus__deref_pbuz2
ldy #0
lda ({z1}),y
clc
ldy #0
adc ({z2}),y
tay
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
//FRAGMENT vwuz1=_deref_pwuz2_plus__deref_pwuz1
ldy #0
clc
lda ({z1}),y
adc ({z2}),y
pha
iny
lda ({z1}),y
adc ({z2}),y
sta ({z1}),y
dey
pla
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_pbuc2_derefidx_vbuz1
ldy {z1}
lda {c1},y
clc
adc {c2},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_vbuc2
lda #{c2}
ldy {z1}
clc
adc {c1},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc1_derefidx_vbuaa_plus_pbuc2_derefidx_vbuaa
tax
tay
lda {c1},x
clc
adc {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_plus_pbuc2_derefidx_vbuxx
lda {c1},x
clc
adc {c2},x
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc1_derefidx_vbuyy_plus_pbuc2_derefidx_vbuyy
lda {c1},y
clc
adc {c2},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_plus_vbuc2
lda #{c2}
clc
adc {c1},x
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc1_derefidx_vbuyy_plus_vbuc2
lda #{c2}
clc
adc {c1},y
sta {c1},y
//FRAGMENT _deref_pbuz1=_deref_pbuz1_plus_pbuz1_derefidx_vbuc1
ldy #0
lda ({z1}),y
ldy #{c1}
clc
adc ({z1}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuc1=pbuz1_derefidx_vbuc1_plus_vbuc2
lda #{c2}
ldy #{c1}
clc
adc ({z1}),y
sta ({z1}),y
//FRAGMENT vbuz1=_deref_pbuz2_ror_4
ldy #0
lda ({z2}),y
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=_deref_pbuz1_ror_4
ldy #0
lda ({z1}),y
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=_deref_pbuz1_ror_4
ldy #0
lda ({z1}),y
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=_deref_pbuz1_ror_4
ldy #0
lda ({z1}),y
lsr
lsr
lsr
lsr
tay
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bxor_vbuc2
lda #{c2}
eor {c1}
sta {c1}
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_plus_vwuc2
ldy {z1}
clc
lda {c1},y
adc #<{c2}
sta {c1},y
lda {c1}+1,y
adc #>{c2}
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_vwuc2
tay
clc
lda {c1},y
adc #<{c2}
sta {c1},y
lda {c1}+1,y
adc #>{c2}
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_vwuc2
clc
lda {c1},x
adc #<{c2}
sta {c1},x
lda {c1}+1,x
adc #>{c2}
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_plus_vwuc2
clc
lda {c1},y
adc #<{c2}
sta {c1},y
lda {c1}+1,y
adc #>{c2}
sta {c1}+1,y
//FRAGMENT vwsz1=_deref_pwsz2_minus__deref_pwsz3
ldy #0
sec
lda ({z2}),y
sbc ({z3}),y
sta {z1}
iny
lda ({z2}),y
sbc ({z3}),y
sta {z1}+1
//FRAGMENT vduz1=vduz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
lda {z2}+2
adc #0
sta {z1}+2
lda {z2}+3
adc #0
sta {z1}+3
//FRAGMENT vduz1=vduz1_plus_vwuz2
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
lda {z1}+2
adc #0
sta {z1}+2
lda {z1}+3
adc #0
sta {z1}+3
//FRAGMENT _deref_(_deref_qbuc1)=vbuc2
lda #{c2}
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
//FRAGMENT vwsz1=vwsz2_minus_vwsc1
lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbsc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
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
//FRAGMENT vwsz1=vwsz2_rol_3
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
//FRAGMENT vwsz1=vwsz2_ror_6
lda {z2}
sta $ff
lda {z2}+1
sta {z1}
lda #0
bit {z2}+1
bpl !+
lda #$ff
!:
sta {z1}+1
rol $ff
rol {z1}
rol {z1}+1
rol $ff
rol {z1}
rol {z1}+1
//FRAGMENT vwsz1=_deref_pwsc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbsc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbsc1_derefidx_vbuxx
lda {c1},x
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbsc1_derefidx_vbuyy
lda {c1},y
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=_sword_vbsaa
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=_sword_vbsxx
txa
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=_sword_vbsyy
tya
sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1
//FRAGMENT vwsz1=vwsz2_minus_vwsz1
lda {z2}
sec
sbc {z1}
sta {z1}
lda {z2}+1
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwsz1=vwsz1_ror_6
lda {z1}
sta $ff
lda {z1}+1
sta {z1}
lda #0
bit {z1}+1
bpl !+
lda #$ff
!:
sta {z1}+1
rol $ff
rol {z1}
rol {z1}+1
rol $ff
rol {z1}
rol {z1}+1
//FRAGMENT vwsz1=vwsz1_rol_3
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vbsz1_le_vbsc1_then_la1
lda #{c1}
sec
sbc {z1}
bvc !+
eor #$80
!:
bpl {la1}
//FRAGMENT vbsaa_le_vbsc1_then_la1
sec
sbc #{c1}
beq {la1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsxx_le_vbsc1_then_la1
txa
sec
sbc #{c1}
beq {la1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vbsyy_le_vbsc1_then_la1
tya
sec
sbc #{c1}
beq {la1}
bvc !+
eor #$80
!:
bmi {la1}
//FRAGMENT vwsz1=vbsz2_plus_vwsc1
lda {z2}
tax
clc
adc #<{c1}
sta {z1}
txa
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vbsaa_plus_vwsc1
tax
clc
adc #<{c1}
sta {z1}
txa
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vbsxx_plus_vwsc1
txa
tax
clc
adc #<{c1}
sta {z1}
txa
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT vwsz1=vbsyy_plus_vwsc1
tya
tax
clc
adc #<{c1}
sta {z1}
txa
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuaa_gt_vbuz1_then_la1
cmp {z1}
beq !+
bcs {la1}
!:
//FRAGMENT pduc1_derefidx_vbuz1=pduc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},y
lda {c2}+1,y
sta {c1}+1,y
lda {c2}+2,y
sta {c1}+2,y
lda {c2}+3,y
sta {c1}+3,y
//FRAGMENT pbuz1_derefidx_vbuz2_eq_0_then_la1
ldy {z2}
lda ({z1}),y

cmp #0
beq {la1}
//FRAGMENT pduc1_derefidx_vbuz1=pduc1_derefidx_vbuz1_plus_pduc2_derefidx_vbuz1
ldy {z1}
clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
lda {c1}+2,y
adc {c2}+2,y
sta {c1}+2,y
lda {c1}+3,y
adc {c2}+3,y
sta {c1}+3,y
//FRAGMENT qbuc1_derefidx_vbuaa=pbuz1
tay
lda {z1}
sta {c1},y
lda {z1}+1
sta {c1}+1,y
//FRAGMENT pduc1_derefidx_vbuaa=pduc2_derefidx_vbuaa
tay
lda {c2},y
sta {c1},y
lda {c2}+1,y
sta {c1}+1,y
lda {c2}+2,y
sta {c1}+2,y
lda {c2}+3,y
sta {c1}+3,y
//FRAGMENT pduc1_derefidx_vbuxx=pduc2_derefidx_vbuxx
lda {c2},x
sta {c1},x
lda {c2}+1,x
sta {c1}+1,x
lda {c2}+2,x
sta {c1}+2,x
lda {c2}+3,x
sta {c1}+3,x
//FRAGMENT pduc1_derefidx_vbuyy=pduc2_derefidx_vbuyy
lda {c2},y
sta {c1},y
lda {c2}+1,y
sta {c1}+1,y
lda {c2}+2,y
sta {c1}+2,y
lda {c2}+3,y
sta {c1}+3,y
//FRAGMENT pbuz1_derefidx_vbuxx_eq_0_then_la1
txa
tay
lda ({z1}),y

cmp #0
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuyy_eq_0_then_la1
lda ({z1}),y

cmp #0
beq {la1}
//FRAGMENT pduc1_derefidx_vbuaa=pduc1_derefidx_vbuaa_plus_pduc2_derefidx_vbuaa
tay
clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
lda {c1}+2,y
adc {c2}+2,y
sta {c1}+2,y
lda {c1}+3,y
adc {c2}+3,y
sta {c1}+3,y
//FRAGMENT pduc1_derefidx_vbuxx=pduc1_derefidx_vbuxx_plus_pduc2_derefidx_vbuxx
clc
lda {c1},x
adc {c2},x
sta {c1},x
lda {c1}+1,x
adc {c2}+1,x
sta {c1}+1,x
lda {c1}+2,x
adc {c2}+2,x
sta {c1}+2,x
lda {c1}+3,x
adc {c2}+3,x
sta {c1}+3,x
//FRAGMENT pduc1_derefidx_vbuyy=pduc1_derefidx_vbuyy_plus_pduc2_derefidx_vbuyy
clc
lda {c1},y
adc {c2},y
sta {c1},y
lda {c1}+1,y
adc {c2}+1,y
sta {c1}+1,y
lda {c1}+2,y
adc {c2}+2,y
sta {c1}+2,y
lda {c1}+3,y
adc {c2}+3,y
sta {c1}+3,y
//FRAGMENT pbuz1=_dec_pbuz2
lda {z2}
sec
sbc #1
sta {z1}
lda {z2}+1
sbc #0
sta {z1}+1
//FRAGMENT vduz1_eq_vduz2_then_la1
lda {z1}
cmp {z2}
bne !+
lda {z1}+1
cmp {z2}+1
bne !+
lda {z1}+2
cmp {z2}+2
bne !+
lda {z1}+3
cmp {z2}+3
beq {la1}
!:
//FRAGMENT vdsz1_eq_vdsz2_then_la1
lda {z1}
cmp {z2}
bne !+
lda {z1}+1
cmp {z2}+1
bne !+
lda {z1}+2
cmp {z2}+2
bne !+
lda {z1}+3
cmp {z2}+3
beq {la1}
!:
//FRAGMENT vdsz1=vdsz1_plus_vwsz2
lda {z2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
lda {z1}+2
adc $ff
sta {z1}+2
lda {z1}+3
adc $ff
sta {z1}+3
//FRAGMENT vdsz1=vdsz1_minus_vwsz2
lda {z2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {z1}
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
lda {z1}+2
sbc $ff
sta {z1}+2
lda {z1}+3
sbc $ff
sta {z1}+3
//FRAGMENT vwsz1=_dec_vwsz1
lda {z1}
bne !+
dec {z1}+1
!:
dec {z1}
//FRAGMENT _deref_pwuc1=vbuz1
lda {z1}
sta {c1}
lda #0
sta {c1}+1
//FRAGMENT pvoz1=_deref_qvoc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
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
//FRAGMENT vwsz1_lt_vbsc1_then_la1
NO_SYNTHESIS
//FRAGMENT vwsz1_lt_vwuc1_then_la1
lda {z1}+1
bmi {la1}
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT vwsz1=pwsc1_derefidx_vbuz2_minus_pwsc2_derefidx_vbuz2
ldy {z2}
sec
lda {c1},y
sbc {c2},y
sta {z1}
lda {c1}+1,y
sbc {c2}+1,y
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_rol_4
ldy {z2}
lda {c1},y
asl
sta {z1}
lda {c1}+1,y
rol
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pbsc1_derefidx_vbuz1=vbsc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT vwsz1=pwsc1_derefidx_vbuaa_minus_pwsc2_derefidx_vbuaa
tay
sec
lda {c1},y
sbc {c2},y
sta {z1}
lda {c1}+1,y
sbc {c2}+1,y
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuxx_minus_pwsc2_derefidx_vbuxx
sec
lda {c1},x
sbc {c2},x
sta {z1}
lda {c1}+1,x
sbc {c2}+1,x
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuyy_minus_pwsc2_derefidx_vbuyy
sec
lda {c1},y
sbc {c2},y
sta {z1}
lda {c1}+1,y
sbc {c2}+1,y
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwsz1=_sword_pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuxx_rol_4
lda {c1},x
asl
sta {z1}
lda {c1}+1,x
rol
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=pwuc1_derefidx_vbuyy_rol_4
lda {c1},y
asl
sta {z1}
lda {c1}+1,y
rol
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pbsc1_derefidx_vbuxx=vbsc2
lda #{c2}
sta {c1},x
//FRAGMENT pbsc1_derefidx_vbuyy=vbsc2
lda #{c2}
sta {c1},y
//FRAGMENT _deref_pwuc1=_deref_pwuc1_plus_vwuc2
lda #<{c2}
clc
adc {c1}
sta {c1}
lda #>{c2}
adc {c1}+1
sta {c1}+1
//FRAGMENT vbuz1=vbuz2_plus__deref_pbuc1
lda {c1}
clc
adc {z2}
sta {z1}
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
//FRAGMENT vwsz1=pwsc1_derefidx_vbuz2_plus__deref_pwsz3
ldx {z2}
clc
ldy #0
lda {c1},x
adc ({z3}),y
sta {z1}
iny
lda {c1}+1,x
adc ({z3}),y
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuaa_plus__deref_pwsz2
tax
clc
ldy #0
lda {c1},x
adc ({z2}),y
sta {z1}
iny
lda {c1}+1,x
adc ({z2}),y
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuxx_plus__deref_pwsz2
clc
ldy #0
lda {c1},x
adc ({z2}),y
sta {z1}
iny
lda {c1}+1,x
adc ({z2}),y
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuyy_plus__deref_pwsz2
tya
tax
clc
ldy #0
lda {c1},x
adc ({z2}),y
sta {z1}
iny
lda {c1}+1,x
adc ({z2}),y
sta {z1}+1
//FRAGMENT vwsz1=pwsc1_derefidx_vbuaa_plus__deref_pwsz1
tax
ldy #0
clc
lda {c1},x
adc ({z1}),y
pha
iny
lda {c1}+1,x
adc ({z1}),y
sta {z1}+1
pla
sta {z1}
//FRAGMENT vwuz1=pwuc1_derefidx_vbuz2_ror_8
ldy {z2}
lda #0
sta {z1}+1
lda {c1}+1,y
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=pwuc1_derefidx_vbuz1_bxor_vwuc2
ldy {z1}
lda {c1},y
eor #<{c2}
sta {c1},y
lda {c1}+1,y
eor #>{c2}
sta {c1}+1,y
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
//FRAGMENT vwuz1_lt_vbuyy_then_la1
lda {z1}+1
bne !+
sty $ff
lda {z1}
cmp $ff
bcc {la1}
!:
//FRAGMENT pwuc1_derefidx_vbuz1=vbuaa
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pwuc1_derefidx_vbuxx=vbuaa
sta {c1},x
lda #0
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=vbuaa
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT vwuz1=vwuz2_rol_5
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
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_5
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT pprz1=_deref_qprc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vbuaa_le_vbuyy_then_la1
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuaa_then_la1
tay
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuyy_ge_vbuaa_then_la1
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=pwuz2_derefidx_vbuc2
ldx {z1}
ldy #{c2}
lda ({z2}),y
sta {c1},x
iny
lda ({z2}),y
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuaa=pwuz1_derefidx_vbuc2
ldy #{c2}
tax
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuxx=pwuz1_derefidx_vbuc2
ldy #{c2}
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
//FRAGMENT pwuc1_derefidx_vbuyy=pwuz1_derefidx_vbuc2
tya
ldy #{c2}
tax
lda ({z1}),y
sta {c1},x
iny
lda ({z1}),y
sta {c1}+1,x
//FRAGMENT vbsaa=vbsc1
lda #{c1}
//FRAGMENT vbsc1_neq_vbsyy_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbum1=vbum2
lda {m2}
sta {m1}
//FRAGMENT vbum1=vbum1_plus_vbuc1
lax {m1}
axs #-[{c1}]
stx {m1}
//FRAGMENT pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2
ldy {m2}
lda {c2},y
ldy {m1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_bor_vbuc2
lda #{c2}
ldy {z1}
ora {c1},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_bor_vbuc2
lda #{c2}
ora {c1},x
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc1_derefidx_vbuyy_bor_vbuc2
lda #{c2}
ora {c1},y
sta {c1},y
//FRAGMENT vduz1=vduz2_rol_0
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_rol_5
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
lda {z2}+2
rol
sta {z1}+2
lda {z2}+3
rol
sta {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vduz1=vduz2_rol_6
lda {z2}+3
lsr
sta $ff
lda {z2}+2
ror
sta {z1}+3
lda {z2}+1
ror
sta {z1}+2
lda {z2}
ror
sta {z1}+1
lda #0
ror
sta {z1}
lsr $ff
ror {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz2_rol_7
lda {z2}+3
lsr
lda {z2}+2
ror
sta {z1}+3
lda {z2}+1
ror
sta {z1}+2
lda {z2}
ror
sta {z1}+1
lda #0
ror
sta {z1}
//FRAGMENT vduz1=vduz2_rol_8
lda #0
sta {z1}
lda {z2}
sta {z1}+1
lda {z2}+1
sta {z1}+2
lda {z2}+2
sta {z1}+3
//FRAGMENT vduz1=vduz2_rol_9
lda #0
sta {z1}
lda {z2}
asl
sta {z1}+1
lda {z2}+1
rol
sta {z1}+2
lda {z2}+2
rol
sta {z1}+3
//FRAGMENT vduz1=vduz2_rol_vbuc1
ldy #{c1}
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e:
//FRAGMENT vduz1=vduz2_rol_16
lda #0
sta {z1}
sta {z1}+1
lda {z2}
sta {z1}+2
lda {z2}+1
sta {z1}+3
//FRAGMENT vduz1=vduz2_rol_24
lda #0
sta {z1}
sta {z1}+1
sta {z1}+2
lda {z2}
sta {z1}+3
//FRAGMENT vduz1=vduz2_rol_32
lda #0
sta {z1}
sta {z1}+1
sta {z1}+2
sta {z1}+3
//FRAGMENT vduz1=vduz2_ror_0
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
//FRAGMENT vduz1=vduz2_ror_1
lda {z2}+3
lsr
sta {z1}+3
lda {z2}+2
ror
sta {z1}+2
lda {z2}+1
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
//FRAGMENT vduz1=vduz2_ror_2
lda {z2}+3
lsr
sta {z1}+3
lda {z2}+2
ror
sta {z1}+2
lda {z2}+1
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz2_ror_3
lda {z2}+3
lsr
sta {z1}+3
lda {z2}+2
ror
sta {z1}+2
lda {z2}+1
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz2_ror_4
lda {z2}+3
lsr
sta {z1}+3
lda {z2}+2
ror
sta {z1}+2
lda {z2}+1
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz2_ror_5
lda {z2}+3
lsr
sta {z1}+3
lda {z2}+2
ror
sta {z1}+2
lda {z2}+1
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
//FRAGMENT vduz1=vduz2_ror_6
lda {z2}
asl
sta $ff
lda {z2}+1
rol
sta {z1}
lda {z2}+2
rol
sta {z1}+1
lda {z2}+3
rol
sta {z1}+2
lda #0
rol
sta {z1}+3
asl $ff
rol {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
//FRAGMENT vduz1=vduz2_ror_7
lda {z2}
asl
lda {z2}+1
rol
sta {z1}
lda {z2}+2
rol
sta {z1}+1
lda {z2}+3
rol
sta {z1}+2
lda #0
rol
sta {z1}+3
//FRAGMENT vduz1=vduz2_ror_8
lda #0
sta {z1}+3
lda {z2}+3
sta {z1}+2
lda {z2}+2
sta {z1}+1
lda {z2}+1
sta {z1}
//FRAGMENT vduz1=vduz2_ror_9
lda #0
sta {z1}+3
lda {z2}+3
lsr
sta {z1}+2
lda {z2}+2
ror
sta {z1}+1
lda {z2}+1
ror
sta {z1}
//FRAGMENT vduz1=vduz2_ror_vbuc1
ldx #{c1}
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_ror_16
lda #0
sta {z1}+3
sta {z1}+2
lda {z2}+3
sta {z1}+1
lda {z2}+2
sta {z1}
//FRAGMENT vduz1=vduz2_ror_24
lda #0
sta {z1}+3
sta {z1}+2
sta {z1}+1
lda {z2}+3
sta {z1}
//FRAGMENT vduz1=vduz2_ror_32
lda #0
sta {z1}+3
sta {z1}+2
sta {z1}+1
sta {z1}
//FRAGMENT vduz1=vduz2_ror_pbuc1_derefidx_vbuz3
ldy {z3}
ldx {c1},y
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_rol_pbuc1_derefidx_vbuaa
tax
ldy {c1},x
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e:
//FRAGMENT vduz1=vduz2_rol_pbuc1_derefidx_vbuyy
ldx {c1},y
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_ror_pbuc1_derefidx_vbuaa
tay
ldx {c1},y
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_ror_pbuc1_derefidx_vbuxx
lda {c1},x
tax
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vduz1=vduz2_ror_pbuc1_derefidx_vbuyy
ldx {c1},y
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e:
//FRAGMENT vbuz1=vbuaa_plus_2
clc
adc #2
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbum2
ldy {m2}
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbum1
ldy {m1}
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbum1
ldy {m1}
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbum1
ldx {m1}
ldy {c1},x
