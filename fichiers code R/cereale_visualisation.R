#install.packages("tidyr")
library(tidyr)
library(ggplot2)
# Renommer les colonnes
colnames(cereale) <- c("Céréale", "X2014", "X2015", "X2016", "X2017", "X2018", "X2019", "X2020", "X2021", "X2022")
head(cereale)
# Transformer le jeu de données en format long
cereale<- pivot_longer(cereale, cols = -Céréale, names_to = "Annee", values_to = "Production")
# Convertir l'année en numérique
cereale$Annee <- as.numeric(sub("X", "", cereale$Annee))

# Créer le graphique
ggplot(cereale, aes(x = Annee, y = as.numeric(Production), color = Céréale)) +
  geom_line() +
  labs(title = "Variation de production des céréales (2014-2022)",
       x = "Année",
       y = "Production (en milliers de tonnes)",
       color = "Céréale") +
  theme_minimal() +
  theme(legend.position = "bottom")