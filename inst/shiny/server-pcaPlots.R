
output$vizPcaPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  VizPCA(object = pbmc, pcs.use = input$pcsToPlotStart:input$pcsToPlotEnd)
})

output$pcaPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  PCAPlot(object = pbmc, dim.1 = input$dim1, dim.2 = input$dim2)
})

output$heatmapPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  PCHeatmap(object = pbmc, pc.use = input$pcsToUse1:input$pcsToUse2, cells.use = input$cellsToUse, do.balanced = TRUE,
            label.columns = FALSE, use.full = FALSE)
})
