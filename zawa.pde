import gab.opencv.*;  //ライブラリをインポート
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

Face face;

boolean detected_flag = false;

void settings() {
  size(WIDTH, HEIGHT, FX2D);
}

void setup() {
  imageMode(CENTER);
  
  PImage ikemen, inoue;
  if (!DEBUG_NO_IMAGE_FLAG) {
    ikemen = loadImage("ikemen.jpg");
    inoue = loadImage("inoue.jpg");
  }
  face = new Face(ikemen, inoue);
  
  String[] cameras;

  while (true) {
    //使用できるカメラのリスト
    cameras = Capture.list();

    // 取得までリトライ
    if (cameras.length == 0) {
      println("No device detected. Wait and retry.");
      delay(DELAY_TIME);
      continue;
    }

    break;
  }

  //カメラの番号をcameras[0]のようにインデックス番号で明示する
  video = new Capture(this, WIDTH, HEIGHT, cameras[0]);
  opencv = new OpenCV(this, WIDTH, HEIGHT);

  //顔用のデータをロード  
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  //キャプチャを開始
  video.start(); 
}

void draw() {
  // 鏡写しになるように設定
  translate(WIDTH, 0);
  scale(-1, 1);

  // カメラの取得結果を表示
  opencv.loadImage(video); //ビデオ画像をメモリに展開
  tint(-1, 255);
  image(video, WIDTH/2,HEIGHT/2);

  // 顔を検出
  Rectangle[] faces = opencv.detect();
  if (faces.length != 0) {
    Rectangle faceArea = faces[0];
    face.update(faceArea);
  }
  
  // 画像表示
  face.showImage();
  
  if (DEBUG_EMPHASIZE_DETECTED_TIMING_FLAG && detected_flag) {
    // 顔検出が良判定になったタイミングの確認用。一瞬赤くなる
    noStroke();
    fill(255,0,0, 150);
    rect(0,0,WIDTH,HEIGHT);
    detected_flag = false;
  }
}

void captureEvent(Capture c) {
  c.read();
}

void mousePressed() {
  println("Set detection size threshold = " + face.changeDetectionSizeThreshold());
}
