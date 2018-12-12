library test.stat.descriptive.summary;

import 'package:test/test.dart';
import 'package:dama/stat/descriptive/summary.dart';

main() {
  test('max', () {
    expect(max([1, 2, 3, 4, 5]), 5);
  });
  test('min', () {
    expect(min([1, 3, -3, 5]), -3);
    expect(min([1, 3, double.nan, -3, 5]), -3);
    expect(min([1, 3, double.negativeInfinity, 5]), double.negativeInfinity);
  });
  test('range test', (){
    List r = range([4,2,1,5]);
    expect(r, [1,5]);
  });
  test('range([4,2,NAN,5]) is [2,5]', (){
    List r = range([4,2,double.nan,5]);
    expect(r, [2,5]);
  });
  test('summary of an iterable', () {
    var res = summary([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    expect(res, {
      'Min.': 1,
      '1st Qu.': 3.25,
      'Median': 5.5,
      'Mean': 5.5,
      '3rd Qu.': 7.75,
      'Max.': 10
    });
  });
  test('ohlc', (){
    var res = ohlc([3, 6, 1, 2, 3, 6, 9, 10, 5, 7, 7]);
    expect(res, {'open': 3, 'high': 10, 'low': 1, 'close': 7});
  });

}
