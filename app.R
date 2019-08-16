### Interactive Product Roadmap
### Stephen Howe
### August 15, 2019

### This RShiny app generates an interactive, JavaScript-based timeline
### in which to view the roadmap for multiple teams.
### Data is sourced from the Excel spreadsheet referenced in the code.

#libraries ----
library(timevis)  # timeline visualization
library(readxl)  # read Excel data
library(shiny)  # build Shiny app

#define CSS styles for roadmap
styles <- "
.vis-item.milestones { background-color: DarkOrange; color: White; }
.vis-item.team_1 { background-color: MidnightBlue; color: White; }
.vis-item.team_2 { background-color: SteelBlue; color: White; }
.vis-item.team_3 { background-color: MediumBlue; color: White; }
.vis-item.team_4 { background-color: CornflowerBlue; }
.vis-item.team_5 { background-color: SkyBlue; }
.vis-item.team_6 { background-color: PowderBlue; }

.vis-labelset .vis-label.milestones { color: Black; }
.vis-labelset .vis-label.team_1 { color: Black; }
.vis-labelset .vis-label.team_2 { color: Black; }
.vis-labelset .vis-label.team_3 { color: Black; }
.vis-labelset .vis-label.team_4 { color: Black; }
.vis-labelset .vis-label.team_5 { color: Black; }
.vis-labelset .vis-label.team_6 { color: Black; }"

# Shiny UI
ui <- fluidPage(
  titlePanel("Cross-Team Product Roadmap"),
  
  sidebarLayout(
    
    sidebarPanel(
      #define input selector
      checkboxGroupInput("group", "Select Product Team(s):",
                         c("Team 1" = "team_1",
                           "Team 2" = "team_2",
                           "Team 3" = "team_3",
                           "Team 4" = "team_4",
                           "Team 5" = "team_5",
                           "Team 6" = "team_6"))
    ),
    
    mainPanel(
      
      #set CSS style
      tags$style(styles, type="text/css"),
      
      #output timeline
      timevisOutput("timeline")
    )
  )

)

server <- function(input, output, session) {
  #get data
  epics <- read_excel(path ="product_roadmap.xlsx",
                         sheet = "Epics")
  milestones <- read_excel(path = "product_roadmap.xlsx",
                           sheet = "Milestones")
  groups <- read_excel(path ="product_roadmap.xlsx",
                       sheet = "Groups")
  
  data = rbind(epics, milestones)
  
  #create timeline output
  output$timeline <- renderTimevis({
    timevis(data = subset(data, data$group %in% input$group | data$group == "milestones"), 
            groups = subset(groups, groups$id %in% input$group | groups$id == "milestones"))
  })
}

shinyApp(ui = ui, server = server)