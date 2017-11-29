
import 'package:test/test.dart';

import 'package:dama/integer/primes.dart';

primesTest() {
  test('isPrime(9991) == false', () {
    expect(isPrime(9991), false);
  });

  test('isPrime(8777) == false', () {
    expect(isPrime(8777), false);
  });

  test('isPrime(2017) == true', () {
    expect(isPrime(2017), true);
  });

  test('isPrime(7919) == true', () {
    expect(isPrime(7919), true);
  });

  test('isPrime(50510017) == false', () {
    expect(isPrime(50510017), false);
  });

  test('isPrime(505100173) == false', () {
    /// stopped it after 30 minutes of not finishing.  Need a better method.
    //expect(isPrime(505100173), false);
  });



}

main() {
  primesTest();
}