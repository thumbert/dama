library basic.rle;

/// TODO:  Make it a class so it supports encoding/decoding for a generic
/// list inputs (not only numeric).

/// Given an input list of numbers, encode (compress) it based on adjacency of
/// repeated values.
///
/// Only encode the numbers in the [keys] input.  If null, encode all
/// input values.
List<num> runLenghtEncode(List<num> xs, {Set<num>? keys}) {
  if (keys != null) {
    return _rleKeys(xs, keys);
  } else {
    return _rle(xs);
  }
}

/// Decode (expand) the input list given the [keys].
List<num> runLenghtDecode(List<num> xs, {Set<num>? keys}) {
  if (keys != null) {
    return _rldKeys(xs, keys);
  } else {
    return _rld(xs);
  }
}

List<num> _rld(List<num> xs) {
  if (xs.isEmpty) return xs;
  var ys = <num>[];
  for (var i = 0; i < xs.length; i = i + 2) {
    if (xs[i] == 1) {
      ys.add(xs[i + 1]);
    } else {
      ys.addAll(List.filled(xs[i] as int, xs[i + 1]));
    }
  }
  return ys;
}

List<num> _rldKeys(List<num> xs, Set<num> keys) {
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

/// Perform run length encoding on the input list [xs].
/// For example, given [1, 1, 1, 2, 3, 3, 3] return [3, 1, 1, 2, 3, 3]
List<num> _rle(List<num> xs) {
  if (xs.isEmpty) return xs;

  var ys = <num>[];
  var counter = 0;
  var anchorValue = xs.first;
  for (var value in xs) {
    if (value == anchorValue) {
      counter += 1;
    } else {
      if (counter > 0) {
        // previous run is over, record it
        ys.add(counter);
        ys.add(anchorValue);
      }
      // a new run starts
      counter = 1;
      anchorValue = value;
    }
  }
  // deal with the last group
  if (counter > 0) {
    ys.add(counter);
    ys.add(anchorValue);
  }
  return ys;
}

/// Only encode values that belong to the keys specified.  The other values
/// are left unchanged.
List<num> _rleKeys(List<num> xs, Set<num> keys) {
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
