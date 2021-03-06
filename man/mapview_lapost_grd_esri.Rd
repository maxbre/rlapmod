% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapview_lapost_grd_esri.R
\name{mapview_lapost_grd_esri}
\alias{mapview_lapost_grd_esri}
\title{Plot LAPOST grid file in ESRI ASCII format with mapview}
\usage{
mapview_lapost_grd_esri(
  file_grd,
  epsg = 32632,
  at = NULL,
  export = FALSE,
  string_filename = "file_name",
  name_of_map_layer = "layer_name",
  trans_factor = 1
)
}
\arguments{
\item{file_grd}{string path to LAPOST grid file in ESRI ASCII format}

\item{epsg}{number epsg to set crs in the raster object}

\item{at}{numeric vector defining breakpoints for the visualization,
default value is NULL by using continuous 'pretty' breakpoints, see lattice::levelplot function for details}

\item{export}{logical, export mapview object as hmtl and png files? The default value is equal to FALSE}

\item{string_filename}{string to name the output files}

\item{name_of_map_layer}{string to name the mapview layer}

\item{trans_factor}{number, transformation factor to be applied to calculated values, leave it as default = 1}
}
\value{
mapview raster object, eventually exported as html and png files
}
\description{
Create a mapview raster object from LAPOST grid file in ESRI ASCII format.
\emph{Beware: it works ONLY with grid files in ESRI ASCII format (i.e. NOT  NOT with grid files in SURFER ASCII format)}
}
