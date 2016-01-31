library(shiny)

# Define UI for random distribution application 
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("NFL Position Predictor App", 
            HTML('<style type="text/css">
            .row-fluid .span4{width: 66%;}
            </style>')),

  # Sidebar with controls to select the physical attributes
 
  # Sidebar with sliders
  sidebarPanel(
    # help text 
	helpText('Use the sliders below to select new attributes.'),

    # Offense slider
    sliderInput("offense", "1 = Offense, 0 = Defense",
                  min=0, max=1, value=1, step=1),

    # Weight slider
    sliderInput("weight", "Weight in Pounds",
                  min=190, max=290, value=240, step=10),

    # Height slider
    sliderInput("heightinchestotal", "Height in Inches",
                  min=66, max=82, value=74, step=2),

    # Forty yard slider
    sliderInput("fortyyd", "Forty Yard Dash Time in Seconds",
                  min=4.3, max=5, value=4.5, step=0.1),

	br(), 
	# help text 
	helpText("Press the 'Update Attributes' button to submit the new player attributes."),
	
	submitButton("Update Attributes"),
	
	br(),
	
	# help text 
	helpText("The purpose of this app is to use physical attributes of potential NFL draftees along with a binary Offense/Defense value to predict the position of a given player. Use the tabs to view predicted position and values, a reactive decision tree and a summary of the attributes of all players in the predicted position."),
      helpText("Position Key:"), 
      helpText("DB = Defensive back"),
      helpText("DL = Defensive Lineman"),
      helpText("LB = Linebacker"),
      helpText("OL = Offensive Lineman"),
      helpText("QB = Quarterback"),
      helpText("RB = Running Back"),
      helpText("TE = Tight End"),
      helpText("WR = Wide Receiver")
  ),
  
  # Show a tabset that includes input values and prediction, decision tree, and summary
  
  mainPanel(
    tabsetPanel(
		tabPanel("Input Values", h3(textOutput("caption")), br(),tableOutput("values")),
		tabPanel("Decision Tree", plotOutput("tree")),
		tabPanel("Summary", verbatimTextOutput("summary")) 
    )
  )
))