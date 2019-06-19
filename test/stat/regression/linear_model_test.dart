library test.stat.regression;


import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/stat/regression/linear_model.dart';
import 'package:dama/src/utils/matchers.dart';

testLongley() {
  /**
   * Test Longley dataset against certified values provided by NIST.
   * Data Source: J. Longley (1967) "An Appraisal of Least Squares
   * Programs for the Electronic Computer from the Point of View of the User"
   * Journal of the American Statistical Association, vol. 62. September,
   * pp. 819-841.
   *
   * Certified values (and data) are from NIST:
   * http://www.itl.nist.gov/div898/strd/lls/data/LINKS/DATA/Longley.dat
   */
  var aux = <num>[
    60323, 83.0, 234289, 2356, 1590, 107608, 1947, //
    61122, 88.5, 259426, 2325, 1456, 108632, 1948, //
    60171, 88.2, 258054, 3682, 1616, 109773, 1949, //
    61187, 89.5, 284599, 3351, 1650, 110929, 1950, //
    63221, 96.2, 328975, 2099, 3099, 112075, 1951, //
    63639, 98.1, 346999, 1932, 3594, 113270, 1952, //
    64989, 99.0, 365385, 1870, 3547, 115094, 1953, //
    63761, 100.0, 363112, 3578, 3350, 116219, 1954, //
    66019, 101.2, 397469, 2904, 3048, 117388, 1955, //
    67857, 104.6, 419180, 2822, 2857, 118734, 1956, //
    68169, 108.4, 442769, 2936, 2798, 120445, 1957, //
    66513, 110.8, 444546, 4681, 2637, 121950, 1958, //
    68655, 112.6, 482704, 3813, 2552, 123366, 1959, //
    69564, 114.2, 502601, 3931, 2514, 125368, 1960, //
    69331, 115.7, 518173, 4806, 2572, 127852, 1961, //
    70551, 116.9, 554894, 4007, 2827, 130081, 1962
  ];
  var y = ColumnMatrix(List.generate(16, (i) => aux[i * 7]));
  // add a column of 1's for the intercept term
  var x = ColumnMatrix.filled(16, 1).cbind(DoubleMatrix(
      List.generate(16 * 7, (i) => i)
          .where((i) => (i % 7) != 0)
          .map((i) => aux[i])
          .toList(),
      16,
      6,
      byRow: true));
  var lm = LinearModel(x, y);
  var coeffAct = lm.coefficients;
  var coeffExp = [
    -3482258.63459582,
    15.0618722713733,
    -0.358191792925910E-01,
    -2.02022980381683,
    -1.03322686717359,
    -0.511041056535807E-01,
    1829.15146461355
  ];
  List.generate(7, (i) => i).forEach((i) => expect(coeffAct[i],
      equalsWithPrecision(coeffExp[i], precision: 1E-11, relative: true)));

  var residualsAct = lm.residuals();
  var residualsExp = [
    267.340029759711,
    -94.0139423988359,
    46.28716775752924,
    -410.114621930906,
    309.7145907602313,
    -249.3112153297231,
    -164.0489563956039,
    -13.18035686637081,
    14.30477260005235,
    455.394094551857,
    -17.26892711483297,
    -39.0550425226967,
    -155.5499735953195,
    -85.6713080421283,
    341.9315139607727,
    -206.7578251937366
  ];
  for (int i = 0; i < residualsExp.length; i++) {
    expect(residualsExp[i],
        equalsWithPrecision(residualsAct[i], precision: 1E-8));
  }

  expect(lm.errorVariance(), equalsWithPrecision(92936.006167, precision: 1E-6));
  expect(lm.totalSumOfSquares(),
      equalsWithPrecision(1.850088260000004E8, precision: 1E-2));
  expect(lm.regressionStandardError(),
      equalsWithPrecision(304.8540735619638, precision: 1E-10));


  var errors = lm.regressionParametersStandardErrors();
  var errorsExp = <num>[890420.383607373,
    84.9149257747669,
    0.334910077722432E-01,
    0.488399681651699,
    0.214274163161675,
    0.226073200069370,
    455.478499142212];
  for (int i = 0; i < errors.length; i++) {
    expect(errorsExp[i], equalsWithPrecision(errors[i], precision: 1E-6));
  }
  
  var rSquared = lm.rSquared();
  expect(rSquared, equalsWithPrecision(0.995479004577296, precision: 1E-12));

}

testCars() {
  var data = <num>[
    4,
    2,
    4,
    10,
    7,
    4,
    7,
    22,
    8,
    16,
    9,
    10,
    10,
    18,
    10,
    26,
    10,
    34,
    11,
    17,
    11,
    28,
    12,
    14,
    12,
    20,
    12,
    24,
    12,
    28,
    13,
    26,
    13,
    34,
    13,
    34,
    13,
    46,
    14,
    26,
    14,
    36,
    14,
    60,
    14,
    80,
    15,
    20,
    15,
    26,
    15,
    54,
    16,
    32,
    16,
    40,
    17,
    32,
    17,
    40,
    17,
    50,
    18,
    42,
    18,
    56,
    18,
    76,
    18,
    84,
    19,
    36,
    19,
    46,
    19,
    68,
    20,
    32,
    20,
    48,
    20,
    52,
    20,
    56,
    20,
    64,
    22,
    66,
    23,
    54,
    24,
    70,
    24,
    92,
    24,
    93,
    24,
    120,
    25,
    85,
  ];
  var speed = ColumnMatrix(List.generate(50, (i) => data[i * 2]));
  var dist = ColumnMatrix(List.generate(50, (i) => data[i * 2 + 1]));
  var X =
      ColumnMatrix.filled(50, 1.0).cbind(DoubleMatrix(speed.toList(), 50, 1));

  var reg = LinearModel(X, dist);
  expect(reg.coefficients.map((e) => e.toStringAsFixed(4)).toList(),
      ['-17.5791', '3.9324']);

  var rSquared = reg.rSquared();
  expect(rSquared, equalsWithPrecision(0.6510794, precision: 1E-7));

  var regStdError = reg.regressionStandardError();
  expect(regStdError.toStringAsFixed(5), '15.37959'); // fails on 3th digit 15/3796

  var residuals = reg.residuals();
  expect(residuals[0].toStringAsFixed(6), '3.849460');
  expect(residuals[2].toStringAsFixed(6), '-5.947766');

  var actualStdErrors = reg.regressionParametersStandardErrors();
  expect(actualStdErrors[0].toStringAsFixed(5), '6.75844');
  expect(actualStdErrors[1].toStringAsFixed(5), '0.41551');
}

tests() {
  group('Linear model regression: ', () {
    test('Longley data', () => testLongley());
    test('R cars data', () => testCars());
  });
}

main() {
  tests();
}
