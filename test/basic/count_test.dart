library test.descriptive.stat.tabulate_test;

import 'package:test/test.dart';
import 'package:dama/basic/count.dart';

tests() {
  group('Tabulate tests', (){
    test('count strings', (){
      var xs = ['a', 'b', 'a', 'a', 'a'];
      expect(count(xs), {'a': 3, 'b': 1});
    });
  });
}

main() {
  tests();
}