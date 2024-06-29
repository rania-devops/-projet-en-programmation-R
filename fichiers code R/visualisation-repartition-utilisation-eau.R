library(ggplot2)
# Changer le nom du dataset
donnees_eau <- data.frame(
  Utilisation.principale = c("Hydroélectricité", "Irrigation", "Alimentation en eau", "Loisirs, Navigation"),
  Pourcentage = c(5, 60, 30, 5)
)

# Créer le pie chart avec le nouveau nom de dataset
pie_chart <- ggplot(donnees_eau, aes(x = "", y = Pourcentage, fill = Utilisation.principale)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste0(Pourcentage, "%")), 
            position = position_stack(vjust = 0.5), 
            color = "white", 
            size = 4) +  
  labs(title = "Répartition des utilisations principales de l'eau",
       fill = "Utilisation principale",
       y = "Pourcentage") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Afficher le pie chart
print(pie_chart)