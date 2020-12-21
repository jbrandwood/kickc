//KICKC FRAGMENT CACHE 15355792e7 153557b11b
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pvoz1=pvoz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT isr_hardware_all_entry
sta rega+1
stx regx+1
sty regy+1
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT isr_hardware_all_exit
rega: lda #0
regx: ldx #0
regy: ldy #0
rti
//FRAGMENT pbuz1=pbuz2_minus_vwuc1
lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_neq_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_plus_vbuz3
lda {z2}
clc
adc {z3}
sta {z1}
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
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
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
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuz1
lda {c1}
ora {z1}
sta {c1}
//FRAGMENT pbuc1_derefidx_(pbuz1_derefidx_vbuc2)=pbuz1_derefidx_vbuc3
ldy #{c3}
lda ({z1}),y
ldy #{c2}
pha
lda ({z1}),y
tay
pla
sta {c1},y
//FRAGMENT pbuz1_derefidx_vbuc1=vbuc2
lda #{c2}
ldy #{c1}
sta ({z1}),y
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
//FRAGMENT vbuz1=_hi_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vbuz1=vbuc1_bxor_vbuz2
lda #{c1}
eor {z2}
sta {z1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuz1
lda {c1}
and {z1}
sta {c1}
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
//FRAGMENT vbuz1=_byte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
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
//FRAGMENT vbuz1=vbuz2_minus_vbuc1
lax {z2}
axs #{c1}
stx {z1}
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
//FRAGMENT vbuz1=vbuz2_ror_3
lda {z2}
lsr
lsr
lsr
sta {z1}
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
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT pbuz1=pbuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=vbuc1_minus_vbuz2
lda #{c1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vwuz1=vbuz2_word_vbuc1
lda {z2}
ldy #{c1}
sta {z1}+1
sty {z1}
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
//FRAGMENT vwuz1=vwuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz3
lda {z3}
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuz1=_neg_vbuz2
lda {z2}
eor #$ff
clc
adc #$01
sta {z1}
//FRAGMENT vbuz1=vbuc1_plus_vbuz2
lax {z2}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT pbuz1_lt_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {c1}
//FRAGMENT pbuz1_derefidx_vbuz2_eq_vbuc1_then_la1
lda #{c1}
ldy {z2}
cmp ({z1}),y
beq {la1}
//FRAGMENT vbuz1=pbuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
sta {z1}
//FRAGMENT vbuz1_ge_vbuz2_then_la1
lda {z1}
cmp {z2}
bcs {la1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
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
lda {z2}
clc
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
//FRAGMENT pbuz1=pbuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuc1_derefidx_vbuz1_neq_vbuc2_then_la1
lda #{c2}
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT vwuz1=vwuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz2
clc
lda {z2}
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
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
//FRAGMENT vbuz1=vbuz2_rol_3
lda {z2}
asl
asl
asl
sta {z1}
//FRAGMENT pwuc1_derefidx_vbuz1=vwuz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
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
//FRAGMENT vwsz1_ge_0_then_la1
lda {z1}+1
bpl {la1}
//FRAGMENT vwsz1=_neg_vwsz2
sec
lda #0
sbc {z2}
sta {z1}
lda #0
sbc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwsz1_neq_0_then_la1
lda {z1}+1
ora {z1}
bne {la1}
//FRAGMENT vwuz1=vwuz2_ror_1
lda {z2}+1
lsr
sta {z1}+1
lda {z2}
ror
sta {z1}
//FRAGMENT vwuz1=vwuc1_minus_vwuz1
sec
lda #<{c1}
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
//FRAGMENT vwuz1=_neg_vwuz1
sec
lda #0
sbc {z1}
sta {z1}
lda #0
sbc {z1}+1
sta {z1}+1
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
cmp #0
beq {la1}
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
//FRAGMENT vwsz1=vwsz1_plus_vwsz2
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
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
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa_neq_vbuc1_then_la1
cmp #{c1}
bne {la1}
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
//FRAGMENT vbuaa=_hi_vwuz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_vwuz1
ldx {z1}+1
//FRAGMENT 0_neq_vbuaa_then_la1
cmp #0
bne {la1}
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
//FRAGMENT vbuaa=_byte_vwuz1
lda {z1}
//FRAGMENT vbuxx=_byte_vwuz1
lda {z1}
tax
//FRAGMENT vbuyy=_byte_vwuz1
lda {z1}
tay
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
//FRAGMENT vbuz1=vbuxx_ror_3
txa
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuz1_ror_3
lda {z1}
lsr
lsr
lsr
//FRAGMENT vbuaa=vbuxx_ror_3
txa
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuz1_ror_3
lda {z1}
lsr
lsr
lsr
tax
//FRAGMENT vbuxx=vbuxx_ror_3
txa
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
//FRAGMENT vbuyy=vbuxx_ror_3
txa
lsr
lsr
lsr
tay
//FRAGMENT vbuyy=vbuz1_minus_vbuc1
lda {z1}
sec
sbc #{c1}
tay
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
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
//FRAGMENT pbuz1_derefidx_vbuz2=vbuaa
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuxx
ldy {z2}
txa
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuyy
tya
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuz2
txa
tay
lda {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuaa
stx $ff
ldy $ff
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuxx
txa
tay
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=vbuyy
stx $ff
tya
ldy $ff
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
//FRAGMENT vbuz1=vbuc1_plus_vbuxx
txa
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuaa=vbuc1_plus_vbuz1
lda #{c1}
clc
adc {z1}
//FRAGMENT vbuaa=vbuc1_plus_vbuxx
txa
clc
adc #{c1}
//FRAGMENT vbuxx=vbuc1_plus_vbuz1
lax {z1}
axs #-[{c1}]
//FRAGMENT vbuxx=vbuc1_plus_vbuxx
txa
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
//FRAGMENT vbuaa_ge_vbuz1_then_la1
cmp {z1}
bcs {la1}
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
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
//FRAGMENT pbuz1_derefidx_vbuxx=vbuc1
txa
tay
lda #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=vbuc1
lda #{c1}
sta ({z1}),y
//FRAGMENT vbuz1=vbuxx
stx {z1}
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
//FRAGMENT vwuz1=_word_vbuaa
sta {z1}
lda #0
sta {z1}+1
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
//FRAGMENT pbuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=vbuxx
txa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuz1
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=vbuxx
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbuyy
tya
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuyy
tya
sta {c1},y
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
//FRAGMENT vbuxx_ge_vbuc1_then_la1
cpx #{c1}
bcs {la1}
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
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
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuxx_ge_vbuz1_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuxx=vbuxx_minus_2
dex
dex
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuyy_ge_vbuc1_then_la1
cpy #{c1}
bcs {la1}
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
beq {la1}
//FRAGMENT vbuyy=vbuyy_minus_2
dey
dey
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=vbuxx
txa
tay
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuyy=_inc_vbuyy
iny
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuxx=vbuyy
tya
tax
//FRAGMENT vbuyy_ge_vbuz1_then_la1
cpy {z1}
bcs {la1}
//FRAGMENT vbuz1_ge_vbuxx_then_la1
lda {z1}
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuyy_ge_vbuxx_then_la1
stx $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuz1_ge_vbuyy_then_la1
lda {z1}
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuyy_then_la1
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuyy=_hi_vwuz1
ldy {z1}+1
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuyy=vbuaa_minus_vbuc1
sec
sbc #{c1}
tay
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT pbuz1=pbuz1_plus_vwuc1
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
//FRAGMENT vwuz1=vwuz1_ror_1
lsr {z1}+1
ror {z1}
//FRAGMENT vwuz1=vwuz1_ror_3
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
lsr {z1}+1
ror {z1}
//FRAGMENT vwuz1=vwuz2_plus_vwuz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuz2_plus_vwuz1
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_plus_vbuz2
lda {z2}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_rol_3
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_4
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
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
//FRAGMENT vwuz1=vbuc1_plus_vwuz1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT isr_hardware_cloba_entry
pha
//FRAGMENT isr_hardware_cloba_exit
pla
rti
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
