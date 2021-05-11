enum _substate_hosts {
    HOSTS,
    DEVICES,
    DONE
};

typedef enum _substate_hosts SubState;

#define ORIGIN_HOST_SLOTS 2
#define ORIGIN_DEVICE_SLOTS 13

const char * OUT = (char*)0x8000;

void main() {
	SubState substate = HOSTS;
	SubState *ss = &substate;
	
	char x = (*ss == DEVICES ? ORIGIN_DEVICE_SLOTS : ORIGIN_HOST_SLOTS);
	*OUT = x;
}
