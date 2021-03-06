

library linear.speed_test;


import 'package:dama/linear/matrix.dart';

/// Compare with other implementations
/// https://github.com/kostya/benchmarks/tree/master/matmul
/// pretty decent results.
///
/// I've got a 30% speedup on JavaScript V8 on 7/1/2015.
speed_test_doubleMatrix() {
  Matrix _makeTestMatrix(int N) {
    var m = <num>[];
    var aux = 1.0/N/N;
    for (int i=0; i<N; i++)
      for (int j=0; j<N; j++)
        m.add(aux*(i-j)*(i+j));

    return Matrix(m, N, N);
  }

  int N = 1500;
  print('Speed test Double Matrix');
  Stopwatch sw = new Stopwatch()..start();
  DoubleMatrix a = _makeTestMatrix(N) as DoubleMatrix;
  Matrix b = _makeTestMatrix(N);
  sw.stop();
  print('created in ${sw.elapsed}');
  sw.start();
  Matrix c = a.multiply(b as DoubleMatrix);
  print(c.element(N~/2, N~/2)); // -143.50016666665678
  print('multiplied in ${sw.elapsed}');
}


main() {
  speed_test_doubleMatrix();
}