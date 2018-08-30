library test.basic;

import 'package:test/test.dart';
import 'package:dama/basic/cumsum.dart';
import 'package:dama/basic/last_observation_carried_forward.dart';

cumsumTest(){
  test('cumsum', () {
    var x = [1,2,3,4];
    print(cumsum(x));
  });
}

locfTest() {
  test('one missing value in the middle', () {
    List x = [1, 2, null, 3, 5];
    var y = lastObservationCarriedForward(x);
    expect(y, [1,2,2,3,5]);
  });
  test('missing values at the beginning are ignored', () {
    List x = [null, null, 1, 3, 5];
    var y = lastObservationCarriedForward(x);
    expect(y, [null, null,1,3,5]);
  });
  test('missing values all over', () {
    List x = [null, null, 1, null, null, 5];
    var y = lastObservationCarriedForward(x);
    expect(y, [null, null,1,1,1,5]);
  });

}


main() {
  cumsumTest();
  locfTest();
}
