

library test.stat.descriptive.autocorrelation_test;

import 'package:dama/src/utils/matchers.dart';
import 'package:dama/stat/descriptive/autocorrelation.dart';
import 'package:test/test.dart';
import '../../_data/lew.dart';


tests() {
  group('Statistics descriptive autocorrelation', () {
    test('Autocorrelation Lew data', () {
      var deformation = lew();
      var autocorrelation = Autocorrelation(deformation, 30);
      var lag0 = autocorrelation.forLag(0);
      var lag1 = autocorrelation.forLag(1);
      var lag2 = autocorrelation.forLag(2);
      expect(lag0, 1.0);
      expect(lag1, equalsWithPrecision(-0.3073048, precision: 1E-6));
      expect(lag2, equalsWithPrecision(-0.7403503, precision: 1E-6));
    });
  });
}


main() {
  tests();
}