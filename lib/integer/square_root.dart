library integer.square_root;

/// Calculate the integer square root of a number using only integers.
/// See https://en.wikipedia.org/wiki/Integer_square_root
BigInt isqrt(BigInt n) {
  BigInt _newX(BigInt n, BigInt x) {
    return ((x + (n~/x))~/BigInt.from(2));
  }
  var x = BigInt.from(1);
  var newX = _newX(n, x);
  while (x != newX && (x != newX + BigInt.from(1))) {
    x = newX;
    newX = _newX(n, x);
  }
  return newX;
}

/// Check if a number is a perfect square.  Using the Babylonian method.
bool isSquare(int n) {
  var x = n ~/ 2;
  var seen = <int>{x};
  while (x*x != n) {
    x = (x + n ~/ x) ~/ 2;
    if (seen.contains(x)) return false;
    seen.add(x);
  }
  return true;
}
