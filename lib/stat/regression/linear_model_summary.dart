library stat.regression.linear_model_summary;

import 'dart:math';

import 'package:dama/analysis/integration/tanhsinh_integrator.dart';
import 'package:dama/dama.dart';
import 'package:table/table.dart';

class LinearModelSummary {
  LinearModel lm;

  /// degrees of freedom
  int nu;

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
  final String Function(double) stars = (double p) {
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
  };

  LinearModelSummary(this.lm);

  /// Try to replicate R's output.
  @override
  String toString() {
    var out = '\nResiduals:\n';
    var _aux = summary(lm.residuals());
    var _resid = {
      'Min': _aux['Min.'],
      '1Q': _aux['1st Qu.'],
      'Median': _aux['Median'],
      '3Q': _aux['3rd Qu.'],
      'Max': _aux['Max.'],
    };
    var residuals = Table.from([_resid], options: _residualsOptions);
    out += residuals.toString();

    var names = lm.names ?? List.generate(lm.coefficients.length, (i) => '$i');
    var coeff = lm.coefficients;
    var sd = lm.regressionParametersStandardErrors();
    var tValues = [for (var i=0; i<names.length; i++) coeff[i]/sd[i]];
    nu = lm.residuals().length - coeff.length;

    out += '\n\nCoefficients:\n';
    var _coeffOptions = {
      'format': {
        'Estimate': (x) => (x as double).toStringAsFixed(4),
        'Std. Error': (x) => (x as double).toStringAsFixed(4),
        't value': (x) => (x as double).toStringAsFixed(3),
        'Pr(>|t|)': (x) => (x as double).toStringAsPrecision(3),
      }
    };
    var prob = tValues.map((t) => pValue(t)).toList();

    var table = Table(options: _coeffOptions)
      ..addColumn(names, name: ' ')
      ..addColumn(coeff, name: 'Estimate')
      ..addColumn(sd, name: 'Std. Error')
      ..addColumn(tValues, name: 't value')
      ..addColumn(prob, name: 'Pr(>|t|)')
      ..addColumn(prob.map(stars).toList(), name: '  ');
    out += table.toString();
    out += '\n---';
    out += '\nSignif. codes:  0 \'***\' 0.001 \'**\' 0.01 \'*\' 0.05 \'.\' 0.1 \' \' 1';

    var rse = lm.regressionStandardError().toStringAsFixed(3);
    out += '\n\nResidual standard error: $rse on ${nu} degrees of freedom';
    out += '\nMultiple R-squared: ${lm.rSquared().toStringAsFixed(4)}';

    return out;
  }

  /// Calculate the p-value by numerical quadrature.
  /// https://en.wikipedia.org/wiki/Student%27s_t-distribution#Integral_of_Student's_probability_density_function_and_p-value
  ///
  double pValue(double t) {
    var x = nu/(nu + t*t);
    return regularizedBetaFunction(x, nu/2.0, 0.5);
  }

  /// I_x(a,b) = B(x; a, b)/B(a,b)
  double regularizedBetaFunction(double x, double a, double b) {
    return incompleteBetaFunction(x, a, b)/betaFunction(a, b);
  }

  double incompleteBetaFunction(double x, double a, double b) {
    return _quad.integrate(100000, (t) => exp((a-1)*log(t) + (b-1)*log(1-t)), 0.0, x);
  }

  double betaFunction(double a, double b) {
    return _quad.integrate(100000, (t) => exp((a-1)*log(t) + (b-1)*log(1-t)), 0.0, 1.0);
  }

}
