

library test.stochastic;

import 'package:dama/stochastic/gbm.dart';


main() {

  var gbm = GeometricBrownianMotion(30, 0, 0.02);

  var x = <num?>[];
  var i = 200;
  while(i > 0) {
    x.add(gbm.next());
    i--;
  }
  for (var e in x) {
    print(e!.toStringAsFixed(2));
  }
}