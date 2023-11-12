library utils.matchers;

import 'package:test/test.dart';

EqualsWithPrecision equalsWithPrecision(num value,
        {num precision = 7E-13, bool relative = false}) =>
    EqualsWithPrecision(value, precision, relative);

class EqualsWithPrecision extends Matcher {
  num value;
  num precision;
  bool relative;
  EqualsWithPrecision(this.value, this.precision, this.relative);

  @override
  bool matches(dynamic item, Map matchState) {
    bool res;
    if (item.isNaN) {}
    if ((item.isNaN && !value.isNaN) || (!item.isNaN && value.isNaN)) {
      return false;
    } else {
      if (relative) {
        res = ((item / value - 1.0).abs() > precision) ? false : true;
      } else {
        res = ((item - value).abs() > precision) ? false : true;
      }
      return res;
    }
  }

  @override
  Description describe(Description description) =>
      description.addDescriptionOf(value).add(' up to precision $precision');
}
