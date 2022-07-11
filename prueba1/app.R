library(shiny)
library(stringr)
library(openxlsx)
library(writexl)

ui <- fluidPage(
    titlePanel("Subida documentos"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Csv o Excel",
                      multiple = TRUE,
                      accept = c(".csv", ".xlsx")),
            downloadButton("downloadData", "Download")
        ),
        mainPanel(
            tableOutput("contents")
        )
    )
)

server <- function(input, output) {
    
    exportar <- reactive({
        
    })
    
    output$contents <- renderTable({
        
        req(input$file1)
        
        ext <- input$file1$datapath
        ext <- str_remove(ext, ".*/0.")
        
        if(ext == "xlsx")
        {
            df <- read.xlsx(input$file1$datapath)
        }else{
            df <- read.csv(input$file1$datapath, header = TRUE)
        }
        df <- df |> 
            mutate(definitiva = mean('Nota1', 'Nota2', 'Nota3'))
    })
    
    output$downloadData <- downloadHandler(
        filename = "prueba.xlsx",
        content = function(file) {
            write_xlsx(exportar(), file)
        }
    )
    
}

shinyApp(ui, server)