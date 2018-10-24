
output$vlnPlotsUI <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(input$subsetNames))
    return()

  vlnsToPlot = c(input$subsetNames, "nUMI")
  pbmc = analyzeDataReactive()$pbmc

  outputUI = lapply(seq(length(vlnsToPlot)), function(i) {

    minThreshA = round(min(pbmc@meta.data[vlnsToPlot[i]]),4)
    maxThreshA = round(max(pbmc@meta.data[vlnsToPlot[i]]),4)

    minThresh = minThreshA - 0.05*(maxThreshA - minThreshA)
    maxThresh = maxThreshA + 0.05*(maxThreshA - minThreshA)

    output[[paste0("VlnPlot",i)]] <- renderPlot({

      lowthreshinput = input[[paste0("thresh",i)]][1]

      if(vlnsToPlot[i] != "nUMI"){
        VlnPlot(object = pbmc, features.plot = vlnsToPlot[i], nCol = 1)  %>%
          + geom_hline(yintercept = input[[paste0("thresh",i)]][1],color = 'red',linetype = "dashed", size = 1) %>%
          + geom_text(data=data.frame(x=1,y=input[[paste0("thresh",i)]][1]), aes(x, y), label="low.threshold", vjust=2, hjust=0,color = "red",size = 5,fontface = "bold") %>%
          + geom_hline(yintercept = input[[paste0("thresh",i)]][2],color = 'blue',linetype = "dashed", size = 1) %>%
          + geom_text(data=data.frame(x=1,y=input[[paste0("thresh",i)]][2]), aes(x, y), label="high.threshold", vjust=-1, hjust=0, color = "blue",size = 5,fontface = "bold") %>%
          + scale_y_continuous(limits=c(minThresh - 0.05*(maxThresh - minThresh),maxThresh + 0.05*(maxThresh - minThresh)))
      }
      else
        VlnPlot(object = pbmc, features.plot = vlnsToPlot[i], nCol = 1)

    })

    output[[paste0("numGenesWithinThresh",i)]] <- renderText({
      dataColumn = round(pbmc@meta.data[vlnsToPlot[i]],4)

      numGenes = length(dataColumn[dataColumn >= input[[paste0("thresh",i)]][1] & dataColumn <= input[[paste0("thresh",i)]][2]])

      HTML(paste("Number of cells within gene detection thresholds<strong>",numGenes,"</strong>out of<strong>",NROW(dataColumn),"</strong>"))
    })


    column(4,

           h4( strong(vlnsToPlot[i]) ),
           withSpinner(plotOutput(outputId = paste0("VlnPlot",i))),
           if(vlnsToPlot[i] != "nUMI")
           {
             wellPanel(
               sliderInput( paste0("thresh",i), "Threshold:",
                            min = minThresh, max = maxThresh,
                            value = c(minThresh, maxThresh)),
               htmlOutput(paste0("numGenesWithinThresh",i)   )
             )
           }
    )


  })

  outputUI

})


# output$VlnPlot <- renderPlot({
#
#   pbmc <- analyzeDataReactive()$pbmc
#
#   featurePlots = c("nGene", "nUMI")
#   if(length(myValues$exprList) > 0)
#     featurePlots = c(featurePlots, paste("percent.",names(myValues$exprList), sep = ""))
#
#   if(length(input$filterSpecGenes) > 0)
#     featurePlots = c(featurePlots,paste0("percent.",input$customGenesLabel))
#
#   VlnPlot(object = pbmc, features.plot = featurePlots, nCol = 3)
# })

output$GenePlot <- renderPlot({

  pbmc <- analyzeDataReactive()$pbmc

  geneListNames = c("nGene")

  if(length(myValues$exprList) > 0)
    geneListNames = c(paste("percent.",names(myValues$exprList), sep = ""), geneListNames)
  if(length(input$filterSpecGenes) > 0)
    geneListNames = c(paste0("percent.",input$customGenesLabel),geneListNames)
  if(length(input$filterPasteGenes) > 0)
    geneListNames = c(paste0("percent.",input$pasteGenesLabel),geneListNames)

  par(mfrow = c(1, length(geneListNames)))

  #GenePlot(object = pbmc, gene1 = "nUMI", gene2 = "percent.mito")
  for (i in 1:length(geneListNames)) {
    GenePlot(object = pbmc, gene1 = "nUMI", gene2 = geneListNames[i])
  }
})



output$highLowThresholdsUI <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(input$subsetNames))
    return()

  outputUI = lapply(seq(length(input$subsetNames)), function(i) {

    column(4,
           tags$div(class = "BoxArea",
                    h4( strong(input$subsetNames[i]) ),
                    textInput( paste0("lowThresh",i), "Low Threshold", value = "-Inf"),
                    textInput(paste0("highThresh",i), "High Threshold", value = "Inf"))
    )
  })

  outputUI

})


observe({
  filterCellsReactive()
})

filterCellsReactive <-
  eventReactive(input$filterCells,{
    withProgress(message = "Processing , please wait",{


      pbmc <- analyzeDataReactive()$pbmc

      js$addStatusIcon("vlnplot","loading")

      shiny::setProgress(value = 0.3, detail = "Filtering Cells ...")


      lowThresh = lapply(seq(length(input$subsetNames)), function(i){
        input[[paste0("thresh",i)]][1]
      })


      highThresh = lapply(seq(length(input$subsetNames)), function(i){
        input[[paste0("thresh",i)]][2]
      })

      lowThresh = unlist(lowThresh)
      highThresh = unlist(highThresh)
      shiny::setProgress(value = 0.6, detail = "Filtering Cells ...")

      pbmc <- FilterCells(object = pbmc, subset.names = input$subsetNames,
                          low.thresholds = lowThresh, high.thresholds = highThresh)

      shiny::setProgress(value = 0.9, detail = "Done.")


      js$addStatusIcon("vlnplot","done")


      js$addStatusIcon("filterNormSelectTab","next")
      shinyjs::show(selector = "a[data-value=\"filterNormSelectTab\"]")

      return(list('pbmc'=pbmc))

    })
  })
