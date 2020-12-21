//KICKC FRAGMENT CACHE 15355792e7 153557b11b
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT isr_hardware_all_entry
pha
phx
phy
phz
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbuz1=vbuz2_rol_4
lda {z2}
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1=_inc_pbuz1
inw {z1}
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT isr_hardware_all_exit
plz
ply
plx
pla
rti
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},y
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_band_vbuc2
lda #{c2}
ldy {z2}
and {c1},y
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_ror_1
ldy {z2}
lda {c1},y
lsr
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_ror_2
ldy {z2}
lda {c1},y
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuz2_ror_1
lda {z2}
lsr
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbuz1=vbuz2_plus_1
lda {z2}
inc
sta {z1}
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1_eq__deref_pbuc1_then_la1
lda {c1}
cmp {z1}
beq {la1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {c1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT pbuz1_neq_pbuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuaa_neq_vbuc1_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1_rol_4
lda {z1}
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
//FRAGMENT vbuyy=vbuz1_rol_4
lda {z1}
asl
asl
asl
asl
tay
//FRAGMENT vbuzz=vbuz1_rol_4
lda {z1}
asl
asl
asl
asl
taz
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
//FRAGMENT vbuzz=_deref_pbuz1
ldy #0
lda ({z1}),y
taz
//FRAGMENT vbuaa_neq_0_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuz1=vbuaa_band_vbuc1
and #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuxx_band_vbuc1
txa
and #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuyy_band_vbuc1
tya
and #{c1}
sta {z1}
//FRAGMENT vbuz1=vbuzz_band_vbuc1
tza
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
//FRAGMENT vbuaa=vbuzz_band_vbuc1
tza
and #{c1}
//FRAGMENT vbuxx=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tax
//FRAGMENT vbuxx=vbuaa_band_vbuc1
and #{c1}
tax
//FRAGMENT vbuxx=vbuxx_band_vbuc1
txa
and #{c1}
tax
//FRAGMENT vbuxx=vbuyy_band_vbuc1
tya
and #{c1}
tax
//FRAGMENT vbuxx=vbuzz_band_vbuc1
tza
and #{c1}
tax
//FRAGMENT vbuyy=vbuz1_band_vbuc1
lda #{c1}
and {z1}
tay
//FRAGMENT vbuyy=vbuaa_band_vbuc1
and #{c1}
tay
//FRAGMENT vbuyy=vbuxx_band_vbuc1
txa
and #{c1}
tay
//FRAGMENT vbuyy=vbuyy_band_vbuc1
tya
and #{c1}
tay
//FRAGMENT vbuyy=vbuzz_band_vbuc1
tza
and #{c1}
tay
//FRAGMENT vbuzz=vbuz1_band_vbuc1
lda #{c1}
and {z1}
taz
//FRAGMENT vbuzz=vbuaa_band_vbuc1
and #{c1}
taz
//FRAGMENT vbuzz=vbuxx_band_vbuc1
txa
and #{c1}
taz
//FRAGMENT vbuzz=vbuyy_band_vbuc1
tya
and #{c1}
taz
//FRAGMENT vbuzz=vbuzz_band_vbuc1
tza
and #{c1}
taz
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
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
//FRAGMENT pbuc1_derefidx_vbuzz=pbuc2_derefidx_vbuzz
tza
tay
lda {c2},y
sta {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldx {z1}
and {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuz1_band_vbuc2
lda #{c2}
ldy {z1}
and {c1},y
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_band_vbuc2
tax
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuaa_band_vbuc2
tay
lda #{c2}
and {c1},y
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuxx_band_vbuc2
lda #{c2}
and {c1},x
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuyy_band_vbuc2
lda #{c2}
and {c1},y
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuzz_band_vbuc2
tza
tay
lda #{c2}
and {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuzz_band_vbuc2
tza
tay
lda #{c2}
and {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuzz_band_vbuc2
tza
tax
lda #{c2}
and {c1},x
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuzz_band_vbuc2
tza
tay
lda #{c2}
and {c1},y
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuzz_band_vbuc2
tza
tay
lda #{c2}
and {c1},y
taz
//FRAGMENT pbuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuz1
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuzz=vbuz1
tza
tay
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuaa
ldy {z1}
sta {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_ror_1
ldy {z1}
lda {c1},y
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_ror_1
ldx {z1}
lda {c1},x
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_ror_1
ldy {z1}
lda {c1},y
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuz1_ror_1
ldy {z1}
lda {c1},y
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_ror_1
tay
lda {c1},y
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_ror_1
tay
lda {c1},y
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_ror_1
tax
lda {c1},x
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_ror_1
tay
lda {c1},y
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuaa_ror_1
tay
lda {c1},y
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuxx_ror_1
lda {c1},x
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuyy_ror_1
lda {c1},y
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuzz_ror_1
tza
tay
lda {c1},y
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuzz_ror_1
tza
tay
lda {c1},y
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuzz_ror_1
tza
tax
lda {c1},x
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuzz_ror_1
tza
tay
lda {c1},y
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuzz_ror_1
tza
tay
lda {c1},y
lsr
taz
//FRAGMENT pbuc1_derefidx_vbuz1=vbuxx
ldy {z1}
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuyy
tya
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuzz
ldy {z1}
tza
sta {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1
ldy {z1}
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1
ldy {z1}
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1
ldx {z1}
ldy {c1},x
//FRAGMENT vbuzz=pbuc1_derefidx_vbuz1
ldx {z1}
ldz {c1},x
//FRAGMENT vbuz1=vbuaa_rol_4
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuaa_rol_4
asl
asl
asl
asl
//FRAGMENT vbuxx=vbuaa_rol_4
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuaa_rol_4
asl
asl
asl
asl
tay
//FRAGMENT vbuzz=vbuaa_rol_4
asl
asl
asl
asl
taz
//FRAGMENT vbuz1=vbuxx_rol_4
txa
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuxx_rol_4
txa
asl
asl
asl
asl
//FRAGMENT vbuxx=vbuxx_rol_4
txa
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuxx_rol_4
txa
asl
asl
asl
asl
tay
//FRAGMENT vbuzz=vbuxx_rol_4
txa
asl
asl
asl
asl
taz
//FRAGMENT vbuz1=vbuyy_rol_4
tya
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuyy_rol_4
tya
asl
asl
asl
asl
//FRAGMENT vbuxx=vbuyy_rol_4
tya
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuyy_rol_4
tya
asl
asl
asl
asl
tay
//FRAGMENT vbuzz=vbuyy_rol_4
tya
asl
asl
asl
asl
taz
//FRAGMENT vbuz1=vbuzz_rol_4
tza
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=vbuzz_rol_4
tza
asl
asl
asl
asl
//FRAGMENT vbuxx=vbuzz_rol_4
tza
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=vbuzz_rol_4
tza
asl
asl
asl
asl
tay
//FRAGMENT vbuzz=vbuzz_rol_4
tza
asl
asl
asl
asl
taz
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
//FRAGMENT vbuzz=vbuzz_plus_vbuc1
tza
clc
adc #{c1}
taz
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
//FRAGMENT pbuc1_derefidx_vbuzz=vbuc2
tza
tay
lda #{c2}
sta {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_ror_2
ldy {z1}
lda {c1},y
lsr
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_ror_2
ldx {z1}
lda {c1},x
lsr
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_ror_2
ldy {z1}
lda {c1},y
lsr
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuz1_ror_2
ldy {z1}
lda {c1},y
lsr
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa_ror_2
tay
lda {c1},y
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa_ror_2
tay
lda {c1},y
lsr
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa_ror_2
tax
lda {c1},x
lsr
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa_ror_2
tay
lda {c1},y
lsr
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuaa_ror_2
tay
lda {c1},y
lsr
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_ror_2
lda {c1},x
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_ror_2
lda {c1},x
lsr
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_ror_2
lda {c1},x
lsr
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_ror_2
lda {c1},x
lsr
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuxx_ror_2
lda {c1},x
lsr
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy_ror_2
lda {c1},y
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy_ror_2
lda {c1},y
lsr
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy_ror_2
lda {c1},y
lsr
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy_ror_2
lda {c1},y
lsr
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuyy_ror_2
lda {c1},y
lsr
lsr
taz
//FRAGMENT vbuz1=pbuc1_derefidx_vbuzz_ror_2
tza
tay
lda {c1},y
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuzz_ror_2
tza
tay
lda {c1},y
lsr
lsr
//FRAGMENT vbuxx=pbuc1_derefidx_vbuzz_ror_2
tza
tax
lda {c1},x
lsr
lsr
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuzz_ror_2
tza
tay
lda {c1},y
lsr
lsr
tay
//FRAGMENT vbuzz=pbuc1_derefidx_vbuzz_ror_2
tza
tay
lda {c1},y
lsr
lsr
taz
//FRAGMENT vbuz1=vbuaa_ror_1
lsr
sta {z1}
//FRAGMENT vbuz1=vbuxx_ror_1
txa
lsr
sta {z1}
//FRAGMENT vbuz1=vbuyy_ror_1
tya
lsr
sta {z1}
//FRAGMENT vbuz1=vbuzz_ror_1
tza
lsr
sta {z1}
//FRAGMENT vbuaa=vbuz1_ror_1
lda {z1}
lsr
//FRAGMENT vbuaa=vbuaa_ror_1
lsr
//FRAGMENT vbuaa=vbuxx_ror_1
txa
lsr
//FRAGMENT vbuaa=vbuyy_ror_1
tya
lsr
//FRAGMENT vbuaa=vbuzz_ror_1
tza
lsr
//FRAGMENT vbuxx=vbuz1_ror_1
lda {z1}
lsr
tax
//FRAGMENT vbuxx=vbuaa_ror_1
lsr
tax
//FRAGMENT vbuxx=vbuxx_ror_1
txa
lsr
tax
//FRAGMENT vbuxx=vbuyy_ror_1
tya
lsr
tax
//FRAGMENT vbuxx=vbuzz_ror_1
tza
lsr
tax
//FRAGMENT vbuyy=vbuz1_ror_1
lda {z1}
lsr
tay
//FRAGMENT vbuyy=vbuaa_ror_1
lsr
tay
//FRAGMENT vbuyy=vbuxx_ror_1
txa
lsr
tay
//FRAGMENT vbuyy=vbuyy_ror_1
tya
lsr
tay
//FRAGMENT vbuyy=vbuzz_ror_1
tza
lsr
tay
//FRAGMENT vbuzz=vbuz1_ror_1
lda {z1}
lsr
taz
//FRAGMENT vbuzz=vbuaa_ror_1
lsr
taz
//FRAGMENT vbuzz=vbuxx_ror_1
txa
lsr
taz
//FRAGMENT vbuzz=vbuyy_ror_1
tya
lsr
taz
//FRAGMENT vbuzz=vbuzz_ror_1
tza
lsr
taz
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuz1
ldx {z1}
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuzz=pbuc2_derefidx_vbuz1
ldx {z1}
tza
tay
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuxx
lda {c2},x
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuzz=pbuc2_derefidx_vbuxx
tza
tay
lda {c2},x
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuyy
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuzz=pbuc2_derefidx_vbuyy
tza
tax
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuzz
tza
tay
lda {c2},y
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=pbuc2_derefidx_vbuzz
tza
tay
lda {c2},y
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=pbuc2_derefidx_vbuzz
tza
tax
lda {c2},x
sta {c1},y
//FRAGMENT vbuaa_eq_vbuc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbuaa=vbuz1_plus_1
lda {z1}
inc
//FRAGMENT vbuxx=vbuz1_plus_1
ldx {z1}
inx
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
//FRAGMENT vbuaa_eq__deref_pbuc1_then_la1
cmp {c1}
beq {la1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuxx
lda {c2},x
sta {c1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuyy
lda {c2},y
sta {c1}
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuzz
tza
tay
lda {c2},y
sta {c1}
//FRAGMENT vbuxx_neq_0_then_la1
cpx #0
bne {la1}
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
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
//FRAGMENT vbuzz=vbuc1
ldz #{c1}
//FRAGMENT vbuzz_lt_vbuc1_then_la1
cpz #{c1}
bcc {la1}
//FRAGMENT vbuzz=_inc_vbuzz
inz
//FRAGMENT vbuyy_neq_0_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuzz_neq_0_then_la1
cpz #0
bne {la1}
//FRAGMENT vbuaa=_dec_vbuaa
sec
sbc #1
//FRAGMENT vbuaa=_inc_vbuaa
inc
//FRAGMENT vbuxx=_dec_vbuxx
dex
//FRAGMENT vbuyy=_dec_vbuyy
dey
//FRAGMENT vbuzz=_dec_vbuzz
dez
//FRAGMENT pbuc1_derefidx_vbuxx=vbuzz
tza
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuzz
tza
sta {c1},y
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuxx_eq__deref_pbuc1_then_la1
cpx {c1}
beq {la1}
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT vbuyy_eq__deref_pbuc1_then_la1
cpy {c1}
beq {la1}
//FRAGMENT vbuzz=_deref_pbuc1
ldz {c1}
//FRAGMENT vbuzz_eq__deref_pbuc1_then_la1
cpz {c1}
beq {la1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuzz=vbuz1
ldz {z1}
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbuzz_neq_vbuc1_then_la1
cpz #{c1}
bne {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuzz
tza
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuzz_eq_vbuc1_then_la1
cpz #{c1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuxx=vbuaa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=vbuyy
tya
sta {c1},x
//FRAGMENT vbuyy=vbuz1_plus_1
ldy {z1}
iny
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuzz
tza
tay
lda {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbuzz
tza
tax
ldy {c1},x
//FRAGMENT vbuaa=vbuaa_plus_1
inc
//FRAGMENT vbuaa=vbuyy_plus_1
tya
inc
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT _deref_pbuc1=vbuzz
stz {c1}
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuc1_eq_vbuz1_then_la1
lda {c1}
cmp {z1}
beq {la1}
//FRAGMENT _deref_pbuc1=_dec__deref_pbuc1
dec {c1}
//FRAGMENT pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1
ldx {z1}
inc {c1},x
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_lo_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_hi_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT _deref_pwuc1=vwuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT _deref_qbuc1=pbuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT _deref_pbuc1_eq_vbuaa_then_la1
cmp {c1}
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuaa=_inc_pbuc1_derefidx_vbuaa
tax
inc {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=_inc_pbuc1_derefidx_vbuxx
inc {c1},x
//FRAGMENT vbuaa=_lo_vwuz1
lda {z1}
//FRAGMENT vbuxx=_lo_vwuz1
ldx {z1}
//FRAGMENT vbuaa=_hi_vwuz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_vwuz1
ldx {z1}+1
//FRAGMENT vbuz1=vbuxx_bor_vbuz2
txa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuyy_bor_vbuz2
tya
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuzz_bor_vbuz2
tza
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
//FRAGMENT vbuz1=vbuzz_bor_vbuaa
tay
tza
sty $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuxx
txa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_bor_vbuxx
stx {z1}
//FRAGMENT vbuyy=_lo_vwuz1
ldy {z1}
//FRAGMENT vbuzz=_lo_vwuz1
ldz {z1}
//FRAGMENT vbuyy=_hi_vwuz1
ldy {z1}+1
//FRAGMENT vbuzz=_hi_vwuz1
ldz {z1}+1
//FRAGMENT vbuz1=vbuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuyy=_inc_pbuc1_derefidx_vbuyy
lda {c1},y
inc
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuzz=_inc_pbuc1_derefidx_vbuzz
tza
tax
inc {c1},x
//FRAGMENT _deref_pbuc1_eq_vbuxx_then_la1
cpx {c1}
beq {la1}
//FRAGMENT _deref_pbuc1_eq_vbuyy_then_la1
cpy {c1}
beq {la1}
//FRAGMENT _deref_pbuc1_eq_vbuzz_then_la1
cpz {c1}
beq {la1}
//FRAGMENT vbuaa=vbuz1_bor_vbuaa
ora {z1}
//FRAGMENT vbuxx=vbuz1_bor_vbuaa
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuaa
ora {z1}
tay
//FRAGMENT vbuzz=vbuz1_bor_vbuaa
ora {z1}
taz
//FRAGMENT vbuz1=vbuz2_bor_vbuzz
tza
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuaa
stx $ff
ora $ff
//FRAGMENT vbuaa=vbuyy_bor_vbuaa
sty $ff
ora $ff
//FRAGMENT vbuaa=vbuzz_bor_vbuaa
tay
tza
sty $ff
ora $ff
