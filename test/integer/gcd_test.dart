


import 'package:test/test.dart';

import 'package:dama/integer/gcd.dart';

testGcd() {
  test('gcd(1071, 1029) == 21', () {
    expect(gcd(1071, 1029), 21);
  });

  test('gcd(1071, 1071) == 1071', () {
    expect(gcd(1071, 1071), 1071);
  });

  test('gcd(7732, 8764) == 4', () {
    expect(gcd(7732, 8764), 4);
  });

}

main() {
  testGcd();
}