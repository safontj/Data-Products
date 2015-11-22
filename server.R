library(shiny)
library(ggplot2)

adjTH <- function(TH1,PA1){
# adjusts thaco (ability to hit) with power attack
  TH1-PA1  
}

probHit <- function(TH1,PA1,AC){
# calculates probability to hit, considering power attack and opponent's armor class
  
  Thaco <- TH1-PA1
  toHit <- AC - Thaco
  
# roll of 1 always misses
  if (toHit <= 1){
    probHit = 19/20
  } 

# roll of 20 always hits
  else if (toHit >= 20){
    probHit = 1/20
  }
  else{
    probHit = (21-toHit)/20  
  }
  probHit
}

avgDmg <- function(th,pa,dmg){
# avg damage to be printed for ACs between 0 and 30
  
  acs <- c(0:30)
  avgDmg <- c(0:30)
  for (i in acs){
    p <- probHit(th,pa,i)
    avgDmg[i+1]<- p*(dmg+pa)
      
  }
  avgDmg
  
}


best <- function(th,ac,dmg){
#lowest Power Attack dealing maximum avg damage per hit
  pas <- c(-10:10)
  paDmg <- c(-10:10)
  for (i in 1:length(pas)){
    p <- probHit(th,pas[i],ac)
    paDmg[i]<- p*(dmg+pas[i])
    
  }
  j <- which.max(paDmg)
  best <- c(pas[j],paDmg[j])
  best
  
}


rounds <-function(hp,dmg){
# rounds to lower Hit Pointes (life) down to 0
  ceiling(hp/dmg)
  
}

result <- function(rd1, rd2){
# expected result of the fight
  if (rd1==rd2){result <- c("Draw")
  }
  else if (rd1>rd2){result <- paste("Foe will win in",rd2,"rounds", sep=" ")}
  
  else {result <- paste("You will win in", rd1,"rounds", sep=" ")}
  
  result
  
}

 
shinyServer(
  function(input, output) {
    
    output$inputValue <- renderPrint({input$PA1})
    output$avgDmg <- renderPlot({
      x <- c(0:30)
      y <- avgDmg(input$TH1,input$PA1,input$DM1)
      plot(x,y,xlab="AC",ylab="Adjusted Avg. Dmg / hit", type="h")
    })
    output$probHit <- renderPrint({probHit(input$TH1,input$PA1,input$AC2)})
    output$probHitFoe <- renderPrint({probHit(input$TH2,0,input$AC1)})
    output$rounds <- renderPrint({rounds(input$HP2,probHit(input$TH1,input$PA1,input$AC2)*(input$DM1+input$PA1))})
    output$adjDmg <- renderPrint({probHit(input$TH1,input$PA1,input$AC2)*(input$DM1+input$PA1)})
    output$adjDmgFoe <- renderPrint({probHit(input$TH2,0,input$AC1)*input$DM2})
    output$result <- renderPrint({result(rounds(input$HP2,probHit(input$TH1,input$PA1,input$AC2)*(input$DM1+input$PA1)),rounds(input$HP1,probHit(input$TH2,0,input$AC1)*input$DM2))})
    output$bestPA <- renderPrint({best(input$TH1,input$AC2,input$DM1)[1]})
    output$bestDmg <- renderPrint({best(input$TH1,input$AC2,input$DM1)[2]})
  
 
  }
)