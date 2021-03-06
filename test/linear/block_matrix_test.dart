

library linear.block_matrix_test;

import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';


block_matrix_basic() {
  test('create 1x1 block matrix', (){
    BlockMatrix m = new BlockMatrix([0,1,2,3,4,5], 3, 2);
    expect(m.element(0,0), 0.0);
    expect(m.element(1,0), 1.0);
    expect(m.element(1,1), 4.0);
    expect(m.element(2,1), 5.0);
  });
  test('create 2x2 block matrix', (){
    BlockMatrix m = new BlockMatrix(new List.generate(6000, (i) => i), 100, 60);

//    expect(m.element(0,0), 0.0);
//    expect(m.element(1,0), 1.0);
//    expect(m.element(1,1), 4.0);
//    expect(m.element(2,1), 5.0);
    print(m);
  });

}


main() {

  block_matrix_basic();
}