# ------------------------------------------------------------
# Load Libraries
# ------------------------------------------------------------

library(ggplot2)
library(dplyr)        # must load AFTER abdiv (safer)
library(gridExtra)
library(abdiv)
library(GGally)
library(memisc)
library(pander)
library(corrplot)

# ------------------------------------------------------------
# Set up plot directories (relative to R/)
# ------------------------------------------------------------

base_plot_dir <- "../plots"
dir.create(base_plot_dir, showWarnings = FALSE)

dir.create(file.path(base_plot_dir, "univariate"), showWarnings = FALSE)
dir.create(file.path(base_plot_dir, "bivariate"), showWarnings = FALSE)
dir.create(file.path(base_plot_dir, "multivariate"), showWarnings = FALSE)
dir.create(file.path(base_plot_dir, "modelling"), showWarnings = FALSE)

univariate_dir   <- file.path(base_plot_dir, "univariate")
bivariate_dir    <- file.path(base_plot_dir, "bivariate")
multivariate_dir <- file.path(base_plot_dir, "multivariate")
modelling_dir    <- file.path(base_plot_dir, "modelling")

# ------------------------------------------------------------
# Load Dataset
# ------------------------------------------------------------

wine <- read.csv("../data/wineQualityReds.csv")

wine$quality <- factor(wine$quality, ordered = TRUE)

wine$rating <- ifelse(wine$quality < 5, "bad",
                      ifelse(wine$quality < 7, "average", "good"))
wine$rating <- ordered(wine$rating, levels = c("bad", "average", "good"))

# ------------------------------------------------------------
# Basic Structure & Summary
# ------------------------------------------------------------

str(wine)
summary(wine)

# ------------------------------------------------------------
# Univariate Plots (quality, rating)
# ------------------------------------------------------------

p_quality <- ggplot(wine, aes(x = quality)) +
  geom_bar(width = 1, color = "black", fill = "orange")
print(p_quality)
ggsave(file.path(univariate_dir, "quality_distribution.png"),
       p_quality, width = 6, height = 4, dpi = 300)

p_rating <- ggplot(wine, aes(x = rating)) +
  geom_bar(width = 1, color = "black", fill = "blue")
print(p_rating)
ggsave(file.path(univariate_dir, "rating_distribution.png"),
       p_rating, width = 6, height = 4, dpi = 300)

# ------------------------------------------------------------
# Boxplots + Histograms (Univariate helper)
# ------------------------------------------------------------

plot_pair <- function(df, var, binwidth, limits = NULL) {
  p1 <- ggplot(df, aes(x = 1, y = .data[[var]])) +
    geom_jitter(alpha = 0.1) +
    geom_boxplot(alpha = 0.2, color = "red")
  
  if (!is.null(limits)) {
    p1 <- p1 + scale_y_continuous(limits = limits)
  }
  
  p2 <- ggplot(df, aes(x = .data[[var]])) +
    geom_histogram(binwidth = binwidth, color = "black", fill = "orange")
  
  if (!is.null(limits)) {
    p2 <- p2 + scale_x_continuous(limits = limits)
  }
  
  combined <- grid.arrange(p1, p2, ncol = 2)
  print(combined)
  
  ggsave(
    file.path(univariate_dir, paste0(var, "_univariate.png")),
    combined,
    width = 8, height = 4, dpi = 300
  )
  
  invisible(combined)
}

plot_pair(wine, "fixed.acidity",        1,    c(4, 14))
plot_pair(wine, "volatile.acidity",     0.05, c(0, 1))
plot_pair(wine, "citric.acid",          0.08, c(0, 1))
plot_pair(wine, "residual.sugar",       0.1,  c(1, 8))
plot_pair(wine, "chlorides",            0.01, c(0, 0.25))
plot_pair(wine, "free.sulfur.dioxide",  1,    c(0, 45))
plot_pair(wine, "total.sulfur.dioxide", 5,    c(0, 180))
plot_pair(wine, "density",              0.001, NULL)
plot_pair(wine, "pH",                   0.1,  NULL)
plot_pair(wine, "sulphates",            0.1,  c(0.3, 1.6))
plot_pair(wine, "alcohol",              0.1,  c(8, 14))

# ------------------------------------------------------------
# Correlation Matrix (Printed Only)
# ------------------------------------------------------------

c <- cor(
  dplyr::select(wine, -rating) %>%
    mutate(quality = as.numeric(quality))
)

pander(c)

# ------------------------------------------------------------
# Scatter Plots vs Quality (Bivariate)
# ------------------------------------------------------------

plot_quality <- function(df, var, limits = NULL) {
  p <- ggplot(df, aes(x = quality, y = .data[[var]])) +
    geom_jitter(alpha = .3) +
    geom_boxplot(alpha = .5, color = "blue") +
    stat_summary(fun = mean, geom = "point", color = "red",
                 shape = 8, size = 4)
  
  if (!is.null(limits)) {
    p <- p + scale_y_continuous(limits = limits)
  }
  
  print(p)
  
  ggsave(
    file.path(bivariate_dir, paste0("quality_vs_", var, ".png")),
    p, width = 6, height = 4, dpi = 300
  )
}

plot_quality(wine, "fixed.acidity")
plot_quality(wine, "volatile.acidity")
plot_quality(wine, "citric.acid")
plot_quality(wine, "residual.sugar", c(0, 5))
plot_quality(wine, "chlorides", c(0, 0.2))
plot_quality(wine, "free.sulfur.dioxide", c(0, 40))
plot_quality(wine, "total.sulfur.dioxide", c(0, 150))
plot_quality(wine, "density")
plot_quality(wine, "pH")
plot_quality(wine, "sulphates", c(0.25, 1))
plot_quality(wine, "alcohol")

# ------------------------------------------------------------
# Multivariate Plots (Saved in multivariate/)
# ------------------------------------------------------------

multi_plot <- function(y, x) {
  p <- ggplot(wine, aes(y = .data[[y]], x = .data[[x]], color = quality)) +
    geom_point(alpha = 0.8, size = 1) +
    geom_smooth(method = "lm", se = FALSE, size = 1) +
    facet_wrap(~rating) +
    scale_color_brewer(type = "seq")
  
  print(p)
  
  ggsave(
    file.path(multivariate_dir, paste0(y, "_vs_", x, "_by_rating.png")),
    p, width = 7, height = 4, dpi = 300
  )
}

multi_plot("density", "alcohol")
multi_plot("sulphates", "alcohol")
multi_plot("volatile.acidity", "alcohol")
multi_plot("pH", "alcohol")
multi_plot("residual.sugar", "alcohol")
multi_plot("total.sulfur.dioxide", "alcohol")
multi_plot("citric.acid", "volatile.acidity")
multi_plot("citric.acid", "fixed.acidity")
multi_plot("fixed.acidity", "volatile.acidity")

# ------------------------------------------------------------
# Linear Modeling
# ------------------------------------------------------------

set.seed(1221)

if ("X" %in% names(wine)) {
  training_data <- sample_frac(wine, 0.6)
  test_data <- wine[!wine$X %in% training_data$X, ]
} else {
  idx <- sample(1:nrow(wine), size = 0.6 * nrow(wine))
  training_data <- wine[idx, ]
  test_data     <- wine[-idx, ]
}

m1 <- lm(as.numeric(quality) ~ alcohol, data = training_data)
m2 <- update(m1, ~ . + sulphates)
m3 <- update(m2, ~ . + volatile.acidity)
m4 <- update(m3, ~ . + citric.acid)
m5 <- update(m4, ~ . + fixed.acidity)

mtable(m1, m2, m3, m4, m5)

df <- data.frame(
  quality = test_data$quality,
  error   = predict(m5, test_data) - as.numeric(test_data$quality)
)

p_err <- ggplot(df, aes(x = quality, y = error)) +
  geom_jitter(alpha = 0.3)
print(p_err)
ggsave(
  file.path(modelling_dir, "model_errors_by_quality.png"),
  p_err, width = 6, height = 4, dpi = 300
)

# ------------------------------------------------------------
# Final Modelling Plots
# ------------------------------------------------------------

p_alc_qual <- ggplot(wine, aes(y = alcohol, x = quality)) +
  geom_jitter(alpha = .3) +
  geom_boxplot(alpha = .5, color = "blue") +
  stat_summary(fun = mean, geom = "point", color = "red",
               shape = 8, size = 4) +
  ggtitle("Influence of Alcohol on Wine Quality")
print(p_alc_qual)
ggsave(
  file.path(modelling_dir, "alcohol_vs_quality.png"),
  p_alc_qual, width = 6, height = 4, dpi = 300
)

p_alc_sulph <- ggplot(wine, aes(y = sulphates, x = alcohol, color = quality)) +
  geom_point(alpha = 0.8, size = 1) +
  geom_smooth(method = "lm", se = FALSE, size = 1) +
  scale_y_continuous(limits = c(0.3, 1.5)) +
  ggtitle("Alcohol and Sulphates across Wine Quality")
print(p_alc_sulph)
ggsave(
  file.path(modelling_dir, "alcohol_vs_sulphates_by_quality.png"),
  p_alc_sulph, width = 6, height = 4, dpi = 300
)

p_final_err <- ggplot(df, aes(x = quality, y = error)) +
  geom_jitter(alpha = 0.3) +
  ggtitle("Linear Model Errors vs Expected Quality")
print(p_final_err)
ggsave(
  file.path(modelling_dir, "final_model_errors.png"),
  p_final_err, width = 6, height = 4, dpi = 300
)

# ============================================================
# Export Output Files (Saved into /output)
# ============================================================

output_dir <- "../output"
dir.create(output_dir, showWarnings = FALSE)

# ---- 1. Save summary statistics ----
capture.output(
  summary(wine),
  file = file.path(output_dir, "summary_statistics.txt")
)

# ---- 2. Save structure ----
capture.output(
  str(wine),
  file = file.path(output_dir, "structure.txt")
)

# ---- 3. Save correlation matrix ----
write.csv(c, file.path(output_dir, "correlation_matrix.csv"), row.names = TRUE)

# ---- 4. Save model summaries ----
capture.output(
  summary(m1),
  summary(m2),
  summary(m3),
  summary(m4),
  summary(m5),
  file = file.path(output_dir, "model_summaries.txt")
)

# ---- 5. Save prediction errors ----
write.csv(df, file.path(output_dir, "prediction_errors.csv"), row.names = FALSE)

# ---- 6. Save the training/test split (optional) ----
write.csv(training_data, file.path(output_dir, "training_data.csv"), row.names = FALSE)
write.csv(test_data, file.path(output_dir, "test_data.csv"), row.names = FALSE)

# ---- Confirmation message ----
cat("All outputs saved successfully to /output folder.\n")
