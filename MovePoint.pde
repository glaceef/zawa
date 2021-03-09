class MovePoint {
  PVector previous;
  PVector current;
  float dist_threshold; // 次フレームでの検出位置の移動距離の限界
  
  MovePoint() {
    this.previous = new PVector();
    this.dist_threshold = 100.0;
  }
  
  void update(float current_x, float current_y) {
    if (this.current == null) {
      // 最初は必ず更新する
      this.current = new PVector(current_x, current_y);
      return;
    }
    
    float dist = this.current.dist(new PVector(current_x, current_y)); 
    if (dist > this.dist_threshold) {
      println("Too far! Skip point updating. dist: " + dist);
      return;
    }
    
    this.previous.set(this.current);
    this.current.set(current_x, current_y);
  }
  
  // This returns a float value between 0.0 and 1.0
  float velocity(float min, float max) {
    float dist = this.previous.dist(this.current);
    println("dist: " + dist);

    return map(dist, min,max, 0,1);
  }
}
