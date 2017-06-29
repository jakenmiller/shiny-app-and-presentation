

library(shiny)


shinyUI(fluidPage(
  
  titlePanel("Prediction Model Comparison for ToothGrowth Dataset"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Select which predictive models you'd like to test on the ToothGrowth dataset."),
      em("Select a % of the data that you would like in the testing set. Select the predictive models you would like to compare to the actuals. Remember that this is a very limited dataset with just 60 observations. Vary the size of the testing set and compare the results for the different models against the actual testing data. Please be patient, especially on the first load. Each run selects a randomized training and test set."),
      sliderInput("slider1",
                  "% of Data in Training Set",
                  min = 0.7,
                  max = 0.9,
                  value = 0.8),
      checkboxInput("showRF", "Random Forest Model:", value = TRUE),
      checkboxInput("showLM", "Linear Model:", value = TRUE),
      checkboxInput("showBoost", "Boosting Model:", value = TRUE),
      submitButton("Submit")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3("Benchmarking Predictive Model Outputs"),
      plotOutput("testingPlot"),
      textOutput("text1"),
      textOutput("text2"),
      textOutput("text3")
    )
  )
))




