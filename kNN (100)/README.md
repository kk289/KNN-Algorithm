Consider the training and test data: Training-data.csv and Test-data.csv, respectively, for a classification problem with two classes.

There are two separate variables x1 and x2 using classification algorithm kNN.

1. Fit KNN with K = 1,2,...,30,35,...,100.
  - (From Line 75 to 95 (kNN(100).R))
  
2. Plot training and test error rates against K. Explain what you observe. Is it consistent with what you expect from the class?
  - (From Line 97 to 104 (kNN(100).R))
  - From following figure, As K size increases model becomes less flexible and at last it becomes inflexibles as large K. 
  - Training MSE is very low and Test MSE is very high for high flexible mdoel i.e. K = 1, as shows in graph (Rplot04)
  - As the flexibility decreases (K increases), Training MSE goes towards Zero and Test MSE becomes minimum and increases again with U-shaped curve as shown in figure as a flatted U-shaped curve (Rplot04).
  - Test MSE is U-shaped curve due to tradeoff between Bias and Variance
  - Test MSE is minimum at K = 80 and K = 100.
  - We can choose less flexible models if both have same Test MSE.
  
3. What is the optimal value of K? What are the training and test error rates associated with the optimal K?
  - (From Line 105 to 109 (kNN(100).R))
  - Better to choose less flexible model. 
  - Pick K = 100.
  - Optimal Value of K is 100
  - Training Error Rate is 0.162
  - Test Error Rate is 0.168
  
4. Make a plot of the training data that also shows the decision boundary for the optimal K. Comment on what you observe. Does the decision boundary seem sensible?
  - (From Line 111 to 129 (kNN(100).R))
  - From Figure (Rplot05), the BLACK Curve in circle of RED and GREEN shows the decision boundry for GREEN (i.e. YES) and RED (i.e. NO).
  - It is observed that some RED and some GREEN are misclassified with TEST ERROR RATE 16.8%.
