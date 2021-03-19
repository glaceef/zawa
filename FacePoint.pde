class Face {
  PImage ikemen, inoue;
  
  PVector previousPosition = new PVector();
  PVector currentPosition;
  Rectangle faceArea;
  
  // 良とする顔検出領域のサイズの一辺の長さの下限しきい値
  int detectionSizeThreshold = DETECTION_SIZE_THRESHOLD;
  // 最後に良となるサイズの顔領域が検出された時間
  int lastDetectedTime;
  // 前フレームでは良判定だったか
  boolean wasOk = false;
  
  float score = 0.5; // 0.0～1.0
  
  Face(PImage ikemen, PImage inoue) {
    this.ikemen = ikemen;
    this.inoue = inoue;
  }
  
  void update(Rectangle faceArea) {
    float currentPositionX = faceArea.x + faceArea.width / 2.0;
    float currentPositionY = faceArea.y + faceArea.height / 2.0;
    
    if (this.currentPosition == null) {
      // 最初は必ず更新する
      this.currentPosition = new PVector(currentPositionX, currentPositionY);
      this.faceArea = faceArea;
      return;
    }
    
    // 変な位置が検出されたら無視する
    float dist = this.currentPosition.dist(new PVector(currentPositionX, currentPositionY));
    if (dist > DETECTION_DISTANCE_THRESHOLD) {
      println("Too far! Skip updating position. dist: " + dist);
      return;
    }
    
    this.previousPosition.set(this.currentPosition);
    this.currentPosition.set(currentPositionX, currentPositionY);
    this.faceArea = faceArea;
    
    if (this.isOk()) {
      this.score = this.score(ELAPSED_TIME_RANGE[1], ELAPSED_TIME_RANGE[0]);
      this.lastDetectedTime = millis();
      detected_flag = true;
    }
    
    // 検出領域を表示
    if (DEBUG_SHOW_DETECTED_AREA_FLAG) {
      noFill();
      stroke(0, 255, 0);
      strokeWeight(3);
      rect(faceArea.x, faceArea.y, faceArea.width, faceArea.height);
    }
  }
  
  void showImage() {
    // 初期化されていなければスキップ
    if (this.currentPosition == null) { return; }
    
    surface.setTitle("score: " + nf(this.score, 1,3) + "");
    
    float alpha = this.score * 255;
    if (DEBUG_NO_IMAGE_FLAG || ikemen != null && inoue != null) {
      // scoreが大きいほどイケメン画像を濃く表示
      tint(255, alpha);
      this.displayImage(this.ikemen, currentPosition.x, currentPosition.y);
      // scoreが小さいほど井上の画像を薄く表示
      tint(255, 255 - alpha);
      this.displayImage(this.inoue, currentPosition.x, currentPosition.y);
    } else {
      // 画像が取得されていない場合
      fill(255, 0, 0, 255-alpha);
      noStroke();
      rect(faceArea.x, faceArea.y, faceArea.width, faceArea.height);
    }
  }
  
  // 顔検出領域のサイズがしきい値以上か
  boolean isOk() {
    boolean isOk = this.detectionSizeThreshold <= min(this.faceArea.width, this.faceArea.height); 
    if (!wasOk && isOk) { // 前回はしきい値未満でかつ今回はしきい値以上の場合
      this.wasOk = true;
      
      // 前回の良判定から一定時間経過している必要がある
      int elapsedTime = millis() - this.lastDetectedTime;
      if (elapsedTime > DETECTION_TIME_THRESHOLD) {
        return true;
      }
    } else {
      this.wasOk = isOk;
    }
    return false;
  }
  
  // This returns a float value between 0.0 and 1.0
  float score(float bad, float good) {
    // 前回の検出からの経過時間（上限下限をELAPSED_TIME_RANGEの値に制限している）
    int elapsedTime = constrain(millis() - this.lastDetectedTime, ELAPSED_TIME_RANGE[0],ELAPSED_TIME_RANGE[1]);
    return map(elapsedTime, bad,good, 0,1);
  }
  
  void displayImage(PImage img, float posX, float posY) {
    float xScale = (float)this.faceArea.width / img.width;
    float yScale = (float)this.faceArea.height / img.height;
    pushMatrix();
      translate(posX, posY);
      scale(xScale, yScale);
      image(img, 0,0);
    popMatrix();
  }
  
  int changeDetectionSizeThreshold() {
    // 直前に検出されている領域サイズを検出サイズしきい値とする
    // 基本的に正方形だが、念のため縦横の大きい方で設定する
    this.detectionSizeThreshold = max(this.faceArea.width, this.faceArea.height);
    return this.detectionSizeThreshold;
  }
}
