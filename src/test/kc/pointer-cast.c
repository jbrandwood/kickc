// Tests casting pointer types to other pointer types

byte* ub_screen = (byte*)$400;
signed byte* sb_screen = (signed byte*)$428;
word* uw_screen = (word*)$450;
signed word* sw_screen = (signed word*)$478;

byte ub = 41;
signed byte sb = -41;
word uw = $3000;
signed word sw = -$3000;

void main() {

    *((byte*)ub_screen) = ub;
    *((signed byte*)ub_screen+1) = sb;
    *((word*)ub_screen+1)= uw;
    *((signed word*)ub_screen+2) = sw;


    *((byte*)sb_screen) = ub;
    *((signed byte*)sb_screen+1) = sb;
    *((word*)sb_screen+1)= uw;
    *((signed word*)sb_screen+2) = sw;

    *((byte*)uw_screen) = ub;
    *((signed byte*)uw_screen+1) = sb;
    *((word*)uw_screen+1)= uw;
    *((signed word*)uw_screen+2) = sw;

    *((byte*)sw_screen) = ub;
    *((signed byte*)sw_screen+1) = sb;
    *((word*)sw_screen+1)= uw;
    *((signed word*)sw_screen+2) = sw;
    
}