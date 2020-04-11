// java.lang.NullPointerException during Pass2TypeInference.java

byte table[256];

// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/2) and g(x) = f(1-x) 
void main() {
	for( byte i:0..128) {
		table[255-i] = 0;
	}
}