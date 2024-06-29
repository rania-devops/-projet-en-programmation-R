library(lubridate)
library(dplyr)
library(sf)
library(ggplot2)
library(shiny)
library(leaflet)

### Calculer le rapport entre le remplissage des barrages et les précipitations pour les années 2023-2024
# Filtrer les données de pluviométrie pour les dates spécifiées
pluviometrie_2023 <- pluviometrie %>%
  filter(Date >= ymd("2023-12-20") & Date <= ymd("2024-03-16"))

# Extraire l'année à partir de la colonne Date pour les données de pluviométrie
pluviometrie_2023$Annee <- year(pluviometrie_2023$Date)

# Agréger les données de pluviométrie par année
pluviometrie_annee <- pluviometrie_2023 %>%
  group_by(Annee) %>%
  summarise(Total_precipitations = sum(Cumul_periode))

# Extraire l'année à partir de la colonne Date pour les données de barrage
barrage$Annee <- year(barrage$Date)

# Agréger les données des barrages par année et convertir les unités en millimètres cubes
barrages_par_annee <- barrage %>%
  group_by(Annee) %>%
  summarise(Total_apports_mm = sum(apports) * 1000) # Convertir en millimètres cubes

# Joindre les données de précipitations et de barrages par année
donnees_annee <- merge(pluviometrie_annee, barrages_par_annee, by = "Annee")

# Créer le graphique qui présente l'influence du pluie sur le stock
ggplot(donnees_annee, aes(x = Annee)) +
  geom_line(aes(y = Total_precipitations, color = "Précipitations"), linewidth = 1.5) +  # Courbe représentant les précipitations
  geom_line(aes(y = Total_apports_mm, color = "augmentation du Stock des barrages"), linewidth = 1.5, linetype = "dashed") +  # Courbe représentant le stock des barrages
  labs(title = "Variation des précipitations et du stock des barrages (2023-2024)",
       x = "Année",
       y = "Quantité (mm)",
       color = "Variable") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +  # Rotation des étiquettes de l'axe x
  scale_color_manual(values = c("Précipitations" = "steelblue", "augmentation du Stock des barrages" = "red")) +  # Couleurs pour les courbes
  theme(panel.grid.major = element_line(color = "gray", linetype = "dotted")) 

## Créer un rapport 
donnees_annee$Rapport <- (donnees_annee$Total_apports_mm / donnees_annee$Total_precipitations) * 100
ggplot(donnees_annee, aes(x = Annee)) +
  geom_bar(aes(y = Total_precipitations, fill = "Précipitations"), stat = "identity", width = 0.5) +
  geom_bar(aes(y = Total_apports_mm, fill = "Stock des barrages"), stat = "identity", width = 0.5) +
  labs(title = "Rapport entre stock des barrages et précipitations",
       x = "Année",
       y = "Quantité (mm)",
       fill = "Variable") +
  scale_fill_manual(values = c("Précipitations" = "steelblue", "Stock des barrages" = "red")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "top")  # Placer la légende en haut du graphique

