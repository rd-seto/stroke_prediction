# Memuat paket yang diperlukan
library(tidyverse)    # Untuk manipulasi data
library(caret)        # Untuk pemodelan dan evaluasi
library(randomForest) # Untuk model Random Forest
library(pROC)         # Untuk ROC dan AUC
library(ROSE)         # Untuk menangani ketidakseimbangan kelas

# Muat data
stroke_data <- read.csv("/Users/elsedot/Documents/stroke_prediction_R/stroke_data.csv")

# Pra-pemrosesan data
stroke_data <- stroke_data %>%
  mutate(
    # Membersihkan dan mengonversi bmi
    bmi = as.character(bmi),  # Konversi ke karakter terlebih dahulu
    bmi = gsub(",", ".", bmi),  # Mengganti koma dengan titik (jika ada)
    bmi = gsub("[^0-9.]", "", bmi),  # Menghapus karakter non-numerik
    bmi = as.numeric(bmi),  # Konversi ke numerik
    
    # Menangani nilai yang hilang dan tidak valid
    bmi = case_when(
      is.na(bmi) ~ median(bmi, na.rm = TRUE),
      bmi <= 0 ~ median(bmi, na.rm = TRUE),
      bmi > 100 ~ median(bmi, na.rm = TRUE),
      TRUE ~ bmi
    ),
    
    # Mengubah variabel kategorikal menjadi faktor
    gender = as.factor(gender),
    hypertension = as.factor(hypertension),
    heart_disease = as.factor(heart_disease),
    ever_married = as.factor(ever_married),
    work_type = as.factor(work_type),
    Residence_type = as.factor(Residence_type),
    smoking_status = as.factor(smoking_status),
    stroke = as.factor(stroke),
    
    # Membuat fitur baru
    age_group = cut(age, breaks = c(0, 18, 35, 50, 65, Inf), 
                    labels = c("0-18", "19-35", "36-50", "51-65", "65+")),
    bmi_category = cut(bmi, breaks = c(0, 18.5, 25, 30, Inf), 
                       labels = c("Underweight", "Normal", "Overweight", "Obese"))
  ) %>%
  # Menghapus kolom yang tidak diperlukan
  select(-id)

# Memeriksa struktur data setelah pra-pemrosesan
str(stroke_data)
summary(stroke_data)
# Memisahkan data menjadi fitur dan target
X <- stroke_data %>% select(-stroke)
y <- stroke_data$stroke

# Membagi data menjadi set pelatihan dan pengujian
set.seed(123)
trainIndex <- createDataPartition(y, p = .7, list = FALSE, times = 1)
X_train <- X[trainIndex,]
X_test <- X[-trainIndex,]
y_train <- y[trainIndex]
y_test <- y[-trainIndex]

# Menangani ketidakseimbangan kelas menggunakan ROSE
balanced_data <- ROSE(stroke ~ ., data = cbind(X_train, stroke = y_train))$data

# Melatih model Random Forest
rf_model <- randomForest(stroke ~ ., data = balanced_data, ntree = 500, importance = TRUE)

# Melakukan prediksi
predictions_rf <- predict(rf_model, newdata = X_test, type = "prob")[,2]

# Mengevaluasi model
roc_curve_rf <- roc(y_test, predictions_rf)
auc_rf <- auc(roc_curve_rf)

# Mencetak hasil
cat("AUC untuk Random Forest:", auc_rf, "\n")

# Plot ROC Curve
plot(roc_curve_rf, main = "ROC Curve Random Forest")

# Menampilkan kepentingan fitur
importance_rf <- importance(rf_model)
varImpPlot(rf_model, main = "Variable Importance Plot")

# Membuat confusion matrix
conf_matrix <- confusionMatrix(predict(rf_model, newdata = X_test), y_test)
print(conf_matrix)

# Menyimpan model
saveRDS(rf_model, file = "stroke_prediction_model_rf_improved.rds")

# Kesimpulan
cat("Model Random Forest yang dioptimalkan memberikan AUC:", auc_rf, "\n")
cat("Fitur-fitur paling penting untuk prediksi stroke adalah:\n")
print(importance_rf[order(importance_rf[,3], decreasing = TRUE),])

