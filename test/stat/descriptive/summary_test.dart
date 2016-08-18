library test.stat.descriptive.summary;

import 'package:test/test.dart';
import 'package:dama/stat/descriptive/summary.dart';

main() {
  test('max', () {
    expect(max([1, 2, 3, 4, 5]), 5);
    expect(max([1, 2, 3, 4, 5], isValid: (x) => x <= 4), 4);

  });


}