library basic.num_extensions;

import 'dart:math' show max;

extension NumExtensions on num {
  /// Compare if two numbers are close up to a relative tolerance.
  /// Copied from https://stackoverflow.com/questions/5595425/what-is-the-best-way-to-compare-floats-for-almost-equality-in-python
  bool isCloseTo(num x,
      {num relativeTolerance = 1e-9, num absoluteTolerance = 0.0}) {
    return (this - x).abs() <=
        max(relativeTolerance * max(abs(), x.abs()), absoluteTolerance);
  }
}

extension DoubleExtensions on double {
  /// Compare if two numbers are close up to a relative tolerance.
  /// Copied from https://stackoverflow.com/questions/5595425/what-is-the-best-way-to-compare-floats-for-almost-equality-in-python
  bool isCloseTo(double x,
      {num relativeTolerance = 1e-9, num absoluteTolerance = 0.0}) {
    return (this - x).abs() <=
        max(relativeTolerance * max(abs(), x.abs()), absoluteTolerance);
  }
}
