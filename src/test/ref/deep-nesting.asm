// Test that the compiler handles deep nesting well -- mainly a performance issue.
  // Commodore 64 PRG executable file
.file [name="deep-nesting.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // f1(0)
    jsr f1
    // screen[0] = f1(0)
    lda #f1.return
    sta screen
    // }
    rts
}
// char f1(char x)
f1: {
    .label return = f2.return+1
    // f2(x)
    jsr f2
    // }
    rts
}
// char f2(char x)
f2: {
    .label return = f3.return+1
    // f3(x)
    jsr f3
    // }
    rts
}
// char f3(char x)
f3: {
    .label return = f4.return+1
    // f4(x)
    jsr f4
    // }
    rts
}
// char f4(char x)
f4: {
    .label return = f5.return+1
    // f5(x)
    jsr f5
    // }
    rts
}
// char f5(char x)
f5: {
    .label return = f6.return+1
    // f6(x)
    jsr f6
    // }
    rts
}
// char f6(char x)
f6: {
    .label return = f7.return+1
    // f7(x)
    jsr f7
    // }
    rts
}
// char f7(char x)
f7: {
    .label return = f8.return+1
    // f8(x)
    jsr f8
    // }
    rts
}
// char f8(char x)
f8: {
    .label return = f9.return+1
    // f9(x)
    jsr f9
    // }
    rts
}
// char f9(char x)
f9: {
    .label return = f10.return+1
    // f10(x)
    jsr f10
    // }
    rts
}
// char f10(char x)
f10: {
    .label return = f11.return+1
    // f11(x)
    jsr f11
    // }
    rts
}
// char f11(char x)
f11: {
    .label return = f12.return+1
    // f12(x)
    jsr f12
    // }
    rts
}
// char f12(char x)
f12: {
    .label return = f13.return+1
    // f13(x)
    jsr f13
    // }
    rts
}
// char f13(char x)
f13: {
    .label return = f14.return+1
    // f14(x)
    jsr f14
    // }
    rts
}
// char f14(char x)
f14: {
    .label return = f15.return+1
    // f15(x)
    jsr f15
    // }
    rts
}
// char f15(char x)
f15: {
    .label return = f16.return+1
    // f16(x)
    jsr f16
    // }
    rts
}
// char f16(char x)
f16: {
    .label return = f17.return+1
    // f17(x)
    jsr f17
    // }
    rts
}
// char f17(char x)
f17: {
    .label return = f18.return+1
    // f18(x)
    jsr f18
    // }
    rts
}
// char f18(char x)
f18: {
    .label return = f19.return+1
    // f19(x)
    jsr f19
    // }
    rts
}
// char f19(char x)
f19: {
    .label return = f20.return+1
    // f20(x)
    jsr f20
    // }
    rts
}
// char f20(char x)
f20: {
    .label return = f21.return+1
    // f21(x)
    jsr f21
    // }
    rts
}
// char f21(char x)
f21: {
    .label return = f22.return+1
    // f22(x)
    jsr f22
    // }
    rts
}
// char f22(char x)
f22: {
    .label return = f23.return+1
    // f23(x)
    jsr f23
    // }
    rts
}
// char f23(char x)
f23: {
    .label return = f24.return+1
    // f24(x)
    jsr f24
    // }
    rts
}
// char f24(char x)
f24: {
    .label return = f25.return+1
    // f25(x)
    jsr f25
    // }
    rts
}
// char f25(char x)
f25: {
    .label return = f26.return+1
    // f26(x)
    jsr f26
    // }
    rts
}
// char f26(char x)
f26: {
    .label return = f27.return+1
    // f27(x)
    jsr f27
    // }
    rts
}
// char f27(char x)
f27: {
    .label return = f28.return+1
    // f28(x)
    jsr f28
    // }
    rts
}
// char f28(char x)
f28: {
    .label return = f29.return+1
    // f29(x)
    jsr f29
    // }
    rts
}
// char f29(char x)
f29: {
    .label return = f30.return+1
    // f30(x)
    jsr f30
    // }
    rts
}
// char f30(char x)
f30: {
    .label return = f31.return+1
    // f31(x)
    jsr f31
    // }
    rts
}
// char f31(char x)
f31: {
    .label return = f32.return+1
    // f32(x)
    jsr f32
    // }
    rts
}
// char f32(char x)
f32: {
    .label return = f33.return+1
    // f33(x)
    jsr f33
    // }
    rts
}
// char f33(char x)
f33: {
    .label return = f34.return+1
    // f34(x)
    jsr f34
    // }
    rts
}
// char f34(char x)
f34: {
    .label return = f35.return+1
    // f35(x)
    jsr f35
    // }
    rts
}
// char f35(char x)
f35: {
    .label return = f36.return+1
    // f36(x)
    jsr f36
    // }
    rts
}
// char f36(char x)
f36: {
    .label return = f37.return+1
    // f37(x)
    jsr f37
    // }
    rts
}
// char f37(char x)
f37: {
    .label return = f38.return+1
    // f38(x)
    jsr f38
    // }
    rts
}
// char f38(char x)
f38: {
    .label return = f39.return+1
    // f39(x)
    jsr f39
    // }
    rts
}
// char f39(char x)
f39: {
    .label return = f40.return+1
    // f40(x)
    jsr f40
    // }
    rts
}
// char f40(char x)
f40: {
    .label return = f41.return+1
    // f41(x)
    jsr f41
    // }
    rts
}
// char f41(char x)
f41: {
    .label return = f42.return+1
    // f42(x)
    jsr f42
    // }
    rts
}
// char f42(char x)
f42: {
    .label return = f43.return+1
    // f43(x)
    jsr f43
    // }
    rts
}
// char f43(char x)
f43: {
    .label return = f44.return+1
    // f44(x)
    jsr f44
    // }
    rts
}
// char f44(char x)
f44: {
    .label return = f45.return+1
    // f45(x)
    jsr f45
    // }
    rts
}
// char f45(char x)
f45: {
    .label return = f46.return+1
    // f46(x)
    jsr f46
    // }
    rts
}
// char f46(char x)
f46: {
    .label return = f47.return+1
    // f47(x)
    jsr f47
    // }
    rts
}
// char f47(char x)
f47: {
    .label return = f48.return+1
    // f48(x)
    jsr f48
    // }
    rts
}
// char f48(char x)
f48: {
    .label return = f49.return+1
    // f49(x)
    jsr f49
    // }
    rts
}
// char f49(char x)
f49: {
    .label return = f50.return+1
    // f50(x)
    jsr f50
    // }
    rts
}
// char f50(char x)
f50: {
    .label return = f51.return+1
    // f51(x)
    jsr f51
    // }
    rts
}
// char f51(char x)
f51: {
    .label return = f52.return+1
    // f52(x)
    jsr f52
    // }
    rts
}
// char f52(char x)
f52: {
    .label return = f53.return+1
    // f53(x)
    jsr f53
    // }
    rts
}
// char f53(char x)
f53: {
    .label return = f54.return+1
    // f54(x)
    jsr f54
    // }
    rts
}
// char f54(char x)
f54: {
    .label return = f55.return+1
    // f55(x)
    jsr f55
    // }
    rts
}
// char f55(char x)
f55: {
    .label return = f56.return+1
    // f56(x)
    jsr f56
    // }
    rts
}
// char f56(char x)
f56: {
    .label return = f57.return+1
    // f57(x)
    jsr f57
    // }
    rts
}
// char f57(char x)
f57: {
    .label return = f58.return+1
    // f58(x)
    jsr f58
    // }
    rts
}
// char f58(char x)
f58: {
    .label return = f59.return+1
    // f59(x)
    jsr f59
    // }
    rts
}
// char f59(char x)
f59: {
    .label return = f60.return+1
    // f60(x)
    jsr f60
    // }
    rts
}
// char f60(char x)
f60: {
    .label return = f61.return+1
    // f61(x)
    jsr f61
    // }
    rts
}
// char f61(char x)
f61: {
    .label return = f62.return+1
    // f62(x)
    jsr f62
    // }
    rts
}
// char f62(char x)
f62: {
    .label return = f63.return+1
    // f63(x)
    jsr f63
    // }
    rts
}
// char f63(char x)
f63: {
    .label return = f64.return+1
    // f64(x)
    jsr f64
    // }
    rts
}
// char f64(char x)
f64: {
    .label return = f65.return+1
    // f65(x)
    jsr f65
    // }
    rts
}
// char f65(char x)
f65: {
    .label return = f66.return+1
    // f66(x)
    jsr f66
    // }
    rts
}
// char f66(char x)
f66: {
    .label return = f67.return+1
    // f67(x)
    jsr f67
    // }
    rts
}
// char f67(char x)
f67: {
    .label return = f68.return+1
    // f68(x)
    jsr f68
    // }
    rts
}
// char f68(char x)
f68: {
    .label return = f69.return+1
    // f69(x)
    jsr f69
    // }
    rts
}
// char f69(char x)
f69: {
    .label return = f70.return+1
    // f70(x)
    jsr f70
    // }
    rts
}
// char f70(char x)
f70: {
    .label return = f71.return+1
    // f71(x)
    jsr f71
    // }
    rts
}
// char f71(char x)
f71: {
    .label return = f72.return+1
    // f72(x)
    jsr f72
    // }
    rts
}
// char f72(char x)
f72: {
    .label return = f73.return+1
    // f73(x)
    jsr f73
    // }
    rts
}
// char f73(char x)
f73: {
    .label return = f74.return+1
    // f74(x)
    jsr f74
    // }
    rts
}
// char f74(char x)
f74: {
    .label return = f75.return+1
    // f75(x)
    jsr f75
    // }
    rts
}
// char f75(char x)
f75: {
    .label return = f76.return+1
    // f76(x)
    jsr f76
    // }
    rts
}
// char f76(char x)
f76: {
    .label return = f77.return+1
    // f77(x)
    jsr f77
    // }
    rts
}
// char f77(char x)
f77: {
    .label return = f78.return+1
    // f78(x)
    jsr f78
    // }
    rts
}
// char f78(char x)
f78: {
    .label return = f79.return+1
    // f79(x)
    jsr f79
    // }
    rts
}
// char f79(char x)
f79: {
    .label return = f80.return+1
    // f80(x)
    jsr f80
    // }
    rts
}
// char f80(char x)
f80: {
    .label return = f81.return+1
    // f81(x)
    jsr f81
    // }
    rts
}
// char f81(char x)
f81: {
    .label return = f82.return+1
    // f82(x)
    jsr f82
    // }
    rts
}
// char f82(char x)
f82: {
    .label return = f83.return+1
    // f83(x)
    jsr f83
    // }
    rts
}
// char f83(char x)
f83: {
    .label return = f84.return+1
    // f84(x)
    jsr f84
    // }
    rts
}
// char f84(char x)
f84: {
    .label return = f85.return+1
    // f85(x)
    jsr f85
    // }
    rts
}
// char f85(char x)
f85: {
    .label return = f86.return+1
    // f86(x)
    jsr f86
    // }
    rts
}
// char f86(char x)
f86: {
    .label return = f87.return+1
    // f87(x)
    jsr f87
    // }
    rts
}
// char f87(char x)
f87: {
    .label return = f88.return+1
    // f88(x)
    jsr f88
    // }
    rts
}
// char f88(char x)
f88: {
    .label return = f89.return+1
    // f89(x)
    jsr f89
    // }
    rts
}
// char f89(char x)
f89: {
    .label return = f90.return+1
    // f90(x)
    jsr f90
    // }
    rts
}
// char f90(char x)
f90: {
    .label return = f91.return+1
    // f91(x)
    jsr f91
    // }
    rts
}
// char f91(char x)
f91: {
    .label return = f92.return+1
    // f92(x)
    jsr f92
    // }
    rts
}
// char f92(char x)
f92: {
    .label return = f93.return+1
    // f93(x)
    jsr f93
    // }
    rts
}
// char f93(char x)
f93: {
    .label return = f94.return+1
    // f94(x)
    jsr f94
    // }
    rts
}
// char f94(char x)
f94: {
    .label return = f95.return+1
    // f95(x)
    jsr f95
    // }
    rts
}
// char f95(char x)
f95: {
    .label return = f96.return+1
    // f96(x)
    jsr f96
    // }
    rts
}
// char f96(char x)
f96: {
    .label return = f97.return+1
    // f97(x)
    jsr f97
    // }
    rts
}
// char f97(char x)
f97: {
    .label return = f98.return+1
    // f98(x)
    jsr f98
    // }
    rts
}
// char f98(char x)
f98: {
    .label return = f99.return+1
    // f99(x)
    jsr f99
    // }
    rts
}
// char f99(char x)
f99: {
    .label return = 1
    rts
}
