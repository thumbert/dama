
library linear.matrix_test;

import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/linear/diagonal_matrix.dart';

basic_ops() {
//  test('unit matrix', (){
//    Matrix m = new Matrix.unit(3);
//    expect(m.diag, [1,1,1]);
//  });
  test('matrix toList method', (){
    Matrix m = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m.toList(), [0,1,2,3,4,5]);
  });
  test('matrix creation by row', (){
    Matrix m = new Matrix([0,1,2,3,4,5], 2, 3, byRow: true);
    expect(m.toList(), [0,3,1,4,2,5]);
  });
  test('matrix equality', () {
    Matrix m1 = new Matrix([0,1,2,3], 2, 2);
    Matrix m2 = new Matrix([0,1,2,3], 2, 2);
    expect(m1, m2);
  });
  test('set/get element', (){
    Matrix m = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m.element(1,2), 5);
    m.setElement(1,2,10);
    expect(m.element(1,2), 10);
  });
  test('extract row', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 3, 2);
    expect(m1.row(1), new Matrix([1,4], 1, 2));
  });
  test('extract column', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m1.column(1), new Matrix([2,3], 2, 1));
    expect(m1.column(2), new Matrix([4,5], 2, 1));
    Matrix m2 = new Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
    expect(m2.column(1).toList(), [-51, 167, 24]);
  });
  test('extract elements', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m1[[1,1]], 3);
    expect(m1[[0,2]], 4);
    expect(m1[[1,2]], 5);
  });
  test('set element', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    m1[[0,2]] = 10;
    expect(m1[[0,2]], 10);
  });
  test('set row', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    m1.setRow(1, [6,7,8]);
    expect(m1.row(1).toList(), [6,7,8]);
  });
  test('set column', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    m1.setColumn(1, [6,7]);
    expect(m1.column(1).toList(), [6,7]);
  });
  test('rbind', (){
    Matrix m1 = new Matrix([0,1,2,3], 2, 2);
    Matrix m2 = new Matrix([4,5,6,7], 2, 2);
    Matrix m3 = m1.rbind(m2);
    expect(m3.toList(), [0,1,4,5,2,3,6,7]);
  });
  test('cbind', (){
    Matrix m1 = new Matrix([0,1,2,3], 2, 2);
    Matrix m2 = new Matrix([4,5,6,7], 2, 2);
    Matrix m3 = m1.cbind(m2);
    expect(m3.toList(), [0,1,2,3,4,5,6,7]);
  });
  test('get matrix diagonal', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m1.diag, [0,3]);
  });
  test('set matrix diagonal', () {
    Matrix m = new Matrix([0,0,0,0,0,0], 2, 3);
    m.diag = [1,1];
    expect(m.data, [[1,0,0],[0,1,0]]);
  });
  test('row apply', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    Function sum = (List x) => x.fold(0.0, (a,b) => a+b);
    expect(m1.rowApply(sum).toList(), [6,9]);
  });
  test('column apply', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    Function sum = (List x) => x.fold(0.0, (a,b) => a+b);
    expect(m1.columnApply(sum).toList(), [1,5,9]);
  });
  test('matrix norm', (){
    Matrix m = new Matrix([-3,2,0, 5,6,2, 7,4,8], 3, 3);
    expect(m.norm(p: '1'), 19);
    expect(m.norm(p: 'INFINITY'), 15);
  });
  test('matrix multiplication', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    Matrix m2 = new Matrix([0,1,2,3,4,5], 3, 2);
    Matrix m = m1.multiply(m2);
    expect(m, new Matrix([10, 13, 28, 40], 2, 2));
  });

}

diagMatrix() {
  group('Diagonal matrix: ', (){
    test('create and check elements', (){
      Matrix m = new DiagonalMatrix([1,2,3]);
      expect(m.element(1,1), 2);
      expect(m.element(0,1), 0);
    });
    test('multiply a diagonal matrix', (){
      Matrix m1 = new DiagonalMatrix([1,2,3]);
      Matrix m2 = new Matrix([0,1,2,3,4,5], 3, 2);
      Matrix m = m1.multiply(m2);
      expect(m, new Matrix([0,2,6, 3,8,15], 3, 2));
    });
  });

}

printMatrix() {
  print("Int matrix:");
  Matrix m1 = new Matrix([0,1,2,3,4,5,6,7,8,9,10,11], 4, 3);
  print(m1.toString());

  print("Double matrix:");
  Matrix m2 = new Matrix([0,1.123,2,3,4,5,6,7,8,9,10.1,11], 4, 3);
  print(m2.toString());

//  print("\nTranspose it:");
//  print(m1.transpose().toString());
//
//  print("\nTranspose it along minor diagonal:");
//  print(m1.transpose_minor_diagonal().toString());
//
//  print("\nReflect it along major diagonal:");
//  print(m1.reflect_diagonal().toString());
//
//  print("\nTranspose twice gets you back");
//  assert(m1 == m1.transpose().transpose());
//
//  print(m1.isSimilar(m1.transpose()));

}


/**
 * Compare with other implementations
 * https://github.com/kostya/benchmarks/tree/master/matmul
 * pretty decent results.
 */
speed_test() {
  Matrix _makeTestMatrix(int N) {
    List m = [];
    var aux = 1.0/N/N;
    for (int i=0; i<N; i++)
      for (int j=0; j<N; j++)
        m.add(aux*(i-j)*(i+j));

    return new Matrix(m, N, N);
  }

  int N = 1500;
  print('Speed test Matrix');
  Stopwatch sw = new Stopwatch()..start();
  Matrix a = _makeTestMatrix(N);
  Matrix b = _makeTestMatrix(N);
  sw.stop();
  print('created in ${sw.elapsed}');
  sw.start();
  Matrix c = a.multiply(b);
  print(c.element(N~/2, N~/2)); // -143.50016666665678
  print('multiplied in ${sw.elapsed}');
}



main() {
  basic_ops();

  diagMatrix();


//  IntMatrix m = new Matrix([0,1,20005,3], 2, 2);
//  Matrix d = m.toDoubleMatrix();
//  //print(m is IntMatrix);
//  //print(m.data.first is Int32List);
//  print(d);



  //speed_test();

  //speed_test_extract();

//  Matrix2 m = new Matrix2([1,2,3,4], 2, 2);
//  print(m.data);




}
