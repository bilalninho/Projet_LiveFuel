#!/bin/bash

echo "Génération du graphique PNG avec gnuplot..."

gnuplot <<EOF
set terminal pngcairo size 800,600
set output "prix_carburants.png"
set title "Évolution des prix des carburants"
set xlabel "Date"
set ylabel "Prix (€)"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m-%d"
set grid
plot "prix_carburants.csv" using 3:4 with lines title "Prix"
EOF

echo " Graphique généré : prix_carburants.png"
