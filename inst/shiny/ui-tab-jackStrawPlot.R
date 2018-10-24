tabItem(tabName =  "jackStrawPlot",
         fluidRow(
           column(12,
                  h3(strong("Determine statistically significant PCs:")),
                  hr(),
           column(3,
                  wellPanel(
                    numericInput("numReplicates", "Number of Replicates", value = 100),
                    hr(),
                    h4("PCs to use:"),
                    numericInput("jsPcsToPlot1", "PC", value = 1),
                    numericInput("jsPcsToPlot2", "To", value = 12)
                  )),
           column(9,
                  column(12,
                         #actionButton("jackStraw","Next Step: Determine statistically significant PCs >>",class = "btn btn-success btn-lg"),

                         p("To overcome the extensive technical noise in any single gene for scRNA-seq data, Seurat clusters cells based on their PCA scores, with each PC essentially representing a ‘metagene’ that combines information across a correlated gene set. Determining how many PCs to include downstream is therefore an important step."),
                         p("In Macosko et al, we implemented a resampling test inspired by the jackStraw procedure. We randomly permute a subset of the data (1% by default) and rerun PCA, constructing a ‘null distribution’ of gene scores, and repeat this procedure. We identify ‘significant’ PCs as those who have a strong enrichment of low p-value genes."),
                         p("The JackStrawPlot function provides a visualization tool for comparing the distribution of p-values for each PC with a uniform distribution (dashed line). ‘Significant’ PCs will show a strong enrichment of genes with low p-values (solid curve above the dashed line)."),
                         p(strong("NOTE: Although we use multi-threading, this process can take a long time for big datasets")),
                         conditionalPanel("output.jackStrawPlotAvailable",
                                          h4(strong("JackStraw Plot")),
                                          withSpinner(plotOutput(outputId = "jackStrawPlot")),
                                          hr(),
                                          h4(strong("PC Elbow Plot (PCElbowPlot)")),
                                          p("A more ad hoc method for determining which PCs to use is to look at a plot of the standard deviations of the principle components and draw your cutoff where there is a clear elbow in the graph. This can be done with PCElbowPlot."),

                                          withSpinner(plotOutput(outputId = "pcElbowPlot")),
                                          p("PC selection – identifying the true dimensionality of a dataset – is an important step for Seurat, but can be challenging/uncertain for the user. We therefore suggest these three approaches to consider. The first is more supervised, exploring PCs to determine relevant sources of heterogeneity, and could be used in conjunction with GSEA for example."),
                                          p("The second implements a statistical test based on a random null model, but is time-consuming for large datasets, and may not return a clear PC cutoff. The third is a heuristic that is commonly used, and can be calculated instantly.")
                         ),
                         hr(),
                         actionButton("jackStraw","Run JackStraw Procedure",class = "button button-3d button-block button-pill button-primary button-large align-right",style = "width: 100%")

                         )
           )
         )
         )

)
