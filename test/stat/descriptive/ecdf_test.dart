

library test.stat.descriptive;

import 'package:dama/stat/descriptive/ecdf.dart';
import 'package:test/test.dart';

ecdf_test() {
  test('ecdf 1', (){
    Ecfd f = ecdf([1,3,4,2]);
    var x = [0,1,1.4,3.2,4,5];
    var p = x.map((e) => f(e)).toList();
    expect(p, [0,0.25,0.25, 0.75,1,1]);
  });
  test('ecdf with duplicates', (){
    Ecfd f = ecdf([1,1,2,3]);
    var x = [0,1,1.4,3];
    var p = x.map((e) => f(e)).toList();
    expect(p, [0,0.5,0.5,1]);
  });
}

main() {
  ecdf_test();
}


