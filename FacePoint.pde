class FacePoint {
  PImage ikemen, inoue;
  
  PVector previous;
  PVector current;
  float dist_threshold; // 次フレームでの検出位置の移動距離の限界
  
  FacePoint() {
    ikemen = loadImage("ikemen.png");
    inoue = loadImage("inoue.png");
    
    this.previous = new PVector();
    this.dist_threshold = 100.0;
  }
  
  void update(Rectangle face) {
    float current_x = face.x + face.width / 2.0;
    float current_y = face.y + face.height / 2.0;
    
    if (this.current == null) {
      // 最初は必ず更新する
      this.current = new PVector(current_x, current_y);
      return;
    }
    
    // 変な位置に検出されたら無視する
    float dist = this.current.dist(new PVector(current_x, current_y)); 
    if (dist > this.dist_threshold) {
      println("Too far! Skip point updating. dist: " + dist);
      return;
    }
    
    this.previous.set(this.current);
    this.current.set(current_x, current_y);
    
    // 検出領域を表示
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    rect(face.x, face.y, face.width, face.height);
  }
  
  // This returns a float value between 0.0 and 1.0
  float velocity(float min, float max) {
    float dist = abs(this.current.y - this.previous.y);
    return map(dist, min,max, 0,1);
  }
  
  void showImage() {
    float alpha = this.velocity(0, 100) * 255;
    if (ikemen != null && inoue != null) {
      // velocityが大きいほどイケメン画像を濃く表示
      tint(255, alpha);
      image(ikemen, current.x, current.y);
      // velocityが大きいほど井上の画像を薄く表示
      tint(255, 255 - alpha);
      image(inoue, current.x, current.y);
    } else {
      // 画像が取得されていない場合
      fill(255, 0, 0, alpha);
      noStroke();
      rect(0, 0, WIDTH, HEIGHT);
    }
  }
}
