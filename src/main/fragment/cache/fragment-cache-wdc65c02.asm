//KICKC FRAGMENT CACHE ce6972ebb ce69753d3
//FRAGMENT vbuz1=_deref_pbuc1
lda {c1}
sta {z1}
//FRAGMENT vbuz1=vbuz2_plus_1
lda {z2}
inc
sta {z1}
//FRAGMENT _deref_pbuc1=vbuz1
lda {z1}
sta {c1}
//FRAGMENT vbuaa=_deref_pbuc1
lda {c1}
//FRAGMENT vbuxx=_deref_pbuc1
ldx {c1}
//FRAGMENT vbuz1=vbuaa_plus_1
inc
sta {z1}
//FRAGMENT vbuz1=vbuxx_plus_1
inx
stx {z1}
//FRAGMENT _deref_pbuc1=vbuaa
sta {c1}
//FRAGMENT vbuyy=_deref_pbuc1
ldy {c1}
//FRAGMENT vbuz1=vbuyy_plus_1
iny
sty {z1}
//FRAGMENT vbuaa=vbuz1_plus_1
lda {z1}
inc
//FRAGMENT vbuaa=vbuaa_plus_1
inc
//FRAGMENT vbuaa=vbuxx_plus_1
txa
inc
//FRAGMENT vbuaa=vbuyy_plus_1
tya
inc
//FRAGMENT vbuxx=vbuz1_plus_1
ldx {z1}
inx
//FRAGMENT _deref_pbuc1=vbuxx
stx {c1}
//FRAGMENT vbuxx=vbuaa_plus_1
tax
inx
//FRAGMENT vbuxx=vbuxx_plus_1
inx
//FRAGMENT vbuxx=vbuyy_plus_1
tya
inc
tax
//FRAGMENT vbuyy=vbuz1_plus_1
ldy {z1}
iny
//FRAGMENT _deref_pbuc1=vbuyy
sty {c1}
//FRAGMENT vbuyy=vbuaa_plus_1
tay
iny
//FRAGMENT vbuyy=vbuxx_plus_1
txa
inc
tay
//FRAGMENT vbuyy=vbuyy_plus_1
iny
//FRAGMENT vbuz1=vbuc1
lda #{c1}
sta {z1}
//FRAGMENT isr_rom_min_cx16_entry

//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuc2
lda #{c2}
and {c1}
sta {c1}
//FRAGMENT vbuz1_neq_vbuc1_then_la1
lda #{c1}
cmp {z1}
bne {la1}
//FRAGMENT vbuz1=_dec_vbuz1
dec {z1}
//FRAGMENT vbuz1_neq_0_then_la1
lda {z1}
bne {la1}
//FRAGMENT vbuz1_ge_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcs {la1}
//FRAGMENT vbuz1=_inc_vbuz1
inc {z1}
//FRAGMENT vbuz1=vbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1_lt_vbuc1_then_la1
lda {z1}
cmp #{c1}
bcc {la1}
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT isr_rom_min_cx16_exit
jmp $e049
//FRAGMENT pbuz1=pbuc1_plus_pbuc2_derefidx_vbuz2
ldy {z2}
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_plus_vbuc1
lda #{c1}
clc
adc {z1}
sta {z1}
//FRAGMENT pbuz1_derefidx_vbuz2=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta ({z1}),y
//FRAGMENT _deref_pbuc1=pbuc2_derefidx_vbuz1
ldy {z1}
lda {c2},y
sta {c1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT pbuz1=pbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
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
//FRAGMENT pbuz1=_inc_pbuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vbuaa_neq_vbuc1_then_la1
cmp #{c1}
bne {la1}
//FRAGMENT vbuaa=vbuz1
lda {z1}
//FRAGMENT vbuxx=vbuz1
ldx {z1}
//FRAGMENT vbuaa_lt_vbuc1_then_la1
cmp #{c1}
bcc {la1}
//FRAGMENT pbuz1=pbuc1_plus_pbuc2_derefidx_vbuaa
tay
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_pbuc2_derefidx_vbuxx
lda {c2},x
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
//FRAGMENT pbuz1=pbuc1_plus_pbuc2_derefidx_vbuyy
lda {c2},y
clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
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
//FRAGMENT pbuz1_derefidx_vbuaa=pbuc1_derefidx_vbuaa
tay
lda {c1},y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuxx=pbuc1_derefidx_vbuxx
txa
tay
lda {c1},y
sta ({z1}),y
//FRAGMENT pbuz1_derefidx_vbuyy=pbuc1_derefidx_vbuyy
lda {c1},y
sta ({z1}),y
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
//FRAGMENT vbuxx_neq_vbuc1_then_la1
cpx #{c1}
bne {la1}
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
//FRAGMENT vbuaa=vbuc1
lda #{c1}
//FRAGMENT vbuaa=_inc_vbuaa
inc
//FRAGMENT vbuyy_neq_vbuc1_then_la1
cpy #{c1}
bne {la1}
//FRAGMENT vwuz1=vwuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vbuz1_lt_vbuz2_then_la1
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT vbuz1=vbuz2_minus_1
ldx {z2}
dex
stx {z1}
//FRAGMENT vbuz1=_stackidxbyte_vbuc1
tsx
lda STACK_BASE+{c1},x
sta {z1}
//FRAGMENT vbuz1=vbuz2_rol_1
lda {z2}
asl
sta {z1}
//FRAGMENT pbuz1=pbuz2_plus_pwuc1_derefidx_vbuz3
ldy {z3}
clc
lda {z2}
adc {c1},y
sta {z1}
lda {z2}+1
adc {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_rol_1
ldy {z2}
lda {c1},y
asl
sta {z1}
//FRAGMENT pbuz1=pbuz2_plus_vbuz3
lda {z3}
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1_eq_vbuc1_then_la1
lda #{c1}
cmp {z1}
beq {la1}
//FRAGMENT vbuz1=_byte0_pbuz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_byte1_pbuz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuc1
lda #{c1}
ora {z2}
sta {z1}
//FRAGMENT pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1
ldx {z1}
inc {c1},x
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
//FRAGMENT 0_neq_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT vwuz1=_word_pbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vwuz1_neq_vwuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_neq_vbuz2_then_la1
lda {z2}
ldy {z1}
cmp {c1},y
bne {la1}
//FRAGMENT _deref_pssc1=_deref_pssc2_memcpy_vbuc3
ldy #{c3}
!:
lda {c2}-1,y
sta {c1}-1,y
dey
bne !-
//FRAGMENT vduz1=vbuc1
lda #{c1}
sta {z1}
lda #0
sta {z1}+1
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
//FRAGMENT vduz1=vwuc1
NO_SYNTHESIS
//FRAGMENT vduz1=vwsc1
NO_SYNTHESIS
//FRAGMENT _deref_pwuc1=vwuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT _deref_pwuc1=vbuc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT vbuz1=_deref_pbuc1_ror_7
lda {c1}
rol
rol
and #$01
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
//FRAGMENT pbuz1=qbuc1_derefidx_vbuz2
ldy {z2}
lda {c1},y
sta {z1}
lda {c1}+1,y
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2_band_vbuc1
lda #{c1}
ldy #0
and ({z2}),y
sta {z1}
//FRAGMENT vbuz1=vbuz2_ror_4
lda {z2}
lsr
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
//FRAGMENT vbuz1=vbuz2_ror_6
lda {z2}
rol
rol
rol
and #$03
sta {z1}
//FRAGMENT _deref_pbuz1=vbuz2
lda {z2}
ldy #0
sta ({z1}),y
//FRAGMENT vbuz1_le_vbuz2_then_la1
lda {z2}
cmp {z1}
bcs {la1}
//FRAGMENT 0_lt_vbuz1_then_la1
lda {z1}
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuz2
lda {z2}
ldy {z1}
sta {c1},y
//FRAGMENT vwuz1=_word_vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
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
//FRAGMENT pwuc1_derefidx_vbuz1=vwuz2
ldy {z1}
lda {z2}
sta {c1},y
lda {z2}+1
sta {c1}+1,y
//FRAGMENT vbuz1=pbuc1_derefidx_vbuz2_rol_4
ldy {z2}
lda {c1},y
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_pbuc1_derefidx_vbuz3
lda {z2}
ldy {z3}
ora {c1},y
sta {z1}
//FRAGMENT vwuz1=vwuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT _deref_pbuz1=_deref_pbuz1_band_vbuc1
lda #{c1}
ldy #0
and ({z1}),y
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=_deref_pbuz1
ldy #0
lda ({z1}),y
ldy #0
sta ({z1}),y
//FRAGMENT pbuz1=pbuz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz2_rol_4
lda {z2}
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_bor_vbuz3
lda {z2}
ora {z3}
sta {z1}
//FRAGMENT vbuz1_lt_vwuz2_then_la1
lda {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbuz1=vbuc2
lda #{c2}
ldy {z1}
sta {c1},y
lda #0
sta {c1}+1,y
//FRAGMENT pbuz1=pbuz1_plus_vwuz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=_deref_pbuz2
ldy #0
lda ({z2}),y
sta {z1}
//FRAGMENT _stackpushbyte_=vbuz1
lda {z1}
pha
//FRAGMENT call_vprc1
jsr {c1}
//FRAGMENT _stackpullbyte_1
pla
//FRAGMENT vbuz1=_byte0_vduz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_byte1_vduz2
lda {z2}+1
sta {z1}
//FRAGMENT vbuz1=_byte2_vduz2
lda {z2}+2
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
//FRAGMENT vbuz1=vbuz2_rol_3
lda {z2}
asl
asl
asl
sta {z1}
//FRAGMENT vbuz1=vbuz2_ror_5
lda {z2}
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vwuz1=_word0_vduz2
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
//FRAGMENT pbuz1=pbuz2_plus_vwuc1
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT vduz1_lt_vduz2_then_la1
lda {z1}+3
cmp {z2}+3
bcc {la1}
bne !+
lda {z1}+2
cmp {z2}+2
bcc {la1}
bne !+
lda {z1}+1
cmp {z2}+1
bcc {la1}
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT pbuz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT _deref_pbuc1=_deref_pbuz1
ldy #0
lda ({z1}),y
sta {c1}
//FRAGMENT vduz1=_inc_vduz1
inc {z1}
bne !+
inc {z1}+1
bne !+
inc {z1}+2
bne !+
inc {z1}+3
!:
//FRAGMENT _deref_pduc1=vduc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
lda #<{c2}>>$10
sta {c1}+2
lda #>{c2}>>$10
sta {c1}+3
//FRAGMENT pbuc1_derefidx_vbuz1_lt_vbuz2_then_la1
ldy {z1}
lda {c1},y
cmp {z2}
bcc {la1}
//FRAGMENT 0_neq_pbuc1_derefidx_vbuz1_then_la1
ldy {z1}
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT pbuc1_derefidx_vbuz1_lt_vwuz2_then_la1
ldy {z1}
lda {c1},y
ldy {z2}+1
bne {la1}
cmp {z2}
bcc {la1}
//FRAGMENT vbuz1=_byte_vwuz2
lda {z2}
sta {z1}
//FRAGMENT pbuz1=_deref_qbuc1
lda {c1}
sta {z1}
lda {c1}+1
sta {z1}+1
//FRAGMENT vwuz1=vbuz2_rol_vbuz3
lda {z2}
ldy {z3}
sta {z1}
lda #0
sta {z1}+1
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT pbuz1=pbuz2_plus_vwuz3
lda {z2}
clc
adc {z3}
sta {z1}
lda {z2}+1
adc {z3}+1
sta {z1}+1
//FRAGMENT pvoz1=pvoz2
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vbuz2
lda {z2}
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT 0_neq__deref_pbuz1_then_la1
ldy #0
lda ({z1}),y
cmp #0
bne {la1}
//FRAGMENT vwuz1=_inc_vwuz1
inc {z1}
bne !+
inc {z1}+1
!:
//FRAGMENT vwuz1_lt_vbuz2_then_la1
lda {z1}+1
bne !+
lda {z1}
cmp {z2}
bcc {la1}
!:
//FRAGMENT vbuz1=_byte0_pvoz2
lda {z2}
sta {z1}
//FRAGMENT vbuz1=_byte1_pvoz2
lda {z2}+1
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
//FRAGMENT _deref_pbuc1=_deref_pbuc2
lda {c2}
sta {c1}
//FRAGMENT vbuaa_lt_vbuz1_then_la1
cmp {z1}
bcc {la1}
//FRAGMENT vbuaa=vbuz1_minus_1
lda {z1}
sec
sbc #1
//FRAGMENT vbuz1=vbuaa
sta {z1}
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
//FRAGMENT pbuz1=pbuz2_plus_pwuc1_derefidx_vbuaa
tay
clc
lda {z2}
adc {c1},y
sta {z1}
lda {z2}+1
adc {c1}+1,y
sta {z1}+1
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
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_rol_1
ldy {z1}
lda {c1},y
asl
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_rol_1
ldx {z1}
lda {c1},x
asl
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_rol_1
ldy {z1}
lda {c1},y
asl
tay
//FRAGMENT pbuz1=pbuz2_plus_vbuaa
clc
adc {z2}
sta {z1}
lda #0
adc {z2}+1
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
//FRAGMENT vbuxx_eq_vbuc1_then_la1
cpx #{c1}
beq {la1}
//FRAGMENT vbuaa=_byte0_pbuz1
lda {z1}
//FRAGMENT vbuxx=_byte0_pbuz1
ldx {z1}
//FRAGMENT vbuaa=_byte1_pbuz1
lda {z1}+1
//FRAGMENT vbuxx=_byte1_pbuz1
ldx {z1}+1
//FRAGMENT vbuz1=vbuyy_bor_vbuc1
tya
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
//FRAGMENT vbuaa=vbuyy_bor_vbuc1
tya
ora #{c1}
//FRAGMENT vbuxx=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
tax
//FRAGMENT vbuxx=vbuyy_bor_vbuc1
tya
ora #{c1}
tax
//FRAGMENT vbuyy=vbuz1_bor_vbuc1
lda #{c1}
ora {z1}
tay
//FRAGMENT vbuyy=vbuyy_bor_vbuc1
tya
ora #{c1}
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
//FRAGMENT 0_neq_vbuaa_then_la1
cmp #0
bne {la1}
//FRAGMENT vbuaa=_deref_pbuc1_ror_7
lda {c1}
rol
rol
and #$01
//FRAGMENT vbuxx=_deref_pbuc1_ror_7
lda {c1}
rol
rol
and #$01
tax
//FRAGMENT vbuyy=_deref_pbuc1_ror_7
lda {c1}
rol
rol
and #$01
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
//FRAGMENT vbuaa=vbuc1_rol_vbuxx
lda #{c1}
cpx #0
beq !e+
!:
asl
dex
bne !-
!e:
//FRAGMENT vbuaa=vbuc1_rol_vbuyy
lda #{c1}
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
//FRAGMENT vbuaa=vbuz1_ror_6
lda {z1}
rol
rol
rol
and #$03
//FRAGMENT vbuxx=vbuz1_ror_6
lda {z1}
rol
rol
rol
and #$03
tax
//FRAGMENT vbuyy=vbuz1_ror_6
lda {z1}
rol
rol
rol
and #$03
tay
//FRAGMENT vbuz1=vbuaa_ror_6
rol
rol
rol
and #$03
sta {z1}
//FRAGMENT vbuaa=vbuaa_ror_6
rol
rol
rol
and #$03
//FRAGMENT vbuxx=vbuaa_ror_6
rol
rol
rol
and #$03
tax
//FRAGMENT vbuyy=vbuaa_ror_6
rol
rol
rol
and #$03
tay
//FRAGMENT vbuz1=vbuxx_ror_6
txa
rol
rol
rol
and #$03
sta {z1}
//FRAGMENT vbuaa=vbuxx_ror_6
txa
rol
rol
rol
and #$03
//FRAGMENT vbuxx=vbuxx_ror_6
txa
rol
rol
rol
and #$03
tax
//FRAGMENT vbuyy=vbuxx_ror_6
txa
rol
rol
rol
and #$03
tay
//FRAGMENT vbuz1=vbuyy_ror_6
tya
rol
rol
rol
and #$03
sta {z1}
//FRAGMENT vbuaa=vbuyy_ror_6
tya
rol
rol
rol
and #$03
//FRAGMENT vbuxx=vbuyy_ror_6
tya
rol
rol
rol
and #$03
tax
//FRAGMENT vbuyy=vbuyy_ror_6
tya
rol
rol
rol
and #$03
tay
//FRAGMENT _deref_pbuz1=vbuxx
txa
ldy #0
sta ({z1}),y
//FRAGMENT _deref_pbuz1=vbuyy
tya
ldy #0
sta ({z1}),y
//FRAGMENT vbuaa_le_vbuz1_then_la1
ldy {z1}
sta $ff
cpy $ff
bcs {la1}
//FRAGMENT pbuc1_derefidx_vbuz1=vbuxx
ldy {z1}
txa
sta {c1},y
//FRAGMENT vwuz1=_word_vbuxx
txa
sta {z1}
lda #0
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
//FRAGMENT vbuaa=pbuc1_derefidx_vbuz1_rol_4
ldy {z1}
lda {c1},y
asl
asl
asl
asl
//FRAGMENT vbuxx=pbuc1_derefidx_vbuz1_rol_4
ldx {z1}
lda {c1},x
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuz1_rol_4
ldy {z1}
lda {c1},y
asl
asl
asl
asl
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx_rol_4
lda {c1},x
asl
asl
asl
asl
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx_rol_4
lda {c1},x
asl
asl
asl
asl
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx_rol_4
lda {c1},x
asl
asl
asl
asl
tax
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx_rol_4
lda {c1},x
asl
asl
asl
asl
tay
//FRAGMENT vbuaa=vbuz1_bor_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
ora {c1},y
//FRAGMENT vbuxx=vbuz1_bor_pbuc1_derefidx_vbuz2
lda {z1}
ldx {z2}
ora {c1},x
tax
//FRAGMENT vbuyy=vbuz1_bor_pbuc1_derefidx_vbuz2
lda {z1}
ldy {z2}
ora {c1},y
tay
//FRAGMENT vbuz1=vbuaa_bor_pbuc1_derefidx_vbuz2
ldy {z2}
ora {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuaa_bor_pbuc1_derefidx_vbuz1
ldy {z1}
ora {c1},y
//FRAGMENT vbuxx=vbuaa_bor_pbuc1_derefidx_vbuz1
ldx {z1}
ora {c1},x
tax
//FRAGMENT vbuyy=vbuaa_bor_pbuc1_derefidx_vbuz1
ldy {z1}
ora {c1},y
tay
//FRAGMENT vbuz1=vbuxx_bor_pbuc1_derefidx_vbuz2
ldy {z2}
txa
ora {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_pbuc1_derefidx_vbuz1
ldy {z1}
txa
ora {c1},y
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuz1
txa
ldx {z1}
ora {c1},x
tax
//FRAGMENT vbuyy=vbuxx_bor_pbuc1_derefidx_vbuz1
ldy {z1}
txa
ora {c1},y
tay
//FRAGMENT vbuz1=vbuyy_bor_pbuc1_derefidx_vbuz2
tya
ldy {z2}
ora {c1},y
sta {z1}
//FRAGMENT vbuaa=vbuyy_bor_pbuc1_derefidx_vbuz1
tya
ldy {z1}
ora {c1},y
//FRAGMENT vbuxx=vbuyy_bor_pbuc1_derefidx_vbuz1
ldx {z1}
tya
ora {c1},x
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuz1
tya
ldy {z1}
ora {c1},y
tay
//FRAGMENT vbuz1=vbuz2_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ora {z1}
//FRAGMENT vbuxx=vbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ora {z1}
tax
//FRAGMENT vbuyy=vbuz1_bor_pbuc1_derefidx_vbuxx
lda {c1},x
ora {z1}
tay
//FRAGMENT vbuz1=vbuaa_bor_pbuc1_derefidx_vbuxx
ora {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuaa_bor_pbuc1_derefidx_vbuxx
ora {c1},x
//FRAGMENT vbuxx=vbuaa_bor_pbuc1_derefidx_vbuxx
ora {c1},x
tax
//FRAGMENT vbuyy=vbuaa_bor_pbuc1_derefidx_vbuxx
ora {c1},x
tay
//FRAGMENT vbuz1=vbuxx_bor_pbuc1_derefidx_vbuxx
txa
ora {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_pbuc1_derefidx_vbuxx
txa
ora {c1},x
//FRAGMENT vbuxx=vbuxx_bor_pbuc1_derefidx_vbuxx
txa
ora {c1},x
tax
//FRAGMENT vbuyy=vbuxx_bor_pbuc1_derefidx_vbuxx
txa
ora {c1},x
tay
//FRAGMENT vbuz1=vbuyy_bor_pbuc1_derefidx_vbuxx
tya
ora {c1},x
sta {z1}
//FRAGMENT vbuaa=vbuyy_bor_pbuc1_derefidx_vbuxx
tya
ora {c1},x
//FRAGMENT vbuxx=vbuyy_bor_pbuc1_derefidx_vbuxx
tya
ora {c1},x
tax
//FRAGMENT vbuyy=vbuyy_bor_pbuc1_derefidx_vbuxx
tya
ora {c1},x
tay
//FRAGMENT vbuz1=pbuc1_derefidx_vbuxx
lda {c1},x
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
//FRAGMENT vbuz1=vbuz2_bor_vbuyy
tya
ora {z2}
sta {z1}
//FRAGMENT vbuaa=vbuz1_bor_vbuyy
tya
ora {z1}
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
//FRAGMENT vbuaa=vbuaa_bor_vbuz1
ora {z1}
//FRAGMENT vbuxx=vbuaa_bor_vbuz1
ora {z1}
tax
//FRAGMENT vbuyy=vbuaa_bor_vbuz1
ora {z1}
tay
//FRAGMENT vbuz1=vbuaa_bor_vbuaa
sta {z1}
//FRAGMENT vbuaa_lt_vwuz1_then_la1
ldy {z1}+1
bne {la1}
cmp {z1}
bcc {la1}
//FRAGMENT pwuc1_derefidx_vbuaa=vbuc2
tay
lda #{c2}
sta {c1},y
lda #0
sta {c1}+1,y
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
//FRAGMENT vbuz1=vbuxx_bor_vbuc1
txa
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuxx_bor_vbuc1
txa
ora #{c1}
//FRAGMENT vbuxx=vbuxx_bor_vbuc1
txa
ora #{c1}
tax
//FRAGMENT vbuyy=vbuxx_bor_vbuc1
txa
ora #{c1}
tay
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
//FRAGMENT _stackpushbyte_=vbuaa
pha
//FRAGMENT vbuaa=_byte0_vduz1
lda {z1}
//FRAGMENT vbuxx=_byte0_vduz1
ldx {z1}
//FRAGMENT vbuaa=_byte1_vduz1
lda {z1}+1
//FRAGMENT vbuxx=_byte1_vduz1
ldx {z1}+1
//FRAGMENT vbuaa=_byte2_vduz1
lda {z1}+2
//FRAGMENT vbuxx=_byte2_vduz1
ldx {z1}+2
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
//FRAGMENT vbuaa=vbuz1_ror_5
lda {z1}
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
//FRAGMENT vbuyy=vbuz1_ror_5
lda {z1}
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuaa_ror_5
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuaa_ror_5
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuaa_ror_5
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuaa_ror_5
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuxx_ror_5
txa
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
sta {z1}
//FRAGMENT vbuaa=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
//FRAGMENT vbuxx=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
tax
//FRAGMENT vbuyy=vbuyy_ror_5
tya
lsr
lsr
lsr
lsr
lsr
tay
//FRAGMENT vbuz1=vbuxx_bor_vbuz2
txa
ora {z2}
sta {z1}
//FRAGMENT vbuz1=vbuxx_bor_vbuaa
stx $ff
ora $ff
sta {z1}
//FRAGMENT vbuz1=vbuxx_bor_vbuxx
stx {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuaa
tay
lda {c1},y
sta {z1}
//FRAGMENT vbuz1=pbuc1_derefidx_vbuyy
lda {c1},y
sta {z1}
//FRAGMENT vbuaa=pbuc1_derefidx_vbuaa
tay
lda {c1},y
//FRAGMENT vbuaa=pbuc1_derefidx_vbuxx
lda {c1},x
//FRAGMENT vbuaa=pbuc1_derefidx_vbuyy
lda {c1},y
//FRAGMENT vbuxx=pbuc1_derefidx_vbuaa
tay
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbuaa
tax
ldy {c1},x
//FRAGMENT vbuxx=vbuz1_minus_1
ldx {z1}
dex
//FRAGMENT vbuz1_le_vbuxx_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vwuz1=vbuaa_rol_vbuz2
ldy {z2}
sta {z1}
lda #0
sta {z1}+1
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vwuz1=vbuxx_rol_vbuz2
ldy {z2}
txa
sta {z1}
lda #0
sta {z1}+1
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vwuz1=vbuyy_rol_vbuz2
tya
ldy {z2}
sta {z1}
lda #0
sta {z1}+1
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vwuz1=vbuxx
txa
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuaa=_byte0_pvoz1
lda {z1}
//FRAGMENT vbuxx=_byte0_pvoz1
ldx {z1}
//FRAGMENT vbuaa=_byte1_pvoz1
lda {z1}+1
//FRAGMENT vbuxx=_byte1_pvoz1
ldx {z1}+1
//FRAGMENT vbuxx_lt_vbuz1_then_la1
cpx {z1}
bcc {la1}
//FRAGMENT vbuz1=vbuxx
stx {z1}
//FRAGMENT vbuxx_le_vbuz1_then_la1
lda {z1}
stx $ff
cmp $ff
bcs {la1}
//FRAGMENT vbuxx_lt_vwuz1_then_la1
lda {z1}+1
bne {la1}
cpx {z1}
bcc {la1}
//FRAGMENT vbuyy_lt_vwuz1_then_la1
lda {z1}+1
bne {la1}
cpy {z1}
bcc {la1}
//FRAGMENT vbuyy=_byte0_pvoz1
ldy {z1}
//FRAGMENT vbuyy=_byte1_pvoz1
ldy {z1}+1
//FRAGMENT vbuyy=vbuz1
ldy {z1}
//FRAGMENT vbuyy=_byte0_pbuz1
ldy {z1}
//FRAGMENT vbuz1=vbuyy
sty {z1}
//FRAGMENT 0_neq_vbuxx_then_la1
cpx #0
bne {la1}
//FRAGMENT 0_neq_vbuyy_then_la1
cpy #0
bne {la1}
//FRAGMENT vbuz1=vbuxx_minus_1
dex
stx {z1}
//FRAGMENT vbuaa=vbuxx_minus_1
txa
sec
sbc #1
//FRAGMENT vbuyy=vbuz1_minus_1
lda {z1}
tay
dey
//FRAGMENT vbuyy=vbuxx_minus_1
txa
tay
dey
//FRAGMENT vbuyy=_byte0_vduz1
ldy {z1}
//FRAGMENT vbuyy=_byte1_vduz1
ldy {z1}+1
//FRAGMENT vbuyy=_byte2_vduz1
ldy {z1}+2
//FRAGMENT _stackpushbyte_=vbuxx
txa
pha
//FRAGMENT _stackpushbyte_=vbuyy
tya
pha
//FRAGMENT vbuxx=pbuc1_derefidx_vbuxx
lda {c1},x
tax
//FRAGMENT vbuxx=pbuc1_derefidx_vbuyy
ldx {c1},y
//FRAGMENT vbuyy=pbuc1_derefidx_vbuxx
ldy {c1},x
//FRAGMENT vbuyy=pbuc1_derefidx_vbuyy
lda {c1},y
tay
//FRAGMENT vbuxx=vbuaa
tax
//FRAGMENT vbuaa=vbuxx
txa
//FRAGMENT vbuaa=vbuyy
tya
//FRAGMENT vbuxx=vbuyy
tya
tax
//FRAGMENT vbuyy=vbuaa
tay
//FRAGMENT vbuyy=vbuxx
txa
tay
//FRAGMENT vbuxx=vbuxx_bor_vbuaa
stx $ff
ora $ff
tax
//FRAGMENT vbuxx=vbuyy_bor_vbuaa
sty $ff
ora $ff
tax
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
//FRAGMENT pbuz1=pbuz1_plus_vwuc1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuaa
clc
adc {z1}
sta {z1}
bcc !+
inc {z1}+1
!:
//FRAGMENT vwuz1=vwuz1_rol_vbuz2
ldy {z2}
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e:
//FRAGMENT vwuz1=vwuz1_plus_vwuz2
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuz1_bor_vbuaa
ora {z1}
sta {z1}
//FRAGMENT pbuz1=pbuz2_plus_vwuz1
clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
//FRAGMENT vwuz1=vwuz1_band_vwuc1
lda {z1}
and #<{c1}
sta {z1}
lda {z1}+1
and #>{c1}
sta {z1}+1
//FRAGMENT pprz1=pprc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT 0_eq_vbuz1_then_la1
lda {z1}
beq {la1}
//FRAGMENT vbuz1=_deref_pbuc1_band__deref_pbuc2
lda {c1}
and {c2}
sta {z1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2
lda {c1}
ora {c2}
sta {c1}
//FRAGMENT vbuz1=_bnot__deref_pbuc1
lda {c1}
eor #$ff
sta {z1}
//FRAGMENT _deref_pbuc1=_deref_pbuc1_band_vbuz1
lda {c1}
and {z1}
sta {c1}
//FRAGMENT call__deref_pprz1
jsr {la1}
{la1}: @outside_flow
jmp ({z1})  @outside_flow
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
//FRAGMENT vbuz1=pbuz2_derefidx_vbuz3
ldy {z3}
lda ({z2}),y
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
//FRAGMENT 0_eq_vbuaa_then_la1
cmp #0
beq {la1}
//FRAGMENT vbuaa=_deref_pbuc1_band__deref_pbuc2
lda {c1}
and {c2}
//FRAGMENT vbuxx=_deref_pbuc1_band__deref_pbuc2
lda {c1}
and {c2}
tax
//FRAGMENT vbuyy=_deref_pbuc1_band__deref_pbuc2
lda {c1}
and {c2}
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
//FRAGMENT pbuc1_derefidx_vbuaa=vbuz1
tay
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuxx=vbuz1
lda {z1}
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuz1
lda {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuaa
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuz1=vbuyy
tya
ldy {z1}
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuaa
tax
sta {c1},x
//FRAGMENT vwuz1=_word_vbuaa
sta {z1}
lda #0
sta {z1}+1
//FRAGMENT vbuaa_eq_vbuc1_then_la1
cmp #{c1}
beq {la1}
//FRAGMENT vbuz1_lt_vbuaa_then_la1
cmp {z1}
beq !+
bcs {la1}
!:
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
//FRAGMENT vbuxx_ge_vbuz1_then_la1
cpx {z1}
bcs {la1}
//FRAGMENT vbuaa_ge_vbuz1_then_la1
cmp {z1}
bcs {la1}
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
//FRAGMENT vbuyy=_byte1_pbuz1
ldy {z1}+1
//FRAGMENT vbuyy_lt_vbuz1_then_la1
cpy {z1}
bcc {la1}
//FRAGMENT vbuz1_ge_vbuxx_then_la1
lda {z1}
stx $ff
cmp $ff
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
//FRAGMENT vbuz1_lt_vbuxx_then_la1
cpx {z1}
beq !+
bcs {la1}
!:
//FRAGMENT vbuz1_lt_vbuyy_then_la1
cpy {z1}
beq !+
bcs {la1}
!:
//FRAGMENT 0_eq_vbuxx_then_la1
cpx #0
beq {la1}
//FRAGMENT 0_eq_vbuyy_then_la1
cpy #0
beq {la1}
//FRAGMENT pbuc1_derefidx_vbuxx=vbuaa
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuyy=vbuaa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuxx
tay
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuyy=vbuxx
txa
sta {c1},y
//FRAGMENT pbuc1_derefidx_vbuaa=vbuyy
tax
tya
sta {c1},x
//FRAGMENT pbuc1_derefidx_vbuxx=vbuyy
tya
sta {c1},x
//FRAGMENT vbuyy_eq_vbuc1_then_la1
cpy #{c1}
beq {la1}
//FRAGMENT vbuz1=vbuyy_bor_vbuaa
sty $ff
ora $ff
sta {z1}
//FRAGMENT isr_rom_sys_cx16_entry

//FRAGMENT vwuz1_neq_vbuc1_then_la1
lda {z1}+1
bne {la1}
lda {z1}
cmp #{c1}
bne {la1}
//FRAGMENT vwuz1=vbuc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT vwuz1=_dec_vwuz1
lda {z1}
bne !+
dec {z1}+1
!:
dec {z1}
//FRAGMENT vwuz1_neq_vwuc1_then_la1
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
//FRAGMENT isr_rom_sys_cx16_exit
jmp $e034
//FRAGMENT vwuz1=vwuz2_rol_1
lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
//FRAGMENT pwuz1=pwuc1_plus_vwuz2
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT _deref_pwuc1=_deref_pwuz1
ldy #0
lda ({z1}),y
sta {c1}
iny
lda ({z1}),y
sta {c1}+1
//FRAGMENT pvoz1=pvoc1
lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
//FRAGMENT pbuz1=pbuz1_plus_vbuc1
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
//FRAGMENT vwuz1_lt_vbuc1_then_la1
lda {z1}+1
bne !+
lda {z1}
cmp #{c1}
bcc {la1}
!:
//FRAGMENT vwuz1=vwuz1_minus_vbuc1
sec
lda {z1}
sbc #{c1}
sta {z1}
lda {z1}+1
sbc #0
sta {z1}+1
//FRAGMENT _deref_pwuc1=_deref_pwuc1_plus_vbuc2
lda #{c2}
clc
adc {c1}
sta {c1}
bcc !+
inc {c1}+1
!:
//FRAGMENT vbuz1=vbuc1_bor_vbuz2
lda #{c1}
ora {z2}
sta {z1}
//FRAGMENT pbuz1_neq_pbuz2_then_la1
lda {z1}+1
cmp {z2}+1
bne {la1}
lda {z1}
cmp {z2}
bne {la1}
//FRAGMENT vbuaa=vbuc1_bor_vbuz1
lda #{c1}
ora {z1}
//FRAGMENT vbuxx=vbuc1_bor_vbuz1
lda #{c1}
ora {z1}
tax
//FRAGMENT vbuyy=vbuc1_bor_vbuz1
lda #{c1}
ora {z1}
tay
//FRAGMENT vbuz1=vbuc1_bor_vbuxx
txa
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_bor_vbuxx
txa
ora #{c1}
//FRAGMENT vbuxx=vbuc1_bor_vbuxx
txa
ora #{c1}
tax
//FRAGMENT vbuyy=vbuc1_bor_vbuxx
txa
ora #{c1}
tay
//FRAGMENT vbuz1=vbuc1_bor_vbuyy
tya
ora #{c1}
sta {z1}
//FRAGMENT vbuaa=vbuc1_bor_vbuyy
tya
ora #{c1}
//FRAGMENT vbuxx=vbuc1_bor_vbuyy
tya
ora #{c1}
tax
//FRAGMENT vbuyy=vbuc1_bor_vbuyy
tya
ora #{c1}
tay
//FRAGMENT pwuz1=pwuc1_plus_vwuz1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
//FRAGMENT 0_neq_pbuc1_derefidx_vbuaa_then_la1
tay
lda {c1},y
cmp #0
bne {la1}
//FRAGMENT 0_neq_pbuc1_derefidx_vbuxx_then_la1
lda {c1},x
cmp #0
bne {la1}
//FRAGMENT 0_neq_pbuc1_derefidx_vbuyy_then_la1
lda {c1},y
cmp #0
bne {la1}
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
//FRAGMENT vduz1=vduz2_plus_vbuc1
lda #{c1}
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
//FRAGMENT vwuz1=vwuz2_plus_vwuc1
lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
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
//FRAGMENT vduz1=vduz1_plus_vwuc1
clc
lda {z1}
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
//FRAGMENT vwuz1_ge_vwuz2_then_la1
lda {z2}+1
cmp {z1}+1
bne !+
lda {z2}
cmp {z1}
beq {la1}
!:
bcc {la1}
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
//FRAGMENT vwuz1=vwuz1_minus_vwuz2
lda {z1}
sec
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
//FRAGMENT vbuz1=vbuyy_bor_vbuz2
tya
ora {z2}
sta {z1}
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
//FRAGMENT vbuaa=_byte_vwuz1
lda {z1}
//FRAGMENT vbuxx=_byte_vwuz1
ldx {z1}
//FRAGMENT vbuyy=_byte_vwuz1
ldy {z1}
//FRAGMENT vbuyy_ge_vbuz1_then_la1
cpy {z1}
bcs {la1}
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
//FRAGMENT vwuz1=vwuz1_plus_vwuc1
lda {z1}
clc
adc #<{c1}
sta {z1}
lda {z1}+1
adc #>{c1}
sta {z1}+1
