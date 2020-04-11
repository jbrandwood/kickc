// Illustrates symbolic array lengths

const byte ITEM_COUNT = 3;
const byte ITEM_SIZE = 5;

byte items[ITEM_COUNT*ITEM_SIZE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// Fills the array item by item with $is, where i is the item# and s is the sub#
void main() {
    byte* cur_item = items;
    for( byte item: 0..ITEM_COUNT-1) {
        for( byte sub: 0..ITEM_SIZE-1) {
            cur_item[sub] = item*$10|sub;
        }
        cur_item += ITEM_SIZE;
    }
}