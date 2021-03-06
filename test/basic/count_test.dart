

library test.basic.count_test;

import 'package:test/test.dart';
import 'package:dama/basic/count.dart';

tests() {
  group('Tabulate tests', (){
    test('count test, strings', (){
      var xs = ['a', 'b', 'a', 'a', 'a'];
      expect(count(xs), {'a': 3, 'b': 1});
    });
  });
}

main() {
  tests();
}