

library linear.matrix_test;

import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
//import 'package:dama/linear/diagonal_matrix.dart';

void basicOps() {
//  test('unit matrix', (){
//    var m = Matrix.unit(3);
//    expect(m.diag, [1,1,1]);
//  });
  group('Matrix basic ops:', () {
    test('matrix toList method', (){
      var m = Matrix([0,1,2,3,4,5], 2, 3);
      expect(m.toList(), [0,1,2,3,4,5]);
    });
    test('matrix creation by row', (){
      var m = Matrix([0,1,2,3,4,5], 2, 3, byRow: true);
      expect(m.toList(), [0,3,1,4,2,5]);
    });
    test('matrix equality', () {
      var m1 = Matrix([0,1,2,3], 2, 2);
      var m2 = Matrix([0,1,2,3], 2, 2);
      expect(m1, m2);
    });
    test('set/get element', (){
      var m = Matrix([0,1,2,3,4,5], 2, 3);
      expect(m.element(1,2), 5);
      m.setElement(1,2,10);
      expect(m.element(1,2), 10);
    });
    test('extract row', (){
      var m1 = Matrix([0,1,2,3,4,5], 3, 2);
      expect(m1.row(1), Matrix([1,4], 1, 2));
    });
    test('extract column', (){
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      expect(m1.column(1), Matrix([2,3], 2, 1));
      expect(m1.column(2), Matrix([4,5], 2, 1));
      var m2 = Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
      expect(m2.column(1).toList(), [-51, 167, 24]);
    });
    test('extract elements', (){
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      expect(m1[[1,1]], 3);
      expect(m1[[0,2]], 4);
      expect(m1[[1,2]], 5);
    });
    test('set element', () {
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      m1[[0,2]] = 10;
      expect(m1[[0,2]], 10);
    });
    test('set row', () {
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      m1.setRow(1, [6,7,8]);
      expect(m1.row(1).toList(), [6,7,8]);
    });
    test('set column', () {
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      m1.setColumn(1, [6,7]);
      expect(m1.column(1).toList(), [6,7]);
    });
    test('rbind', (){
      var m1 = DoubleMatrix([0,1,2,3], 2, 2);
      var m2 = DoubleMatrix([4,5,6,7], 2, 2);
      var m3 = m1.rbind(m2);
      expect(m3.toList(), [0,1,4,5,2,3,6,7]);
    });
    test('cbind', (){
      var m1 = DoubleMatrix([0,1,2,3], 2, 2);
      var m2 = DoubleMatrix([4,5,6,7], 2, 2);
      var m3 = m1.cbind(m2);
      expect(m3.toList(), [0,1,2,3,4,5,6,7]);
    });
    test('get matrix diagonal', () {
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      expect(m1.diag, [0,3]);
    });
    test('set matrix diagonal', () {
      var m = Matrix([0,0,0,0,0,0], 2, 3);
      m.diag = [1,1];
      expect(m.toList(byRow: true), [1.0,0.0,0.0,  0.0,1.0,0.0]);
    });
    test('row apply', (){
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      sum(List x) => x.fold(0.0, (dynamic a,b) => a+b);
      expect(m1.rowApply(sum).toList(), [6,9]);
    });
    test('column apply', (){
      var m1 = Matrix([0,1,2,3,4,5], 2, 3);
      sum(List x) => x.fold(0.0, (dynamic a,b) => a+b);
      expect(m1.columnApply(sum).toList(), [1,5,9]);
    });
    test('matrix norm', (){
      var m = Matrix([-3,2,0, 5,6,2, 7,4,8], 3, 3);
      expect(m.norm(p: '1'), 19);
      expect(m.norm(p: 'INFINITY'), 15);
    });
    test('matrix multiplication', (){
      var m1 = DoubleMatrix([0,1,2,3,4,5], 2, 3);
      var m2 = DoubleMatrix([0,1,2,3,4,5], 3, 2);
      var m = m1.multiply(m2);
      expect(m, DoubleMatrix([10, 13, 28, 40], 2, 2));
    });
  });
}

//diagMatrix() {
//  group('Diagonal matrix: ', (){
//    test('create and check elements', (){
//      var m = new DiagonalMatrix([1,2,3]);
//      expect(m.element(1,1), 2);
//      expect(m.element(0,1), 0);
//    });
//    test('multiply a diagonal matrix', (){
//      var m1 = new DiagonalMatrix([1,2,3]);
//      var m2 = Matrix([0,1,2,3,4,5], 3, 2);
//      var m = m1.multiply(m2);
//      expect(m, Matrix([0,2,6, 3,8,15], 3, 2));
//    });
//  });
//}

void printMatrix() {
  test('print matrix', (){
    var m = Matrix([0,1,2,3,4,5], 3, 2);
    expect(m.toString(),
    '      [,0]  [,1]\n[0,] 0.000 3.000\n[1,] 1.000 4.000\n[2,] 2.000 5.000');
  });

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




void main() {
  basicOps();

  //diagMatrix();

  printMatrix();

}
