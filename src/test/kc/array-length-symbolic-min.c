// Illustrates symbolic array lengths

const byte SZ = 15;
byte items[SZ];

// Fills the array item by item with $is, where i is the item# and s is the sub#
void main() {
    byte* cur_item = items;
    for( byte sub: 0..SZ) {
        cur_item[sub] = sub;
    }
}