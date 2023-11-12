

library test_discrete_distribution;

import 'package:test/test.dart';

import 'package:dama/distribution/discrete_distribution.dart';
import 'package:dama/distribution/markov_chain.dart';

testDiscreteDistribution() {
  group('Discrete distribution test:', (){
    var dist = DiscreteDistribution(['A', 'B', 'C'], [0.1, 0.25, 0.65], 0);

    var sample = List.generate(10, (i) => dist.sample());
    test('sample', (){
     expect(sample, ['C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'B']);
    });
  });
}

testMarkov() {
  group('Markov Chain test', () {
    var mat = [[0.1, 0.95], [0.9, 0.05]];

    var chain = MarkovChain(mat, states: ['A', 'B'], seed: 0);
    chain.state = 'A';

    var path = List.generate(20, (i) => i).map((i) {
      chain.step();
      return chain.state;
    });
    test('evolve 3 steps', (){
      expect(path.take(3).toList(), ['B', 'A', 'B']);
    });
  });
}


main() {

  testDiscreteDistribution();

  testMarkov();
}
