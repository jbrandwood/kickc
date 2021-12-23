//KICKC FRAGMENT CACHE ce6972ebb ce69753d3
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
//FRAGMENT vbuz1=vbuc1
ldz #{c1}
stz {z1}
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT vbuz1_eq_vbuc1_then_la1
ldz #{c1}
cpz {z1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuz3
lda {z3}
ldz {z2}
sta ({z1}),z
//FRAGMENT pbuz1_derefidx_vbuz2=vbuc1
lda #{c1}
ldz {z2}
sta ({z1}),z
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
ldz #{c1}
cpz {z1}
bne {la1}
//FRAGMENT pprz1=pprc1
lda #<{c1}
sta {z1}
lda #>{c1}
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
//FRAGMENT pbuz1=pbuc1_plus_vwuz2
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
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT pbuz1=_inc_pbuz1
inw {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT _stackpushbyte_=vbuz1
lda {z1}
pha
//FRAGMENT call__deref_pprz1
jsr {la1}
{la1}: @outside_flow
jmp ({z1})  @outside_flow
//FRAGMENT _stackpullbyte_1
pla
//FRAGMENT _deref_pbuc1=vbuc2
ldz #{c2}
stz {c1}
//FRAGMENT vduz1=vduc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda #<{c1}>>$10
sta {z1}+2
lda #>{c1}>>$10
sta {z1}+3
//FRAGMENT pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1
ldx {z1}
inc {c1},x
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1
ldy {z1}
lda {c1},y
cmp #{c2}
beq {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT vduz1=_inc_vduz1
inc {z1}
bne !+
inc {z1}+1
bne !+
inc {z1}+2
bne !+
inc {z1}+3
!:
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
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
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
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
//FRAGMENT _deref_pbuz1=vbuc1
lda #{c1}
ldy #0
sta ({z1}),y
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
//FRAGMENT vwuz1=vwuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbsz1=_sbyte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT vbsz1=_inc_vbsz1
inc {z1}
//FRAGMENT vbsz1=vbsz2_minus_vbsz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbsz1_ge_0_then_la1
lda {z1}
cmp #0
bpl {la1}
//FRAGMENT vbsz1=vbsc1
ldz #{c1}
stz {z1}
//FRAGMENT 0_neq_vbsz1_then_la1
lda {z1}
cmp #0
bne {la1}
//FRAGMENT pprz1=pprz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_minus_1
ldx {z2}
dex
stx {z1}
//FRAGMENT vbuz1_le_vbuz2_then_la1
lda {z2}
cmp {z1}
bcs {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuz2_then_la1
ldy {z1}
lda {c1},y
cmp {z2}
beq {la1}
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT vbuz1=vbuz2_minus_vbuz3
lda {z2}
sec
sbc {z3}
sta {z1}
//FRAGMENT vbuz1_neq_vbuz2_then_la1
lda {z1}
cmp {z2}
bne {la1}
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
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
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
//FRAGMENT vwuz1=vwuz1_minus_vwuz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT 0_neq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
bne {la1}
//FRAGMENT vwuz1=_inc_vwuz1
inw {z1}
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
ldz #{c1}
cpz {z1}
bcs {la1}
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
//FRAGMENT vbuz1_ge_vbuz2_then_la1
lda {z1}
cmp {z2}
bcs {la1}
//FRAGMENT vbuz1=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
sta {z1}
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
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
//FRAGMENT vbuzz=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
taz
//FRAGMENT vbuaa_eq_vbuc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT pbuz1_derefidx_vbuz2=vbuaa
ldz {z2}
sta ({z1}),z
//FRAGMENT pbuz1_derefidx_vbuz2=vbuxx
txa
ldz {z2}
sta ({z1}),z
//FRAGMENT pbuz1_derefidx_vbuz2=vbuyy
tya
ldz {z2}
sta ({z1}),z
//FRAGMENT pbuz1_derefidx_vbuz2=vbuzz
tza
ldz {z2}
sta ({z1}),z
//FRAGMENT vbuz1=vbuaa
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
//FRAGMENT pbuz1_derefidx_vbuaa=vbuc1
taz
lda #{c1}
sta ({z1}),z
//FRAGMENT pbuz1_derefidx_vbuxx=vbuc1
txa
taz
lda #{c1}
sta ({z1}),z
//FRAGMENT pbuz1_derefidx_vbuyy=vbuc1
lda #{c1}
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuzz=vbuc1
lda #{c1}
sta ({z1}),z
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
//FRAGMENT 0_neq_vbuaa_then_la1
cmp #0
bne {la1}
//FRAGMENT _stackpushbyte_=vbuaa
pha
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
//FRAGMENT 0_eq_vbuaa_then_la1
cmp #0
beq {la1}
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
//FRAGMENT _deref_pbuz1=pbuc1_derefidx_vbuzz
tza
tay
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
//FRAGMENT vbuzz=vbuz1_rol_1
lda {z1}
asl
taz
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
//FRAGMENT vbuzz=vbuaa_rol_1
asl
taz
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
//FRAGMENT vbuzz=vbuxx_rol_1
txa
asl
taz
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
//FRAGMENT vbuzz=vbuyy_rol_1
tya
asl
taz
//FRAGMENT vbuz1=vbuzz_rol_1
tza
asl
sta {z1}
//FRAGMENT vbuaa=vbuzz_rol_1
tza
asl
//FRAGMENT vbuxx=vbuzz_rol_1
tza
asl
tax
//FRAGMENT vbuyy=vbuzz_rol_1
tza
asl
tay
//FRAGMENT vbuzz=vbuzz_rol_1
tza
asl
taz
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
//FRAGMENT vwuz1=pwuc1_derefidx_vbuzz
tza
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
//FRAGMENT vbsaa=_sbyte_vwuz1
lda {z1}
//FRAGMENT vbsxx=_sbyte_vwuz1
ldx {z1}
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
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
//FRAGMENT vbsz1=vbsz2_minus_vbszz
tza
eor #$ff
sec
adc {z2}
sta {z1}
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
//FRAGMENT vbsz1=vbsxx_minus_vbszz
txa
stz $ff
sec
sbc $ff
sta {z1}
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
//FRAGMENT vbsz1=vbsyy_minus_vbszz
tya
stz $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbsz1=vbszz_minus_vbsz2
tza
sec
sbc {z2}
sta {z1}
//FRAGMENT vbsz1=vbszz_minus_vbsaa
tay
tza
sty $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbsz1=vbszz_minus_vbsxx
tza
stx $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbsz1=vbszz_minus_vbsyy
tza
sty $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbsz1=vbszz_minus_vbszz
tza
lda #0
sta {z1}
//FRAGMENT _stackpushbyte_=vbuxx
txa
pha
//FRAGMENT _stackpushbyte_=vbuyy
tya
pha
//FRAGMENT _stackpushbyte_=vbuzz
tza
pha
//FRAGMENT vbuz1=vbuaa_minus_1
sec
sbc #1
sta {z1}
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
//FRAGMENT pbuc1_derefidx_vbuzz_eq_vbuz1_then_la1
tza
tay
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
//FRAGMENT pbuc1_derefidx_vbuzz_eq_vbuaa_then_la1
tax
tza
tay
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
//FRAGMENT pbuc1_derefidx_vbuzz_eq_vbuxx_then_la1
tza
tay
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
//FRAGMENT pbuc1_derefidx_vbuzz_eq_vbuyy_then_la1
tza
tax
lda {c1},x
tax
sty $ff
cpx $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_eq_vbuzz_then_la1
ldy {z1}
lda {c1},y
sta $ff
cpz $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuaa_eq_vbuzz_then_la1
tay
lda {c1},y
sta $ff
cpz $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuxx_eq_vbuzz_then_la1
lda {c1},x
sta $ff
cpz $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuyy_eq_vbuzz_then_la1
lda {c1},y
sta $ff
cpz $ff
beq  {la1}
//FRAGMENT pbuc1_derefidx_vbuzz_eq_vbuzz_then_la1
tza
tay
lda {c1},y
sta $ff
cpz $ff
beq  {la1}
//FRAGMENT vbuaa_lt_vbuz1_then_la1
cmp {z1}
bcc {la1}
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
//FRAGMENT vbuz1=vbuzz_minus_vbuz2
tza
sec
sbc {z2}
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
//FRAGMENT vbuaa=vbuzz_minus_vbuz1
tza
sec
sbc {z1}
//FRAGMENT vbuxx=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
tax
//FRAGMENT vbuxx=vbuaa_minus_vbuz1
sec
sbc {z1}
tax
//FRAGMENT vbuxx=vbuxx_minus_vbuz1
txa
sec
sbc {z1}
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
tax
//FRAGMENT vbuxx=vbuzz_minus_vbuz1
tza
sec
sbc {z1}
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
//FRAGMENT vbuyy=vbuzz_minus_vbuz1
tza
sec
sbc {z1}
tay
//FRAGMENT vbuzz=vbuz1_minus_vbuz2
lda {z1}
sec
sbc {z2}
taz
//FRAGMENT vbuzz=vbuaa_minus_vbuz1
sec
sbc {z1}
taz
//FRAGMENT vbuzz=vbuxx_minus_vbuz1
txa
sec
sbc {z1}
taz
//FRAGMENT vbuzz=vbuyy_minus_vbuz1
tya
sec
sbc {z1}
taz
//FRAGMENT vbuzz=vbuzz_minus_vbuz1
tza
sec
sbc {z1}
taz
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
//FRAGMENT vbuz1=vbuzz_minus_vbuxx
tza
stx $ff
sec
sbc $ff
sta {z1}
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
//FRAGMENT vbuaa=vbuzz_minus_vbuxx
tza
stx $ff
sec
sbc $ff
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
//FRAGMENT vbuxx=vbuxx_minus_vbuxx
lda #0
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuzz_minus_vbuxx
tza
stx $ff
sec
sbc $ff
tax
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
//FRAGMENT vbuyy=vbuzz_minus_vbuxx
tza
stx $ff
sec
sbc $ff
tay
//FRAGMENT vbuzz=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
taz
//FRAGMENT vbuzz=vbuaa_minus_vbuxx
stx $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuxx_minus_vbuxx
lda #0
taz
//FRAGMENT vbuzz=vbuyy_minus_vbuxx
tya
stx $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuzz_minus_vbuxx
tza
stx $ff
sec
sbc $ff
taz
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
//FRAGMENT vbuz1=vbuzz_minus_vbuyy
tza
sty $ff
sec
sbc $ff
sta {z1}
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
//FRAGMENT vbuaa=vbuzz_minus_vbuyy
tza
sty $ff
sec
sbc $ff
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
//FRAGMENT vbuxx=vbuxx_minus_vbuyy
txa
sty $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuyy
lda #0
tax
//FRAGMENT vbuxx=vbuzz_minus_vbuyy
tza
sty $ff
sec
sbc $ff
tax
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
//FRAGMENT vbuyy=vbuzz_minus_vbuyy
tza
sty $ff
sec
sbc $ff
tay
//FRAGMENT vbuzz=vbuz1_minus_vbuyy
tya
eor #$ff
sec
adc {z1}
taz
//FRAGMENT vbuzz=vbuaa_minus_vbuyy
sty $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuxx_minus_vbuyy
txa
sty $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuyy_minus_vbuyy
lda #0
taz
//FRAGMENT vbuzz=vbuzz_minus_vbuyy
tza
sty $ff
sec
sbc $ff
taz
//FRAGMENT vbuz1=vbuz2_minus_vbuzz
tza
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbuz1=vbuaa_minus_vbuzz
stz $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuxx_minus_vbuzz
txa
stz $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuyy_minus_vbuzz
tya
stz $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuz1=vbuzz_minus_vbuzz
tza
lda #0
sta {z1}
//FRAGMENT vbuaa=vbuz1_minus_vbuzz
tza
eor #$ff
sec
adc {z1}
//FRAGMENT vbuaa=vbuaa_minus_vbuzz
stz $ff
sec
sbc $ff
//FRAGMENT vbuaa=vbuxx_minus_vbuzz
txa
stz $ff
sec
sbc $ff
//FRAGMENT vbuaa=vbuyy_minus_vbuzz
tya
stz $ff
sec
sbc $ff
//FRAGMENT vbuaa=vbuzz_minus_vbuzz
tza
lda #0
//FRAGMENT vbuxx=vbuz1_minus_vbuzz
tza
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbuxx=vbuaa_minus_vbuzz
stz $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuxx_minus_vbuzz
txa
stz $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuyy_minus_vbuzz
tya
stz $ff
sec
sbc $ff
tax
//FRAGMENT vbuxx=vbuzz_minus_vbuzz
tza
lda #0
tax
//FRAGMENT vbuyy=vbuz1_minus_vbuzz
tza
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbuyy=vbuaa_minus_vbuzz
stz $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuxx_minus_vbuzz
txa
stz $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuyy_minus_vbuzz
tya
stz $ff
sec
sbc $ff
tay
//FRAGMENT vbuyy=vbuzz_minus_vbuzz
tza
lda #0
tay
//FRAGMENT vbuzz=vbuz1_minus_vbuzz
tza
eor #$ff
sec
adc {z1}
taz
//FRAGMENT vbuzz=vbuaa_minus_vbuzz
stz $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuxx_minus_vbuzz
txa
stz $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuyy_minus_vbuzz
tya
stz $ff
sec
sbc $ff
taz
//FRAGMENT vbuzz=vbuzz_minus_vbuzz
tza
lda #0
taz
//FRAGMENT vbuxx_lt_vbuz1_then_la1
cpx {z1}
bcc {la1}
//FRAGMENT vbuz1_neq_vbuaa_then_la1
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=vbuz2_minus_vbuaa
eor #$ff
sec
adc {z2}
sta {z1}
//FRAGMENT vbuxx=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
tax
//FRAGMENT vbuyy=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
tay
//FRAGMENT vbuzz=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
taz
//FRAGMENT vbuz1=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
sta {z1}
//FRAGMENT vbuxx=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
tax
//FRAGMENT vbuyy=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
tay
//FRAGMENT vbuzz=vbuxx_minus_vbuaa
sta $ff
txa
sec
sbc $ff
taz
//FRAGMENT vbuz1=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
sta {z1}
//FRAGMENT vbuxx=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
tax
//FRAGMENT vbuyy=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
tay
//FRAGMENT vbuzz=vbuyy_minus_vbuaa
sta $ff
tya
sec
sbc $ff
taz
//FRAGMENT vbuz1=vbuzz_minus_vbuaa
tay
tza
sty $ff
sec
sbc $ff
sta {z1}
//FRAGMENT vbuxx=vbuzz_minus_vbuaa
tax
tza
stx $ff
sec
sbc $ff
tax
//FRAGMENT vbuyy=vbuzz_minus_vbuaa
tay
tza
sty $ff
sec
sbc $ff
tay
//FRAGMENT vbuzz=vbuzz_minus_vbuaa
tay
tza
sty $ff
sec
sbc $ff
taz
//FRAGMENT vbuaa=_byte_vduz1
lda {z1}
//FRAGMENT vbuxx=_byte_vduz1
lda {z1}
tax
//FRAGMENT vbuyy=_byte_vduz1
lda {z1}
tay
//FRAGMENT vbuzz=_byte_vduz1
lda {z1}
taz
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
//FRAGMENT vbuz1=vbuzz_rol_2
tza
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
//FRAGMENT vbuaa=vbuzz_rol_2
tza
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
//FRAGMENT vbuxx=vbuzz_rol_2
tza
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
//FRAGMENT vbuyy=vbuzz_rol_2
tza
asl
asl
tay
//FRAGMENT vbuzz=vbuz1_rol_2
lda {z1}
asl
asl
taz
//FRAGMENT vbuzz=vbuaa_rol_2
asl
asl
taz
//FRAGMENT vbuzz=vbuxx_rol_2
txa
asl
asl
taz
//FRAGMENT vbuzz=vbuyy_rol_2
tya
asl
asl
taz
//FRAGMENT vbuzz=vbuzz_rol_2
tza
asl
asl
taz
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
//FRAGMENT vduz1=pduc1_derefidx_vbuzz
tza
tay
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
lda {c1}+2,y
sta {z1}+2
lda {c1}+3,y
sta {z1}+3
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
//FRAGMENT _deref_pbuz1=vbuaa
ldy #0
sta ({z1}),y
//FRAGMENT vbuaa_le_vbuc1_then_la1
cmp #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuaa=vbuaa_plus_vbuc1
clc
adc #{c1}
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
//FRAGMENT vbuaa_ge_vbuz1_then_la1
cmp {z1}
bcs {la1}
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuz1=vbuz1_minus_vbuaa
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_vbuxx
txa
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_vbuyy
tya
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuz1=vbuz1_minus_vbuzz
tza
eor #$ff
sec
adc {z1}
sta {z1}
//FRAGMENT vbuxx_lt_vbuc1_then_la1
cpx #{c1}
bcc {la1}
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
//FRAGMENT vbuzz_le_vbuz1_then_la1
ldy {z1}
tza
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuz1_le_vbuaa_then_la1
cmp {z1}
bcs {la1}
//FRAGMENT vbuxx_ge_vbuz1_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuzz=vbuz1
ldz {z1}
//FRAGMENT vbuz1=vbuzz
stz {z1}
//FRAGMENT vbuzz_ge_vbuz1_then_la1
cpz {z1}
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
//FRAGMENT vbuzz_ge_vbuxx_then_la1
stx $ff
cpz $ff
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
//FRAGMENT vbuzz_ge_vbuyy_then_la1
sty $ff
cpz $ff
bcs {la1}
//FRAGMENT vbuz1_ge_vbuzz_then_la1
ldy {z1}
tza
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT vbuxx_ge_vbuzz_then_la1
tza
tay
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuaa=vbuzz
tza
//FRAGMENT vbuxx=vbuzz
tza
tax
//FRAGMENT vbuxx_le_vbuc1_then_la1
cpx #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT vbuyy_lt_vbuc1_then_la1
cpy #{c1}
bcc {la1}
//FRAGMENT vbuyy_le_vbuc1_then_la1
cpy #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuzz_le_vbuc1_then_la1
cpz #{c1}
bcc {la1}
beq {la1}
//FRAGMENT vbuaa=vbuyy
tya
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuxx=vbuyy
tya
tax
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT vbuyy=vbuxx
txa
tay
//FRAGMENT vbuyy=vbuzz
tza
tay
//FRAGMENT vbuzz=vbuaa
taz
//FRAGMENT vbuzz=vbuxx
txa
taz
//FRAGMENT vbuzz=vbuyy
tya
taz
//FRAGMENT vbuyy_ge_vbuz1_then_la1
cpy {z1}
bcs {la1}
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT 0_neq_vbuzz_then_la1
cpz #0
bne {la1}
//FRAGMENT vbuyy_ge_vbuxx_then_la1
stx $ff
cpy $ff
bcs {la1}
//FRAGMENT vbsxx=_inc_vbsxx
inx
//FRAGMENT vbsyy=_sbyte_vwuz1
ldy {z1}
//FRAGMENT vbsyy=_inc_vbsyy
iny
//FRAGMENT vbszz=_sbyte_vwuz1
ldz {z1}
//FRAGMENT vbszz=_inc_vbszz
inz
//FRAGMENT 0_eq_vbuzz_then_la1
cpz #0
beq {la1}
//FRAGMENT vbuz1_neq_vbuxx_then_la1
cpx {z1}
bne {la1}
//FRAGMENT vbuz1_neq_vbuyy_then_la1
cpy {z1}
bne {la1}
//FRAGMENT vbuz1_neq_vbuzz_then_la1
cpz {z1}
bne {la1}
//FRAGMENT vbuxx_neq_vbuz1_then_la1
cpx {z1}
bne {la1}
//FRAGMENT vbuxx_neq_vbuaa_then_la1
tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuxx_neq_vbuyy_then_la1
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuxx_neq_vbuzz_then_la1
tza
tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuyy_neq_vbuz1_then_la1
cpy {z1}
bne {la1}
//FRAGMENT vbuyy_neq_vbuaa_then_la1
tax
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuyy_neq_vbuxx_then_la1
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuyy_neq_vbuzz_then_la1
tza
tax
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuzz_neq_vbuz1_then_la1
cpz {z1}
bne {la1}
//FRAGMENT vbuzz_neq_vbuaa_then_la1
tax
tza
tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuzz_neq_vbuxx_then_la1
tza
tay
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuzz_neq_vbuyy_then_la1
tza
tax
stx $ff
cpy $ff
bne {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx
lda {c1},x
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuyy_lt_vbuz1_then_la1
cpy {z1}
bcc {la1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuzz
tza
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuzz_lt_vbuz1_then_la1
cpz {z1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1_minus_1
lda {z1}
sec
sbc #1
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
beq {la1}
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT vbuzz=_deref_pbuc1
ldz {c1}
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuzz_eq_vbuc1_then_la1
cpz #{c1}
beq {la1}
//FRAGMENT vbuyy_le_vbuaa_then_la1
sty $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx=vbuz1_minus_1
ldx {z1}
dex
//FRAGMENT vbuyy_le_vbuxx_then_la1
sty $ff
cpx $ff
bcs  {la1}
//FRAGMENT vbuzz=vbuz1_minus_1
lda {z1}
taz
dez
//FRAGMENT vbuyy_le_vbuzz_then_la1
sty $ff
cpz $ff
bcs {la1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy
ldx {c1},y
//FRAGMENT vbuzz=pbuc1_derefidx_vbuyy
lda {c1},y
taz
//FRAGMENT vbuaa_lt_vbuzz_then_la1
stz $ff
cmp $ff
bcc {la1}
//FRAGMENT vbuxx=vbuzz_minus_1
tza
tax
dex
//FRAGMENT vbuyy_lt_vbuzz_then_la1
stz $ff
cpy $ff
bcc {la1}
//FRAGMENT vbuyy=_byte_vwuz1
ldy {z1}
//FRAGMENT vbuzz=_byte_vwuz1
lda {z1}
taz
//FRAGMENT vwuz1=vwuz2_plus_vwuz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_vwuz1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_rol_3
asw {z1}
asw {z1}
asw {z1}
