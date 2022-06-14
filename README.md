# vis
scientific visualization codes

## LFM可視化
* LFMは地表のみの4p-lfmと、上空3次元の4v-lfmがある

### Qv（シェード）& U（ベクトル）
* Qv(水蒸気混合比)はからmetpyを利用して気圧(P)と温度(T)から計算する
  * 4p-lfm は変数に地表面気圧Pと温度Tを利用
  * 4p-lfm は変数の温度Tを利用し、描画に指定する気圧面の気圧を利用する
  * metpyの saturation_mixing_ratio を利用
    * https://unidata.github.io/MetPy/latest/api/generated/metpy.calc.saturation_mixing_ratio.html

#### スクリプト
* draw_4p-lfm_qv-U.ipynb
* draw_4v-lfm_qv-U.ipynb
* draw_4p-lfm_qv-U.py
* draw_4v-lfm_qv-U.py


## 水蒸気ライダーデータ可視化
### 読み込み
pandasを使って読み込みを行った. 

#### スクリプト
* read_vaporlidar_org.ipynb    : 読み込み練習
* read_vaporlidar.ipynb        : 1ファイル読み込み
* read_vaporlidar_2files.ipynb : 2ファイル読み込み
* read_vaporlidar_multi.ipynb  : 複数ファイル読み込み

### Qv
#### スクリプト
* draw_vaporlidar_qv.ipynb          : 1ファイルを読み込み, qvの鉛直プロファイルを描く(qv-z)
* draw_vaporlidar_multi_qv-t.ipynb  : 複数ファイル読み込み, qvの鉛直プロファイルを描く(time-z)

## Other
* 日時のloopのサンプルスクリプト
  * pandas の date_range を利用
  * sample_loop_time.ipynb