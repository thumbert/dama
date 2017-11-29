
import 'package:test/test.dart';

import 'package:dama/basic/interval.dart';

intervalTest() {
  test('Create interval [0,1)', () {
    Interval i = new Interval(0, 1);
    print(i);
  });


}

main() {
  intervalTest();
}