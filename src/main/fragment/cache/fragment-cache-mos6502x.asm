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
