library special.erf;

import 'dart:math';

/// Calculate \Phi(x) = \int_{-\infty}^x dt e^{-t^2/2}/\sqrt{2*\pi}.
/// \Phi(\infty)=1
/// Based on Marsaglia's 'Evaluating the Normal Distribution Function', 2004.
/// http://www.jstatsoft.org/v11/a05/paper
double Phi(num x) {
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
double erf(num x) => 2 * Phi(x * sqrt(2)) - 1;

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
