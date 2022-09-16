#!/usr/bin/ruby
# -*- coding: utf-8 -*-
txt = true
txt = false
tt = "text"

th = ARGV[0].to_i 
l  = ARGV[1].to_i
manipulation_type = ARGV[2].to_i # "TYPE" of evaluate.nc; 0: mean, 1: max
#ng_min = ARGV[3].to_i # 100
#yyyy = ARGV[4]
#mm   = ARGV[5]

plot = 1

#ft_all = ["05", 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60] # HRNCST の全予測時間 (min)
#ft_all = ["05"] # HRNCST の全予測時間 (min)
#ft_all = ["05", 30, 60] # HRNCST の全予測時間 (min)
#ft_all = [60] # HRNCST の全予測時間 (min)

#ft_all.each do |ft|

draw_type = "plot"  # JRレーダー（○）・XPOD（×）
#draw_type = "text" # ○×の代りに事例番号をplotする

#gmt_path     = "/opt/local/lib/gmt4/bin"
#gmt_path     = "/Users/katon/.pyenv/versions/miniforge3-4.10.3-10/bin/gmt" 


xmin = 0; xmax = 1; ymin = xmin; ymax = xmax 
# (m s@+-1@+)
dx1 = 100; dx2 = 0.1; dx3 = 0.1
dy1 = 100; dy2 = 0.1; dy3 = 0.1

xtitle = "Success Ratio (SR = 1 - FAR)"
ytitle = "Probability of Detection (POD)" 
#title = "POD-SR diagram #{manipulation_type}"
#title = "201808 (TH=20mm/h, L=11km, NG>196)"
#title = "#{yyyy}#{mm} (TH=#{th}mm/h, L=#{l}km, NG>=#{ng_min})"
title = "TH=#{th}mm/h, L=#{l}km"

fig_name = "fig_#{$0}_TH#{"%02d"%th}_L#{"%02d"%l}_#{manipulation_type}.png"
fig_name = "fig_SR1.png"


jx = "10/10"

color = "black"

#----set title
x = (xmin + xmax) / 2.0
y = ymax + (ymax-ymin) / 13.0
size = 16
angle = 0 
justify = "CB" # CenterBottom
fontno = 0 # Helvetica

#-----gmt settingsv
`gmt gmtset LABEL_FONT_SIZE 16p`
`gmt gmtset ANOT_FONT_SIZE 16p`
`gmt gmtset ANOT_OFFSET 0.2c`
`gmt gmtset LABEL_OFFSET 0.3c`

ps = "a.eps"
p range = "#{xmin}/#{xmax}/#{ymin}/#{ymax}"

#-----draw title
text = "#{x} #{y} #{size} #{angle} #{fontno} #{justify} '#{title}'"
`echo #{text} | gmt pstext -R#{range} -JX#{jx} -N -K -Y5 > #{ps}`

gt = 1.0
dyy1 = 5.0; dyy2 = dyy1; dyy3 = dyy1
`gmt gmtset TICK_LENGTH 0.2c`
`gmt psbasemap -JX#{jx} -R#{range} -Bg#{dx1}a#{dx2}f#{dx3}:"#{xtitle}":/g#{dy1}a#{dy2}f#{dy3}:"#{ytitle}":WeSn -K -O >> #{ps}`

#-----draw 
n_x_var = 4 # S
n_y_var = 5 # A
n_z_var = 6 # L 
w = 2

cpt = "cp.cpt"
#system("gmt makecpt -Cwysiwyg -D -T0/60/0.1 > #{cpt}")
#system("gmt makecpt -Cwysiwyg -D -T0/65/5 > #{cpt}")
#system("gmt makecpt -Cwysiwyg -T0/65/5 > #{cpt}")
##!system("gmt makecpt -Cwysiwyg -T0/65/5 -D > #{cpt}")
#system("gmt makecpt -Cwysiwyg -T-2.5/62.5/5 > #{cpt}")

ft_max = 65
  dd = 5 
  dd = 10 if ft_max >= 120
#  cpt_type = "gray"
  cpt_type = "haxby"
  system("gmt makecpt -C#{cpt_type}  -T0/#{ft_max}/#{dd} > #{cpt}")


bias_all = [10, 5, 3, 2, 1.5, 1.25, 1, 0.8, 0.6, 0.4, 0.2, 0.1]

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
  #  `cat bias.txt | gmt psxy -R#{range} -JX#{jx} -K -O -W#{w},black,'-' >> #{ps}` # 点線
    `cat bias.txt | gmt psxy -R#{range} -JX#{jx} -K -O -W#{w},blue,'-' >> #{ps}` # 点線
#  `awk 'END{print $1, $2, "5 #{angle} #{fontno} CM", $3 }' bias.txt | gmt pstext -R#{range} -JX#{jx} -O -K -Gblue >> #{ps}`
end

#  `echo 0.1 1.0 CM #{angle} 10p,Helvetica,blue 10.0 | gmt pstext -R#{range} -JX#{jx} -N -O -K >> #{ps}`

cl = "+f12p,Helvetica,blue"
`echo 0.10 1.04  10.0 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.20 1.04  5.0 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.33 1.04  3.0 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.50 1.04  2.0 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.66 1.04  1.5 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.80 1.04  1.25 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.04 1.04  1.0 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.8  0.8 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.6  0.6 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.4  0.4 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.2  0.2 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 1.05 0.1  0.1 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`

for j in 1..9
  fb = File.open("csi.txt", "w")
  csi = 0.1 * j
  for i in 10*j..100
    sr = 0.01 * i
    pod = 1.0 / ( (1.0/csi) - (1.0/sr) + 1)
    fb.puts "#{sr} #{pod} #{csi}"
  end
  fb.close
  #  `cat csi.txt | gmt psxy -R#{range} -JX#{jx} -K -O -W1,black >> #{ps}` # 点線
    `cat csi.txt | gmt psxy -R#{range} -JX#{jx} -K -O -W1,red >> #{ps}` # 点線
end

cl = "+f12p,Helvetica,red"
`echo 0.97 0.935  0.9 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.85  0.8 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.745  0.7 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.64  0.6 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.535  0.5 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.43  0.4 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.325  0.3 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.225  0.2 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`
`echo 0.97 0.125  0.1 | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`

cl = "+f12p,Helvetica,black"
`echo 1.13 1.0      | gmt psxy -R#{range} -JX#{jx} -St0.5 -N -K -O -W1 >> #{ps}` 
`echo 1.23 1.0  EXT | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`

`echo 1.13 0.95     | gmt psxy -R#{range} -JX#{jx} -Sc0.35 -N -K -O -W1 >> #{ps}` 
`echo 1.23 0.95  NWP | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`

`echo 1.13 0.9       | gmt psxy -R#{range} -JX#{jx} -Ss0.45 -N -K -O -W1 >> #{ps}` 
`echo 1.23 0.9  BLEND | gmt pstext -F#{cl} -R#{range} -JX#{jx} -N -O -K >> #{ps}`


#  `echo "0.1 1.0 CM #{angle} 10p,#{fontno},blue 10.0" | gmt pstext -F#{cl} -R#{range} -JX#{jx} -O -K >> #{ps}`

#var = "NOWC"
vars = ["NOWC"]
#vars = ["NOWC", "MODEL"]
vars = ["NOWC", "MODEL", "BLEND"]
#vars = ["MODEL"]
#vars = ["BLEND"]
vars.each do |var|
fname = "SR#{manipulation_type}_#{var}.txt"
  
#ll = [1.0, 5.0, 11.0, 15.0, 21.0]
#ll = [11.0]

#ll.each do |l|

  rmiss = -9.99
#  ft_min = 0.0
  #  ft_min = 5.0 if var == "MODEL"
  ft_min = 5.0 
  
  f = "f.txt"
    `awk '$1>=#{ft_min}&&$2==#{th}&&$3==#{l}{print 1.0-$5, $4, $1}' #{fname} > #{f}`

    # plot
    s_type = "t0.5" if var == "NOWC"
    s_type = "c0.35" if var == "MODEL"
    s_type = "s0.45" if var == "BLEND"

  `cat #{f} | gmt psxy -C#{cpt} -S#{s_type} -JX#{jx} -R#{range} -W1 -O -K >> #{ps}` if plot == 1 # -W#{w}/#{color} 
  `cat #{f} | gmt psxy -JX#{jx} -R#{range} -W1 -O -K >> #{ps}` if plot == 1 # -W#{w}/#{color}  

#end
end

#-----for SCALE
#`gmt gmtset TICK_LENGTH -0.3c`
`gmt gmtset ANOT_FONT_SIZE 14p`
#`gmt psscale -D10.9/5/10/0.3 -C#{cpt} -B/:"L": -E1 -P -K -O >> #{ps}`  #(mm)
#`gmt psscale -D11.2/5/10/0.3 -C#{cpt} -B#{dd}/:"(min)": -E0.5 -O -K >> #{ps}`  #(min)
`gmt psscale -D11.7/3.5/7/0.3 -C#{cpt} -B#{dd}/:"FT(min)": -E0.5 -O -K >> #{ps}`  #(min)

#`psscale -D15.5/7/10/0.3 -C#{cpt} -B/:"(#{unit})": -E1 -L -O >> #{ps}`  #(mm/h)

#  `gmt psscale -D2.5/9.5/3/0.3h -C#{cpt} -B/:"L": -L -P -K -O >> #{ps}`  #(mm)
#`gmt psscale -D2/9.7/3/0.3h -C#{cpt} -BneSw0.3/:"L-component": -P -K -O >> #{ps}`  #(mm)
#`gmt psscale -D2/9.7/3/0.3h -C#{cpt} -BneSw/:"L-component": -P -K -O >> #{ps}`  #(mm)

#----dummy title
`echo #{text} | gmt pstext -R#{range} -JX#{jx} -O >> #{ps}`

dens = 200
anti = "" # anti = "+antialias"
#`convert #{anti} -density #{dens} -rotate 90 -trim -bordercolor "#ffffff" -border 10x10 +repage #{ps} #{fig_name}`
`convert -alpha opaque -fill white +antialias -density #{dens} -rotate 90 -trim -bordercolor "#ffffff" -border 20x20 +repage #{ps} #{fig_name}`
#`convert #{anti} -density #{dens} -rotate 90 -trim -border 10x10 +repage #{ps} #{fig_name}` 
#`open #{fig_name}`
puts "#{fig_name} has been created."
#`eog #{fig_name}`
#`mirage #{fig_name}`

#end

exit

system("rk-convert ./'fig_draw_gmt_SAL_plot.rb_FT*.png' all.png 1 3")
#system("eog all.png")

system("mv all.png fig_all_draw_gmt_SAL_plot.rb.png")       if txt == false
system("mv all.png fig_all_draw_gmt_SAL_plot.rb_#{tt}.png") if txt == true


