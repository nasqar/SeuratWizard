

observe({
  findVariableGenesReactive()
})

findVariableGenesReactive <-
  eventReactive(input$findVariableGenes, {
    withProgress(message = "Processing , please wait",{
      print("analysisCountDataReactive")

      pbmc <- filterCellsReactive()$pbmc


      js$addStatusIcon("filterNormSelectTab","loading")


      shiny::setProgress(value = 0.4, detail = "Normalizing Data ...")

      pbmc <- NormalizeData(object = pbmc, normalization.method = input$normMethod,
                            scale.factor = input$scaleFactor)


      shiny::setProgress(value = 0.8, detail = "Finding Variable Genes ...")

      pbmc <- FindVariableGenes(object = pbmc, mean.function = ExpMean, dispersion.function = LogVMR,
                                x.low.cutoff = input$xlowcutoff, x.high.cutoff = input$xhighcutoff,
                                y.cutoff = input$ycutoff, do.plot = FALSE)

      print(paste("number of genes found: ", length(x = pbmc@var.genes)))



      shinyjs::show(selector = "a[data-value=\"runPcaTab\"]")
      shinyjs::show(selector = "a[data-value=\"dispersionPlot\"]")



      varsToRegressSelect = c("nGene", "nUMI")
      if(length(myValues$exprList) > 0)
        varsToRegressSelect = c(varsToRegressSelect, paste("percent.",names(myValues$exprList), sep = ""))

      if(length(input$filterSpecGenes) > 0)
        varsToRegressSelect = c(varsToRegressSelect,paste0("percent.",input$customGenesLabel))

      if(length(input$filterPasteGenes) > 0)
        varsToRegressSelect = c(varsToRegressSelect,paste0("percent.",input$pasteGenesLabel))

      updateSelectizeInput(session,'varsToRegress',
                           choices=varsToRegressSelect, selected= varsToRegressSelect[varsToRegressSelect != "nGene"])

      js$addStatusIcon("dispersionPlot","loading")
      js$addStatusIcon("filterNormSelectTab","done")
      js$addStatusIcon("runPcaTab","next")



      return(list('pbmc'=pbmc))
    })}
  )
