library(shiny)
library(shinydashboard)
library(highcharter)
library(readxl)
library(shinyFeedback)
library(glue)
library(rlist)
library(tidyverse)
library(dplyr)



source('download_emae.R')




interanual <-    function(df, val)  {
    valueuno = pull((df[,c(val)]))[nrow(df) - 12]
    valuedos = pull((df[,c(val)]))[nrow(df)]
    porcentaje = round(((valuedos - valueuno) / valueuno ) * 100,1)
    return(porcentaje)
}


most_interanual = function(df){
    
    col_names = colnames(df)[1:16]
    counter = 0
    values = c()
    names = c()
    
    for (col in col_names){
        counter = counter + 1
        valueuno = pull((df[,c(col)]))[nrow(df) - 12]
        valuedos = pull((df[,c(col)]))[nrow(df)]
        porcentaje = round(((valuedos - valueuno) / valueuno ) * 100,1)
        
        values[counter] <- porcentaje
        names[counter] <- col
    }
    
    dtf = data.frame(names,values)
    return(dtf)
    
}







valueBoxSpark <- function(value, title, sparkobj = NULL, subtitle, info = NULL, 
                          icon = NULL, color = "aqua", width = 4, href = NULL){
    
    shinydashboard:::validateColor(color)
    
    if (!is.null(icon))
        shinydashboard:::tagAssert(icon, type = "i")
    
    info_icon <- tags$small(
        tags$i(
            class = "fa fa-info-circle fa-lg",
            title = info,
            `data-toggle` = "tooltip",
            style = "color: rgba(255, 255, 255, 0.75);"
        ),
        class = "pull-right float-right"
    )
    
    boxContent <- div(
        class = paste0("small-box bg-", color),
        div(
            class = "inner",
            tags$small(title),
            if (!is.null(sparkobj)) info_icon,
            h3(value),
            if (!is.null(sparkobj)) sparkobj,
            p(subtitle)
        ),
        if (!is.null(icon)) div(class = "icon-large icon", icon, style = "z-index; 0")
    )
    
    if (!is.null(href)) 
        boxContent <- a(href = href, boxContent)
    
    div(
        class = if (!is.null(width)) paste0("col-sm-", width), 
        boxContent
    )
}


ui <- dashboardPage(
    skin = "blue",
    dashboardHeader(
        title = "EMAE - Argentina",
        titleWidth = 200,
        tags$li(
            a('Indec Page',
                href = 'https://www.indec.gob.ar/',
                icon("database"),
                title = "Indec Page"),
            class = "dropdown")),
    dashboardSidebar(tags$head(tags$style(".wrapper {overflow: visible !important;}")),
        tags$head(
            tags$link(
                rel = "stylesheet", 
                type = "text/css", 
                href = "styles.css")), 
        collapsed = F,
        width = 200,
        sidebarMenu(
            menuItem("Panel Principal",
                     tabName = "panelprincipal",
                     startExpanded = T,
                     icon = icon("chart-line")),
            # Rubros ---------------------------------------------------------
            
            menuItem("Sectores",
                     tabName = "acercade",
                     startExpanded = T,
                     icon = icon("arrows-alt-v"),
                     selectInput(
                         inputId = 'yvalue',
                         label = tags$strong('Variable Y'),
                         choices = gsub("_", " ", sort(names(dataframe[,c(1:16)]))), 
                         selected = "Educacion")
                     
            ),
            
            # Resumen ---------------------------------------------------------
            
            
            
            menuItem("Ficha Tecnica",
                     tabName = "fichatecnica",
                     startExpanded = T,
                     icon = icon("table")))),
    dashboardBody(
        tabItems(
            tabItem(tabName = "panelprincipal",
                    div(p(strong(h2("Estimador Mensual de la Actividad Economica - Argentina, Indec.")))),
                    div(p(strong(paste0("Ultima Actualizacion: ", Sys.time())))),

                    
                    fluidRow(
                        valueBoxOutput("vbox", width = 4),
                        valueBoxOutput("vbox2", width = 4),
                        valueBoxOutput("vbox3", width = 4)),
                    fluidRow(
                        box(
                            highchartOutput("chart1"),
                            width = 7),
                        box(highchartOutput("chart2"),
                            width = 5))
            ),
            tabItem(tabName = 'fichatecnica',
                    div(p(strong(h3("Estimador Mensual de la Actividad Economica - Argentina, Indec.")))),
                    div(p(strong(paste0("Ultima Actualizacion: ", Sys.Date())))))
        )
    )
)







server <- shinyServer(function(input, output, session) {
    
    output$vbox <- renderValueBox({
        
        yvar <- input$yvalue
        
        interanual_value = interanual(dataframe, input$yvalue)
        
        hc <- hchart(dataframe, "area", hcaes(x = as.Date(periodos), 
                                       y = !!sym(yvar)), name = "lines of code")  %>% 
            hc_size(height = 100) %>% 
            hc_credits(enabled = FALSE) %>% 
            hc_add_theme(hc_theme_sparkline_vb()) 
        
        valueBoxSpark(
            value = glue::glue("{interanual_value} %"),
            title = toupper(glue::glue("{input$yvalue}")),
            sparkobj = hc,
            subtitle = tagList(HTML("&uarr;"), glue::glue("{interanual_value} % Variacion Interanual.")),
            info = paste0('Serie Temporal de Area de la variable ',input$yvalue,'.','Hay una Variacion Interanual de ',interanual_value),
            icon = NULL,
            width = 4,
            color = "yellow",
            href = NULL
        )
        
        
    })
    
    output$vbox2 <- renderValueBox({
        
        
        dtf = most_interanual(dataframe)
        
        
        most_name = dtf[order(-dtf$values),]$names[1]
        most_value = dtf[order(-dtf$values),]$values[1]

        
        
        hc2 <- hchart(dataframe, "line", hcaes(x = as.Date(periodos), y = !!sym(most_name)), name = "Mayor Interanual")  %>% 
            hc_size(height = 100) %>% 
            hc_credits(enabled = FALSE) %>% 
            hc_add_theme(hc_theme_sparkline_vb()) 
        
        valueBoxSpark(
            value = glue::glue("{most_value} %"),
            title = toupper(glue::glue("{most_name}")),
            sparkobj = hc2,
            subtitle = tagList(HTML("&uarr;"), glue::glue("{most_value} % Mayor Variacion Interanual.")),
            info = paste0('Serie Temporal de Linea de la variable ',most_name,'.','Hay una Variacion Interanual de ',most_value),
            icon = NULL,
            width = 4,
            color = "maroon",
            href = NULL
        )
        
    })
    
    output$vbox3 <- renderValueBox({
        
        
        dtfs = most_interanual(dataframe)

        min_name = dtfs[order(dtfs$values),]$names[1]
        min_value = dtfs[order(dtfs$values),]$values[1]
        
        
        
        
        hc3 <- hchart(dataframe, "line", hcaes(x = as.Date(periodos), y = !!sym(min_name)), name = "Menor Interanual")  %>% 
            hc_size(height = 100) %>% 
            hc_credits(enabled = FALSE) %>% 
            hc_add_theme(hc_theme_sparkline_vb())
        
        valueBoxSpark(
            value = glue::glue("{min_value} %"),
            title = toupper(glue::glue("{min_name}")),
            sparkobj = hc3,
            subtitle = tagList(HTML("&uarr;"), glue::glue("{min_value} % Menor Variacion Interanual.")),
            info = paste0('Serie Temporal de Linea de la variable ',min_name,'.','Hay una Variacion Interanual de ',min_value),
            icon = NULL,
            width = 4,
            color = "red",
            href = NULL
        )
        
        
    })
    
    
    output$chart1 <- renderHighchart({
        
        
        
        yvard = input$yvalue
        
        highcharter::hchart(
            dataframe, type = "line",  highcharter::hcaes(x = as.Date(periodos), 
                                                          y = !!sym(yvard)),
            color = "rgba(29, 53, 87, 1)",
            name = yvard, 
            id = "trend",
            showInLegend = TRUE) %>%
            highcharter::hc_tooltip(crosshairs = TRUE, pointFormat = "Base: {point.y}") %>%
            
            highcharter::hc_plotOptions(
                line = list(
                    color = "blue",
                    marker = list(
                        fillColor = "white",
                        lineWidth = 2,
                        radius=1,
                        lineColor = NULL
                    )
                )
            ) %>%
            highcharter::hc_legend(
                layout = "vertical",
                verticalAlign = "top",
                align = "right",
                floating = TRUE
            ) %>%
            highcharter::hc_xAxis(
                title = list(text = ""),
                gridLineWidth = 0,
                dateTimeLabelFormats = list(day = '%d/%m/%Y'),
                type = "datetime",
                reversed = FALSE
            ) %>%
            highcharter::hc_yAxis(
                title = list(text = ""),
                gridLineWidth = 0,
                reversed = FALSE
            ) %>%

            highcharter::hc_caption(
                text = paste0("Serie Temporal de ",input$yvalue, ". Año Base Enero 2004. <br>Fuente: Indec.")) %>%
            highcharter::hc_tooltip(
                crosshairs = TRUE,
                backgroundColor = "#F0F0F0",
                shared = TRUE, 
                borderWidth = 5
            ) 

        
    })
    

    output$chart2 <- renderHighchart({
        

        dtfa = most_interanual(dataframe)
        
        dtfa %>% 
            arrange(desc(values)) %>% 
            hchart('column', hcaes(x = names, y = values),
                   showInLegend = F,
                   maxSize = "15%",
                   dataLabels = list(enabled = TRUE,
                                     format = '{point.y} %')) %>% 
            hc_colorAxis(stops = color_stops(18, rev(RColorBrewer::brewer.pal(8, 'Set1'))))  %>%
            hc_legend(enabled = FALSE) %>% 
            highcharter::hc_plotOptions(
                line = list(
                    color = "blue",
                    marker = list(
                        fillColor = "white",
                        lineWidth = 2,
                        radius = 1,
                        lineColor = NULL
                    )
                )
            ) %>% 
            highcharter::hc_tooltip(crosshairs = TRUE, 
                                    pointFormat = "Variacion: {point.y} %",
                                    backgroundColor = "#F0F0F0",
                                    shared = TRUE, 
                                    borderWidth = 5) %>% 
            highcharter::hc_caption(
                text = paste0("Variacion Interanual. Año Base Enero 2004. <br>Fuente: Indec.")) %>% 
            highcharter::hc_xAxis(
                title = list(text = " "),
                gridLineWidth = 0,
                reversed = FALSE
            ) %>%
            highcharter::hc_yAxis(
                title = list(text = " "),
                gridLineWidth = 0,
                reversed = FALSE
            ) 
        
        
        
        
    })
    
    observeEvent(input$yvalue, {
        showNotification(glue::glue("{input$yvalue}"), type = "message")
        Sys.sleep(0.2)
    })
    
    
    
})




shinyApp(ui = ui, server = server)
