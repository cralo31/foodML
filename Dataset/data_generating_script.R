set.seed(1031)  # Set seed for reproducibility

# ---- Parameters ----
n_subj <- 500                  # Number of unique subjects
n_features <- 200             # Number of microbial features (e.g., species-level taxa)
detect_thresh <- 1e-3         # Detection threshold: values below this are set to 0
food_names <- c("Almond", "Avocado", "Broccoli", "Grains", "Walnut")  # Diet study labels

# ---- Metadata generation ----
# Each subject has a baseline and an end measurement → total 2 × n_subj rows
SubjectID <- rep(1:n_subj, each = 2)  # Repeat subject ID for baseline and end
Period <- rep(sample(1:4, n_subj, replace = TRUE), each = 2)  # Random treatment period per subject
Study <- rep(sample(food_names, n_subj, replace = TRUE), each = 2)  # Assign study type per subject

# Assign food condition: 50% treatment, 50% control (prefixed with "No")
Food <- ifelse(runif(n_subj) > 0.5, Study, paste0("No", Study))
Food <- rep(Food, each = 2)  # Repeat for baseline and end

# Label treatment/control based on "No" prefix
Treatment <- ifelse(grepl("^No", Food), "Control", "Treatment")

# Assign baseline/end labels
BaselineEnd <- rep(c("baseline", "end"), times = n_subj)

# ---- Study × Treatment-specific shape parameters for gamma sampling ----
# We simulate compositional differences using gamma-distributed feature abundances
# Each food has different microbial profiles for treatment and control groups

shape_map <- list()
for (food in food_names) {
  base_shape <- runif(n_features, min = 0.5, max = 1.5)           # Base shape per feature
  treat_shift <- rnorm(n_features, mean = 0.2, sd = 0.05)         # Up-regulation for treatment
  control_shift <- rnorm(n_features, mean = 0.0, sd = 0.05)       # Slight random noise for control
  
  # Ensure all shapes are positive
  shape_map[[food]] <- list(
    Treatment = abs(base_shape + treat_shift),
    Control   = abs(base_shape + control_shift)
  )
}

# ---- Function to generate one microbiome abundance row ----
# For a given subject's food and treatment status,
# sample feature abundances from gamma(shape), normalize to sum to 1 (compositional),
# threshold values < detect_thresh to 0 (simulate detection limit), then re-normalize

generate_row <- function(food, treat_status, n_feat, threshold) {
  clean_food <- gsub("^No", "", food)  # Remove "No" prefix if present
  shape_vec <- shape_map[[clean_food]][[treat_status]]  # Get correct shape vector
  
  x <- rgamma(n_feat, shape = shape_vec, scale = 1)  # Sample from gamma distribution
  x <- x / sum(x)                                    # Normalize to compositional (sum to 1)
  x[x < threshold] <- 0                              # Zero-out undetectable features
  
  total <- sum(x)
  if (total == 0) {
    x <- rep(1 / n_feat, n_feat)  # Fallback: use uniform distribution if all values were dropped
  } else {
    x <- x / total  # Re-normalize after thresholding
  }
  
  return(x)
}

# ---- Generate the full feature matrix ----
# Loop through all samples and generate corresponding microbial profile
feature_matrix <- mapply(generate_row, Food, Treatment,
                         MoreArgs = list(n_feat = n_features, threshold = detect_thresh),
                         SIMPLIFY = "array")
feature_matrix <- t(feature_matrix)  # Transpose to put samples in rows

# Assign feature names (SV_F_16S_xxx format)
colnames(feature_matrix) <- paste0("SV_F_16S_", sprintf("Feature__%03d__", 1:n_features))

# ---- Combine metadata and feature matrix into final dataset ----
dat_dummy <- data.frame(
  SubjectID = as.factor(SubjectID),
  Study = as.factor(Study),
  Food = as.factor(Food),
  Period = as.factor(Period),
  Treatment = as.factor(Treatment),
  BaselineEnd = as.factor(BaselineEnd)
)
dat_dummy <- cbind(dat_dummy, feature_matrix)

# Reset row names to 1:n for clarity
row.names(dat_dummy) <- 1:nrow(dat_dummy)

# ---- Sanity check and summary output ----
# Report percentage of zeroed (undetectable) values
cat(sprintf("Proportion of values < %.0e (zeroed): %.2f%%\n",
            detect_thresh,
            mean(dat_dummy[, 8:ncol(dat_dummy)] < detect_thresh) * 100))

# View first few rows (optional)
head(dat_dummy)

# ---- Export to CSV ----
write.csv(dat_dummy, "dummy_microbiome_data.csv", row.names = FALSE)
