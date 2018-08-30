library test.basic;

import 'package:test/test.dart';
import 'package:dama/basic/cumsum.dart';

cumsumTest(){
  test('cumsum', () {
    var x = [1,2,3,4];
    print(cumsum(x));
  });
}

main() {
  cumsumTest();
}