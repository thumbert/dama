library stat.estimate.kernel_density_estimator;

import 'dart:math';
import 'package:dama/dama.dart';

enum KernelType { gaussian, epanechnikov, biweight }

class KernelDensityEstimator {
  List<num> data;
  num bandwidth;
  KernelType kernelType;

  num Function(num) kernel;

  final _functions = {
    KernelType.gaussian: (num x) => exp(-0.5 * x * x) / sqrt(2 * pi),
    KernelType.epanechnikov: (num x) => (x.abs() <= 1) ? 0.75 * (1 - x * x) : 0,
    KernelType.biweight: (num x) =>
        (x.abs() <= 1) ? 0.9375 * pow(1 - x * x, 2) : 0,
  };

  KernelDensityEstimator(this.data,
      {this.bandwidth, this.kernelType = KernelType.gaussian}) {
    bandwidth ??= 1.06 * sqrt(variance(data)) * exp(-0.2 * log(data.length));
    var _fun = _functions[kernelType];
    kernel =
        (x) => mean(data.map((e) => _fun((x - e) / bandwidth))) / bandwidth;
  }

  num valueAt(num x) => kernel(x);
}
