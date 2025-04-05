#!/bin/bash

# Définition des chemins
DATA_URL="https://donnees.roulez-eco.fr/opendata/instantane"
XML_FILE="/home/bilal/essence_scrapp/prix_carburants.xml"
CSV_FILE="/home/bilal/essence_scrapp/prix_carburants.csv"
TEMP_FILE="/home/bilal/essence_scrapp/prix_carburants_temp.txt"

echo "Début de la mise à jour des prix du carburant..."

echo "Téléchargement du fichier XML..."
curl -s "$DATA_URL" -o "${XML_FILE}.gz"

# On décompresse le fichier
echo "Décompression du fichier XML..."
gunzip -f "${XML_FILE}.gz"

if [[ ! -f "$XML_FILE" ]]; then
    echo "Le fichier XML est introuvable après décompression."
    exit 1
fi

echo "Le fichier a été décompressé avec succès !"

# Extraction des prix avec awk
echo "Extraction des prix en cours..."
grep -i prix "$XML_FILE" | awk -F '"' '{print $2","$4","$6","$8}' > "$TEMP_FILE"

if [[ ! -s "$TEMP_FILE" ]]; then
    echo "L'extraction des prix a échoué."
    exit 1
fi

echo "Extraction des prix réussie !"

# Formatage et écriture dans le fichier CSV
echo "Écriture dans le fichier CSV..."
echo "Carburant,ID,Date,Prix" > "$CSV_FILE"

while read -r line; do
    echo "$line" >> "$CSV_FILE"
done < "$TEMP_FILE"

if [[ ! -s "$CSV_FILE" ]]; then
    echo "Erreur : Fichier CSV vide après écriture."
    exit 1
fi

# Tri par date croissante
head -n 1 "$CSV_FILE" > "${CSV_FILE}.tmp"
tail -n +2 "$CSV_FILE" | sort -t',' -k3 >> "${CSV_FILE}.tmp"
mv "${CSV_FILE}.tmp" "$CSV_FILE"

echo "Tout a bien été mis à jour ✅"
