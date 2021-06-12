// Call returns wrong value
// Reported by Clay Cowgill as an NPE (which has been fixed - but this return-value problem has popped up instead)
// Caused by constant loop head unroll


int ball_y[8] = {  50, 100, -200, 12, -100, 75, 0, -121 } ;

void main() {
    char* const screen = (char*)0x0400;
    char hit_check=scan_for_lowest();
    screen[0] = hit_check;
    screen[2] = BYTE0(ball_y[hit_check]);
    screen[3] = BYTE1(ball_y[hit_check]);
}

byte scan_for_lowest() {
    char lowest=255;
    int height=600;
	for (char i=0;i<8;i++) {
	    if (ball_y[i]<height) {
		    height=ball_y[i];
			lowest=i;
        }
	}
	return(lowest);
}