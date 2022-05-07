#' mapview_lalpost_grd_contour
#'
#' Create a mapview contourline object from LAPOST ascii grid file
#'
#' @param file_grd string path to the LAPOST ascii grid file
#' @param epsg number epsg to set crs in the raster object
#' @param levels vector of the levels for the contourplot
#' @param export logical, export mapview object as hmtl and png files? The default value is equal to FALSE
#' @param string_filename string to name the output files
#' @param name_of_map_layer string to name the mapview layer
#' @return mapview contourline object, eventually exported as html and png files
#' @export

mapview_lapost_grd_contour <- function(file_grd,
                                       epsg = 32632,
                                       levels = NULL,
                                       export = FALSE,
                                       string_filename = ' file_name',
                                       name_of_map_layer = 'layer_name'){

  grd <- read_lapost_grd(file_grd, epsg)

  # contourlines form raster: pay attention here because it gets a SpatialLinedDataFrame
  #grd<-raster::rasterToContour(grd, levels=c(1,3,5))
  #grd<-raster::rasterToContour(grd, levels=levels)

  # checking user input value
  if(is.null(levels)) {

    # use default of contour line
    grd<-raster::rasterToContour(grd)

    # need to sort the factor levels of the spatialLinesDataFRame
    grd@data$level<-factor(grd@data$level,
                            as.character(sort(as.numeric(grd@data$level))))
    } else {

    # here it is not necessary to sort the factor levels, not completely understand that...
    grd<-raster::rasterToContour(grd, levels=levels)

  }

  # mapview
  map <- mapview::mapview(grd,
                   #define the palette
                   #color = grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(8, 'RdYlBu'))),
                   #alpha.region= 0.5,
                   #legend.opacity=0.5,
                   layer.name = name_of_map_layer)


  # eventually export the map to hml and png
  if(export) rfunctions::export_mapview(map, string_filename)

  # and finally return the map
  map
}
