import gab.opencv.*;  //ライブラリをインポート
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

final int WIDTH = 640;
final int HEIGHT = 480;

MovePoint point = new MovePoint();

void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  String[] cameras;

  while (true) {
    //使用できるカメラのリスト
    cameras = Capture.list();

    if (cameras.length == 0) {
      println("No device detected. Wait and retry.");
      delay(100);
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

  // 検出領域を表示する設定
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
}

void draw() {
  // 鏡写しになるように設定
  translate(WIDTH, 0);
  scale(-1, 1);

  // カメラの取得結果を表示
  opencv.loadImage(video); //ビデオ画像をメモリに展開
  image(video, 0, 0);

  // 顔を検出
  Rectangle[] faces = opencv.detect();
  if (faces.length != 0) {
    Rectangle face = faces[0];
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    rect(face.x, face.y, face.width, face.height);

    float face_center_x = face.x + face.width / 2.0;
    float face_center_y = face.y + face.height / 2.0;
    point.update(face_center_x, face_center_y);

    float alpha = point.velocity(0, 100) * 255;
    fill(255, 0, 0, alpha);
    noStroke();
    rect(0, 0, WIDTH, HEIGHT);
  }
}

void captureEvent(Capture c) {
  c.read();
}
