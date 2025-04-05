import pandas as pd
import plotly.express as px
import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import os

# Chemin du fichier CSV
CSV_FILE = "/home/bilal/essence_scrapp/prix_carburants.csv"

# Liste des carburants et leur couleur
CARBURANTS = ["E10", "E85", "GPLc", "Gazole", "SP95", "SP98"]
COLOR_MAP = {
    "E10": "#1f77b4", "E85": "#ff6347", "GPLc": "#2ca02c",
    "Gazole": "#9467bd", "SP95": "#d62728", "SP98": "#17becf"
}

# Initialisation de l'application Dash
app = dash.Dash(__name__)
app.title = "Tableau de bord Carburants"

# Layout principal
app.layout = html.Div([
    html.H1(
        "À la pompe... le prix qui ne dort jamais !",
        style={"textAlign": "center", "marginBottom": "30px"}
    ),
    dcc.Interval(id="interval-component", interval=5 * 60 * 1000, n_intervals=0),
    html.Div(id="main-graph"),
    html.Hr(style={"borderTop": "1px solid #666"}),
    html.Div(
        id="carburant-cards",
        style={
            "display": "flex",
            "flexWrap": "wrap",
            "justifyContent": "center",
            "gap": "20px",
            "padding": "20px"
        }
    )
], style={"backgroundColor": "#1e1e1e", "color": "white", "fontFamily": "Arial"})


# Callback de mise à jour
@app.callback(
    [Output("main-graph", "children"), Output("carburant-cards", "children")],
    [Input("interval-component", "n_intervals")]
)
def update_dashboard(n_intervals):
    if not os.path.exists(CSV_FILE):
        return html.Div("Fichier non trouvé."), []

    # Chargement et nettoyage
    df = pd.read_csv(CSV_FILE, sep=",", names=["Carburant", "ID", "Date", "Prix"], skiprows=1)
    df["Date"] = pd.to_datetime(df["Date"], errors="coerce")
    df.dropna(subset=["Date"], inplace=True)

    # Fenêtre des 7 derniers jours
    df = df[df["Date"] >= df["Date"].max() - pd.Timedelta(days=7)]

    # Arrondi à la minute
    df["Date_5min"] = df["Date"].dt.floor("5min")
    df_agg = df.groupby(["Carburant", "Date_5min"]).Prix.mean().reset_index()

    # Graphique principal
    fig = px.line(
        df_agg, x="Date_5min", y="Prix", color="Carburant",
        markers=False, color_discrete_map=COLOR_MAP
    )
    fig.update_layout(
        template="plotly_dark",
        title="Évolution des prix des carburants",
        xaxis_title="Date",
        yaxis_title="Prix (€)",
        plot_bgcolor="#1e1e1e",
        paper_bgcolor="#1e1e1e"
    )

    main_graph = dcc.Graph(figure=fig)

    # Création des mini-cartes par carburant
    cards = []
    for carb in CARBURANTS:
        sub_df = df_agg[df_agg["Carburant"] == carb]
        last_price = sub_df["Prix"].iloc[-1] if not sub_df.empty else "N/A"
        fig_small = px.line(
            sub_df, x="Date_5min", y="Prix",
            color_discrete_sequence=[COLOR_MAP[carb]]
        )
        fig_small.update_layout(
            template="plotly_dark",
            margin=dict(l=0, r=0, t=30, b=0),
            height=200,
            xaxis=dict(showticklabels=False),
            yaxis=dict(showticklabels=False),
            title=f"{carb} : {last_price:.3f} €" if last_price != "N/A" else f"{carb} : N/A",
            plot_bgcolor="#222", paper_bgcolor="#222",
            font_color="white"
        )
        cards.append(html.Div(
            children=dcc.Graph(figure=fig_small),
            style={
                "width": "300px",
                "minWidth": "280px",
                "backgroundColor": "#222",
                "borderRadius": "12px",
                "padding": "10px",
                "boxShadow": "0 0 10px rgba(0,0,0,0.5)"
            }
        ))

    return main_graph, cards

# Lancement du serveur
if __name__ == "__main__":
    app.run_server(debug=True, host="0.0.0.0")
