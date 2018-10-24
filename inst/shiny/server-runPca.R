observe({
  runPcaReactive()
})

runPcaReactive <-
  eventReactive(input$runPca, {
    withProgress(message = "Processing , please wait",{
      print("Running PCA")

      pbmc <- findVariableGenesReactive()$pbmc

      js$addStatusIcon("runPcaTab","loading")

      shiny::setProgress(value = 0.3, detail = "Scaling Data (this might take a while)...")

      pbmc <- ScaleData(object = pbmc, vars.to.regress = input$varsToRegress, do.par = T)

      shiny::setProgress(value = 0.6, detail = "Performing PCA ...")

      pbmc <- RunPCA(object = pbmc, pc.genes = pbmc@var.genes)


      shinyjs::show(selector = "a[data-value=\"vizPcaPlot\"]")
      shinyjs::show(selector = "a[data-value=\"pcaPlot\"]")
      shinyjs::show(selector = "a[data-value=\"heatmapPlot\"]")
      shinyjs::show(selector = "a[data-value=\"jackStrawPlot\"]")
      shinyjs::show(selector = "a[data-value=\"runPcaTab\"]")

      js$addStatusIcon("runPcaTab","done")
      js$addStatusIcon("vizPcaPlot","done")
      js$addStatusIcon("pcaPlot","done")
      js$addStatusIcon("heatmapPlot","done")
      js$addStatusIcon("jackStrawPlot","next")

      updateTabItems(session, "tabs", "runPcaTab")

      return(list('pbmc'=pbmc))
    })}
  )


output$pcsPrintAvailable <- reactive({
  if(is.null(runPcaReactive()$pbmc))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'pcsPrintAvailable', suspendWhenHidden=FALSE)

output$pcsPrint <- renderText({

  pbmc <- runPcaReactive()$pbmc

  printStr = capture.output(PrintPCA(object = pbmc, pcs.print = 1:input$numPCs, genes.print = input$numGenes, use.full = FALSE))

  printStr = gsub("\\[1\\]","",printStr)
  printStr = paste(printStr, collapse = "<br>")

  HTML(printStr)
})

observeEvent(input$vizPca, {

  updateTabItems(session, "tabs", "vizPcaPlot")
})
