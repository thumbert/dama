library special.erf;

import 'dart:math';

/// A simple recursive implementation of the Gamma function.
/// Works for positive integer arguments only.
num gamma(num x) {
  if (x <= 0) {
    throw ArgumentError('Argument x needs to be > 0');
  }
  if (x == 1) return 1;
  if (x == 2) return 1;
  return (x - 1) * gamma(x - 1);
}

/// Calculate \Phi(x) = \int_{-\infty}^x dt e^{-t^2/2}/\sqrt{2*\pi}.
/// \Phi(\infty)=1
/// Based on Marsaglia's 'Evaluating the Normal Distribution Function', 2004.
/// http://www.jstatsoft.org/v11/a05/paper
double phi(num x) {
  if (x < -8.0) return 0.0;
  if (x > 8.0) return 1.0;
  var sum = 0.0;
  var term = x.toDouble();
  for (var i = 3; sum + term != sum; i += 2) {
    sum += term;
    term *= x * x / i;
  }
  return 0.5 + sum * exp(-0.5 * x * x - 0.91893853320467274178);
}

/// Calculate the error function: 2/\sqrt{\pi} \int_0^x dt e^{-t^2}.
/// <p>erf(0) = 0;  erf(\infty) = 1
double erf(num x) => 2 * phi(x * sqrt(2)) - 1;

/// Return the inverse standard normal CDF for a probability in (0, 1).
///
/// This is equivalent to sqrt(2) * erf^-1(2 * probability - 1).
double inverseStandardNormal(num probability) {
  if (probability <= 0 || probability >= 1) {
    throw ArgumentError('Probability needs to be between 0 and 1');
  }

  const a = [
    -3.969683028665376e1,
    2.209460984245205e2,
    -2.759285104469687e2,
    1.383577518672690e2,
    -3.066479806614716e1,
    2.506628277459239,
  ];
  const b = [
    -5.447609879822406e1,
    1.615858368580409e2,
    -1.556989798598866e2,
    6.680131188771972e1,
    -1.328068155288572e1,
  ];
  const c = [
    -7.784894002430293e-3,
    -3.223964580411365e-1,
    -2.400758277161838,
    -2.549732539343734,
    4.374664141464968,
    2.938163982698783,
  ];
  const d = [
    7.784695709041462e-3,
    3.224671290700398e-1,
    2.445134137142996,
    3.754408661907416,
  ];

  final p = probability.toDouble();
  double z;
  if (p < 0.02425) {
    final q = sqrt(-2 * log(p));
    z = (((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) /
        ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
  } else if (p > 1 - 0.02425) {
    final q = sqrt(-2 * log(1 - p));
    z = -(((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) /
        ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
  } else {
    final q = p - 0.5;
    final r = q * q;
    z = (((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r + a[5]) *
        q /
        (((((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]) * r + 1);
  }

  if (p > 1e-15 && p < 1 - 1e-15) {
    final error = phi(z) - p;
    final density = exp(-0.5 * z * z) / sqrt(2 * pi);
    z -= error / density;
  }
  return z;
}

/// Calculate 1 - \Phi(x) = \int_{x}^\infty dt e^{-t^2/2}/\sqrt{2*\pi}.
/// This is needed to achieve relative accuracy for large argument values [x].
double cPhi(num x) {
  var i = (0.5 * (x.abs() + 1)).truncate();
  var j = i;
  final R = [
    1.25331413731550025,
    0.421369229288054473,
    0.236652382913560671,
    0.162377660896867462,
    .123131963257932296,
    0.0990285964717319214,
    0.0827662865013691773,
    .0710695805388521071,
    0.0622586659950261958
  ];
  var pwr = 1.0,
      a = R[j],
      z = 2.0 * j,
      b = a * z - 1,
      h = x.abs() - z,
      s = a + h * b,
      t = a,
      q = h * h;
  for (i = 2; s != t; i += 2) {
    a = (a + z * b) / i;
    b = (b + z * a) / (i + 1);
    pwr *= q;
    t = s;
    s = t + pwr * (a + h * b);
  }
  s = s * exp(-.5 * x * x - 0.91893853320467274178);
  if (x >= 0) {
    return s;
  } else {
    return (1.0 - s);
  }
}
