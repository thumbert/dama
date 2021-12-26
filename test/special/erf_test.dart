

library test.special.erf;

import 'package:test/test.dart';
import 'package:dama/special/erf.dart';
import 'package:dama/src/utils/matchers.dart';

erf_test(){
  test('erf', (){
    expect(Phi(0.0), 0.5);
    expect(erf(0.0), 0.0);
    expect(erf(1.0), 0.8427007929497148); //693412);

    var x = [0.1, 1.2, 2.3, 3.4, 4.5, 5.6, 6.7, 7.8, 8.9,
    10.0, 11.1, 12.2, 13.3, 14.4, 15.5, 16.6];
    var cPhiExpected = [4.60172162722971e-01, 1.15069670221708e-01,
    1.07241100216758e-02, 3.36929265676881e-04, 3.39767312473006e-06,
    1.07175902583109e-08, 1.04209769879652e-11, 3.09535877195870e-15,
    2.79233437493966e-19, 7.61985302416053e-24, 6.27219439321703e-29,
    1.55411978638959e-34, 1.15734162836904e-40, 2.58717592540226e-47,
    1.73446079179387e-54, 3.48454651995041e-62];
    for (var i=0; i<x.length; i++){
      expect(cPhi(x[i]), equalsWithPrecision(cPhiExpected[i], precision: 1E-12, relative: true));
    }

  });
}


main() {
  group('Special functions:', (){
    erf_test();
  });
}