**foodML**
A curated and reproducible R-based workflow developed to support the research presented in the manuscript:

Shinn, L. M., Li, Y., Mansharamani, A., Auvil, L. S., Welge, M. E., Bushell, C., Khan, N. A., Charron, C. S., Novotny, J. A., Baer, D. J., Zhu, R., & Holscher, H. D. (2021). Fecal bacteria as biomarkers for predicting food intake in healthy adults. The Journal of Nutrition, 151(2), 423–433.
https://doi.org/10.1093/jn/nxaa393

This repository implements a predictive framework using gut microbiome data to identify dietary intake patterns. It includes data preprocessing, feature screening, classification via Random Forest and LASSO, model comparison, validation, and reproducibility through dummy data.

📦 Features
- Random Forest-based dietary intake prediction using microbial abundance changes
- Species-level microbial feature selection via Kruskal-Wallis tests
- Cross-validation, multi-class ROC/AUC analysis, and node-size tuning
- Comparison of Random Forest and LASSO classifiers under repeated cross-validation
- Validation via principal component removal to separate treatment effects from study effects
-  Supports 4-, 5-, and 6-diet configurations
-  Includes dummy microbiome dataset for application

🧬 Methodology Overview
- Preprocessing
-- Convert paired-end microbiome data (baseline vs. end) to differential abundance matrix
-- Extract species-level Silva features and rename for modeling compatibility
-- Define datasets based on number of food categories (4, 5, or 6 diets)

-Feature Screening
-- Kruskal-Wallis test per diet to select top discriminative microbes
-- Pool features across diets and pass to classifier

- Classification
-- Random Forest model with node-size tuning
-- LASSO comparison using multinomial regression
-- Cross-validation (50-fold) for performance robustness

- Validation
-- Use PCA to subtract control-related variance
-- Train model on residual treatment signal
-- Test the model on both treatment and control sets

📬 Contact
For questions or collaborations, please contact:

Yutong Li, Ph.D.
📧 yutongli92@gmail.com

