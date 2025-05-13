library(shiny)
library(openxlsx)
library(DT)

ui <- fluidPage(
  titlePanel("Food Exposure Calculator"),
  
  tabsetPanel(
    tabPanel("Contaminants",
             sidebarLayout(
               sidebarPanel(
                 width = 3,
                 textInput("contaminant", "Contaminant Name:", value = "Example Contaminant", width = "100%"),
                 tags$div(style = "display:none;",

                 ),
                 fileInput("file_upload", "Or upload an Excel file:", accept = ".xlsx"),
                 uiOutput("food_ui"),
                 uiOutput("consumption_ui"),
                 
                 conditionalPanel(
                   condition = "input.food_item == 'Other'",
                   textInput("other_item", "Enter other food item name:", value = "", width = "100%"),
                   numericInput("other_consumption", "Enter consumption for other item (g/day):", value = 0, min = 0)
                 ),
                 
                 numericInput("concentration", "Contaminant concentration (mg):", value = 50, min = 0),
                 numericInput("bodyweight", "Body Weight (kg):", value = 70, min = 1),
                 
                 radioButtons("ref_type", "Select Reference Type:",
                              choices = c("BMDL", "HBGV"), selected = "HBGV"),
                 
                 conditionalPanel(
                   condition = "input.ref_type == 'HBGV'",
                   numericInput("hbgv", "HBGV value (mg/kg bw/day):", value = 1, min = 0)
                 ),
                 
                 conditionalPanel(
                   condition = "input.ref_type == 'BMDL'",
                   numericInput("bmdl", "BMDL value (mg/kg bw/day):", value = 100, min = 0)
                 ),
                 
                 actionButton("add_btn", "Calculate Exposure", class = "btn-primary"),
                 br(), br(),
                 downloadButton("download_excel", "Download Final Report")
               ),
               
               mainPanel(
                 width = 9,
                 tags$div(style = "text-align: center;",
                          h4("Exposure and Risk Calculation Table", style = "display: inline;"),
                          actionButton("clear_btn", "Clear Table", class = "btn-success", style = "margin-left: 10px;")
                 ),
                 dataTableOutput("report_table")
               )
             )),
    
    tabPanel("Isotopes",
             sidebarLayout(
               sidebarPanel(
                 width = 3,
                 textInput("isotope_name", "Isotope Name:", value = "Example Isotope", width = "100%"),
                 tags$div(style = "display:none;",
        
                 ),
                 fileInput("iso_file_upload", "Upload Excel File", accept = ".xlsx"),
                 uiOutput("iso_food_ui"),
                 uiOutput("iso_consumption_ui"),
                 
                 conditionalPanel(
                   condition = "input.iso_food_item == 'Other'",
                   textInput("iso_other_item", "Enter other food item name:", value = "", width = "100%"),
                   numericInput("iso_other_consumption", "Enter consumption for other item (g/day):", value = 0, min = 0)
                 ),
                 
                 numericInput("iso_concentration", "Isotope concentration (Bq/kg):", value = 100, min = 0),
                 numericInput("effective_dose", "Effective dose per unit intake (mSv/Bq):", value = 0.0001, min = 0),
                 
                 actionButton("add_iso_btn", "Calculate Exposure", class = "btn-primary"),
                 br(), br(),
                 downloadButton("download_iso_excel", "Download Isotope Report")
               ),
               mainPanel(
                 width = 9,
                 tags$div(style = "text-align: center;",
                          h4("Isotope Exposure Table", style = "display: inline;"),
                          actionButton("clear_iso_btn", "Clear Table", class = "btn-success", style = "margin-left: 10px;")
                 ),
                 dataTableOutput("iso_table")
               )
             )),
    
    tabPanel("History",
             mainPanel(
               width = 12,
               h4("Action History"),
               dataTableOutput("history_table")
             )),
    
    tabPanel("Sources",
             mainPanel(
               width = 12,
               h4("Scientific and Regulatory Sources"),
               tags$ul(
                 tags$li(a(href = "https://apps.who.int/food-additives-contaminants-jecfa-database/", target = "_blank", "JECFA: WHO Food Additives and Contaminants Database")),
                 tags$li(a(href = "https://apps.who.int/pesticide-residues-jmpr-database/", target = "_blank", "JMPR: WHO Pesticide Residue Database")),
                 tags$li(a(href = "https://iris.epa.gov/AtoZ/?list_type=alpha", target = "_blank", "EPA IRIS: Integrated Risk Information System")),
                 tags$li(a(href = "https://www.icrp.org/docs/p%20119%20jaicrp%2041(s)%20compendium%20of%20dose%20coefficients%20based%20on%20icrp%20publication%2060.pdf", target = "_blank", "ICRP: Dose Coefficients from Publication 60"))
               )
             ))
  )
)


shinyApp(ui, server)
