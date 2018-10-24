
observe({
  clusterCellsReactive()
})

clusterCellsReactive <-
  eventReactive(input$clusterCells, {
    withProgress(message = "Processing , please wait",{
      print("Finding Clusters")

      pbmc <- jackStrawReactive()$pbmc

      js$addStatusIcon("clusterCells","loading")

      shiny::setProgress(value = 0.4, detail = "Finding Cell Clusters ...")

      pbmc <- FindClusters(object = pbmc, reduction.type = input$reducType, dims.use = input$clustPCDim1:input$clustPCDim2,
                           resolution = input$clustResolution, print.output = 0, save.SNN = TRUE)

      shinyjs::show(selector = "a[data-value=\"tsneTab\"]")
      shinyjs::show(selector = "a[data-value=\"clusterCells\"]")

      js$addStatusIcon("clusterCells","done")
      js$addStatusIcon("tsneTab","next")

      return(list('pbmc'=pbmc))
    })}
  )


output$clustParamsAvailable <- reactive({
  if(is.null(clusterCellsReactive()$pbmc))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'clustParamsAvailable', suspendWhenHidden=FALSE)

output$clustParamsPrint <- renderText({

  pbmc <- clusterCellsReactive()$pbmc

  printStr = capture.output(PrintFindClustersParams(object = pbmc))

  printStr = gsub("\\[1\\]","",printStr)
  printStr = paste(printStr, collapse = "<br>")

  HTML(printStr)
})
