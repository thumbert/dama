library test.basic.linear_filter_test;

import 'package:dama/basic/linear_filter.dart';
import 'package:test/test.dart';


tests() {
  group('Linear filter tests', () {
    test('Binomial filter, order 2', () {
      var x = <num>[12, 17, 10, 22, 15, 11, 18, 27, 14];
      var y = binomialFilter(x, 2, align: Align.center);
      var yExp = [null, 14, 14.75, 17.25, 15.75, 13.75, 18.50, 21.50, null];
      expect(yExp, y);
    });
    test('Binomial filter, order 4', () {
      var x = <num>[12, 17, 10, 22, 15, 11, 18, 27, 14];
      var y = binomialFilter(x, 4, align: Align.center);
      expect(y[0], null);
      expect(y[1], null);
      expect(y[2], 15.1875);
    });
  });

}

main() {
  tests();
}
