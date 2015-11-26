library distribution.markov_chain;

import 'package:dama/distribution/discrete_distribution.dart';

class MarkovChain<E> {

  List<List<num>> transitionMatrix;
  List<E> states;

  E _state;
  List<DiscreteDistribution<E>> _dist;
  int _N;
  Map<E,int> _toIndex = {};

  /**
   * Define a Markov chain with a given transition matrix.
   * Element P_{i,j} of the transition matrix represents the probability
   * to transition from state j to state i.
   */
  MarkovChain(this.transitionMatrix, {this.states, int seed}) {
    // test that the matrix is OK, prob add to 1 by column, etc.

    if (states.length != transitionMatrix.length)
      throw 'States dimensions don\'t match the dimensions of the transitionMatrix';

    _N = transitionMatrix.length;
    states ??= new List.generate(_N, (i) => i);

    _dist = new List(_N);

    // construct the List of discrete distributions (needed for dynamics)
    for (int i=0; i<_N; i++) {
      List probs = transitionMatrix.map((e) => e[i]).toList(growable: false);
      if (seed == null)
        _dist[i] = new DiscreteDistribution(states, probs);
      else
        _dist[i] = new DiscreteDistribution(states, probs, seed+i);
      _toIndex[states[i]] = i;
    }
  }

  /// advance the chain
  step() {
    _state = _dist[_toIndex[state]].sample();
    return _state;
  }

  E get state => _state;
  set state(E value) {
    if (!states.contains(value))
      throw 'State $value is not allowed';
    _state = value;
  }

}
