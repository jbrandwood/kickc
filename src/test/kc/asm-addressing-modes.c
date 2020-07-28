// Tests the different ASM addressing modes

void main() {

    asm {
        // absolute indexed
        lda $12,x
        // Indirect
        jmp ($1234)

        // TODO: Indirect ABS,x
        // jmp ($1234,x)

        // TODO Indirect Zeropage
        //jmp ($12)

        // TODO test relative
        // lda $12, $1234

        // TODO Stack Pointer Indirect Indexed
        //lda ($12,sp),y

        // TODO Indirect,Z
        //lda ($12),z

        // TODO Indirect Long,Z
        //lda (($12)),z

        // TODO Indirect Long
        //lda (($12))
    }

}