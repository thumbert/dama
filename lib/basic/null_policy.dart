library basic.null_policy;

/// Experimental.  How to maintain the type?
class NullPolicy<K> {
  final K Function(K?) _function;
  const NullPolicy._internal(this._function);

  static final nullToEmpty = NullPolicy._internal((String? x) => x ?? '');

  static final nullToZero = NullPolicy._internal((num? x) => x ?? 0);

  static NullPolicy nullToValue(dynamic value) =>
      NullPolicy._internal((dynamic x) => x ?? value);

  dynamic call(dynamic x) => _function(x);
}
