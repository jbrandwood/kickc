//KICKC FRAGMENT CACHE fda5310c5 fda532f51
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
