// MEGA65 platform PRG executable with banked code and data starting in MEGA65 mode.
.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segmentdef Banked [segments="CodeBanked, DataBanked"]
.segmentdef CodeBanked [start=$4000]
.segmentdef DataBanked [startAfter="CodeBanked"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(%E)                                   //         NNNN
.byte $00, $00, $00                                     // 