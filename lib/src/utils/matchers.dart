library utils.matchers;

import 'package:test/test.dart';

equalsWithPrecision(num value, {num precision: 1E-10}) => new _EqualsWithPrecision(value, precision);

class _EqualsWithPrecision extends Matcher {
  num value;
  num precision;
  _EqualsWithPrecision(this.value, this.precision);

  bool matches(num item, Map matchState) {
    if (item.isNaN){

    }
    if ((item.isNaN && !value.isNaN) || (!item.isNaN && value.isNaN))
      return false;
    else {
      var res = ((item-value).abs() > precision) ? false : true;
      return res;
    }
  }

  Description describe(Description description) =>
  description.addDescriptionOf(value).add(' up to precision $precision');
}

