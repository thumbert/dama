library special.hyperbolic_trig;

import 'dart:math';

/// Returns the hyperbolic sine of x.
num sinh(num x) => 0.5 * (exp(x) - exp(-x));

/// Returns hyperbolic cosine of x.
num cosh(num x) => 0.5 * (exp(x) + exp(-x));

/// Returns hyperbolic tangent of x.
num tanh(num x) => (exp(2 * x) - 1) / (exp(2 * x) + 1);

/// Returns hyperbolic cotangent of x.
num coth(num x) => (exp(2 * x) + 1) / (exp(2 * x) - 1);

/// Returns hyperbolic secant (1 / cosh(x)) of x.
num sech(num x) => ((2 * exp(x) / exp(2 * x) + 1));

/// Returns hyperbolic cosecant (1 / sinh(x)) of x
num csch(num x) => ((2 * exp(x) / exp(2 * x) - 1));
