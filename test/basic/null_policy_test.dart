library test.basic.null_policy_test;

import 'package:test/test.dart';
import 'package:dama/dama.dart';

tests() {
  group('null policy tests', () {
    test('nulls to empty', () {
      var nullPolicy = NullPolicy.nullToEmpty;
      var x = ['a', null, 'c'];
      var out = x.map((e) => nullPolicy(e)).toList();
      expect(out, ['a', '', 'c']);
    });
    test('nulls to zero', () {
      var nullPolicy = NullPolicy.nullToZero;
      var x = [1, null, 3];
      var out = x.map((e) => nullPolicy(e)).toList();
      expect(out, [1, 0, 3]);
    });
  });
}


main() {
  tests();
}