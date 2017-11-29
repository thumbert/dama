library test.stat.descriptive.summary;

import 'package:test/test.dart';
import 'package:dama/stat/descriptive/summary.dart';

main() {
  test('max', () {
    expect(max([1, 2, 3, 4, 5]), 5);
    expect(max([1, 2, 3, 4, 5], isValid: (x) => x <= 4), 4);
  });
  test('min', () {
    expect(min([1, 3, -3, 5]), -3);
    expect(min([1, 3, double.NAN, -3, 5]), -3);
    expect(min([1, 3, double.NEGATIVE_INFINITY, 5]), double.NEGATIVE_INFINITY);
  });
  test('range test', (){
    List r = range([4,2,1,5]);
    expect(r, [1,5]);
  });
  test('range([4,2,NAN,5]) is [2,5]', (){
    List r = range([4,2,double.NAN,5]);
    expect(r, [2,5]);
  });
  test('summary of an iterable', () {
    Map res = summary([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    expect(res, {
      'Min.': 1,
      '1st Qu.': 3.25,
      'Median': 5.5,
      'Mean': 5.5,
      '3rd Qu.': 7.75,
      'Max.': 10
    });
  });
}
