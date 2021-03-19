/* Setting Constasts */

// 画面サイズ
final int WIDTH = 640;
final int HEIGHT = 480;

// カメラ検出ループの待機時間（ミリ秒）
final int DELAY_TIME = 100;

// フレーム間での検出距離の上限しきい値
final float DETECTION_DISTANCE_THRESHOLD = 50.0;

// 良判定とする顔検出領域サイズのしきい値
final int DETECTION_SIZE_THRESHOLD = 250;

// 前回の良判定からの経過時間しきい値（ミリ秒）
// 検出領域サイズがしきい値付近でぶれた時のためにクールタイムを設ける
final int DETECTION_TIME_THRESHOLD = 500;

// 良検出の時間経過による、イケメン100% <--> 井上100% となる範囲（ミリ秒）
// 例：2000～5000 → 2秒以内ならイケメン100%、5秒以上なら井上100%
final int[] ELAPSED_TIME_RANGE = new int[]{2000, 5000};


/* Debug Constants */

// 顔検出領域を表示するか（黄緑色の枠が表示される）
final boolean DEBUG_SHOW_DETECTED_AREA_FLAG = true; 

// 画像を使用しないか
final boolean DEBUG_NO_IMAGE_FLAG = false;

// 顔検出が良判定となるタイミングをわかりやすくする
final boolean DEBUG_EMPHASIZE_DETECTED_TIMING_FLAG = true;
