#' mapview_lalpost_grd
#'
#' Create a mapview object from LAPOST ascii grid file and export as html and png files
#'
#' @param file_grd string path to the LAPOST ascii grid file
#' @param epsg number epsg to set crs in the raster object
#' @param levels vector of contour levels to plot
#' @param string_filename string to name the output files
#' @param name_of_map_layer string to name the mapview layer
#' @return mapview object exported as html and png files
#' @export

mapview_lapost_grd_contour <- function(file_grd,
                                       epsg = 32632,
                                       levels = NULL,
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


  rfunctions::export_mapview(map, string_filename)

}
