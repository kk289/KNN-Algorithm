library(tidyverse)
library(class)
library(GGally)
library(caret)
set.seed(170030)
getwd()

# Loading Training data and Test data
train_data <- read.csv("Training_data.csv")
test_data<- read.csv("Test_data.csv")

# View of Training and Test data
str(train_data)
str(test_data)

# Scatterplot matrix of training data
pairs(train_data)
ggpairs(train_data)
# Directly accesing column names without using $sign

# Correlations between predictors
train_data %>%
  keep(is.numeric)%>%
  cor(.)%>%
  as.data.frame()
# View
cor(train_data[,-3])
attach(train_data)

# Combining predictors of training datasets.
train_data.x = cbind(x.1,x.2)

# Response variable for training datasets
train_data.y = y

# Viewing top 6 rows of combined predictors
head(train_data.x)

# Viewing response variable for training datasets
head(train_data.y)
dim(train_data.x)

# Scatterplots between two predictors
plot(train_data.x, xlab = "x.1", ylab = "x.2", col = ifelse(train_data.y == "yes", "green", "blue"))

ggplot(train_data, aes(x=x.1, y=x.2,shape=y, color=y))+ geom_point()+ theme_classic()

# For not using $sign to access column
attach(test_data)

test_data.x = cbind(x.1,x.2)
dim(test_data.x)
test_data.y = y

head(test_data.y)
table(test_data.y)

# Apply KNN
# K = 1

# For Training data
mod.train <- knn(train_data.x, train_data.x, train_data.y, k = 1)
# confusion matrix
table(mod.train, train_data.y)
# Error rate
1 - sum(mod.train == train_data.y)/length(train_data.y)

# For Test data
mod.test <- knn(train_data.x, test_data.x, train_data.y, k = 1)
# confusion matrix for test data
table(mod.test, test_data.y)
# Error rate 
1 - sum(mod.test == test_data.y)/length(test_data.y)

# Fit KNN for several values of K
ks <- c(seq(1, 30, by = 1), seq(35, 100, by = 5))
nks <- length(ks)
nks

err.rate.train <- numeric(length = nks)
err.rate.train

err.rate.test <- numeric(length = nks)
err.rate.test

names(err.rate.train) <- names(err.rate.test) <- ks

for (i in seq(along = ks)) {
  set.seed(170030)
  mod.train <- knn(train_data.x, train_data.x, train_data.y, k = ks[i])
  set.seed(170030)
  mod.test <- knn(train_data.x, test_data.x, train_data.y, k = ks[i])
  err.rate.train[i] <- 1 - sum(mod.train == train_data.y)/length(train_data.y)
  err.rate.test[i] <- 1 - sum(mod.test == test_data.y)/length(test_data.y)
}

# Codes for plotting train and test error
plot(ks, err.rate.train, xlab = "Number of nearest neighbors", ylab = "Error rate", 
     type = "b", ylim = range(c(err.rate.train, err.rate.test)), col = "blue", pch = 20)

lines(ks, err.rate.test, type="b", col="purple", pch = 20)

legend("bottomright", lty = 1, col = c("blue", "purple"), legend = c("training", "test"))

# Optimal value of K and training and test error rates associated it. 
result <- data.frame(ks, err.rate.train, err.rate.test)
View(result)

result[err.rate.test == min(result$err.rate.test), ]

# Decision boundary for optimal K (not very informative here)
n.grid <- 50
x1.grid <- seq(f = min(train_data.x[, 1]), t = max(train_data.x[, 1]), l = n.grid)
x2.grid <- seq(f = min(train_data.x[, 2]), t = max(train_data.x[, 2]), l = n.grid)
grid <- expand.grid(x1.grid, x2.grid)

# Minimum test MSE from plot is 100
k.opt <- 100
set.seed(170030)

mod.opt <- knn(train_data.x, grid, train_data.y, k = k.opt, prob = T)

prob <- attr(mod.opt, "prob") # prob is voting fraction for winning class
prob <- ifelse(mod.opt == "yes", prob, 1 - prob) # now it is voting fraction for Direction == "yes"
prob <- matrix(prob, n.grid, n.grid)

plot(train_data.x,main="Plots with Decision Boundary for K=100", col = ifelse(train_data.y == "yes", "green", "red"))
contour(x1.grid, x2.grid, prob, levels = 0.5, labels = "", xlab = "", ylab = "", main = "", add = T)
legend("topright",col=c("green","red"),legend=c("Yes","no"),bty="n",pch=c(16,17))

# Decision plot using Decision function
decisionplot <- function(model, data, class = NULL, predict_type = "class",resolution = 100, showgrid = TRUE, ...)
{
  if(!is.null(class)) cl <- data[,class] else cl <- 1
  data <- data[,1:2]
  k <- length(unique(cl))
  
  plot(data, col = as.integer(cl)+1L, pch = as.integer(cl)+1L, ...)
  
  # make grid
  r <- sapply(data, range, na.rm = TRUE)
  xs <- seq(r[1,1], r[2,1], length.out = resolution)
  ys <- seq(r[1,2], r[2,2], length.out = resolution)
  g <- cbind(rep(xs, each=resolution), rep(ys, time = resolution))
  colnames(g) <- colnames(r)
  g <- as.data.frame(g)
  
  ### guess how to get class labels from predict
  ### (unfortunately not very consistent between models)
  p <- predict(model, g, type = predict_type)
  if(is.list(p)) p <- p$class
  p <- as.factor(p)
  
  if(showgrid) points(g, col = as.integer(p)+1L, pch = ".")
  
  z <- matrix(as.integer(p), nrow = resolution, byrow = TRUE)
  contour(xs, ys, z, add = TRUE, drawlabels = FALSE,
          lwd = 2, levels = (1:(k-1))+.5)
  
  invisible(z)
}

model <- knn3(y ~ ., data=train_data, k = 100)

decisionplot(model, train_data, class = "y", main = "kNN (100)")
