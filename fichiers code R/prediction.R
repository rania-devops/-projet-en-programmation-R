# Install and load the tidyverse package
#install.packages("tidyverse")
library(tidyverse)
library(ggplot2)

# Create the dataframe with the provided data
sonede_prediction_data <- sonede

# Rename the columns for ease of use
colnames(sonede_prediction_data)[3:4] <- c("prix_2023", "prix_2024")

# Adjust a linear regression model to predict water prices per bracket for the years 2025 to 2034
model <- lm(prix_2024 ~ prix_2023, data = sonede_prediction_data)

# Predict water prices per bracket for the years 2025 to 2034
predictions <- predict(model, newdata = data.frame(prix_2023 = sonede_prediction_data$prix_2024))

# Add predictions to the dataframe
sonede_prediction_data$`2025` <- predictions

# Calculate the difference between the predicted prices for 2025 and the prices for 2024
difference <- sonede_prediction_data$`2025` - sonede_prediction_data$prix_2024

# Create a new dataframe containing the bracket and the calculated difference
difference_data <- data.frame(tranche = sonede_prediction_data$`tranche-metre-cube-par-trimestre`, difference = difference)

# Convert the bracket variable into a factor with a specific order
difference_data$tranche <- factor(difference_data$tranche, levels = c("0-20", "20-40", "40-70", "70-100", "100-150", "150 et plus", "usage touristique"))

# Plot the curve with the bracket variable in the specified order
ggplot(difference_data, aes(x = tranche, y = difference)) +
  geom_line(color = "green") +
  geom_point(color = "red") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Add a linear regression line
  labs(x = "Tranche", y = "Price Difference", title = "Prediction of water price increase per bracket in 2025") +
  theme_minimal()