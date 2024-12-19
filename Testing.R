# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)
library(readr)

# 1. Data Loading and Preprocessing
dataset <- read_csv("D:/dataset-2.csv")

# Handle missing values
dataset <- dataset %>%
  mutate(
    Age = ifelse(is.na(Age), mean(Age, na.rm = TRUE), Age),
    wifi_service = ifelse(is.na(wifi_service), mean(wifi_service, na.rm = TRUE), wifi_service),
    Food_drink = ifelse(is.na(Food_drink), mean(Food_drink, na.rm = TRUE), Food_drink),
    Cleanliness = ifelse(is.na(Cleanliness), mean(Cleanliness, na.rm = TRUE), Cleanliness),
    Other_service = ifelse(is.na(Other_service), mean(Other_service, na.rm = TRUE), Other_service)
  )

# Create Satisfaction Score
dataset <- dataset %>%
  mutate(Satisfaction_Score = (wifi_service + Food_drink + Cleanliness + Other_service) / 4)

### 1. T-Test: Comparing the Means of Satisfaction Score between High and Low Wi-Fi Groups

# Group data into 'High' and 'Low' Wi-Fi service based on mean
dataset <- dataset %>%
  mutate(Wifi_Group = ifelse(wifi_service >= mean(wifi_service), "High", "Low"))

# Perform t-test
t_test_result <- t.test(Satisfaction_Score ~ Wifi_Group, data = dataset)

# Display t-test result
print("t-test Result for Wi-Fi Groups:")
print(t_test_result)

# Visualize using box plot with customized colors
ggplot(dataset, aes(x = Wifi_Group, y = Satisfaction_Score, fill = Wifi_Group)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 19, color = "black", alpha = 0.7) +
  scale_fill_manual(values = c("High" = "#1f78b4", "Low" = "#33a02c")) +
  labs(title = "Boxplot: Satisfaction Score by Wi-Fi Group", x = "Wi-Fi Group", y = "Satisfaction Score") +
  theme_minimal()

### 2. One-Way ANOVA: Comparing Means of Satisfaction Score for Different Cleanliness Groups

# Create groups for Cleanliness levels (Low, Medium, High)
dataset <- dataset %>%
  mutate(Cleanliness_Group = cut(Cleanliness, breaks = quantile(Cleanliness, probs = seq(0, 1, 1/3)), 
                                 include.lowest = TRUE, labels = c("Low", "Medium", "High")))

# Perform ANOVA
anova_result <- aov(Satisfaction_Score ~ Cleanliness_Group, data = dataset)

# Display ANOVA summary
print("ANOVA Result for Cleanliness Group:")
summary(anova_result)

# Post-hoc Tukey's HSD test for pairwise comparisons
tukey_test <- TukeyHSD(anova_result)
print("Tukey's HSD Test Result:")
print(tukey_test)

# Visualize using box plot with customized colors
ggplot(dataset, aes(x = Cleanliness_Group, y = Satisfaction_Score, fill = Cleanliness_Group)) +
  geom_boxplot(outlier.color = "blue", outlier.shape = 8, color = "black", alpha = 0.6) +
  scale_fill_manual(values = c("Low" = "#e41a1c", "Medium" = "#377eb8", "High" = "#4daf4a")) +
  labs(title = "Boxplot: Satisfaction Score by Cleanliness Group", x = "Cleanliness Group", y = "Satisfaction Score") +
  theme_minimal()

# Visualize the post-hoc test with error bars
tukey_df <- as.data.frame(tukey_test$Cleanliness_Group)
tukey_df$Comparison <- rownames(tukey_df)

ggplot(tukey_df, aes(x = Comparison, y = diff)) +
  geom_point(size = 4, color = "purple") +
  geom_errorbar(aes(ymin = lwr, ymax = upr), width = 0.2) +
  labs(title = "Tukey's HSD Test for Cleanliness Group Comparisons", x = "Comparison", y = "Mean Difference") +
  theme_minimal()

### 3. Chi-Square Test: Testing Independence between Wi-Fi Service Quality and Customer Satisfaction

# Group data into Satisfied and Not Satisfied based on median of Satisfaction Score
dataset <- dataset %>%
  mutate(Satisfaction_Group = ifelse(Satisfaction_Score >= median(Satisfaction_Score), "Satisfied", "Not Satisfied"))

# Create contingency table
contingency_table <- table(dataset$Wifi_Group, dataset$Satisfaction_Group)

# Perform Chi-Square test
chi_square_result <- chisq.test(contingency_table)

# Display Chi-Square test result
print("Chi-Square Test Result for Wi-Fi Group and Satisfaction Group:")
print(chi_square_result)

# Visualize the relationship between Wi-Fi service quality and Satisfaction with a bar plot
ggplot(dataset, aes(x = Wifi_Group, fill = Satisfaction_Group)) +
  geom_bar(position = "fill", color = "black", alpha = 0.8) +
  scale_fill_manual(values = c("Satisfied" = "#ff7f00", "Not Satisfied" = "#984ea3")) +
  labs(title = "Bar Plot: Wi-Fi Group vs Satisfaction", x = "Wi-Fi Group", y = "Proportion") +
  theme_minimal()

### 4. Bar Chart: Age Group vs Satisfaction Group
# Create Age groups for better insights
dataset <- dataset %>%
  mutate(Age_Group = cut(Age, breaks = c(18, 25, 35, 50, 65), labels = c("18-25", "26-35", "36-50", "51-65")))

# Visualize Satisfaction by Age Group
ggplot(dataset, aes(x = Age_Group, fill = Satisfaction_Group)) +
  geom_bar(position = "dodge", color = "black", alpha = 0.7) +
  scale_fill_manual(values = c("Satisfied" = "#4daf4a", "Not Satisfied" = "#e41a1c")) +
  labs(title = "Bar Plot: Satisfaction by Age Group", x = "Age Group", y = "Count") +
  theme_minimal()

### 5. Scatter Plot with Trend Line: Food and Drink Service vs Satisfaction Score
ggplot(dataset, aes(x = Food_drink, y = Satisfaction_Score)) +
  geom_point(color = "#377eb8", size = 3, alpha = 0.6) +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  labs(title = "Scatter Plot: Food and Drink Service vs Satisfaction Score", x = "Food and Drink Service", y = "Satisfaction Score") +
  theme_minimal()

### 6. Residual Plot for ANOVA Assumptions
residuals_df <- augment(anova_result)

ggplot(residuals_df, aes(.fitted, .resid)) +
  geom_point(size = 3, color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Residual Plot: Fitted Values vs Residuals", x = "Fitted Values", y = "Residuals") +
  theme_minimal()

