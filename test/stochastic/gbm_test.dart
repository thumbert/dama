

library test.stochastic;

import 'package:dama/stochastic/gbm.dart';


main() {

  var gbm = new GeometricBrownianMotion(30, 0, 0.02);

  var x = <num?>[];
  int i = 200;
  while(i > 0) {
    x.add(gbm.next());
    i--;
  }
  x.forEach((e)=>print(e!.toStringAsFixed(2)));
}