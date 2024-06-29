#install.packages("sf")
#install.packages("ggplot2")
#install.packages("leaflet")
#install.packages("dplyr")
#pour determiner annee a partir de date
#install.packages("lubridate")
library(lubridate)
library(dplyr)
library(sf)
library(ggplot2)
library(shiny)
library(leaflet)
###visualisation de barrges
# Charger les données des barrages à partir du data frame nettoyé 'barrage'
barrages_sf <- st_as_sf(barrage, coords = c("Longitude", "Latitude"), crs = 4326)

# Calculer le taux de remplissage
barrage$Taux <- (barrage$stock / barrage$Cap_tot_act) * 100

# Obtenir la gamme de valeurs de Taux
taux_range <- range(barrage$Taux, na.rm = TRUE)
my_palette <- rev(colorRampPalette(c("#FFFFFF", "#add8e6"))(100))  # Bleu clair
# Générer une palette de couleurs correspondant à la gamme de valeurs de Taux
color_palette <- colorNumeric(palette = my_palette, domain = taux_range)

# Créer une carte interactive avec leaflet
ma_carte_leaflet <- leaflet(data = barrages_sf) %>%
  addTiles() %>%
  addCircleMarkers(
    fillColor = ~color_palette(barrage$Taux), # correction
    # Utiliser la palette de couleurs pour le taux de remplissage
    color = "black",
    weight = 1, 
    radius = ~sqrt(Cap_tot_act) *2 ,  # Utiliser la racine carrée de la capacité pour le rayon
    label = ~paste("Nom: ", Nom_Fr, "<br>",
                   "Stock: ", stock, "<br>",
                   "Capacité totale: ", Cap_tot_act, "<br>",
                   "Taux: ", barrage$Taux, "%<br>"),
    
  )%>%
  addLegend(position = "bottomright", 
            pal = color_palette,
            opacity = 1,
            values = taux_range,
            title = "Taux de remplissage (%)")


# Afficher la carte interactive
#ma_carte_leaflet
###visualisation de pluviometrie
# Extraire l'année à partir de la date
pluviometrie$Annee <- format(pluviometrie$Date, "%Y")
# Agréger les données de pluviométrie par année
pluviometrie_an <- pluviometrie %>%
  group_by(Annee) %>%
  summarise(Cumul_periode_an = sum(Cumul_periode))
# Créer un graphique en barres pour représenter la quantité de pluie par année
ggplot(pluviometrie_an, aes(x = Annee, y = Cumul_periode_an)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Quantité de pluie par année",
       x = "Année",
       y = "Quantité de pluie (mm)") +
  theme_minimal()
# Définir les couleurs pour chaque année
colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728")  

# le pie chart
ggplot(pluviometrie_an, aes(x = factor(1), y =Cumul_periode_an, fill = Annee)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  scale_fill_manual(values = colors) +
  labs(title = "Répartition de la quantité de pluie par année",
       fill = "Année",
       y = "Quantité de pluie (cm)") +
  theme_void()  # Supprimer les éléments de la grille et de l'axe