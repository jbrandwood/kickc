// https://gitlab.com/camelot/kickc/-/issues/586
// typedef enum not defining values

// Define enum and typedef in one go
typedef enum _x {
	A, B, C
} X;

// Split the enum and typedef into 2 parts
enum y {
	I, J, K
};

typedef enum y Y;

char * const SCREEN = (char*)0x0400;

void main() {
	enum y a = I;
	Y b = J;
	X c = A;   // <<<--- ERROR here
	SCREEN[0] = a;
	SCREEN[1] = b;
	SCREEN[2] = c;
}
