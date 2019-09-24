

![#1589F0](https://placehold.it/15/1589F0/000000?text=+) `This version is no longer supported. See ` <a href="https://github.com/nasqar/seuratv3wizard">SeuratV3Wizard</a> `for the new version`

# SeuratWizard: R Shiny interface for Seurat single-cell analysis library

## Online/Demo:
You can try it online at http://nasqar.abudhabi.nyu.edu/SeuratWizard

## Run using docker (Recommended):

```
docker run -p 80:80 aymanm/seuratwizard
```
This will run on port 80
***

## Local Install:

```
devtools::install_github("nasqar/SeuratWizard")
```

## Run:

```
library(SeuratWizard)
SeuratWizard()
```
This will run on http://0.0.0.0:1234/ by default

To run on specific ip/port:

```
ip = '127.0.0.1'
portNumber = 5555
SeuratWizard(ip,portNumber)
```
This will run on http://127.0.0.1:5555/

## Screenshots:
![alt text](screenshots/screenshot-input.png "Input Data")

![alt text](screenshots/screenshot-vln.png "Vln Plots")

![alt text](screenshots/screenshot-biomarkers.png "Cluster Biomarkers")

## Acknowledgements:

1) Rahul Satija, Andrew Butler and Paul Hoffman (2017). Seurat: Tools for Single Cell Genomics. R package version 2.2.1\. [https://CRAN.R-project.org/package=Seurat](https://CRAN.R-project.org/package=Seurat)

2) [Satija Lab](http://satijalab.org/seurat/)
