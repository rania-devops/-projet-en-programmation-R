library(ggplot2)

# Convertir les virgules en points dans les valeurs numériques
sonede$`2023 (en dt)` <- as.numeric(gsub(",", ".", sonede$`2023 (en dt)`))
sonede$`2024 (en dt)` <- as.numeric(gsub(",", ".", sonede$`2024 (en dt)`))

# Convertir `tranche-metre-cube-par-trimestre` en facteur avec l'ordre approprié
sonede$`tranche-metre-cube-par-trimestre` <- factor(sonede$`tranche-metre-cube-par-trimestre`, 
                                                    levels = c("0-20", "20-40", "40-70", "70-100", "100-150", "150 et plus", "usage touristique"))

# Créer le graphique avec les valeurs pivotées
tarif_water_plot <- ggplot(sonede, aes(x = `tranche-metre-cube-par-trimestre`)) +
  geom_bar(aes(y = `2024 (en dt)`, fill = "2024"), stat = "identity", position = "dodge") +
  geom_bar(aes(y = `2023 (en dt)`, fill = "2023"), stat = "identity", position = "dodge") +
  labs(title = "Augmentation du tarif de l'eau par tranche de consommation",
       x = "Tranche de mètre cube par trimestre",
       y = "Tarif (en dt)",
       fill = "Année") +
  scale_fill_manual(values = c("2023" = "red", "2024" = "blue")) +
  theme_minimal()

# Afficher le graphique
print(tarif_water_plot)