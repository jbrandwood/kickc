// Test that the compiler handles deep nesting well -- mainly a performance issue.

void main() {
    byte* screen = (char*)$400;
    const byte reverse = $80;
    screen[0] = f1(0);
}

byte f1(byte x) { return f2(x) + 1; }
byte f2(byte x) { return f3(x) + 1; }
byte f3(byte x) { return f4(x) + 1; }
byte f4(byte x) { return f5(x) + 1; }
byte f5(byte x) { return f6(x) + 1; }
byte f6(byte x) { return f7(x) + 1; }
byte f7(byte x) { return f8(x) + 1; }
byte f8(byte x) { return f9(x) + 1; }
byte f9(byte x) { return f10(x) + 1; }
byte f10(byte x) { return f11(x) + 1; }
byte f11(byte x) { return f12(x) + 1; }
byte f12(byte x) { return f13(x) + 1; }
byte f13(byte x) { return f14(x) + 1; }
byte f14(byte x) { return f15(x) + 1; }
byte f15(byte x) { return f16(x) + 1; }
byte f16(byte x) { return f17(x) + 1; }
byte f17(byte x) { return f18(x) + 1; }
byte f18(byte x) { return f19(x) + 1; }
byte f19(byte x) { return f20(x) + 1; }
byte f20(byte x) { return f21(x) + 1; }
byte f21(byte x) { return f22(x) + 1; }
byte f22(byte x) { return f23(x) + 1; }
byte f23(byte x) { return f24(x) + 1; }
byte f24(byte x) { return f25(x) + 1; }
byte f25(byte x) { return f26(x) + 1; }
byte f26(byte x) { return f27(x) + 1; }
byte f27(byte x) { return f28(x) + 1; }
byte f28(byte x) { return f29(x) + 1; }
byte f29(byte x) { return f30(x) + 1; }
byte f30(byte x) { return f31(x) + 1; }
byte f31(byte x) { return f32(x) + 1; }
byte f32(byte x) { return f33(x) + 1; }
byte f33(byte x) { return f34(x) + 1; }
byte f34(byte x) { return f35(x) + 1; }
byte f35(byte x) { return f36(x) + 1; }
byte f36(byte x) { return f37(x) + 1; }
byte f37(byte x) { return f38(x) + 1; }
byte f38(byte x) { return f39(x) + 1; }
byte f39(byte x) { return f40(x) + 1; }
byte f40(byte x) { return f41(x) + 1; }
byte f41(byte x) { return f42(x) + 1; }
byte f42(byte x) { return f43(x) + 1; }
byte f43(byte x) { return f44(x) + 1; }
byte f44(byte x) { return f45(x) + 1; }
byte f45(byte x) { return f46(x) + 1; }
byte f46(byte x) { return f47(x) + 1; }
byte f47(byte x) { return f48(x) + 1; }
byte f48(byte x) { return f49(x) + 1; }
byte f49(byte x) { return f50(x) + 1; }
byte f50(byte x) { return f51(x) + 1; }
byte f51(byte x) { return f52(x) + 1; }
byte f52(byte x) { return f53(x) + 1; }
byte f53(byte x) { return f54(x) + 1; }
byte f54(byte x) { return f55(x) + 1; }
byte f55(byte x) { return f56(x) + 1; }
byte f56(byte x) { return f57(x) + 1; }
byte f57(byte x) { return f58(x) + 1; }
byte f58(byte x) { return f59(x) + 1; }
byte f59(byte x) { return f60(x) + 1; }
byte f60(byte x) { return f61(x) + 1; }
byte f61(byte x) { return f62(x) + 1; }
byte f62(byte x) { return f63(x) + 1; }
byte f63(byte x) { return f64(x) + 1; }
byte f64(byte x) { return f65(x) + 1; }
byte f65(byte x) { return f66(x) + 1; }
byte f66(byte x) { return f67(x) + 1; }
byte f67(byte x) { return f68(x) + 1; }
byte f68(byte x) { return f69(x) + 1; }
byte f69(byte x) { return f70(x) + 1; }
byte f70(byte x) { return f71(x) + 1; }
byte f71(byte x) { return f72(x) + 1; }
byte f72(byte x) { return f73(x) + 1; }
byte f73(byte x) { return f74(x) + 1; }
byte f74(byte x) { return f75(x) + 1; }
byte f75(byte x) { return f76(x) + 1; }
byte f76(byte x) { return f77(x) + 1; }
byte f77(byte x) { return f78(x) + 1; }
byte f78(byte x) { return f79(x) + 1; }
byte f79(byte x) { return f80(x) + 1; }
byte f80(byte x) { return f81(x) + 1; }
byte f81(byte x) { return f82(x) + 1; }
byte f82(byte x) { return f83(x) + 1; }
byte f83(byte x) { return f84(x) + 1; }
byte f84(byte x) { return f85(x) + 1; }
byte f85(byte x) { return f86(x) + 1; }
byte f86(byte x) { return f87(x) + 1; }
byte f87(byte x) { return f88(x) + 1; }
byte f88(byte x) { return f89(x) + 1; }
byte f89(byte x) { return f90(x) + 1; }
byte f90(byte x) { return f91(x) + 1; }
byte f91(byte x) { return f92(x) + 1; }
byte f92(byte x) { return f93(x) + 1; }
byte f93(byte x) { return f94(x) + 1; }
byte f94(byte x) { return f95(x) + 1; }
byte f95(byte x) { return f96(x) + 1; }
byte f96(byte x) { return f97(x) + 1; }
byte f97(byte x) { return f98(x) + 1; }
byte f98(byte x) { return f99(x) + 1; }
byte f99(byte x) { return f100(x) + 1; }
byte f100(byte x) { return x;}