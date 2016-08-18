library stat.descriptive.summary;


/// Calculate the maximum value of an iterable.  The function [isValid] can be
/// used to filter values that should be ignored.  [isValid]: num => bool.
num max(Iterable<num> x, {Function isValid}) {
  isValid ??= (x) => true;
  return x.where(isValid).reduce((a,b) => a >= b ? a : b);
}

/// Calculate the minimum value of an iterable.  The function [isValid] can be
/// used to filter values that should be ignored.  [isValid]: num => bool.
num min(Iterable<num> x, {Function isValid}) {
  isValid ??= (x) => true;
  return x.where(isValid).reduce((a,b) => a <= b ? a : b);
}


List<num> summary(Iterable<num> x, {Function isValid}) {

}
