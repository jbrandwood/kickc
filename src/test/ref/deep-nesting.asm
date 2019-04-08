// Test that the compiler handles deep nesting well -- mainly a performance issue.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    jsr f1
    lda #f1.return
    sta screen
    rts
}
f1: {
    .label x = 0
    .label return = f2.return+1
    jsr f2
    rts
}
f2: {
    .label return = f3.return+1
    jsr f3
    rts
}
f3: {
    .label return = f4.return+1
    jsr f4
    rts
}
f4: {
    .label return = f5.return+1
    jsr f5
    rts
}
f5: {
    .label return = f6.return+1
    jsr f6
    rts
}
f6: {
    .label return = f7.return+1
    jsr f7
    rts
}
f7: {
    .label return = f8.return+1
    jsr f8
    rts
}
f8: {
    .label return = f9.return+1
    jsr f9
    rts
}
f9: {
    .label return = f10.return+1
    jsr f10
    rts
}
f10: {
    .label return = f11.return+1
    jsr f11
    rts
}
f11: {
    .label return = f12.return+1
    jsr f12
    rts
}
f12: {
    .label return = f13.return+1
    jsr f13
    rts
}
f13: {
    .label return = f14.return+1
    jsr f14
    rts
}
f14: {
    .label return = f15.return+1
    jsr f15
    rts
}
f15: {
    .label return = f16.return+1
    jsr f16
    rts
}
f16: {
    .label return = f17.return+1
    jsr f17
    rts
}
f17: {
    .label return = f18.return+1
    jsr f18
    rts
}
f18: {
    .label return = f19.return+1
    jsr f19
    rts
}
f19: {
    .label return = f20.return+1
    jsr f20
    rts
}
f20: {
    .label return = f21.return+1
    jsr f21
    rts
}
f21: {
    .label return = f22.return+1
    jsr f22
    rts
}
f22: {
    .label return = f23.return+1
    jsr f23
    rts
}
f23: {
    .label return = f24.return+1
    jsr f24
    rts
}
f24: {
    .label return = f25.return+1
    jsr f25
    rts
}
f25: {
    .label return = f26.return+1
    jsr f26
    rts
}
f26: {
    .label return = f27.return+1
    jsr f27
    rts
}
f27: {
    .label return = f28.return+1
    jsr f28
    rts
}
f28: {
    .label return = f29.return+1
    jsr f29
    rts
}
f29: {
    .label return = f30.return+1
    jsr f30
    rts
}
f30: {
    .label return = f31.return+1
    jsr f31
    rts
}
f31: {
    .label return = f32.return+1
    jsr f32
    rts
}
f32: {
    .label return = f33.return+1
    jsr f33
    rts
}
f33: {
    .label return = f34.return+1
    jsr f34
    rts
}
f34: {
    .label return = f35.return+1
    jsr f35
    rts
}
f35: {
    .label return = f36.return+1
    jsr f36
    rts
}
f36: {
    .label return = f37.return+1
    jsr f37
    rts
}
f37: {
    .label return = f38.return+1
    jsr f38
    rts
}
f38: {
    .label return = f39.return+1
    jsr f39
    rts
}
f39: {
    .label return = f40.return+1
    jsr f40
    rts
}
f40: {
    .label return = f41.return+1
    jsr f41
    rts
}
f41: {
    .label return = f42.return+1
    jsr f42
    rts
}
f42: {
    .label return = f43.return+1
    jsr f43
    rts
}
f43: {
    .label return = f44.return+1
    jsr f44
    rts
}
f44: {
    .label return = f45.return+1
    jsr f45
    rts
}
f45: {
    .label return = f46.return+1
    jsr f46
    rts
}
f46: {
    .label return = f47.return+1
    jsr f47
    rts
}
f47: {
    .label return = f48.return+1
    jsr f48
    rts
}
f48: {
    .label return = f49.return+1
    jsr f49
    rts
}
f49: {
    .label return = f50.return+1
    jsr f50
    rts
}
f50: {
    .label return = f51.return+1
    jsr f51
    rts
}
f51: {
    .label return = f52.return+1
    jsr f52
    rts
}
f52: {
    .label return = f53.return+1
    jsr f53
    rts
}
f53: {
    .label return = f54.return+1
    jsr f54
    rts
}
f54: {
    .label return = f55.return+1
    jsr f55
    rts
}
f55: {
    .label return = f56.return+1
    jsr f56
    rts
}
f56: {
    .label return = f57.return+1
    jsr f57
    rts
}
f57: {
    .label return = f58.return+1
    jsr f58
    rts
}
f58: {
    .label return = f59.return+1
    jsr f59
    rts
}
f59: {
    .label return = f60.return+1
    jsr f60
    rts
}
f60: {
    .label return = f61.return+1
    jsr f61
    rts
}
f61: {
    .label return = f62.return+1
    jsr f62
    rts
}
f62: {
    .label return = f63.return+1
    jsr f63
    rts
}
f63: {
    .label return = f64.return+1
    jsr f64
    rts
}
f64: {
    .label return = f65.return+1
    jsr f65
    rts
}
f65: {
    .label return = f66.return+1
    jsr f66
    rts
}
f66: {
    .label return = f67.return+1
    jsr f67
    rts
}
f67: {
    .label return = f68.return+1
    jsr f68
    rts
}
f68: {
    .label return = f69.return+1
    jsr f69
    rts
}
f69: {
    .label return = f70.return+1
    jsr f70
    rts
}
f70: {
    .label return = f71.return+1
    jsr f71
    rts
}
f71: {
    .label return = f72.return+1
    jsr f72
    rts
}
f72: {
    .label return = f73.return+1
    jsr f73
    rts
}
f73: {
    .label return = f74.return+1
    jsr f74
    rts
}
f74: {
    .label return = f75.return+1
    jsr f75
    rts
}
f75: {
    .label return = f76.return+1
    jsr f76
    rts
}
f76: {
    .label return = f77.return+1
    jsr f77
    rts
}
f77: {
    .label return = f78.return+1
    jsr f78
    rts
}
f78: {
    .label return = f79.return+1
    jsr f79
    rts
}
f79: {
    .label return = f80.return+1
    jsr f80
    rts
}
f80: {
    .label return = f81.return+1
    jsr f81
    rts
}
f81: {
    .label return = f82.return+1
    jsr f82
    rts
}
f82: {
    .label return = f83.return+1
    jsr f83
    rts
}
f83: {
    .label return = f84.return+1
    jsr f84
    rts
}
f84: {
    .label return = f85.return+1
    jsr f85
    rts
}
f85: {
    .label return = f86.return+1
    jsr f86
    rts
}
f86: {
    .label return = f87.return+1
    jsr f87
    rts
}
f87: {
    .label return = f88.return+1
    jsr f88
    rts
}
f88: {
    .label return = f89.return+1
    jsr f89
    rts
}
f89: {
    .label return = f90.return+1
    jsr f90
    rts
}
f90: {
    .label return = f91.return+1
    jsr f91
    rts
}
f91: {
    .label return = f92.return+1
    jsr f92
    rts
}
f92: {
    .label return = f93.return+1
    jsr f93
    rts
}
f93: {
    .label return = f94.return+1
    jsr f94
    rts
}
f94: {
    .label return = f95.return+1
    jsr f95
    rts
}
f95: {
    .label return = f96.return+1
    jsr f96
    rts
}
f96: {
    .label return = f97.return+1
    jsr f97
    rts
}
f97: {
    .label return = f98.return+1
    jsr f98
    rts
}
f98: {
    .label return = f99.return+1
    jsr f99
    rts
}
f99: {
    .label return = f1.x+1
    jsr f100
    rts
}
f100: {
    rts
}
