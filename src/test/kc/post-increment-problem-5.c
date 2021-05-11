// Post-increment expression causes  java.lang.ClassCastException: class dk.camelot64.kickc.model.values.ConstantBinary cannot be cast to class dk.camelot64.kickc.model.values.LValue
// Should result in a proper error

char* const SCREEN = (char*)0x0400;

void main() {
    *(SCREEN+999)++;
}
