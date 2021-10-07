//KICKC FRAGMENT CACHE d183e4015 d183e6153
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT isr_hardware_all_entry
pha @clob_none
txa @clob_x
pha @clob_x
tya @clob_y
pha @clob_y
//FRAGMENT isr_hardware_all_exit
pla @clob_y
tay @clob_y
pla @clob_x
tax @clob_x
pla @clob_none
rti
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},y
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
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
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
//FRAGMENT vbuyy=_inc_vbuyy
iny
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbuz1=vbuz2_plus_1
ldy {z2}
iny
sty {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbuz1=vbuz2_rol_2
lda {z2}
asl
asl
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=vbuz1_minus_vbuc1
lax {z1}
axs #{c1}
stx {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_plus_pbuc2_derefidx_vbuz3
ldy {z2}
lda {c1},y
ldy {z3}
clc
adc {c2},y
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lax {z1}
axs #-[{c1}]
stx {z1}
//FRAGMENT vbuz1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
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
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
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
//FRAGMENT vbuz1=_byte1_pvoz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=_byte0_pvoz2
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
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT 0_eq_vbuaa_then_la1
cmp #0
beq {la1}
//FRAGMENT vbuaa=vbuz1_plus_1
lda {z1}
clc
adc #1
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
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
//FRAGMENT vbuz1=vbuaa_rol_2
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuaa_rol_2
asl
asl
//FRAGMENT vbuxx=vbuaa_rol_2
asl
asl
tax
//FRAGMENT vbuyy=vbuaa_rol_2
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
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuz1
ldx {z1}
tay
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuz1
ldx {z1}
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuxx
tay
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=pbuc2_derefidx_vbuyy
tax
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1},x
//FRAGMENT vbuxx=vbuxx_minus_vbuc1
txa
axs #{c1}
//FRAGMENT vbuyy=vbuyy_minus_vbuc1
tya
sec
sbc #{c1}
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
//FRAGMENT pbuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuxx_ge_vbuc1_then_la1
cpx #{c1}
bcs {la1}
//FRAGMENT vbuxx=vbuxx_plus_vbuc1
txa
axs #-[{c1}]
//FRAGMENT vbuyy=vbuyy_plus_vbuc1
tya
clc
adc #{c1}
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
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
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
//FRAGMENT vbuaa=_byte1_pvoz1
lda {z1}+1
//FRAGMENT vbuxx=_byte1_pvoz1
ldx {z1}+1
//FRAGMENT vbuaa=_byte0_pvoz1
lda {z1}
//FRAGMENT vbuxx=_byte0_pvoz1
ldx {z1}
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy=_byte1_pvoz1
ldy {z1}+1
//FRAGMENT vbuyy=_byte0_pvoz1
ldy {z1}
//FRAGMENT vbuyy_lt_vbuc1_then_la1
cpy #{c1}
bcc {la1}
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
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
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuyy_ge_vbuc1_then_la1
cpy #{c1}
bcs {la1}
//FRAGMENT vbuaa=vbuyy_bor_vbuaa
sty $ff
ora $ff
//FRAGMENT pbuc1_derefidx_vbuxx=vbuaa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuaa
sta {c1},y
//FRAGMENT vbuxx=vbuz1_plus_1
ldx {z1}
inx
//FRAGMENT vbuyy=vbuz1_plus_1
ldy {z1}
iny
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuyy=vbuaa
tay
