

library utils.matchers;

import 'package:test/test.dart';

equalsWithPrecision(num value, {num precision: 7E-13, bool relative: false}) =>
new _EqualsWithPrecision(value, precision, relative);

class _EqualsWithPrecision extends Matcher {
  num value;
  num precision;
  bool relative;
  _EqualsWithPrecision(this.value, this.precision, this.relative);

  bool matches(dynamic item, Map matchState) {
    bool res;
    if (item.isNaN){

    }
    if ((item.isNaN && !value.isNaN) || (!item.isNaN && value.isNaN))
      return false;
    else {
      if (relative) {
        res = ((item/value - 1.0).abs() > precision) ? false : true;
      } else {
        res = ((item-value).abs() > precision) ? false : true;
      }
      return res;
    }
  }

  Description describe(Description description) =>
  description.addDescriptionOf(value).add(' up to precision $precision');
}



