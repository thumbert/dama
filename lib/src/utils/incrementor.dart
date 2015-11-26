library incrementor;

class Incrementor {
  
  int _maximalCount;
  
  int _count = 0;
  
  Incrementor([int max]) {
    this._maximalCount = max;
  }
  
  int get maximalCount => _maximalCount;
  set maximalCount(int value) => _maximalCount = value;
 
  
  int get count => _count;
  
  bool canIncrement() {
    return _count < _maximalCount;
  }
  
  incrementCount([int value=1]) {
     for (int i = 0; i<value; i++) {
       if (++_count > _maximalCount) {
         throw _maximalCount; // FIXME: don't just thow me.
       }
     }
  }
  
  resetCount() => _count = 0;
  
}
