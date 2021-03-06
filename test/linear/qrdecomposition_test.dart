

library linear.qrdecomposition_test;

import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/linear/qr_decomposition.dart';
import 'package:dama/linear/decomposition_solver.dart';
import 'package:dama/src/utils/matchers.dart';

qrDecomposition() {
  group('QR decomposition: ', (){
    test('3x3 non singular', (){
      Matrix m = new Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-14, 0, 0, -21, -175, 0, 14, 70, 35], 3, 3);
      Matrix qExp = new Matrix([-0.8571428571,0.3942857143,-0.3314285714,-0.4285714286,-0.9028571429,0.0342857143,
      0.2857142857,-0.1714285714,-0.9428571429], 3, 3, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm(), precision: 1E-10));
      expect(qr.getQ()!.norm(), equalsWithPrecision(qExp.norm(), precision: 1E-10));

      DecompositionSolver solver = qr.getSolver();
      List x = solver.solveVector(new ColumnMatrix([1,1,1])).data;
      List xExp = [0.0514285714285714, -0.0102857142857143, -0.0354285714285714];
      [0,1,2].forEach((i) => expect(x[i], equalsWithPrecision(xExp[i], precision: 1E-14)));
    });
    test('3x3 singular', (){
      Matrix m = new Matrix([1,2,3,4,5,6,7,8,9], 3, 3);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-3.7416573868,0,0,-8.5523597412,1.9639610121,0,-13.3630620956,3.9279220242,0.0], 3, 3);
      Matrix qExp = new Matrix([-0.2672612419,0.8728715609,0.4082482905, -0.5345224838,0.2182178902,-0.8164965809,
      -0.8017837257,-0.4364357805,0.4082482905], 3, 3, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm(), precision: 1E-10));
      expect(qr.getQ()!.norm(), equalsWithPrecision(qExp.norm(), precision: 1E-10));

      DecompositionSolver solver = qr.getSolver();
      List x = solver.solveVector(new ColumnMatrix([1,1,1])).data;
      expect(true, x.every((e) => e.isNaN));  // singular
    });
    test('3x4 matrix', (){
      Matrix m = new Matrix([12,-51,4,1, 6,167,-68,2, -4,24,-41,3], 3, 4, byRow: true);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-14.0,-21.0,14.0,-0.8571428571,0.0,-175.0,70.0,-1.9257142857,0.0,0.0,35.0,-3.0914285714],
      3, 4, byRow: true);
      Matrix qExp = new Matrix([-0.8571428571,0.3942857143,-0.3314285714, -0.4285714286,-0.9028571429,0.0342857143,
      0.2857142857,-0.1714285714,-0.9428571429], 3, 3, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm(), precision: 1E-10));
      expect(qr.getQ()!.norm(), equalsWithPrecision(qExp.norm(), precision: 1E-10));
    });
    test('4x3 matrix', (){
      Matrix m = new Matrix([12,-51,4, 6,167,-68, -4,24,-41, -5,34,7], 4, 3, byRow: true);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-14.8660687473,-8.3411426456,15.5387415413, 0.0,-179.3109738398,67.906547377, 0.0,0.0,38.95187203, 0.0,0.0,0.0],
      4, 3, byRow: true);
      Matrix qExp = new Matrix([-0.8072073528,0.3219715472,-0.1366042098,0.475489119, -0.4036036764,-0.9125681527,0.0061831614,-0.0654614965,
      0.2690691176,-0.1463621737,-0.9047587127,0.2959587739, 0.336336397,-0.2052603311,0.4033766604,0.8258530707], 4, 4, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm(), precision: 1E-10));
      expect(qr.getQ()!.norm(), equalsWithPrecision(qExp.norm(), precision: 1E-10));
    });
    test('solve 3x3 non-singular', (){
      Matrix m = new Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
      DecompositionSolver solver = new QRDecomposition(m).getSolver();
      List x = solver.solveVector(new ColumnMatrix([1,1,1])).data;
      List xExp = [0.0514285714285714, -0.0102857142857143, -0.0354285714285714];
      [0,1,2].forEach((i) => expect(x[i], equalsWithPrecision(xExp[i], precision: 1E-14)));
    });
  });

}

main() {
  qrDecomposition();
}
