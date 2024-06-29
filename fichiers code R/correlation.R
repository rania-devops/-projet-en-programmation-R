library(dplyr)

# Sélectionner les colonnes pertinentes
barrage_corr <- barrage[, c("Date", "apports")]
sonede_corr <- sonede[, c("id", "2023 (en dt)", "2024 (en dt)")]

# Filtrez les données pour chaque année
barrage_2023 <- filter(barrage_corr, Date >= "2023-01-01" & Date <= "2023-12-31")
barrage_2024 <- filter(barrage_corr, Date >= "2024-01-01" & Date <= "2024-12-31")
sonede_2023 <- filter(sonede_corr, !is.na(`2023 (en dt)`))  
sonede_2024 <- filter(sonede_corr, !is.na(`2024 (en dt)`))

# Assurez-vous que les données ont la même longueur
min_length <- min(length(barrage_2023$apports), length(sonede_2023$`2023 (en dt)`))
barrage_2023 <- head(barrage_2023, min_length)
sonede_2023 <- head(sonede_2023, min_length)

min_length <- min(length(barrage_2024$apports), length(sonede_2024$`2024 (en dt)`))
barrage_2024 <- head(barrage_2024, min_length)
sonede_2024 <- head(sonede_2024, min_length)

# Calculer la corrélation entre la somme du stock des barrages et l'augmentation des tarifs pour chaque année
correlation_2023 <- cor(barrage_2023$apports, sonede_2023$`2023 (en dt)`)
correlation_2024 <- cor(barrage_2024$apports, sonede_2024$`2024 (en dt)`)

# Afficher les résultats
print(paste("Corrélation pour 2023 :", correlation_2023))
print(paste("Corrélation pour 2024 :", correlation_2024))
