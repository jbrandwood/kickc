  // Commodore 64 PRG executable file
.file [name="weeip-ipv4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNION_HEADER = $28
  .const OFFSET_STRUCT_ARP_HDR_ORIG_HW = 8
  .const OFFSET_STRUCT_ARP_HDR_DEST_IP = $18
  .const OFFSET_STRUCT_IP_HDR_SOURCE = $c
  .const OFFSET_STRUCT_IP_T = $14
  .const OFFSET_STRUCT_TCP_HDR_CHECKSUM = $10
  .label SCREEN = $400
.segment Code
main: {
    // header.arp.orig_hw.b[5] = 0xff
    lda #$ff
    sta header+OFFSET_STRUCT_ARP_HDR_ORIG_HW+5
    // header.arp.dest_ip.b[3] = 0xff
    sta header+OFFSET_STRUCT_ARP_HDR_DEST_IP+3
    // SCREEN[0] = header
    ldy #SIZEOF_UNION_HEADER
  !:
    lda header-1,y
    sta SCREEN-1,y
    dey
    bne !-
    // header.ip.ip.source.d = 0xdddddddd
    lda #<$dddddddd
    sta header+OFFSET_STRUCT_IP_HDR_SOURCE
    lda #>$dddddddd
    sta header+OFFSET_STRUCT_IP_HDR_SOURCE+1
    lda #<$dddddddd>>$10
    sta header+OFFSET_STRUCT_IP_HDR_SOURCE+2
    lda #>$dddddddd>>$10
    sta header+OFFSET_STRUCT_IP_HDR_SOURCE+3
    // header.ip.t.tcp.checksum = 0xeeee
    lda #<$eeee
    sta header+OFFSET_STRUCT_IP_T+OFFSET_STRUCT_TCP_HDR_CHECKSUM
    lda #>$eeee
    sta header+OFFSET_STRUCT_IP_T+OFFSET_STRUCT_TCP_HDR_CHECKSUM+1
    // SCREEN[1] = header
    ldy #SIZEOF_UNION_HEADER
  !:
    lda header-1,y
    sta SCREEN+1*SIZEOF_UNION_HEADER-1,y
    dey
    bne !-
    // }
    rts
}
.segment Data
  header: .fill SIZEOF_UNION_HEADER, 0
