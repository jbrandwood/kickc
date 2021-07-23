// Minimal union with C-Standard behavior - union with array member
  // Commodore 64 PRG executable file
.file [name="union-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNION_IPV4 = 4
  .label SCREEN = $400
.segment Code
main: {
    // ipv4.d = 0x12345678ul
    lda #<$12345678
    sta ipv4
    lda #>$12345678
    sta ipv4+1
    lda #<$12345678>>$10
    sta ipv4+2
    lda #>$12345678>>$10
    sta ipv4+3
    // SCREEN[0] = ipv4.b[3]
    sta SCREEN
    // SCREEN[1] = ipv4.b[2]
    lda ipv4+2
    sta SCREEN+1
    // SCREEN[2] = ipv4.b[1]
    lda ipv4+1
    sta SCREEN+2
    // SCREEN[3] = ipv4.b[0]
    lda ipv4
    sta SCREEN+3
    // }
    rts
}
.segment Data
  ipv4: .fill SIZEOF_UNION_IPV4, 0
