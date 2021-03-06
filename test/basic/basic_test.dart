

library test.basic;

import 'package:test/test.dart';
import 'package:dama/basic/count.dart';
import 'package:dama/basic/cumsum.dart';
import 'package:dama/basic/last_observation_carried_forward.dart';
import 'interval_test.dart' as intervalTests;
import 'null_policy_test.dart' as nullPolicyTests;

tests(){
  group('basic tests:', () {
    test('count test, strings', (){
      var xs = ['a', 'b', 'a', 'a', 'b'];
      expect(count(xs), {'a': 3, 'b': 2});
    });
    test('cumsum', () {
      var x = [1, 2, 3, 4];
      expect(cumsum(x).toList(), [1, 3, 6, 10]);
    });
    test('last observation carried forward, one missing value in the middle', () {
      var x = [1, 2, null, 3, 5];
      var y = lastObservationCarriedForward(x);
      expect(y, [1,2,2,3,5]);
    });
    test('last observation carried forward, missing values at the beginning are ignored', () {
      var x = [null, null, 1, 3, 5];
      var y = lastObservationCarriedForward(x);
      expect(y, [null, null, 1, 3, 5]);
    });
    test('last observation carried forward, missing values all over', () {
      var x = [null, null, 1, null, null, 5];
      var y = lastObservationCarriedForward(x);
      expect(y, [null, null, 1, 1, 1, 5]);
    });
    intervalTests.tests();
    nullPolicyTests.tests();
  });
}




main() {
  tests();
}
