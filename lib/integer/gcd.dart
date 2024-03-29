library integer.gcd;

/// calculate the greatest common divisor using Euclid's algorithm.
int gcd(int x, int y) {
  if (x < y) {
    var aux = x;
    x = y;
    y = aux;
  }
  if (x == y) return x;
  var r = x % y;
  while (r > 0) {
    r = x % y;
    if (r == 0) return y;
    x = y;
    y = r;
  }
  return y;
}