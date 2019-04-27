library basic.null_policy;

/// Experimental.  How to maintain the type?
class NullPolicy {
  final Function _function;
  const NullPolicy._internal(this._function);

  static var nullToEmpty = NullPolicy._internal((x) {
    if (x == null) return '';
    return x;
  });

  static var nullToZero = NullPolicy._internal((num x) {
    if (x == null) return 0;
    return x;
  });

  static nullToValue(value) => NullPolicy._internal((x) {
    if (x == null) return value;
    return x;
  });

  call(x) => _function(x);
}