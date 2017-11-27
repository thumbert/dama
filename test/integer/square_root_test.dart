library test.integer.square_root_test;

import 'package:test/test.dart';
import 'package:dama/integer/square_root.dart';

testSquareRoot() {
  test('isqrt(10) == 3', (){
    expect(isqrt(10), 3);
  });
  test('isqrt(15) == 3', () {
    expect(isqrt(15), 3);
  });
  test('isqrt(152415789666209426002111556165263283035677489)', () {
    expect(isqrt(152415789666209426002111556165263283035677489), 12345678987654321234567);
  });
}

testSquareNumber() {
  test('isSquare(98) == false', () {
    expect(isSquare(98), false);
  });
  test('isSquare(152415789666209426002111556165263283035677489)', () {
    expect(isSquare(152415789666209426002111556165263283035677489), true);
  });
}


main() {
  testSquareRoot();
  testSquareNumber();
}

