import gab.opencv.*;  //ライブラリをインポート
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

// 画面サイズ
final int WIDTH = 640;
final int HEIGHT = 480;

FacePoint point = new FacePoint();

void settings() {
  size(WIDTH, HEIGHT);
  imageMode(CENTER);
}

void setup() {
  String[] cameras;

  while (true) {
    //使用できるカメラのリスト
    cameras = Capture.list();

    // 検出までリトライ
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
}

void draw() {
  // 鏡写しになるように設定
  translate(WIDTH, 0);
  scale(-1, 1);

  // カメラの取得結果を表示
  opencv.loadImage(video); //ビデオ画像をメモリに展開
  image(video, WIDTH/2,HEIGHT/2);

  // 顔を検出
  Rectangle[] faces = opencv.detect();
  if (faces.length != 0) {
    Rectangle face = faces[0];
    point.update(face);
  }
  
  // 画像表示
  point.showImage();
}

void captureEvent(Capture c) {
  c.read();
}
