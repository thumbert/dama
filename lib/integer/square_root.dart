library integer.square_root;

/// Calculate the integer square root of a number using only integers.
/// See https://en.wikipedia.org/wiki/Integer_square_root
int isqrt(int n) {
  int _newX(int n, int x) {
    return ((x + (n~/x).truncate())~/2).truncate();
  }
  int x = 1;
  int newX = _newX(n, x);
  while (x != newX && (x != newX + 1)) {
    x = newX;
    newX = _newX(n, x);
  }
  return newX;
}

/// Check if a number is a perfect square.  Using the Babylonian method.
bool isSquare(int n) {
  int x = n ~/ 2;
  Set seen = new Set()..add(x);
  while (x*x != n) {
    x = (x + n ~/ x) ~/ 2;
    if (seen.contains(x)) return false;
    seen.add(x);
  }
  return true;
}
