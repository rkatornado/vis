#!/usr/bin/ruby
# -*- coding: utf-8 -*-

#--- 入出力ファイルの設定
f = "ff.txt"            # input file
                        # (1: SR, 2: POD, 3: FT(min))
fig_name = "fig_SR.png" # output file

#-----gmt settings------------------
gmt_path     = "/Users/katon/.pyenv/versions/miniforge3-4.10.3-10/bin/gmt" # GMT5 or GMT6 のパス

`#{gmt_path} gmtset LABEL_FONT_SIZE 16p`
`#{gmt_path} gmtset ANOT_FONT_SIZE 16p`
`#{gmt_path} gmtset ANOT_OFFSET 0.2c`
`#{gmt_path} gmtset LABEL_OFFSET 0.3c`
ps = "a.eps"

#---図の領域等の設定
xmin = 0; xmax = 1; ymin = xmin; ymax = xmax 
dx1 = 100; dx2 = 0.1; dx3 = 0.1
dy1 = 100; dy2 = 0.1; dy3 = 0.1
jx = "10/10"
p range = "#{xmin}/#{xmax}/#{ymin}/#{ymax}"


#-----draw title-------------
title = "POD-SR diagram"
x = (xmin + xmax) / 2.0
y = ymax + (ymax-ymin) / 13.0
size = 16
angle = 0
justify = "CB" # CenterBottom
fontno = 0 # Helvetica
text = "#{x} #{y} #{size} #{angle} #{fontno} #{justify} '#{title}'"
`echo #{text} | #{gmt_path} pstext -R#{range} -JX#{jx} -N -K -Y5 > #{ps}`

#----ベースマップの描画---------------
gt = 1.0
dyy1 = 5.0; dyy2 = dyy1; dyy3 = dyy1
xtitle = "Success Ratio (SR = 1 - FAR)"
ytitle = "Probability of Detection (POD)" 
`#{gmt_path} gmtset TICK_LENGTH 0.2c`
`#{gmt_path} psbasemap -JX#{jx} -R#{range} -Bg#{dx1}a#{dx2}f#{dx3}:"#{xtitle}":/g#{dy1}a#{dy2}f#{dy3}:"#{ytitle}":WeSn -K -O >> #{ps}`

#-----カラーパレットの作成(FTに対して)
cpt = "cp.cpt"
ft_max = 65
dd = 5 
dd = 10 if ft_max >= 120
#  cpt_type = "gray"
cpt_type = "haxby"
system("#{gmt_path} makecpt -C#{cpt_type}  -T0/#{ft_max}/#{dd} > #{cpt}")

#--- BIASの下絵の作図（線）----------------
bias_all = [10, 5, 3, 2, 1.5, 1.25, 1, 0.8, 0.6, 0.4, 0.2, 0.1] # この値を描く

dy = 0.1
bias_all.each do |bias|
  fb = File.open("bias.txt", "w")
  for i in 0..10
    sr = 0.1 * i
    pod = bias * sr
    fb.puts "#{sr} #{pod} #{bias}"
  end
  fb.close
  w = 1
  w = 2 if bias == 1
  `cat bias.txt | #{gmt_path} psxy -R#{range} -JX#{jx} -K -O -W#{w},blue,'-' >> #{ps}` # 点線
end

#--- BIASの下絵の作図（数字）----------------
cl = "+f12p,Helvetica,blue"
`echo 0.10 1.04  10.0 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.20 1.04  5.0 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.33 1.04  3.0 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.50 1.04  2.0 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.66 1.04  1.5 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.80 1.04  1.25 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.04 1.04  1.0 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.8  0.8 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.6  0.6 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.4  0.4 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.2  0.2 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.1  0.1 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`

#--- CSIの下絵の作図（線）----------------
for j in 1..9
  fb = File.open("csi.txt", "w")
  csi = 0.1 * j
  for i in 10*j..100
    sr = 0.01 * i
    pod = 1.0 / ( (1.0/csi) - (1.0/sr) + 1)
    fb.puts "#{sr} #{pod} #{csi}"
  end
  fb.close
  `cat csi.txt | #{gmt_path} psxy -R#{range} -JX#{jx} -K -O -W1,red >> #{ps}` # 点線
end

#--- CSIの下絵の作図（数字）----------------
cl = "+f12p,Helvetica,red"
`echo 0.97 0.935  0.9 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.85  0.8 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.745  0.7 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.64  0.6 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.535  0.5 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.43  0.4 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.325  0.3 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.225  0.2 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.125  0.1 | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`

#!#---凡例の作図--------------------------
#!cl = "+f12p,Helvetica,black"
#!`echo 1.13 1.0      | #{gmt_path} psxy -R#{range} -JX#{jx} -St0.5 -N -K -O -W1 >> #{ps}` 
#!`echo 1.23 1.0  EXT | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
#!
#!`echo 1.13 0.95     | #{gmt_path} psxy -R#{range} -JX#{jx} -Sc0.35 -N -K -O -W1 >> #{ps}` 
#!`echo 1.23 0.95  NWP | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
#!
#!`echo 1.13 0.9       | #{gmt_path} psxy -R#{range} -JX#{jx} -Ss0.45 -N -K -O -W1 >> #{ps}` 
#!`echo 1.23 0.9  BLEND | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
#!#---------------------------------------------

#  `echo "0.1 1.0 CM #{angle} 10p,#{fontno},blue 10.0" | #{gmt_path} pstext -F#{cl} -R#{range} -JX#{jx} -O -K >> #{ps}`

#---- データのプロット----------------------------
#s_type = "t0.5"
s_type = "c0.5" 
`cat #{f} | #{gmt_path} psxy -C#{cpt} -S#{s_type} -JX#{jx} -R#{range} -W1 -O -K >> #{ps}` 
`cat #{f} | #{gmt_path} psxy -JX#{jx} -R#{range} -W1 -O -K >> #{ps}` 


#----- SCALE の描画-----------------
`#{gmt_path} gmtset ANOT_FONT_SIZE 14p`
`#{gmt_path} psscale -D11.7/3.5/7/0.3 -C#{cpt} -B#{dd}/:"FT(min)": -E0.5 -O -K >> #{ps}`  #(min)


#----dummy title
`echo #{text} | #{gmt_path} pstext -R#{range} -JX#{jx} -O >> #{ps}`

#-----図の出力
dens = 200
anti = "" # anti = "+antialias"
`convert -alpha opaque -fill white +antialias -density #{dens} -rotate 90 -trim -bordercolor "#ffffff" -border 20x20 +repage #{ps} #{fig_name}`
#`open #{fig_name}`
puts "#{fig_name} has been created."
#`eog #{fig_name}`

exit
