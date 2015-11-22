library(shiny)
shinyUI(fluidPage(
  
  titlePanel("Power Attack calculator"),
  
  sidebarLayout(
  sidebarPanel(
    h2('Hero player stats'),
    sliderInput('TH1', 'THACO', value=10, min = 1, max = 20,, step = 1,),
    sliderInput('DM1', 'Damage', value=5, min = 1, max = 15,, step = 1,),
    sliderInput('AC1', 'AC', value=10, min = 0, max = 30,, step = 1,),
    sliderInput('HP1', 'HP', value=10, min = 1, max = 50,, step = 1,),
         
    h2('Foe stats'),
    sliderInput('TH2', 'THACO', value=10, min = 1, max = 20,, step = 1,),
    sliderInput('DM2', 'Damage', value=5, min = 1, max = 15,, step = 1,),
    sliderInput('AC2', 'AC', value=10, min = 0, max = 30,, step = 1,),
    sliderInput('HP2', 'HP', value=10, min = 1, max = 50,, step = 1,)
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Calculator",
        h3('Power Attack adjusted Expected Damage'),
        sliderInput('PA1', 'Power Attack',value=0, min=-10, max=10,, step=1,),
        plotOutput("avgDmg"),
        
        h3('Results of prediction'),
        verbatimTextOutput("result"),
    
        h3('Fight analysis'),
    
        h4('You entered Power Attack of:'),
        verbatimTextOutput("inputValue"),
        h4('Which resulted in a probability to hit of '),
        verbatimTextOutput("probHit"),
        h4('and an average damage per round of '),    
        verbatimTextOutput("adjDmg"),
        h4('Your most efficient PA is '),    
        verbatimTextOutput("bestPA"),
        h4('which will deal an average damage of'),
        verbatimTextOutput("bestDmg"),
    
        h4('Your foe will hit you with a probability of '),
        verbatimTextOutput("probHitFoe"),
        h4('and the average damage per round will be '),    
        verbatimTextOutput("adjDmgFoe")
      ),
    
      tabPanel("Instructions",
        includeMarkdown("index.Rmd")
      )         
    )
  )
  )
))