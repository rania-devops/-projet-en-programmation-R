library(readr)
#install.packages("readxl")
library(readxl)
# Importer les données de barrages
barrage <- read.csv("C:/Users/21629/OneDrive/Bureau/projet programmation R/barrages.csv")
# Importer les données de barrages
pluviometrie <- read.csv("C:/Users/21629/OneDrive/Bureau/projet programmation R/pluviometrie.csv")
# Importer les données de cereale
cereale <- read.csv("C:/Users/21629/OneDrive/Bureau/projet programmation R/cereale.csv")
head(cereale)
# Charger le fichier de usage
donnees <- read_excel("C:/Users/21629/OneDrive/Bureau/projet programmation R/usage.xlsx")
# Charger le fichier de sonede
sonede <- read_excel("C:/Users/21629/OneDrive/Bureau/projet programmation R/Sonede.xlsx")

# Convertir et enregistrer en format CSV
write.csv(sonede, "C:/Users/21629/OneDrive/Bureau/projet programmation R/Sonede.csv", row.names = FALSE)
head(sonede)
#class(sonede)
head(pluviometrie)
#class(pluviometrie)
#pour verifier que les donnees sont bien sous format frame
#class(barrage)
# Lire les premières lignes
head(barrage)

# Supprimer les colonnes Nom_Ar et Annee_prod
barrage <- subset(barrage, select = -c(Nom_Ar, Annee_prod))

# Supprimer des lignes avec des valeurs manquantes
barrage <- na.omit(barrage)
pluviometrie <- na.omit(pluviometrie)

# Supprimer des lignes avec des valeurs négatives dans la colonne apports
barrage <- barrage[barrage$apports >= 0, ]
pluviometrie <- pluviometrie[pluviometrie$Cumul_periode >= 0, ]
# Convertir les colonnes contenant des dates en types de données de date
barrage$Date <- as.Date(barrage$Date)
pluviometrie$Date <- as.Date(pluviometrie$Date)

# Normaliser les valeurs de la colonne Nom_Fr en minuscules
barrage$Nom_Fr <- tolower(barrage$Nom_Fr)
head(barrage)
donnees <- data.frame(
  "Utilisation.principale" = c("Hydroélectricité", "Irrigation", "Alimentation en eau", "Loisirs, Navigation"),
  "Pourcentage" = c("5 %", "60 %", "30 %", "5 %")
)