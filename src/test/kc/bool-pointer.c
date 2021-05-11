// Tests a pointer to a boolean

void main() {
    bool* bscreen = (bool*)$400;
    bscreen[0] = true;
    bscreen[1] = false;
    bscreen = bscreen+2;
    *bscreen = true;
    if(*bscreen) {
        *(++bscreen)= true;
    }

}