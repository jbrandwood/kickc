clc
sbc {z1}
eor #$ff
sta {z1}
bcc !+
dec {z1}+1
!:
