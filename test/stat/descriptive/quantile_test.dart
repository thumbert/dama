library test_median;

import 'dart:math';
import 'package:test/test.dart';
import 'package:dama/stat/descriptive/quantile.dart';

testQuantile() {
  group('Quantile test:', () {
    test('minK', () {
      List x = [3, 1, 5, 9, 4, 2, 7];
      Quantile q = new Quantile(x);
      var res = new List.generate(7, (i) => i).map((e) => q.minK(e));
      expect(res, [1, 2, 3, 4, 5, 7, 9]);
    });

    test('R1 quantile calculation, sorted array', () {
      List x = new List.generate(8, (i) => i);
      Quantile q = new Quantile(x,
          shuffle: false, quantileEstimationType: QuantileEstimationType.R1);
      List probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 1, 3, 5, 7]);
    });

    test('R4 quantile calculation, sorted array', () {
      List x = new List.generate(3, (i) => i);
      Quantile q = new Quantile(x,
          shuffle: false, quantileEstimationType: QuantileEstimationType.R4);
      List probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 0, 0.5, 1.25, 2]);
    });

    test('R7 quantile calculation, sorted array', () {
      List x = new List.generate(8, (i) => i);
      Quantile q = new Quantile(x,
          shuffle: false, quantileEstimationType: QuantileEstimationType.R7);
      List probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [0, 1.75, 3.5, 5.25, 7]);
    });

    test('R7 quantile calculation, unsorted array', () {
      List x = new List.generate(8, (i) => i);
      //x.shuffle();
      Quantile q = new Quantile(x,
          shuffle: true, quantileEstimationType: QuantileEstimationType.R7);
      List probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
    });

    test('default quantiles, unsorted array', () {
      List x = new List.generate(10, (i) => i+1);
      x.shuffle(new Random(0));
      Quantile q = new Quantile(x, shuffle: false);
      List probs = [0, 0.25, 0.5, 0.75, 1];
      var res = probs.map((p) => q.value(p)).toList();
      expect(res, [1, 3.25, 5.5, 7.75, 10]);
    });
  });
}

speedTest() {
  //How it is so fast?!  takes 11 milliseconds to do this!
  test('performance for large inputs', () {
    int N = 20000000;
    List x = new List.generate(N, (i) => i);
    x.shuffle(new Random(0));
    //print(x.take(5));
    Quantile q = new Quantile(x, shuffle: false);
    var w = new Stopwatch()..start();
    var res = new List.generate(1000000, (i) => i * 200).map((e) => q.minK(e));
    print('evaluation microseconds: ${w.elapsedMicroseconds}');
    w.stop();
  });
}

main() {
  testQuantile();
}

// NAN's are put after the max value
//  var y = [3, 1, double.NAN, 8]..sort();
//  print(y);
