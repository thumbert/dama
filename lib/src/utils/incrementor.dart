library incrementor;

class Incrementor {
  late int maximalCount;

  int _count = 0;

  Incrementor([int? max]) {
    maximalCount = max ?? 2147483647;
  }

  int get count => _count;

  bool canIncrement() {
    return _count < maximalCount;
  }

  void incrementCount([int value = 1]) {
    for (var i = 0; i < value; i++) {
      if (++_count > maximalCount) {
        throw maximalCount;
      }
    }
  }

  void resetCount() => _count = 0;
}
