set terminal png size 800,600
set output "prix_carburants.png"
set title "Évolution des Prix des Carburants"
set xlabel "Date"
set ylabel "Prix (€/L)"
set xdata time
set timefmt "%Y-%m-%d"
set format x "%d-%m"
set grid
plot "data_gnuplot.txt" using 1:2 with lines title "Prix du Carburant"
