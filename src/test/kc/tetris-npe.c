// NullPointerException using current_movedown_rate in the main loop

byte* RASTER = $d012;	
byte* SCREEN = $400;	
byte ypos = 0;
byte RATE = 50;
byte counter = RATE;

void main() {
	while(true) { 
		while(*RASTER!=$ff) {}
		if(--counter==0) {
			counter = RATE;
			ypos++;
			*SCREEN = ypos;
		}
	}
}



