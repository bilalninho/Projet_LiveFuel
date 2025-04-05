#!/bin/bash

echo " Analyse des tendances des prix du carburant :"
echo "---------------------------------------------"

# Lire le fichier CSV et trier par date
sort -t ',' -k3 prix_carburants.csv | awk -F ',' '
{
    carburant=$1;
    prix_actuel=$4;
    
    if (carburant in dernier_prix) {
        variation = prix_actuel - dernier_prix[carburant];
        if (variation > 0) {
            tendance="🔺 Augmente";
        } else if (variation < 0) {
            tendance="🔻 Diminue";
        } else {
            tendance="➖ Stable";
        }
    } else {
        tendance=" Première donnée";
    }
    
    dernier_prix[carburant] = prix_actuel;
    print carburant, ": Prix actuel =", prix_actuel, "€ | Variation =", tendance;
}
'
