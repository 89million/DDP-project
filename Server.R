library(shiny)
library(caret)
library(reshape)
library(ggplot2)
library(rpart.plot)
library(rpart)
library(e1071)

# NFL combine data
draftees <<- read.csv("data/NFL-combine.csv")
draftees <- draftees[,2:6]

# Define server logic for Decision Tree prediction application
shinyServer(function(input, output) {
  # Reactive expression to generate the predicted position. 
  sliderValues <- reactive({
    # create data frame
    data.frame(
      Attributes = c("Offense",
               "Weight",
               "Total Height in Inches", 
               "Forty Yard Dash Time"),
      Values = as.character(c(input$offense, 
                             input$weight,
                             input$heightinchestotal,
                             input$fortyyd)), 
      stringsAsFactors=FALSE)
  }) 

  # Show the values using an HTML table
  output$values <- renderTable({
    sliderValues()
  })
  # Create the New Data for the prediction function from the slider input 
  AttributeSelect <- reactive({      
	Newdata <- data.frame(offense = input$offense,
						  weight = input$weight,
						  heightinchestotal = input$heightinchestotal,
						  fortyyd = input$fortyyd)
  })
  
  
  # Generate a plot of the data. 
   output$plot <- renderPlot({
 	modelFit <- rpart(position~., data=draftees)
 	newPred <- predict(modelFit,AttributeSelect(), type='class')
      draftmelt <- melt(draftees, "position") 
 	draftmelt$position <- ifelse(draftmelt$position==newPred, "Classified position", "Other position")
  })

  # Generate a summary of the data
    output$summary <- renderPrint({
      modelFit <- rpart(position~., data=draftees)
	newPred <- predict(modelFit,AttributeSelect(), type='class')
	h2(print("Summary of Attributes of Predicted Position"))
	br()
	br()
	summary(droplevels(draftees[draftees$position == newPred,]))
  })
  # Generate the prediction text caption
  formulaText <- reactive({
	modelFit <- rpart(position~., data=draftees)
	newPred <- predict(modelFit,AttributeSelect(), type='class')
	paste("Based on these measurements, the predicted position is ", newPred)
  })

  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the data. 
  output$tree <- renderPlot({
	modelFit <- rpart(position~., data=draftees)
	newPred <- predict(modelFit,AttributeSelect(), type='class')
	node <- ifelse(newPred=="DB", 4,ifelse(newPred=="DL", 10,ifelse(newPred=="LB", 11,
	      ifelse(newPred=="OL", 6,ifelse(newPred=="QB", 28,ifelse(newPred=="RB", 116,ifelse(newPred=="TE", 15,117)))))))
      # return the given node and all its ancestors (a vector of node numbers)
	path.to.root <- function(node)
	{
	      if(node == 1) # root?
	            node
	      else # recurse, %/% 2 gives the parent of node
	            c(node, path.to.root(node %/% 2))
	}
	nodes <- as.numeric(row.names(modelFit$frame))
	cols <- ifelse(nodes %in% path.to.root(node), "dodgerblue3", "#b7b8b6")
	prp(modelFit, nn=TRUE, col=cols, branch.col=cols, split.col=cols, nn.col=cols)
  })  
})