
library(shiny)
library(caret)
library(randomForest)
library(gbm)
library(reshape2)


shinyServer(function(input, output) {
  data(ToothGrowth)
  rnd <- 54321
  df <- ToothGrowth

  ActualTesting <- reactive ({
    set.seed(rnd)
    inTrain <- createDataPartition(y = df$len, p = input$slider1, list = FALSE)
    training <- df[inTrain,]
    testing <- df[-inTrain,]
    
    training <- training[with(training, order(len)),]
    training$record <- seq_along(along.with = training$len)
    
    testing <- testing[with(testing, order(len)),]
    testing$record <- seq_along(along.with = testing$len)
    data.frame("Record" = testing$record, "Actual" = testing$len)
  })
  
  rfModel <- reactive({
    set.seed(rnd)
    inTrain <- createDataPartition(y = df$len, p = input$slider1, list = FALSE)
    training <- df[inTrain,]
    training <- training[with(training, order(len)),]
    train(len ~., data = training, method = "rf")
  })
  
  lmModel <- reactive({
    set.seed(rnd)
    inTrain <- createDataPartition(y = df$len, p = input$slider1, list = FALSE)
    training <- df[inTrain,]
    training <- training[with(training, order(len)),]
    train(len ~., data = training, method = "lm")    
  })
  
  gbmModel <- reactive({
    set.seed(rnd)
    inTrain <- createDataPartition(y = df$len, p = input$slider1, list = FALSE)
    training <- df[inTrain,]
    training <- training[with(training, order(len)),]
    train(len ~., data = training, method = "gbm")    
  })
  
  output$testingPlot <- renderPlot({
    set.seed(rnd)
    inTrain <- createDataPartition(y = df$len, p = input$slider1, list = FALSE)
    training <- df[inTrain,]
    testing <- df[-inTrain,]
    training <- training[with(training, order(len)),]
    training$record <- seq_along(along.with = training$len)
    testing <- testing[with(testing, order(len)),]
    testing$record <- seq_along(along.with = testing$len)
    
    
    rfPredict <- predict(rfModel(), newdata = testing)
    lmPredict <- predict(lmModel(), newdata = testing)
    gbmPredict <- predict(gbmModel(), newdata = testing)
    plot(ActualTesting()$Record, ActualTesting()$Actual, xlab = "Record", ylab = "Actual", main = "Testing Set Results")
    lines(ActualTesting()$Record, ActualTesting()$Actual, col = "red")
    
    if(input$showRF) {
      points(x = ActualTesting()$Record, y = rfPredict)
      lines(x = ActualTesting()$Record, y = rfPredict, col = "blue")
    }
    
    if(input$showLM) {
      points(x = ActualTesting()$Record, y = lmPredict)
      lines(x = ActualTesting()$Record, y = lmPredict, col = "green")
    }
    
    if(input$showBoost) {
      points(x = ActualTesting()$Record, y = gbmPredict)
      lines(x = ActualTesting()$Record, y = gbmPredict, col = "black")
    }
    legend(x = "topleft", legend = c("Actual", "RF", "LM", "GBM"), lwd = c(1,1,1,1), col = c("red", "blue", "green", "black"))
  })
    
  output$text1 <- renderText({
    if (input$showRF) {
      paste0("Testing Set Random Forest Mean Squared Error = ", round(rfModel()$results[[2]], digits = 2))
    }
  })
  
  output$text2 <- renderText({
    if (input$showLM) {
      paste0("Testing Set Linear Model Mean Squared Error = ", round(lmModel()$results[[2]], digits = 2))
    }
  })
  
  output$text3 <- renderText({
    if (input$showBoost) {
      paste0("Testing Set Boosting Model Mean Squared Error = ", round(min(gbmModel()$results[[5]]), digits = 2))
    }
  })
})
