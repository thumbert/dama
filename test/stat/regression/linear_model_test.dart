library test.stat.regression;

import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/stat/regression/linear_model.dart';
import 'package:dama/src/utils/matchers.dart';

linearModel() {
  group('Linear model regression: ', () {
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
    test('Longley data', () {
      List<num> aux = [
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
      ColumnMatrix y =
          new ColumnMatrix(new List.generate(16, (i) => aux[i * 7]));
      // add a column of 1's for the intercept term
      DoubleMatrix x = new ColumnMatrix.filled(16, 1).cbind(new DoubleMatrix(
          new List.generate(16 * 7, (i) => i)
              .where((i) => (i % 7) != 0)
              .map((i) => aux[i])
              .toList(),
          16,
          6,
          byRow: true));
      LinearModel lm = new LinearModel(x, y);
      List coeffAct = lm.coefficients;
      List coeffExp = [-3482258.63459582, 15.0618722713733,
      -0.358191792925910E-01,-2.02022980381683,
      -1.03322686717359,-0.511041056535807E-01,
      1829.15146461355];
      new List.generate(7, (i) => i).forEach((i) => expect(coeffAct[i],
        equalsWithPrecision(coeffExp[i], precision: 1E-11, relative: true)));

    });
  });
}

main() {
  linearModel();
}
