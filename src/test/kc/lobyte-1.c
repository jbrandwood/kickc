#define LOBYTE(c) BYTE0(c)
#define TMS_WRITE_CTRL_PORT(a)  (*VDP_REG=(byte)(a))

const byte *VDP_REG  = (byte*)0xA001;

void main() {
   byte addr = 3;
   TMS_WRITE_CTRL_PORT(LOBYTE(addr));
}
