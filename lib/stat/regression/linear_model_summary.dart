library stat.regression.linear_model_summary;

import 'dart:math';

import 'package:dama/analysis/integration/tanhsinh_integrator.dart';
import 'package:dama/dama.dart';
import 'package:table/table_base.dart';

class LinearModelSummary {
  LinearModelSummary(this.lm) {
    nu = lm.residuals().length - lm.coefficients.length;
  }

  final LinearModel lm;
  /// degrees of freedom
  late final int nu;

  List<Map<String,dynamic>> makeTable() {
    var names = lm.names ?? List.generate(lm.coefficients.length, (i) => '$i');
    var coeff = lm.coefficients;
    var sd = lm.regressionParametersStandardErrors();
    var tValues = [for (var i = 0; i < names.length; i++) coeff[i] / sd[i]];
    var prob = tValues.map((t) => pValue(t)).toList();
    var star = prob.map(stars).toList();

    var out = <Map<String,dynamic>>[];
    for (var i=0; i<names.length; i++){
      out.add({
        ' ': names[i],
        'Estimate': coeff[i],
        'Std. Error': sd[i],
        't value': tValues[i],
        'Pr(>|t|)': prob[i],
        '  ': star[i],
      });
    }

    return out;
  }


  final _quad = TanhSinhIntegrator();

  final _residualsOptions = {
    'format': {
      'Min': (x) => (x as double).toStringAsPrecision(5),
      '1Q': (x) => (x as double).toStringAsPrecision(5),
      'Median': (x) => (x as double).toStringAsPrecision(5),
      '3Q': (x) => (x as double).toStringAsPrecision(5),
      'Max': (x) => (x as double).toStringAsPrecision(5),
    },
    'columnSeparation': '  ',
  };

  /// Calculate the stars given the probability
  String stars(double p) {
    if (p <= 0.001) {
      return '***';
    } else if (p <= 0.01) {
      return '**';
    } else if (p <= 0.05) {
      return '*';
    } else if (p <= 0.1) {
      return '.';
    } else {
      return '';
    }
  }

  /// Try to replicate R's output.
  @override
  String toString() {
    var out = 'Residuals:\n';
    var aux = summary(lm.residuals());
    var resid = {
      'Min': aux['Min.'],
      '1Q': aux['1st Qu.'],
      'Median': aux['Median'],
      '3Q': aux['3rd Qu.'],
      'Max': aux['Max.'],
    };
    var residuals = Table.from([resid], options: _residualsOptions);
    out += residuals.toString();

    fmtValue(double x) {
      if (x.abs() < 1000) {
        return x.toStringAsFixed(4);
      } else {
        return x.toStringAsExponential(4);
      }
    }

    out += '\n\nCoefficients:\n';
    var coeffOptions = {
      'format': {
        'Estimate': (x) => fmtValue(x as double),
        'Std. Error': (x) => fmtValue(x as double),
        't value': (x) => (x as double).toStringAsFixed(3),
        'Pr(>|t|)': (x) => (x as double).toStringAsPrecision(3),
      },
      'columnSeparation': ' ',
    };

    var table = Table.from(makeTable(), options: coeffOptions);
    out += table.toString();
    out += '\n---';
    out +=
        '\nSignif. codes:  0 \'***\' 0.001 \'**\' 0.01 \'*\' 0.05 \'.\' 0.1 \' \' 1';

    var rse = lm.regressionStandardError().toStringAsFixed(3);
    out += '\n\nResidual standard error: $rse on $nu degrees of freedom';
    out += '\nMultiple R-squared: ${lm.rSquared().toStringAsFixed(4)}';

    return out;
  }

  /// Calculate the p-value by numerical quadrature.
  /// https://en.wikipedia.org/wiki/Student%27s_t-distribution#Integral_of_Student's_probability_density_function_and_p-value
  ///
  double pValue(double t) {
    var x = nu / (nu + t * t);
    return regularizedBetaFunction(x, nu / 2.0, 0.5);
  }

  /// I_x(a,b) = B(x; a, b)/B(a,b)
  double regularizedBetaFunction(double x, double a, double b) {
    return incompleteBetaFunction(x, a, b)! / betaFunction(a, b)!;
  }

  double? incompleteBetaFunction(double x, double a, double b) {
    return _quad.integrate(
        100000, (t) => exp((a - 1) * log(t) + (b - 1) * log(1 - t)), 0.0, x);
  }

  double? betaFunction(double a, double b) {
    return _quad.integrate(
        100000, (t) => exp((a - 1) * log(t) + (b - 1) * log(1 - t)), 0.0, 1.0);
  }
}
