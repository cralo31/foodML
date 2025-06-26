foodML
A curated and reproducible R-based workflow developed to support the research presented in the manuscript:

Shinn, L. M., Li, Y., Mansharamani, A., Auvil, L. S., Welge, M. E., Bushell, C., Khan, N. A., Charron, C. S., Novotny, J. A., Baer, D. J., Zhu, R., & Holscher, H. D. (2021). Fecal bacteria as biomarkers for predicting food intake in healthy adults. The Journal of Nutrition, 151(2), 423–433.
https://doi.org/10.1093/jn/nxaa393

This repository provides the analysis code, data preprocessing steps, and machine learning pipelines used to develop predictive models that link fecal microbiome profiles with specific dietary intake patterns.

This repository implements a predictive framework using gut microbiome data to identify dietary intake patterns. It includes data preprocessing, feature screening, classification via Random Forest and LASSO, model comparison, validation, and reproducibility through dummy data.

📦 Features
📊 Random Forest-based dietary intake prediction using microbial abundance changes

🔬 Species-level microbial feature selection via Kruskal-Wallis tests

⚙️ Cross-validation, multi-class ROC/AUC analysis, and node-size tuning

🔍 Comparison of Random Forest and LASSO classifiers under repeated cross-validation

🔄 Validation via principal component removal to separate treatment effects from study effects

📁 Supports 4-, 5-, and 6-diet configurations

🧪 Includes dummy microbiome dataset for reproducibility

🔧 Requirements
R
Copy code
install.packages(c("stringr", "qdapRegex", "glmnet", "vegan", "car", "randomForest",
                   "readxl", "caret", "pROC", "ROCR", "changepoint"))

bash
Copy code
git clone https://github.com/YOUR_USERNAME/foodML.git
Open R and run the pipeline:

R
Copy code
source("scripts/foodML_pipeline.R")
The pipeline will output:

Accuracy and AUC from Random Forest and LASSO classifiers

Variable importance rankings for predictive microbes

Confusion matrices across 4-, 5-, and 6-diet models

Figures validating treatment effects via PCA

🧬 Methodology Overview
🧹 Preprocessing
Convert paired-end microbiome data (baseline vs. end) to differential abundance matrix

Extract species-level Silva features and rename for modeling compatibility

Define datasets based on number of food categories (4, 5, or 6 diets)

🧪 Feature Screening
Kruskal-Wallis test per diet to select top discriminative microbes

Pool features across diets and pass to classifier

🌲 Classification
Random Forest model with node-size tuning

LASSO comparison using multinomial regression

Cross-validation (50-fold) for performance robustness

📊 Validation
Use PCA to subtract control-related variance

Train model on residual treatment signal

Test the model on both treatment and control sets

📈 Example Results
R
Copy code
# Run core pipeline on 5-diet data
sv5.spe.20 = pipe.line(SV.5, 20, 1031)

# Inspect results
sv5.spe.20$accu      # Accuracy & AUC
sv5.spe.20$mat       # Confusion matrix
sv5.spe.20$imp       # Top microbes per diet
📝 Citation
If you use this code or dataset in your work, please cite:

Shinn, L. M., Li, Y., et al. (2021). Fecal Bacteria as Biomarkers for Predicting Food Intake in Healthy Adults. Journal of Nutrition, 151(2), 423–433.
https://doi.org/10.1093/jn/nxaa393

📬 Contact
For questions or collaborations, please contact:

Yutong Li, Ph.D.
📧 yutongli92@gmail.com

Let me know if you'd like a minimal version or one formatted for CRAN-style documentation.
