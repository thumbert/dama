library test.basic;

import 'package:dama/basic/rle.dart';
import 'package:test/test.dart';
import 'package:dama/basic/count.dart';
import 'package:dama/basic/cumsum.dart';
import 'package:dama/basic/last_observation_carried_forward.dart';
import 'interval_test.dart' as interval_tests;
import 'null_policy_test.dart' as null_policy;

void tests() {
  group('basic tests:', () {
    test('count test, strings', () {
      var xs = ['a', 'b', 'a', 'a', 'a'];
      expect(count(xs), {'a': 4, 'b': 1});
    });
    test('count test, with existing map', () {
      var xs = ['a', 'b', 'a', 'a', 'a'];
      expect(count(xs, input: {'a': 4, 'b': 1}), {'a': 8, 'b': 2});
    });
    test('cumSum, cumMean, cumProd', () {
      var x = [1, 2, 3, 4];
      expect(cumSum(x).toList(), [1, 3, 6, 10]);
      expect(cumMean(x).toList(), [1, 1.5, 2, 2.5]);
      expect(cumProd(x).toList(), [1, 2, 6, 24]);
    });
    test('last observation carried forward, one missing value in the middle',
        () {
      var x = [1, 2, null, 3, 5];
      var y = lastObservationCarriedForward(x);
      expect(y, [1, 2, 2, 3, 5]);
    });
    test(
        'last observation carried forward, missing values at the beginning are ignored',
        () {
      var x = [null, null, 1, 3, 5];
      var y = lastObservationCarriedForward(x);
      expect(y, [null, null, 1, 3, 5]);
    });
    test('last observation carried forward, missing values all over', () {
      var x = [null, null, 1, null, null, 5];
      var y = lastObservationCarriedForward(x);
      expect(y, [null, null, 1, 1, 1, 5]);
    });
    interval_tests.tests();
    null_policy.tests();

    test('run length encoding', () {
      var xs = [1, 1, 1, 2, 3, 3, 3];
      var ys = runLenghtEncode(xs);
      expect(ys, [3, 1, 1, 2, 3, 3]);
    });

    test('run length decoding', () {
      var xs = [3, 1, 1, 2, 3, 3];
      var ys = runLenghtDecode(xs);
      expect(ys, [1, 1, 1, 2, 3, 3, 3]);
    });

    test('run length encoding with keys, 1', () {
      var xs = [
        0.31,
        0.1,
        0.4,
        0.1,
        0.1,
      ];
      var ys = runLenghtEncode(xs, keys: {0, 0.1});
      expect(ys, [
        0.31,
        0.1,
        1,
        0.4,
        0.1,
        2,
      ]);

      var xsExp = runLenghtDecode(ys, keys: {0, 0.1});
      expect(xs, xsExp);
    });

    test('run length encoding with keys, 2', () {
      var xs = [0.4, 0.1, 0.1, 0, 0.5, 0.5, 0.5, 0, 0.2];
      var ys = runLenghtEncode(xs, keys: {0, 0.1});
      expect(ys, [0.4, 0.1, 2, 0, 1, 0.5, 0.5, 0.5, 0, 1, 0.2]);
      var xsExp = runLenghtDecode(ys, keys: {0, 0.1});
      expect(xs, xsExp);
    });

    test('run length encoding with keys, 3', () {
      var xs = [
        0,
        0,
        0,
        0.3,
        0.31,
        0.1,
        0.4,
        0.1,
        0.1,
        0,
        0.5,
        0.5,
        0.5,
        0,
        0.2
      ];
      var ys = runLenghtEncode(xs, keys: {0, 0.1});
      expect(ys, [
        0,
        3,
        0.3,
        0.31,
        0.1,
        1,
        0.4,
        0.1,
        2,
        0,
        1,
        0.5,
        0.5,
        0.5,
        0,
        1,
        0.2
      ]);

      var xsExp = runLenghtDecode(ys, keys: {0, 0.1});
      expect(xs, xsExp);
    });
  });
}

void main() {
  tests();
}
