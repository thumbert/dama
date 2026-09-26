import 'package:dama/basic/quadratic_solution.dart';
import 'package:test/test.dart';

void main() {
  test('preserves the small root when the direct formula cancels', () {
    final (root1, root2) = quadraticSolution(1, 1e16, 1);

    expect(root1, closeTo(-1e-16, 1e-30));
    expect(root2, closeTo(-1e16, 1));
  });
}
