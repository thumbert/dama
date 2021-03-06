

library test_median;

import 'dart:math';
import 'package:test/test.dart';
import 'package:dama/stat/descriptive/quantile.dart';

void tests() {
  group('QuantilePair test:', () {
    test('basic', (){
      var qp1 = QuantilePair(0.3, 5.1);
      var qp2 = QuantilePair(0.3, 5.1);
      expect(qp1, qp2);
      expect({qp1, qp2}, {qp1});
      var m1 = {qp1: 42};
      expect(m1[qp2], 42);
    });

  });

  group('Quantile test:', () {
    test('minK', () {
      var x = [3, 1, 5, 9, 4, 2, 7];
      var q = Quantile(x);
      var res = List.generate(7, (i) => i).map((e) => q.minK(e));
      expect(res, [1, 2, 3, 4, 5, 7, 9]);
    });

    test('R1 quantile calculation, sorted array', () {
      var x = List.generate(8, (i) => i);
      var q = Quantile(x,
          shuffle: false, quantileEstimationType: QuantileEstimationType.R1);
      var probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 1, 3, 5, 7]);
    });

    test('R4 quantile calculation, sorted array', () {
      var x = List.generate(3, (i) => i);
      var q = Quantile(x,
          shuffle: false, quantileEstimationType: QuantileEstimationType.R4);
      var probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 0, 0.5, 1.25, 2]);
    });

    test('R7 quantile calculation, sorted array', () {
      var x = List.generate(8, (i) => i);
      var q = Quantile(x,
          shuffle: false, quantileEstimationType: QuantileEstimationType.R7);
      var probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 1.75, 3.5, 5.25, 7]);
    });

    test('R7 quantile calculation, unsorted array', () {
      var x = List.generate(8, (i) => i);
      //x.shuffle();
      var q = Quantile(x,
          shuffle: true, quantileEstimationType: QuantileEstimationType.R7);
      var probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 1.75, 3.5, 5.25, 7]);
    });

    test('default quantiles, unsorted array', () {
      var x = List.generate(10, (i) => i+1);
      x.shuffle(Random(0));
      var q = Quantile(x, shuffle: false);
      var probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [1, 3.25, 5.5, 7.75, 10]);
    });
  });
}

speedTest() {
  //How it is so fast?!  takes 11 milliseconds to do this!
  test('performance for large inputs', () {
    int N = 20000000;
    List x = List.generate(N, (i) => i);
    x.shuffle(Random(0));
    Quantile q = Quantile(x as List<num>, shuffle: false);
    var w = Stopwatch()..start();
    var res = List.generate(1000000, (i) => i * 200).map((e) => q.minK(e));
    print('evaluation microseconds: ${w.elapsedMicroseconds}');
    w.stop();
    print(res);
  });
}

void main() {
  tests();
}

// NAN's are put after the max value
//  var y = [3, 1, double.NAN, 8]..sort();
//  print(y);
