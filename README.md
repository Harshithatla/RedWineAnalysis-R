<p align="center">
  <img src="https://img.shields.io/badge/Red_Wine_Analysis_R_Project-darkred?style=for-the-badge&logo=R&logoColor=white" />
</p>

<hr/>

# 📊 **RedWineAnalysis-R**  
Comprehensive Exploratory Data Analysis (EDA) & Modelling of Portuguese Red Wine Quality Dataset using R

---

## 🏷️ **Badges**

[![R](https://img.shields.io/badge/R-4.0+-blue?logo=r&logoColor=white)](https://www.r-project.org/)  
[![ggplot2](https://img.shields.io/badge/ggplot2-Visualizations-orange?logo=R&logoColor=white)](https://ggplot2.tidyverse.org/)  
[![dplyr](https://img.shields.io/badge/dplyr-Data%20Manipulation-blue?logo=R&logoColor=white)](https://dplyr.tidyverse.org/)  
[![Project Type](https://img.shields.io/badge/Type-EDA%20%2B%20Modelling-green)]()  
[![Dataset](https://img.shields.io/badge/Dataset-Red%20Wine%20Quality-brown)]()  
[![Made With Love](https://img.shields.io/badge/Made%20With-❤️-ff69b4)]()  
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

# Red Wine Quality Analysis (R Project)

A complete exploratory data analysis (EDA) and modeling project analyzing the **Wine Quality Red** dataset using R.

This project generates univariate, bivariate, and multivariate visualizations, along with statistical model outputs to understand what factors most influence wine quality.

---

## 📌 Project Overview
This project performs a full analysis of the **Wine Quality – Red** dataset, including:

* Data cleaning & preparation
* Univariate exploration (histograms, boxplots)
* Bivariate relationships with wine quality
* Multivariate faceted plots
* Correlation matrix
* Linear regression models
* Exporting plots and statistical outputs
* **Reproducible folder-structured workflow:** All plots are automatically saved into organized folders, and model outputs/statistics are exported into `/output/`.

## 📁 Folder Structure

```text
RedWineAnalysis-R/
│
├── data/
│   └── wineQualityReds.csv
│
├── R/
│   └── analysis.R
│
├── plots/
│   ├── univariate/
│   ├── bivariate/
│   ├── multivariate/
│   └── modelling/
│
├── output/
│   ├── correlation_matrix.csv
│   ├── model_summaries.txt
│   ├── prediction_errors.csv
│   ├── structure.txt
│   ├── summary_statistics.txt
│   ├── training_data.csv
│   └── test_data.csv
│
├── install.R
└── README.md
```

## 📦 Required R Packages
Run these once in your R console before starting the analysis:

```r
install.packages(c("ggplot2", "dplyr", "gridExtra", "abdiv", 
                   "GGally", "memisc", "pander", "corrplot"))
```

## ▶️ How to Run the Project

1. **Open RStudio.**
2. **Set your working directory** to the `R/` folder:
   ```r
   setwd("RedWineAnalysis-R/R")
   ```
3. **Run the full analysis:**
   ```r
   source("analysis.R")
   ```
4. All plots and outputs will appear in the `plots/` and `output/` directories.

## 📊 Outputs Generated

### 1️⃣ Univariate Plots (`/plots/univariate/`)
* Distributions of all numeric variables
* Boxplots + histograms combo
* Quality distribution
* Rating distribution

### 2️⃣ Bivariate Plots (`/plots/bivariate/`)
* Quality vs fixed acidity
* Quality vs alcohol
* Quality vs sulphates
* *etc.*

### 3️⃣ Multivariate Plots (`/plots/multivariate/`)
Faceted scatterplots colored by quality rating:
* alcohol vs sulphates
* volatile acidity vs citric acid
* residual sugar vs alcohol
* *etc.*

### 4️⃣ Modelling Plots (`/plots/modelling/`)
* Model prediction errors
* Alcohol vs Quality (box + jitter + mean)
* Alcohol vs Sulphates

### 5️⃣ Statistical Outputs (`/output/`)
* `correlation_matrix.csv`
* `summary_statistics.txt`
* `structure.txt`
* `model_summaries.txt`
* `prediction_errors.csv`
* Train/test splits

## 🍷 Key Insights About Wine Quality
Based on the plots and the correlation matrix, the variables that impact red wine quality the most are:

* **✅ 1. Alcohol:** Strongest positive correlation (+0.48). High-quality wines usually have higher alcohol content.
* **✅ 2. Sulphates:** Moderate positive correlation. Better wines have higher sulphate levels (important for preservation & flavor).
* **❌ 3. Volatile Acidity:** Strong negative correlation. High values = more vinegary taste → lower quality.

### ⚠️ Other Influential Variables
* **Citric Acid** – mild positive
* **Density** – slight negative
* **Total Sulfur Dioxide** – weak negative
* **Chlorides** – weak negative

> **Summary:**
> * 🥇 **Alcohol** is the biggest indicator of wine quality
> * 🥈 **Sulphates** also help improve quality
> * ❌ **Volatile acidity** strongly decreases quality

## 🧠 Methods Used
* Histograms & Boxplots
* Jittered quality comparisons
* Correlation matrix
* Faceted multivariate visualizations
* Train/Test split evaluation
* **Linear Regression Models:** The modeling includes progressive regression.

| Model | Variable Added |
| :--- | :--- |
| **M1** | Alcohol |
| **M2** | + Sulphates |
| **M3** | + Volatile Acidity |
| **M4** | + Citric Acid |
| **M5** | + Fixed Acidity |

## 🚀 Future Improvements
* Add Random Forest & Gradient Boosting models
* Try PCA for dimensionality reduction
* Add a Shiny dashboard
* Support both red & white wine datasets

## 👤 Author

**Harshith Atla**
* Master’s in Data Science
* UMass Dartmouth