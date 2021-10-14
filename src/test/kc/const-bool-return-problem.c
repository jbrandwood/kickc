// A function that returns a constant boolean crashes the compiler because it produces illegal ASM

char * const SCREEN = (char*)0x0400;

void main() {
    for(char ox=0;ox<5;ox++)
        for(char oy=0;oy<5;oy++)
            if(OBJ_is_solid(ox,oy))
                SCREEN[ox] = oy;

}

bool OBJ_is_solid(char ox, char oy) {
	if (oy==oy) {
		return true;
	}
	return tile_flag_at();
}

bool tile_flag_at() {
	return false;
}
