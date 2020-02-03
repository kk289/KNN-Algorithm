library(class)
library(gmodels)

# Topic: Machine Learning Using KNN (k-Nearest neighbours test)
# Dataset: Prostate Cancer

# Load the dataset
pro_can <- read.csv("Prostate_Cancer.csv",stringsAsFactors = FALSE)
View(pro_can)

pro_can<-pro_can[-1]

head(pro_can)

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }

pro_can_n <- as.data.frame(lapply(pro_can[2:9], normalize))

summary(pro_can_n$radius)

# Training data
pro_can_train <- pro_can_n[1:65,]

# Test data
pro_can_test <- pro_can_n[66:100,]

# Training labels
pro_can_train_labels <- pro_can[1:65, 1]

# Test Labels
pro_can_test_labels <- pro_can[66:100, 1]

# Prostate Cancer Test Prediction
pro_can_test_pred <- knn(train = pro_can_train, test = pro_can_test,cl = pro_can_train_labels, k=3)

# CrossTable View
CrossTable(x=pro_can_test_labels, y=pro_can_test_pred, prop.chisq = FALSE)
