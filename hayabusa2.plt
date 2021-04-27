# You need to get the below txt file before running this program.
# https://www.hayabusa2.jaxa.jp/topics/20201021_orbit/hayabusa2_orbit_20201021.txt

# -------------------- Setting ------------------- #
reset
set term pngcairo enhanced size 1280, 720 font 'Times, 20'
folderName = 'data'
system sprintf("mkdir %s", folderName)  # Make the folder
data_txt = "hayabusa2_orbit_20201021.txt"

# Calculate UTC using UNIX time
date_0 = "2014/12/03 05:00"                               # First date
unix_time = strptime("%Y/%m/%d %H:%M", date_0)            # UNIX time [s]
Date(unix_time) = strftime("%Y/%m/%d %H:%M", unix_time)   # unix_time convert date (UTC)
Time(i) = sprintf("%4d day", i)  # Total flight time

# -------------------- Update and draw ------------------- #
do for[i=0:2184]{
    set output sprintf("%s/img_%04d.png", folderName, i)
    set label 1 sprintf("%s (UTC)     %s", Date(unix_time + 86400*i), Time(i)) \
        left at screen 0.34, 0.90 font ', 22'
    set grid
    set multiplot
    # Left side: Hayabusa2 orbit, Earth orbit, and Ryugu orbit
        set origin 0, -0.01
        set size 0.58, 0.58*1280./720
        set view 65, 300, 1, 1           # set point of view
        set zeroaxis
        set ticslevel 0
        set xlabel "{/:Italic x} [×10^7 km]" offset -1.2, -1.3
        set ylabel "{/:Italic y} [×10^7 km]" offset 0, -0.3
        set zlabel "{/:Italic z} [×10^7 km]" offset 1.5, 0 rotate by 90
        set xtics 15 offset 0.8, -0.2
        set ytics 15 offset -1.3, -0.2
        set ztics 15 offset 1, 0.8
        set key font ' ,16' spacing 0.9 width -2 at screen 0.55, 0.83

        # Plot position of Hayabusa2, Earth, and Ryugu
        splot[-30:30][-30:30][-30:30] \
            data_txt every ::0::i using ($6/1e7):($7/1e7):($8/1e7)   w l lw 1.5 lc rgb "royalblue" notitle,\
            data_txt every ::i::i using ($6/1e7):($7/1e7):($8/1e7)   w p pt 7 ps 3 lc rgb "royalblue" title "Earth",\
            data_txt every ::0::i using ($9/1e7):($10/1e7):($11/1e7) w l lw 1.5 lc rgb "grey" notitle,\
            data_txt every ::i::i using ($9/1e7):($10/1e7):($11/1e7) w p pt 7 ps 2 lc rgb "grey50" title "Ryugu",\
            data_txt every ::0::i using ($3/1e7):($4/1e7):($5/1e7)   w l lw 1.5 lc rgb "orange" notitle ,\
            data_txt every ::i::i using ($3/1e7):($4/1e7):($5/1e7)   w p pt 7 ps 1.5 lc rgb "orange" title "Hayabusa2"

    # Right side: Distance between Hayabusa2 and Ryugu
        set pm3d map
        set origin 0.58, 0.05
        set size 0.45, 0.45*1280./720
        set xlabel "Total flight time [day]" offset 0, 0.2
        set ylabel "Distance [×10^7 km]" offset -1, 0
        unset zl
        set xtics 500 offset 0, 0
        set ytics 10 offset 0, 0
        set key font ' ,16' spacing 0.9 width -2 at screen 0.97, 0.83

        splot[0:2184][0:40][0:2184] \
            data_txt every ::0::i using 2:($13/1e3):2 w l lw 2 lc rgb "royalblue" title "Hayabusa2 - Earth", \
            data_txt every ::0::i using 2:($14/1e3):2 w l lw 2 lc rgb "grey50" title "Hayabusa2 - Ryugu"

    unset multiplot
    set out
}
