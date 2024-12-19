# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(corrplot)

# 1. Data Loading and Preprocessing
# Load the dataset
dataset <- read_csv("D:/dataset-2.csv")

# 2. Handle Missing Values
# Replace missing numeric values with mean
dataset <- dataset %>%
  mutate(
    Age = ifelse(is.na(Age), mean(Age, na.rm = TRUE), Age),
    wifi_service = ifelse(is.na(wifi_service), mean(wifi_service, na.rm = TRUE), wifi_service),
    Food_drink = ifelse(is.na(Food_drink), mean(Food_drink, na.rm = TRUE), Food_drink),
    Cleanliness = ifelse(is.na(Cleanliness), mean(Cleanliness, na.rm = TRUE), Cleanliness),
    Other_service = ifelse(is.na(Other_service), mean(Other_service, na.rm = TRUE), Other_service)
  )

# 3. Standardize the data using Z-scores
dataset <- dataset %>%
  mutate(
    Z_Age = scale(Age),
    Z_Wifi = scale(wifi_service),
    Z_Food = scale(Food_drink),
    Z_Cleanliness = scale(Cleanliness),
    Z_Other = scale(Other_service)
  )

# 4. Basic Statistics (Mean, Median, Standard Deviation)
basic_stats <- dataset %>%
  summarise(
    Mean_Age = mean(Age, na.rm = TRUE),
    Median_Age = median(Age, na.rm = TRUE),
    SD_Age = sd(Age, na.rm = TRUE),
    
    Mean_Wifi = mean(wifi_service, na.rm = TRUE),
    Median_Wifi = median(wifi_service, na.rm = TRUE),
    SD_Wifi = sd(wifi_service, na.rm = TRUE),
    
    Mean_Food = mean(Food_drink, na.rm = TRUE),
    Median_Food = median(Food_drink, na.rm = TRUE),
    SD_Food = sd(Food_drink, na.rm = TRUE),
    
    Mean_Cleanliness = mean(Cleanliness, na.rm = TRUE),
    Median_Cleanliness = median(Cleanliness, na.rm = TRUE),
    SD_Cleanliness = sd(Cleanliness, na.rm = TRUE),
    
    Mean_Other = mean(Other_service, na.rm = TRUE),
    Median_Other = median(Other_service, na.rm = TRUE),
    SD_Other = sd(Other_service, na.rm = TRUE)
  )


print("Basic Statistics:")
print(basic_stats)

# Print all data values
print("All Data Values:")
print(dataset, n = Inf)  # Print all rows



# 5. Identify outliers using Z-scores
outliers <- dataset %>%
  filter(abs(Z_Age) > 3 | abs(Z_Wifi) > 3 | abs(Z_Food) > 3 | abs(Z_Cleanliness) > 3 | abs(Z_Other) > 3)

print("Outliers detected:")
if (nrow(outliers) > 0) {
  print(outliers)
} else {
  print("No outliers detected.")
}

# 6. Frequency distribution and Histograms for all numeric variables
# Create histograms for numeric columns
for (col in c("Age", "wifi_service", "Food_drink", "Cleanliness", "Other_service")) {
  p <- ggplot(dataset, aes_string(x = col)) +
    geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
    labs(title = paste("Histogram of", col), x = col, y = "Frequency") +
    theme_minimal()
  
  print(p)
}

# 7. Calculate Satisfaction Score
dataset <- dataset %>%
  mutate(Satisfaction_Score = (wifi_service + Food_drink + Cleanliness + Other_service) / 4)

# 8. Scatter Plot to visualize the relationship between Satisfaction and Service Ratings
ggplot(dataset, aes(x = Age, y = Satisfaction_Score)) +
  geom_point() +
  labs(title = "Scatter Plot: Age vs Satisfaction Score", x = "Age", y = "Satisfaction Score")

ggplot(dataset, aes(x = wifi_service, y = Satisfaction_Score)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Scatter Plot: wifi_service vs Satisfaction Score", x = "wifi_service", y = "Satisfaction Score")

# 9. Box plots for service quality variables
melted_dataset <- dataset %>%
  select(wifi_service, Food_drink, Cleanliness, Other_service) %>%
  tidyr::gather(key = "Service", value = "Score")

ggplot(melted_dataset, aes(x = Service, y = Score)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  labs(title = "Box Plot: Service Quality Ratings", x = "Service Type", y = "Score")

# 10. Correlation matrix for understanding relationships
correlation_matrix <- dataset %>%
  select(Satisfaction_Score, wifi_service, Food_drink, Cleanliness, Other_service) %>%
  cor()

print("Correlation Matrix:")
print(correlation_matrix)

# Visualizing the correlation matrix as a circle
corrplot(correlation_matrix, method = "circle", type = "upper", 
         tl.col = "black", tl.srt = 45, 
         title = "Correlation Matrix (Circle Method)", mar = c(0,0,1,0))

# 11. Analyze the relationship between service quality and customer satisfaction using regression
model <- lm(Satisfaction_Score ~ wifi_service + Food_drink + Cleanliness + Other_service, data = dataset)

# Model summary
model_summary <- summary(model)
print("Regression Model Summary:")
print(model_summary)

# 12. Display the results of regression in a scatter plot with fitted line
ggplot(dataset, aes(x = Satisfaction_Score, y = wifi_service)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Regression: Satisfaction Score vs wifi_service", x = "Satisfaction Score", y = "wifi_service")

# 13. Show a table summarizing customer satisfaction with service quality
satisfaction_table <- dataset %>%
  select(Satisfaction_Score, wifi_service, Food_drink, Cleanliness, Other_service)

print("Customer Satisfaction and Service Quality Table:")
print(satisfaction_table)

