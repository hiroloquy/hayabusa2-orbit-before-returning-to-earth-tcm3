# https://www.hayabusa2.jaxa.jp/topics/20201021_orbit/

# -------------------- Setting ------------------- #
reset
set term pngcairo enhanced size 720, 720 font 'Times, 20'
folderName = 'data_mini'
system sprintf("mkdir %s", folderName)  # Make the folder

# data_txt = "Trajectory_20180226.txt"
data_txt = "hayabusa2_orbit_20201021.txt"

# Calculate UTC using UNIX time
# date_0 = "2014/12/03 05:00"                               # First date
# unix_time = strptime("%Y/%m/%d %H:%M", date_0)            # UNIX time [s]
# Date(unix_time) = strftime("%Y/%m/%d %H:%M", unix_time)   # unix_time convert date (UTC)
date_0 = "2014/12/03"                               # First date
unix_time = strptime("%Y/%m/%d", date_0)            # UNIX time [s]
Date(unix_time) = strftime("%Y/%m/%d", unix_time)   # unix_time convert date (UTC)
Time(i) = sprintf("%4d day", i)  # Total flight time

#　残像を残す
delay(i) = (i<50) ? i : 50

# -------------------- Update and draw ------------------- #
do for[i=0:2184]{
    set output sprintf("%s/img_%04d.png", folderName, i)
    set label 1 sprintf("%s", Date(unix_time + 86400*i)) \
        center at screen 0.5, 0.62 font ', 16'
    set grid

    set size ratio -1
    set view 65, 300, 1, 1           # set point of view
    unset zeroaxis
    set ticslevel 0
    unset border
    unset xl; unset yl; unset zl
    unset xtics; unset ytics; unset ztics
    unset key
    unset grid

    # Plot position of Hayabusa2, Earth, and Ryugu
    splot[-30:30][-30:30][-30:30] \
      data_txt every ::(i-delay(i))::i using ($6/1e7):($7/1e7):($8/1e7)   w l lw 1.5 lc rgb "royalblue" notitle,\
      data_txt every ::i::i using ($6/1e7):($7/1e7):($8/1e7)   w p pt 7 ps 3 lc rgb "royalblue" title "Earth",\
      data_txt every ::(i-delay(i))::i using ($9/1e7):($10/1e7):($11/1e7) w l lw 1.5 lc rgb "grey" notitle,\
      data_txt every ::i::i using ($9/1e7):($10/1e7):($11/1e7) w p pt 7 ps 2 lc rgb "grey50" title "Ryugu",\
      data_txt every ::(i-delay(i))::i using ($3/1e7):($4/1e7):($5/1e7)   w l lw 1.5 lc rgb "orange" notitle ,\
      data_txt every ::i::i using ($3/1e7):($4/1e7):($5/1e7)   w p pt 7 ps 1.5 lc rgb "orange" title "Hayabusa2"

    set out
}
