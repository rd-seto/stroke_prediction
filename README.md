# Stroke Prediction Project Documentation

Project Description

This project aims to develop a stroke prediction model using machine learning, particularly the Random Forest algorithm. The project involves:

Data preprocessing
Handling class imbalance
Model building
Model evaluation
The main objective is to predict the likelihood of stroke based on several health and demographic features.

<div align="center">
    <img src="https://github.com/rd-seto/stroke_prediction/blob/main/variable_importance_plot.png?raw=true" alt="Variable Importance Plot" width="300"/>
    <img src="https://github.com/rd-seto/stroke_prediction/blob/main/roc_curve_random_forest.png?raw=true" alt="ROC Curve" width="300"/>
</div>

#Code Structure

1. Preparation
Load essential packages: tidyverse, caret, randomForest, pROC, ROSE
Read the stroke dataset from a CSV file
2. Data Preprocessing
Clean and convert the BMI column
Transform categorical variables into factors
Generate new features: age_group, bmi_category
Drop irrelevant columns, such as id
3. Data Splitting
Separate features (X) and target variable (y)
Split the data into 70% training and 30% testing
4. Handling Class Imbalance
Apply the ROSE technique to balance the classes in the training set
5. Modeling
Train the Random Forest model with 500 decision trees
6. Model Evaluation
Make predictions on the test set
Plot the ROC curve and calculate AUC
Display variable importance
Create the confusion matrix
7. Model Saving
Save the trained Random Forest model for future use
8. Conclusion
Print the AUC score
Highlight the most important features for stroke prediction

#How to Run the Code

1. Clone the repository and make sure all required packages are installed.
2. Adjust the file path in the line:

<details>
  <summary>Click to expand code</summary>
stroke_data <- read.csv('path/to/your/data.csv')
</details> ```

3. Run the code sequentially.
4. Check the outputs, including the ROC plot, variable importance plot, and confusion matrix.
5. The saved model can be loaded later using readRDS().

#Key Outputs

1. AUC (Area Under the Curve) to evaluate model performance
2. ROC Curve
3. Variable Importance Plot
4. Confusion Matrix
5. List of important features for stroke prediction

#Further Improvements

1. Experiment with additional preprocessing techniques
2. Try alternative machine learning models (e.g., XGBoost, SVM)
3. Implement cross-validation for more robust evaluations
4. Explore new features relevant to stroke prediction




