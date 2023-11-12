library test_quadrature_1d;

import 'dart:math';
import 'package:test/test.dart';
import 'package:dama/analysis/integration/tanhsinh_integrator.dart';
import 'package:dama/analysis/integration/gausslegendre_integrator.dart';
import 'package:dama/analysis/integration/filon_integrator.dart';
import 'package:dama/analysis/integration/univariate_integrator.dart';
import 'package:dama/src/utils/matchers.dart';

/**
 * Test problems from
 * http://projecteuclid.org/download/pdf_1/euclid.em/1128371757
 * The following 15 integrals were used as a test suite to
 * compare these three quadrature schemes. In each case
 * an analytic result is known, as shown below, facilitating
 * the checking of results. The 15 integrals are listed in five
 * groups:
 *   1–4: continuous, well-behaved functions (all deriva-
 *     tives exist and are bounded) on finite intervals;
 *   5–6: continuous functions on finite intervals, but
 *     with an infinite derivative at an endpoint;
 *  7–10: functions on finite intervals with an integrable
 *     singularity at an endpoint;
 *  11–13: functions on an infinite interval;
 *  14–15: oscillatory functions on an infinite interval.
 *
 */

/// Round a double to a certain digit.
/// e.g. round(1.23456, 2) == 1.23
///
double round(double value, [int digit = 1]) {
  if (value.isFinite) {
    var pow10 = pow(10.0, digit) as double;
    return (pow10 * value).round() / pow10;
  } else {
    return value;
  }
}

Map<int, Map<String, dynamic>> getHarness() {
  var harness = {
    1: {
      'problem': r'\int_0^1 x \log(1+x) dx = 0.25',
      'function': (num x) => x * log(1 + x),
      'limits': [0, 1],
      'result': 0.25
    },
    2: {
      'problem': r'\int_0^1 x^2 \arctan(x) dx = (pi - 2 + 2log2)/12',
      'function': (x) => pow(x, 2) * atan(x),
      'limits': [0, 1],
      'result': 0.210657251225806988108092302182988001695680805674634694
    },
    3: {
      'problem': r'\int_0^{\pi/2} \exp(x)\cos(x) dx = (e^{\pi/2} - 1)/2',
      'function': (x) => exp(x) * cos(x),
      'limits': [0, pi / 2],
      'result': 1.905238690482675827736517833351916563195085437332267470010407
    },
    4: {
      'problem':
          r'\int_0^1 \frac{\arctan(\sqrt{2+x^2})}{(1+x^2)\sqrt{2+x^2}} dx = 5\pi^2/96',
      'function': (x) =>
          atan(sqrt(2 + x * x)) / ((1 + x * x) * sqrt(2 + x * x)),
      'limits': [0, 1],
      'result': 0.514041895890070761397629739576882871630921844127124511792361
    },
    5: {
      'problem': r'\int_0^1 \sqrt{x}\log(x)) dx = -4/9',
      'function': (x) => sqrt(x) * log(x),
      'limits': [0, 1],
      'result': -0.444444444444444444444444444
    },
    6: {
      'problem': r'\int_0^1 \sqrt{1-x^2}) dx = \pi/4',
      'function': (x) => sqrt(1 - x * x),
      'limits': [0, 1],
      'result': 0.7853981633974483096156608458198757210492923498437764
    },
    7: {
      'problem':
          r'\int_0^1 \frac{\sqrt{x}}{\sqrt{1-x^2}}) dx = 2\sqrt{\pi}\Gamma(3/4)/\Gamma(1/4)',
      'function': (x) => sqrt(x) / sqrt(1 - x * x),
      'limits': [0, 1],
      'result': 1.19814023473559220743992249228032387822721266321565155826367
    },
    8: {
      'problem': r'\int_0^1 \log(x)^2 dx = 2',
      'function': (x) => log(x) * log(x),
      'limits': [0, 1],
      'result': 2
    },
    9: {
      'problem': r'\int_0^{\pi/2} \log(\cos x) dx = -\pi\log(2)/2',
      'function': (x) => log(cos(x)),
      'limits': [0, pi / 2],
      'result': -1.08879304515180106525034444911880697366929185018464314716289
    },
    10: {
      'problem': r'\int_0^{\pi/2} \sqrt(\tan x) dx = \pi\sqrt(2)/2',
      'function': (x) => sqrt(tan(x)),
      'limits': [0, pi / 2],
      'result': 2.221441469079183123507940495030346849307310844687845111542
    },
    11: {
      // note the change in variable y = 1/(1+x)
      'problem': r'\int_0^{\infty} \frac{1}{1+x^2} dx = \pi/2',
      'function': (y) => 1.0 / (1.0 - 2.0 * y + 2 * y * y),
      'limits': [0, 1],
      'result': 1.570796326794896619231321691639751442098584699687552910487472
    },
    12: {
      // note the change in variable y = 1/(1+x)
      'problem': r'\int_0^{\infty} \frac{e^{-x}}{\sqrt{x}} dx = \sqrt{\pi}',
      'function': (y) => exp(1 - 1.0 / y) / sqrt(pow(y, 3) - pow(y, 4)),
      'limits': [0, 1],
      'result': 1.772453850905516027298167483341145182797549456122387128213807
    },
    13: {
      // note the change in variable y = 1/(1+x)
      'problem': r'\int_0^{\infty} e^{-x^2/2} dx = \sqrt{\pi/2}',
      'function': (y) => exp(-0.5 * pow(1.0 / y - 1, 2)) / pow(y, 2),
      'limits': [0, 1],
      'result': 1.25331413731550025120788264240552262650349337030496915831496
    },
    14: {
      // note the change in variable y = 1/(1+x)
      'problem': r'\int_0^{\infty} e^{-x}\cos x dx = 1/2',
      'function': (y) => exp(1 - 1 / y) * cos(1 / y - 1) / pow(y, 2),
      'limits': [0, 1],
      'result': 0.5
    },
    15: {
      'problem': r'\int_0^1 x^6 \sin(10\pi x) dx = 0.0059568281477...',
      'function': (x) => pow(x, 6) * cos(10 * pi * x),
      'limits': [0, 1],
      'result': 0.005956828147744827278016119076475372232470412836389028335703
    }
  };
  return harness;
}

void testQuadrature1D(UnivariateIntegrator quad, Map precision) {
  var harness = getHarness();
  for (var i in harness.keys) {
    var info = harness[i]!;
    num? r = quad.integrate(
        1000000,
        info['function'] as double Function(double),
        info['limits'][0],
        info['limits'][1]);
    num? rel = 7E-13;
    if (precision.containsKey(i)) rel = precision[i];
    if (!rel!.isNaN) {
      test(info['problem'], () {
        expect(
            r,
            equalsWithPrecision(info['result'],
                precision: rel!, relative: true));
      });
    }
  }
}

void main() {
  group('TanhSinh integrator', () {
    var precision = {7: 1E-6, 10: 1E-8, 12: 1E-6};
    testQuadrature1D(TanhSinhIntegrator(), precision);
  });

  group('GaussLegendre integrator', () {
    var precision = {
      5: 1E-7,
      6: 1E-7,
      7: 1E-4,
      8: 1E-5,
      9: 1E-5,
      10: double.nan,
      11: double.nan,
      12: double.nan,
      13: double.nan,
      14: double.nan,
      15: double.nan
    };
    testQuadrature1D(GaussLegendreIntegrator(1024), precision);
  });

  group('Filon integrator', () {
    var quad = FilonIntegrator(10 * pi);
    test(r'\int_0^1 x^6 \cos(10\pi x) dx = 0.0059568281477...', () {
      num r = quad.integrate(100000, (x) => pow(x, 6) as double, 0.0, 1.0)!;
      num i = 0.005956828147744827278016119076475372232470412836389028335703;
      expect(round(r as double, 6), round(i as double, 6));
    });
  });
}
