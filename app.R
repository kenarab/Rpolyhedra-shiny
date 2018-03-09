#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyRGL)
library(Rpolyhedra)
library(rgl)

open3d(useNULL = TRUE)
ids <- plot3d(rnorm(100), rnorm(100), rnorm(100))[1]
scene <- scene3d()
rgl.close()

dmccooey.polyhedra <- getAvailablePolyhedra(source="dmccooey")
bounding_box_color_choices <- list("white", "grey", "blue", "red", "green")
palette_choices <- list("rainbow")
#20 polyhedron in a disc
dmccooey.polyhedra <- dmccooey.polyhedra[1:20,]
n <- nrow(dmccooey.polyhedra)
polyhedron.colors <- rainbow(n)
polyhedron.scale <- 5

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Polyhedra"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout( 
     sidebarPanel(
       shiny::selectInput("polyhedron", label = "Polyhedron", choices = dmccooey.polyhedra$polyhedron.name),
       shiny::titlePanel("Faces Model Bounding Box"),
       shiny::sliderInput("slider_faces_x", "x",
                   min = -1, max = 1,
                   value = c(-1,1), step = 0.01),
       shiny::sliderInput("slider_faces_y", "y",
                          min = -1, max = 1,
                          value = c(-1,1), step = 0.01),
       shiny::sliderInput("slider_faces_z", "z",
                          min = -1, max = 1,
                          value = c(-1,1), step = 0.01),
       shiny::selectInput("bounding_box_faces_model_color", label = "Color", choices = bounding_box_color_choices, selected = "blue"),
       shiny::titlePanel("Edges Model Bounding Box"),
       shiny::sliderInput("slider_edges_x", "x",
                          min = -1, max = 1,
                          value = c(-1,1), step = 0.01),
       shiny::sliderInput("slider_edges_y", "y",
                          min = -1, max = 1,
                          value = c(-1,1), step = 0.01),
       shiny::sliderInput("slider_edges_z", "z",
                          min = -1, max = 1,
                          value = c(-1,1), step = 0.01),
       shiny::selectInput("bounding_box_edges_vertices_model_color", label = "Color", choices = bounding_box_color_choices,  selected = "red"), 
       shiny::selectInput("palette_choices", label = "Color Palette", choices = palette_choices,  selected = "rainbow"), 
       
       shiny::checkboxInput(inputId="show_faces", label = "Show Faces"),
       shiny::checkboxInput(inputId="show_edges", label = "Show Edges"),
       shiny::checkboxInput(inputId="show_axis", label = "Show Axis"),
       shiny::checkboxInput(inputId="show_bounding_box", label = "Show Bounding Box"),
       shiny::submitButton("Render")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
          rglwidgetOutput("wdg")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  options(rgl.useNULL = TRUE)
  save <- options(rgl.inShiny = TRUE)
  on.exit(options(save))
  
  output$wdg <- renderRglwidget({
    params = data.frame(input$polyhedron, input$slider_faces_x,input$slider_faces_y, input$slider_faces_z, 
                        input$bounding_box_faces_model_color, input$slider_edges_x, input$slider_faces_y, input$slider_faces_z, 
                        input$bounding_box_edges_vertices_model_color, input$show_faces, input$show_edges, input$show_axis, 
                        input$show_bounding_box)
    names(params) <- c("polyhedron", "slider_faces_x","slider_faces_y", "slider_faces_z", 
                                  "bounding_box_faces_model_color", "slider_edges_x", "slider_faces_y", "slider_faces_z", 
                                  "bounding_box_edges_vertices_model_color", "show_faces", "show_edges", "show_axis", 
                                  "show_bounding_box")
    print(params)
    # withProgress(message = 'Processing...', value = 0, {
    # open3d()
    # rgl.bg( sphere =FALSE, fogtype = "none", color=c("white"))
    # rgl.viewpoint(theta = 45,phi=10,zoom=0.8,fov=1)
    # 
    # polyhedron <- getPolyhedron(source="dmccooey",dmccooey.polyhedra[17,]$polyhedron.name)
    # pos3D <- rep(0,3)
    # shapes.rgl <- polyhedron$getRGLVerticesEdges(1, pos3D)
    # colors <- rainbow(length(shapes.rgl))
    # 
    # pos3D.text <- pos3D
    # pos3D.text[3] <- pos3D.text[3]+polyhedron.scale*10
    # 
    # cont <- 1
    # for (shape.rgl in shapes.rgl){
    #   shade3d(shape.rgl, color = colors[cont])
    #   cont <- cont + 1
    # }
    # faces2render <- polyhedron$getRGLModel(1, pos3D)
    # shade3d(faces2render,color=rainbow(ncol(faces2render$it)))
    # 
    # rglwidget()
    # })
  })
  
  output$control <- renderPlaywidget({
    toggleWidget("wdg", respondTo = "chk",
                 ids = ids)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

