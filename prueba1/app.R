library(shiny)
library(stringr)
library(openxlsx)
library(writexl)
library(tidyverse)
library(ggplot2)

ui <- fluidPage(
    titlePanel("ShinyApps"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Csv o Excel",
                      multiple = TRUE,
                      accept = c(".csv", ".xlsx")),
            downloadButton("downloadData", "Download")
        ),
        mainPanel(
            tableOutput("contents"),
            plotOutput("fig")
        )
    )
)

server <- function(input, output) {
    
    exportar <- reactive({
    
        req(input$file)
        
        ext <- input$file$datapath
        ext <- str_remove(ext, ".*/0.")
        
        if(ext == "xlsx")
        {
            df <- read.xlsx(input$file$datapath)
        }else{
            df <- read.csv(input$file$datapath, header = TRUE, sep = ";")
        }
        
        df$definitiva = rowMeans(df[2:4])
        #ganaron <- df |> filter(definitiva >= 3)
        #ganaron
        df
    })
    
    output$contents <- renderTable(
        df <- exportar()
    )
    
    
    output$downloadData <- downloadHandler(
        filename = "prueba.xlsx",
        content = function(file) {
            write_xlsx(exportar(), file)
        }
    )
    
    output$fig <- renderPlot(
       ggplot(data = exportar(), aes(ID, definitiva))+
           geom_point()
    )
    
}

shinyApp(ui, server)