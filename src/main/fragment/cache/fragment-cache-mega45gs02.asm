//KICKC FRAGMENT CACHE 1813f9ad84 1813f9c5cd
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1=_inc_pbuz1
inw {z1}
//FRAGMENT vbuc1_neq_vbuz1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz3
lda {z3}
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
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
//FRAGMENT pbuz1=pbuz2_plus_vbuc1
lda #{c1}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1=vbuz2
lda {z2}
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
//FRAGMENT vbuzz=_deref_pbuz1
ldy #0
lda ({z1}),y
taz
//FRAGMENT vbuc1_neq_vbuaa_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbuz1=vbuaa
sta {z1}
//FRAGMENT vbuaa_eq_vbuc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuaa
ldy {z2}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuz2=vbuxx
txa
ldz {z2}
sta ({z1}),z
//FRAGMENT _deref_pbuz1=vbuxx
txa
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=vbuyy
tya
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=vbuzz
tza
ldy #0
sta ({z1}),y
//FRAGMENT vbuxx=vbuc1
ldx #{c1}
//FRAGMENT vbuzz=vbuc1
ldz #{c1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuyy
tya
ldy {z2}
sta ({z1}),y
//FRAGMENT vbuzz=vbuz1
ldz {z1}
//FRAGMENT vbuzz_eq_vbuc1_then_la1
cpz #{c1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuzz
tza
ldz {z2}
sta ({z1}),z
//FRAGMENT vbuc1_neq_vbuxx_then_la1
cpx #{c1}
bne {la1}
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuc1_neq_vbuyy_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vbuaa=vbuyy
tya
//FRAGMENT vbuc1_neq_vbuzz_then_la1
cpz #{c1}
bne {la1}
//FRAGMENT vbuaa=vbuzz
tza
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT _deref_pbuc1=_deref_pbuc2
lda {c2}
sta {c1}
//FRAGMENT vwuz1=vwuc1_minus_vbuz2
sec
lda #<{c1}
sbc {z2}
sta {z1}
lda #>{c1}
sbc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_ror_5
lda {z2}
lsr
lsr
lsr
lsr
lsr
sta {z1}
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
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=_lo_vwuz2
lda {z2}
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vbuz1=vbuz2_rol_4
lda {z2}
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=_hi_vwuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=vbuz2_band_vbuc1
lda #{c1}
and {z2}
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vwuz1=vwuc1_minus_vbuaa
tax
stx $ff
lda #<{c1}
sec
sbc $ff
sta {z1}
lda #>{c1}
sbc #00
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_minus_vbuxx
stx $ff
lda #<{c1}
sec
sbc $ff
sta {z1}
lda #>{c1}
sbc #00
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_minus_vbuyy
tya
tax
stx $ff
lda #<{c1}
sec
sbc $ff
sta {z1}
lda #>{c1}
sbc #00
sta {z1}+1
//FRAGMENT vwuz1=vwuc1_minus_vbuzz
tza
tax
stx $ff
lda #<{c1}
sec
sbc $ff
sta {z1}
lda #>{c1}
sbc #00
sta {z1}+1
//FRAGMENT vbuz1=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuz1=vbuzz_ror_5
tza
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuz1_ror_5
lda {z1}
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuaa=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuaa=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuaa=vbuzz_ror_5
tza
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuz1_ror_5
lda {z1}
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuxx=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuxx=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuxx=vbuzz_ror_5
tza
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuz1_ror_5
lda {z1}
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuyy=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuyy=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuyy=vbuzz_ror_5
tza
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuzz=vbuz1_ror_5
lda {z1}
lsr
lsr
lsr
lsr
lsr
taz
//FRAGMENT vbuzz=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
taz
//FRAGMENT vbuzz=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
taz
//FRAGMENT vbuzz=vbuzz_ror_5
tza
lsr
lsr
lsr
lsr
lsr
taz
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
//FRAGMENT vbuzz=vbuc1_rol_vbuz1
lda #{c1}
ldy {z1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
taz
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
//FRAGMENT vbuzz=vbuc1_rol_vbuaa
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
taz
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
//FRAGMENT vbuzz=vbuc1_rol_vbuxx
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
taz
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
//FRAGMENT vbuzz=vbuc1_rol_vbuyy
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
taz
//FRAGMENT vbuz1=vbuc1_rol_vbuzz
tza
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
//FRAGMENT vbuaa=vbuc1_rol_vbuzz
tza
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
//FRAGMENT vbuxx=vbuc1_rol_vbuzz
tza
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
//FRAGMENT vbuyy=vbuc1_rol_vbuzz
tza
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
//FRAGMENT vbuzz=vbuc1_rol_vbuzz
tza
tay
lda #{c1}
cpy #0
beq !e+
!:
asl
dey
bne !-
!e:
taz
//FRAGMENT vbuaa=_lo_vwuz1
lda {z1}
//FRAGMENT vbuxx=_lo_vwuz1
ldx {z1}
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
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
//FRAGMENT vbuaa=_hi_vwuz1
lda {z1}+1
//FRAGMENT vbuxx=_hi_vwuz1
ldx {z1}+1
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
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuyy=_lo_vwuz1
ldy {z1}
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuzz=_lo_vwuz1
ldz {z1}
//FRAGMENT _deref_pbuc1=vbuzz
stz {c1}
//FRAGMENT vbuyy=_hi_vwuz1
ldy {z1}+1
//FRAGMENT vbuzz=_hi_vwuz1
ldz {z1}+1
//FRAGMENT vbuz1=vbuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuz1=vbuzz
tza
sta {z1}
//FRAGMENT vbuyy=vbuc1
ldy #{c1}
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
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT vbuzz=vbuaa
taz
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuz1_then_la1
lda #{c1}
ldy {z1}
cmp {c2},y
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz1
ldy {z1}
tya
sta {c1},y
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuaa_then_la1
tay
lda #{c1}
cmp {c2},y
bne {la1}
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuxx_then_la1
lda {c2},x
cmp #{c1}
bne {la1}
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuyy_then_la1
lda #{c1}
cmp {c2},y
bne {la1}
//FRAGMENT vbuc1_neq_pbuc2_derefidx_vbuzz_then_la1
tza
tay
lda #{c1}
cmp {c2},y
bne {la1}
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
//FRAGMENT pbuc1_derefidx_vbuxx=vbuxx
txa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuyy
tya
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuzz=vbuzz
tza
tax
sta {c1},x
//FRAGMENT vbuxx=_inc_vbuxx
inx
//FRAGMENT vbuyy=_inc_vbuyy
iny
//FRAGMENT vbuzz=_inc_vbuzz
inz
//FRAGMENT vduz1=vduc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda #<{c1}>>$10
sta {z1}+2
lda #>{c1}>>$10
sta {z1}+3
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT _deref_pduc1=vduz1
ldq {z1}
stq {c1}
//FRAGMENT vduz1=vduz1_plus_vduz2
clc
ldq {z1}
adcq {z2}
stq {z1}
//FRAGMENT vduz1=vduz1_plus_vbuz2
lda {z2}
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
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT vduz1=vwuc1
NO_SYNTHESIS
//FRAGMENT vduz1=vwsc1
NO_SYNTHESIS
