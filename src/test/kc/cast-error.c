// Results in exception instead of a nice error message
// Reported by Paul Gardner-Stephen

void main() {
    *$d020 = $01;
}