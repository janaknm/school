set term png 
set output "31.png"
set termoption enhanced
set encoding utf8
set samples 500
unset border
set xtic 1
set ytic 1
set xrange [0:3]
set yrange [0:5]
f(x) = (-1+x)/2
g(x) = 4-x
set multiplot
set style fill solid 0.2 border
plot '+' using 1:(f($1)):(g($1)) with filledcurve lt 2 title "Feasible Region", \
     f(x) title "-x_1 + 2x_2 <= -1" lt 3, g(x) ls 4 title "x_1 + x_2 <= 4", '31data' lt -1 title "Basic Feasible Solutions"
unset multiplot
