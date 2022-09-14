// ABANDONED it because I couldn't replicate the paper and did not
// go to the source to read it.

// library stat.meboot;
//
// import 'dart:math';
//
// import 'package:dama/analysis/interpolation/multi_linear_interpolator.dart';
// import 'package:dama/dama.dart';
// import 'package:more/iterable.dart';
//
// /// Implement Vinod's meboot R package functionality
// /// http://cran.wustl.edu/web/packages/meboot/vignettes/meboot.pdf
//
// class MeBoot {
//   MeBoot(this.xs, {this.trimPercentage = 0.1, int seed = 0}) {
//     random = Random(seed);
//   }
//
//   final List<num> xs;
//   final num trimPercentage;
//   late final Random random;
//
//   bool _isPrepped = false;
//
//   /// ordered values
//   late List<num> _oxs;
//
//   /// ordered index
//   late List<int> _oix;
//
//   late MultiLinearInterpolator interpolator;
//
//   /// Generate a new sample.
//   List<num> sample() {
//     if (!_isPrepped) {
//       _prepData();
//     }
//
//     var etas = [0.12, 0.83, 0.53, 0.59, 0.11];
//
//     var yCandidates = List.generate(xs.length, (i) {
//       // var eta = random.nextDouble();
//       var eta = etas[i];
//       return interpolator.valueAt(eta);
//     }, growable: false);
//
//     // reorder them according to the initial order
//     var ys = List.generate(xs.length, (i) {
//       return yCandidates[_oix[i]];
//     }, growable: false);
//
//     return ys;
//   }
//
//   void _prepData() {
//     var aux = [...xs].indexed().toList()
//       ..sort((a, b) => a.value.compareTo(b.value));
//     _oxs = aux.map((e) => e.value).toList();
//     _oix = aux.map((e) => e.index).toList();
//     var dxs = <num>[];
//     for (var i = 1; i < xs.length; i++) {
//       dxs.add(xs[i] - xs[i - 1]);
//     }
//     var _trimmedMean = trimmedMean(xs, trimPercentage: trimPercentage);
//     var _z0 = _oxs.first - _trimmedMean;
//     _z0 = -11.0;
//     var _zT = _trimmedMean + _oxs.last;
//     _zT = 51.0;
//
//     var _intermediatePoints = <num>[_z0];
//     for (var i = 1; i < xs.length; i++) {
//       _intermediatePoints.add(0.5 * (_oxs[i] + _oxs[i - 1]));
//     }
//     _intermediatePoints.add(_zT);
//
//     // var means = <num>[0.75 * _oxs[0] + 0.25 * _oxs[1]];
//     // for (var i = 1; i < xs.length - 1; i++) {
//     //   means.add(0.25 * _oxs[i - 1] + 0.5 * _oxs[i] + 0.25 * _oxs[i + 1]);
//     // }
//     // means.add(0.25 * _oxs[xs.length - 1] + 0.75 * _oxs.last);
//
//     interpolator = MultiLinearInterpolator(
//         [...List.generate(xs.length, (i) => i / xs.length), 1.0],
//         _intermediatePoints);
//
//     _isPrepped = true;
//   }
// }
