// https://gitlab.com/camelot/kickc/-/issues/587
// Creating variable instances of structs with array members fails to compile

#pragma struct_model(classic)
#pragma var_model(struct_mem)

typedef struct netconfig {
    char ssid[32];
    char password[64];
} NetConfig;

typedef struct other {
	char a;
	char b;
} Other;

char const * OUT = (char*)0x8000;

void main() {
	Other x;

	NetConfig a = {"123", "abc"};
	*(OUT + 0) = a.ssid[0];

	NetConfig b;
}
