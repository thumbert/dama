library distribution.markov_chain;

import 'package:dama/distribution/discrete_distribution.dart';

class MarkovChain {
  List<List<num>> transitionMatrix;
  List? states;

  var _state;
  late List<DiscreteDistribution> _dist;
  late int _N;
  final Map<dynamic, int> _toIndex = {};

  /// Define a Markov chain with a given transition matrix.
  /// Element P_{i,j} of the transition matrix represents the probability
  /// to transition from state j to state i.
  MarkovChain(this.transitionMatrix, {this.states, int? seed}) {
    // TODO: test that the matrix is OK, prob add to 1 by column, etc.

    if (states!.length != transitionMatrix.length) {
      throw 'States dimensions don\'t match the dimensions of the transitionMatrix';
    }

    _N = transitionMatrix.length;
    states ??= List.generate(_N, (i) => i);

    _dist = <DiscreteDistribution>[];

    /// construct the List of discrete distributions (needed for dynamics)
    for (var i = 0; i < _N; i++) {
      var probs = transitionMatrix.map((e) => e[i]).toList(growable: false);
      if (seed == null) {
        _dist.add(DiscreteDistribution(states!, probs));
      } else {
        _dist.add(DiscreteDistribution(states!, probs, seed + i));
      }
      _toIndex[states![i]] = i;
    }
  }

  /// advance the chain
  dynamic step() {
    _state = _dist[_toIndex[state]!].sample();
    return _state;
  }

  dynamic get state => _state;
  set state(dynamic value) {
    if (!states!.contains(value)) {
      throw ArgumentError('State $value is not allowed');
    }
    _state = value;
  }
}
