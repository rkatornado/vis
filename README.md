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

* draw_4v-lfm_multi_qv_z-t.ipynb

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
* draw_vaporlidar_qv.ipynb          : 水蒸気ライダーデータ（1ファイル）を読み込み, qvの鉛直プロファイルを描く(qv-z)
* draw_vaporlidar_multi_qv-z-t.ipynb  : 水蒸気ライダーデータ（複数ファイル）からqvの鉛直プロファイルを描く（z-t）
  * Kato et al. (2023)の図3(a), 図4(a)に対応
  * Kato et al. (2023)の図3(c), 図4(c)を描くためのNetCDFデータ（鉛直プロファイルを時間方向に連結したデータ）の出力にも利用
* draw_qv-diff_z.ipynb : 水蒸気ライダー(WVL)とLFMのQVの鉛直プロファイルを比較する図
  * draw_vaporlidar_multi_qv_z-t.ipynb => 'wvl_Ko.nc'
  * draw_4v-lfm_multi_qv_z-t.ipynb     => 'lfm_Ko_FT1.nc'
                                       => 'lfm_Ko_FT0.nc'

## Other
* 日時のloopのサンプルスクリプト
  * pandas の date_range を利用
  * sample_loop_time.ipynb


## CReSSの積算雨量と瞬間雨量の解析
* calc_tpa.ipynb : 1分間雨量から積算雨量の時系列を計算しnetcdfで出力するスクリプト
  * 入力: cress データ

* draw_cress_tpa-pa_simple.ipynb : CReSSの雨量を簡易的に可視化するスクリプト
  * 1分間雨量の出力から積算雨量を計算し可視化
  * 1分間雨量の時系列図の可視化

* draw_cress_tpa-pa_rotate_K23.ipynb: Kato et al. (2023) の図9, 10を描くためのスクリプト
  * cressの1分間雨量を積算し1時間積算雨量を計算(図9)
  * blendの1時間積算雨量の差分を計算(図9)
  * 1分間雨量を回転させ、時間変化を描画(図10)

* draw_cress_tpa-pa_rotate_2peak_K23.ipynb
  * 上記のスクリプト + 2つのピークを描く(AW-H用）

* draw_cress_tpa-pa_rotate.ipynb: draw_cress_tpa-pa_rotate_K23.ipynbのblendの図なしバージョン

* draw_tpa_4exp.ipynb : CReSSの積算雨量の時系列を描画する（5本の線）
  * 事前に calc_tpa.ipynb で積算雨量の時系列データ(netcdf)を作成しておく

## スネーク曲線の可視化
* アンサンブルスネークの可視化
  * ens_snake.ipynb

