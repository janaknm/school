set term png 
set output "315.png"
set termoption enhanced
set encoding utf8
set samples 500
unset border
set xtic 10
set ytic 10
set xrange [0:50]
set yrange [0:50]
f(x) = (5/3)*(x**2)+(10/3)
plot f(x) title 'Fit Curve', '315data' lt -1 title "Actual points"
