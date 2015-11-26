library distribution.discrete_distribution;


import 'dart:math';

/** Version of [binarySearch] optimized for comparable keys */
/**
 * Returns a position of the [key] in [sortedList], if it is there.
 *
 * If the list isn't sorted according to the [compare] function, the result
 * is unpredictable.
 *
 * If [compare] is omitted, it defaults to calling [Comparable.compareTo] on
 * the objects.
 *
 * Returns -1-min index if [key] is not in the list by default.
 */
int _comparableBinarySearch(List<Comparable> list, Comparable key) {
  int min = 0;
  int max = list.length;
  while (min < max) {
    int mid = min + ((max - min) >> 1);
    var element = list[mid];
    int comp = element.compareTo(key);
    if (comp == 0) return mid;
    if (comp < 0) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return -1 - min;
}

class DiscreteDistribution<E> {
  final List<E> values;
  final List<num> probabilities;
  Random rand;

  int _N;
  List<num> _cumulativeProbabilities;

  /**
   * Values need to be unique.  Probabilities needs to add up to 1.0.
   */
  DiscreteDistribution(this.values, this.probabilities, [int seed]) {
    _N = probabilities.length;

    if (values.toSet().length !=
        values.length) throw 'Values supplied are not distinct.';

    if (values.length !=
        _N) throw 'Values and probabilities don\'t have the same length';

    _cumulativeProbabilities = new List(_N);
    num s = 0;
    for (int i = 0; i < _N; i++) {
      if (!(probabilities[i] >= 0 &&
          probabilities[i] <=
              1)) throw 'Invalid probability value ${probabilities[i]}';
      s += probabilities[i];
      _cumulativeProbabilities[i] = s;
    }

    if ((_cumulativeProbabilities[_N - 1] - 1.0).abs() >
        1E-14) throw 'Proabilities don\'t add up to 1!';

    rand = new Random(seed);
  }

  List<num> get cumulativeProbabilities => _cumulativeProbabilities;

  /**
   * Sample one value from this distribution
   */
  E sample() {
    double x = rand.nextDouble();
    if (x == 0.0) x = rand.nextDouble(); // reject 0's

    int ind = _comparableBinarySearch(_cumulativeProbabilities, x);
    if (ind < 0) ind = -ind - 1;

    return values[ind];
  }


}

