# ⛽ Projet LiveFuel – Dashboard de Suivi des Prix de Carburants

##  Objectif

LiveFuel est un projet de monitoring des prix de carburants scrappés toutes les 5 minutes via un script Bash, puis affichés en temps réel sur un dashboard interactif conçu avec Dash (Python). Un rapport quotidien est généré à 20h.

---

##  Fichiers clés

| Fichier | Rôle |
|--------|------|
| `app.py` | Dashboard Dash : affichage des données et rapport journalier. |
| `update_prices.sh` | Scraper Bash lancé via `cron` (toutes les 5 minutes). |
| `prix_carburants.csv` | Données scrappées au fil du temps. |
| `sorted_prices.csv` | Données triées pour affichage. |
| `.gitignore` | Exclut fichiers sensibles : `venv/`, `.pem`, logs, etc. |

---

##  Lancer le projet

```bash
# Clonage
git clone https://github.com/bilalninho/Projet_LiveFuel.git
cd LiveFuel

# Dépendances
pip install dash pandas

# Lancement du dashboard
python3 app.py

