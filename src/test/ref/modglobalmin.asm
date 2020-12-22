  // Commodore 64 PRG executable file
.file [name="modglobalmin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // inccnt()
    ldx #0
    jsr inccnt
    // SCREEN[0]=cnt++
    stx SCREEN
    // SCREEN[0]=cnt++;
    inx
    // inccnt()
    jsr inccnt
    // SCREEN[1]=++cnt;
    inx
    // SCREEN[1]=++cnt
    stx SCREEN+1
    // }
    rts
}
inccnt: {
    // ++cnt;
    inx
    // }
    rts
}
