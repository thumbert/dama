library basic.rle;

/// Given an input list of numbers, encode (compress) it based on adjacency of
/// repeated values.
///
/// Only encode the numbers in the [keys] input.  If null, encode all
/// input values.
List<num> runLenghtEncode(List<num> xs, {Set<num>? keys}) {
  if (keys != null) {
    return _rle(xs, keys);
  } else {
    throw ArgumentError('Not implemented yet');
  }
}

/// Decode (expand) the input list given the [keys].
List<num> runLenghtDecode(List<num> xs, {Set<num>? keys}) {
  if (keys != null) {
    return _rld(xs, keys);
  } else {
    throw ArgumentError('Not implemented yet');
  }
}

List<num> _rld(List<num> xs, Set<num> keys) {
  var ys = <num>[];
  var flag = false;
  for (var i = 0; i < xs.length; i++) {
    if (flag) {
      //expand if more than 1 repetition
      if (xs[i] > 1) {
        ys.addAll(List.filled((xs[i] as int) - 1, xs[i - 1]));
      }
    } else {
      // only add when the flag is false
      ys.add(xs[i]);
    }
    if (keys.contains(xs[i])) {
      // need to expand
      flag = true;
    } else {
      // no need to do anything
      flag = false;
    }
  }

  return ys;
}

/// with keys specified
List<num> _rle(List<num> xs, Set<num> keys) {
  var ys = <num>[];
  var counter = 0;
  var anchorValue = xs.first;
  for (var value in xs) {
    if (keys.contains(value)) {
      if (value == anchorValue) {
        counter += 1;
      } else {
        if (counter > 0) {
          // previous run is over, record it
          ys.add(anchorValue);
          ys.add(counter);
        }
        // a new run starts
        counter = 1;
        anchorValue = value;
      }
    } else {
      // if it's a value that doesn't need to be encoded
      if (counter > 0) {
        // the previous run is over, record it
        ys.add(anchorValue);
        ys.add(counter);
        counter = 0;
        anchorValue = value;
      }
      // also record the current value
      ys.add(value);
    }
  }
  // deal with the last group
  if (counter > 0) {
    ys.add(anchorValue);
    ys.add(counter);
  }

  return ys;
}
