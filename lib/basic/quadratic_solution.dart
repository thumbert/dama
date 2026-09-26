import 'dart:math';

(num?, num?) quadraticSolution(num a, num b, num c) {
  final discriminant = b * b - 4 * a * c;
  if (discriminant < 0) {
    return (null, null);
  }
  final sqrtDiscriminant = sqrt(discriminant);
  if (discriminant == 0) {
    final root = -b / (2 * a);
    return (root, root);
  }
  final q = -0.5 * (b >= 0 ? b + sqrtDiscriminant : b - sqrtDiscriminant);
  final x1 = b >= 0 ? c / q : q / a;
  final x2 = b >= 0 ? q / a : c / q;
  return (x1, x2);
}
