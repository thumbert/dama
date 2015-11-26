library test_discrete_distribution;

import 'package:test/test.dart';

import 'package:dama/distribution/discrete_distribution.dart';
import 'package:dama/distribution/markov_chain.dart';

test_discrete_distribution() {
  group('Discrete distribution test:', (){
    var dist = new DiscreteDistribution(['A', 'B', 'C'], [0.1, 0.25, 0.65], 0);

    var sample = new List.generate(10, (i) => dist.sample());
    test('sample', (){
     expect(sample, ['C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'B']);
    });
  });
}

test_markov() {
  group('Markov Chain test', () {
    var mat = [[0.1, 0.95], [0.9, 0.05]];

    var chain = new MarkovChain(mat, states: ['A', 'B'], seed: 0);
    chain.state = 'A';

    var path = new List.generate(20, (i) => i).map((i) {
      chain.step();
      return chain.state;
    });
    test('evolve 3 steps', (){
      expect(path.take(3).toList(), ['B', 'A', 'B']);
    });
  });
}


main() {

  test_discrete_distribution();

  test_markov();
}
