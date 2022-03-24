library(shiny)
library(leaflet)
library(maptools)

species <- readShapePoly("data_0.shp") # extracts data to variable
colours <- c("yellow", "blue", "red", "darkgreen")


# extracting the polygon layers for each category
extinct <- species[species$LEGEND == "Extinct",] 
extant_res <- species[species$LEGEND == "Extant (resident)",]
extant_nb <- species[species$LEGEND == "Extant (non-breeding)",]
possibly_extinct <- species[species$LEGEND == "Possibly Extinct",]

# define UI 
ui <- fluidPage(
  titlePanel("Africa Hooded Vultures Population"), # application title
  mainPanel(
    leafletOutput("my_map")) # drawing the map 
)

# defining server logic
server <- function(input, output, session) {
  output$my_map <- renderLeaflet({
    leaflet(extinct) %>%
      addProviderTiles(providers$Esri.OceanBasemap) %>%
      setView(lng = 20, lat = 0, zoom = 3) %>%
      addLegend(colors = colours, labels = species$LEGEND, title = "Legend")%>% # legend
      addLayersControl(baseGroups = c("Extinct", "Extant"), position = "topleft", options = layersControlOptions(collapsed=F)) %>% # layer control
      
      #ADDING CATEGORIZED POLYGONS
      # extinct
      addPolygons(data=extinct,
                  weight = 1, 
                  color = 'red', 
                  fillColor = 'red',
                  fillOpacity = 0.5, 
                  group = 'Extinct') %>%
      # extant resident
      addPolygons(data= extant_res,
                  weight = 1, 
                  color = 'darkgreen', 
                  fillColor = 'darkgreen',
                  fillOpacity = 0.5, 
                  group = 'Extant') %>%
      # extant non-breeding
      addPolygons(data=extant_nb,
                  weight = 1, 
                  color = 'blue', 
                  fillColor = 'blue',
                  fillOpacity = 0.5, 
                  group = 'Extant') %>%
      # possibly extinct
      addPolygons(data=possibly_extinct,
                  weight = 1, 
                  color = 'yellow', 
                  fillColor = 'yellow',
                  fillOpacity = 0.5, 
                  group = 'Extinct')
  })
}

# run application
shinyApp(ui, server)
