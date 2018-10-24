
observe({
  jackStrawReactive()
})

jackStrawReactive <-
  eventReactive(input$jackStraw, {
    withProgress(message = "Processing , please wait",{
      print("Running JackStraw")

      js$addStatusIcon("jackStrawPlot","loading")
      #updateTabItems(session, "tabs", "jackStrawPlot")

      pbmc <- runPcaReactive()$pbmc

      shiny::setProgress(value = 0.3, detail = "Running JackStraw Procedure (this might take a while)...")

      pbmc <- JackStraw(object = pbmc, num.replicate = input$numReplicates, do.par = T)

      shiny::setProgress(value = 0.9, detail = "Done.")


      shinyjs::show(selector = "a[data-value=\"clusterCells\"]")
      shinyjs::show(selector = "a[data-value=\"jackStrawPlot\"]")

      js$addStatusIcon("jackStrawPlot","done")
      js$addStatusIcon("clusterCells","next")

      return(list('pbmc'=pbmc))
    })}
  )


output$pcElbowPlot <- renderPlot({

  pbmc <- jackStrawReactive()$pbmc

  PCElbowPlot(object = pbmc)
})

output$jackStrawPlot <- renderPlot({

  pbmc <- jackStrawReactive()$pbmc

  JackStrawPlot(object = pbmc, PCs = input$jsPcsToPlot1:input$jsPcsToPlot2)
})

output$jackStrawPlotAvailable <- reactive({
  if(is.null(jackStrawReactive()$pbmc))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'jackStrawPlotAvailable', suspendWhenHidden=FALSE)

