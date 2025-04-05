#!/bin/bash

# Nom du fichier contenant les prix
CSV_FILE="prix_carburants.csv"
GRAPH_OUTPUT="prix_carburants.png"
TEMP_DATA="data_gnuplot.txt"

# Extraction des données pour GNUplot
awk '{print $3, $4}' $CSV_FILE | sort > $TEMP_DATA

# Génération du script GNUplot
cat << EOF > plot_prices.gnuplot
set terminal png size 800,600
set output "$GRAPH_OUTPUT"
set title "Évolution des Prix des Carburants"
set xlabel "Date"
set ylabel "Prix (€/L)"
set xdata time
set timefmt "%Y-%m-%d"
set format x "%d-%m"
set grid
plot "$TEMP_DATA" using 1:2 with lines title "Prix du Carburant"
EOF

# Exécution de GNUplot
gnuplot plot_prices.gnuplot

# Suppression du fichier temporaire
rm -f $TEMP_DATA
