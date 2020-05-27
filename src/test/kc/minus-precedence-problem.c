const unsigned char matrixSize = 8;
const unsigned char matrixSizeMask = 255 - (matrixSize - 1);

void main(void)
{
    *((unsigned char *)0x400) = matrixSizeMask;
}
