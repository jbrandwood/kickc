//KICKC FRAGMENT CACHE 108dd16dc1 108dd18d7f
//FRAGMENT isr_hardware_all_entry
pha @clob_none
txa @clob_x
pha @clob_x
tya @clob_y
pha @clob_y
//FRAGMENT _deref_pbuc1=vbuc2
lda #{c2}
sta {c1}
//FRAGMENT isr_hardware_all_exit
pla @clob_y
tay @clob_y
pla @clob_x
tax @clob_x
pla @clob_none
rti
//FRAGMENT _deref_pbuc1=_deref_pbuc1_bor_vbuc2
lda #{c2}
ora {c1}
sta {c1}
//FRAGMENT _deref_qprc1=pprc2
lda #<{c2}
sta {c1}
lda #>{c2}
sta {c1}+1
//FRAGMENT _deref_pbuc1=_inc__deref_pbuc1
inc {c1}
