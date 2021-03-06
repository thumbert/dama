

library test.basic.num_extensions_test;

import 'package:test/test.dart';
import 'package:dama/dama.dart';

void tests() {
  group('Num extensions test', () {
    test('isCloseTo with relative tolerance', () {
      expect(2.100001.isCloseTo(2.1, relativeTolerance: 0.001), true);
      expect(2.100001.isCloseTo(2.1, relativeTolerance: 0.0001), true);
      expect(2.100001.isCloseTo(2.1, relativeTolerance: 0.00001), true);
      expect(2.100001.isCloseTo(2.1, relativeTolerance: 0.000001), true);
      expect(2.100001.isCloseTo(2.1, relativeTolerance: 0.0000001), false);
    });
    test('isCloseTo with absolute tolerance', () {
      expect(0.000001.isCloseTo(0, absoluteTolerance: 0.001), true);
      expect(0.000001.isCloseTo(0, absoluteTolerance: 0.0001), true);
      expect(0.000001.isCloseTo(0, absoluteTolerance: 0.00001), true);
      expect(0.000001.isCloseTo(0, absoluteTolerance: 0.000001), true);
      expect(0.000001.isCloseTo(0, absoluteTolerance: 0.0000001), false);
    });
  });
}

void main() {
  tests();
}
