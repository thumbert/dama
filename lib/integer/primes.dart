library integer.primes;

import 'dart:math' show sqrt;

import 'package:dama/integer/square_root.dart';

bool isPrime(int x, {String method: 'Fermat'}) {
  return _fermatPrimeTest(x);
}

/// Implement Fermat's test for a prime.  From book Nice Numbers by John Barnes.
///
bool _fermatPrimeTest(int n) {
  /// find x and y such that n = x^2 - y^2
  if (n % 2 == 0) return true;
  int k = isqrt(n)+1;
  for (int i = 0; i < (n + 1) / 2 - k; i++) {
    int y2 = (k + i) * (k + i) - n;
    //print('i=$i, y2=$y2');
    if (isSquare(y2)) return false;
  }
  return true;
}

/// find the smalles number k for which k^2 > n
int _smallestPower(int n) {
  int k = 1;
  while (k * k < n) {
    ++k;
  }
  return k;
}
