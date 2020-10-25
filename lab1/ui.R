library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  wellPanel(
    
    titlePanel("Temperature"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
      checkboxInput("temperature1", "Bars", value = FALSE)),
  
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
      checkboxInput("temperature2", "Count", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
      checkboxInput("temperature3", "Points", value = FALSE)),
    
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.temperature1 == true",
      plotOutput("temp_bar")
    ),
    conditionalPanel(
      condition = "input.temperature2 == true",
      plotOutput("temp_count")
    ),
    conditionalPanel(
      condition = "input.temperature3 == true",
      plotOutput("temp_point")
    )
    
  ),
  wellPanel(
    
    titlePanel("Dew Point"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("dewpoint1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("dewpoint2", "Count", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("dewpoint3", "Points", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.dewpoint1 == true",
      plotOutput("dewPoint_bar")
    ),
    conditionalPanel(
      condition = "input.dewpoint2 == true",
      plotOutput("dewPoint_count")
    ),
    conditionalPanel(
      condition = "input.dewpoint3 == true",
      plotOutput("dewPoint_point")
    )
  ),
  wellPanel(
    
    titlePanel("Humidity"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("humidity1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("humidity2", "Count", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("humidity3", "Points", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.humidity1 == true",
      plotOutput("humidity_bar")
    ),
    conditionalPanel(
      condition = "input.humidity2 == true",
      plotOutput("humidity_count")
    ),
    conditionalPanel(
      condition = "input.humidity3 == true",
      plotOutput("humidity_point")
    )
    
  ),
  wellPanel(
    
    titlePanel("Wind Speed"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("Windspeed1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("Windspeed2", "Count", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("Windspeed3", "Points", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.Windspeed1 == true",
      plotOutput("windspeed_bar")
    ),
    conditionalPanel(
      condition = "input.Windspeed2 == true",
      plotOutput("windspeed_count")
    ),
    conditionalPanel(
      condition = "input.Windspeed3 == true",
      plotOutput("Windspeed_point")
    )
    
  ),
  wellPanel(
    
    titlePanel("Wind Gust"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("windgust1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("windgust2", "Count", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("windgust3", "Points", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.windgust1 == true",
      plotOutput("windgust_bar")
    ),
    conditionalPanel(
      condition = "input.windgust2 == true",
      plotOutput("windgust_count")
    ),
    conditionalPanel(
      condition = "input.windgust3 == true",
      plotOutput("Windgust_point")
    )
    
  ),
  wellPanel(
    
    titlePanel("Pressure"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("pressure1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("pressure2", "Count", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("pressure3", "Points", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.pressure1 == true",
      plotOutput("pressure_bar")
    ),
    conditionalPanel(
      condition = "input.pressure2 == true",
      plotOutput("pressure_count")
    ),
    conditionalPanel(
      condition = "input.pressure3 == true",
      plotOutput("pressure_point")
    )
    
  ),
  wellPanel(
    
    titlePanel("Wind"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("wind1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("wind2", "Pie", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.wind1 == true",
      plotOutput("wind_bar")
    ),
    conditionalPanel(
      condition = "input.wind2 == true",
      plotOutput("wind_pie")
    )
    
  ),
  wellPanel(
    
    titlePanel("Condition"),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("condition1", "Bars", value = FALSE)),
    
    tags$div(style = "display: inline-block;vertical-align:top; width: 65px;",
             checkboxInput("condition2", "Pie", value = FALSE)),
    
    style = "margin-top: 15px",
    conditionalPanel(
      condition = "input.condition1 == true",
      plotOutput("condition_bar")
    ),
    conditionalPanel(
      condition = "input.condition2 == true",
      plotOutput("condition_pie")
    )
   
  )
)