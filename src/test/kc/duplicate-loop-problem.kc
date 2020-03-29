// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis


byte* const DC00 = $DC00;
byte rpc;
byte key;

void main() {
	do {
		rpc++;
		do {
			key = *DC00;
		} while(key == 0 && ((key & %00011111) == %00011111));
	} while (true);
}	
