

library linear.speed_test;


import 'package:dama/linear/matrix.dart';

/// Compare with other implementations
/// https://github.com/kostya/benchmarks/tree/master/matmul
/// pretty decent results.
///
/// I've got a 30% speedup on JavaScript V8 on 7/1/2015.
speedTestDoubleMatrix() {
  Matrix _makeTestMatrix(int N) {
    var m = <num>[];
    var aux = 1.0/N/N;
    for (var i=0; i<N; i++){
      for (var j=0; j<N; j++) {
        m.add(aux*(i-j)*(i+j));
      }
    }
    return Matrix(m, N, N);
  }

  var N = 1500;
  print('Speed test Double Matrix');
  var sw = Stopwatch()..start();
  var a = _makeTestMatrix(N) as DoubleMatrix;
  var b = _makeTestMatrix(N);
  sw.stop();
  print('created in ${sw.elapsed}');
  sw.start();
  Matrix c = a.multiply(b as DoubleMatrix);
  print(c.element(N~/2, N~/2)); // -143.50016666665678
  print('multiplied in ${sw.elapsed}');
}


main() {
  speedTestDoubleMatrix();
}