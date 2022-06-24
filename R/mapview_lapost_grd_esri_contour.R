#' Plot contour of LAPOST grid file in ESRI ASCII format with mapview
#'
#' Create a mapview contourline object from LAPOST grid file in ESRI ASCII format.
#' \emph{Beware: it works ONLY with grid files in ESRI ASCII format (i.e. NOT with grid files in SURFER ASCII format)}
#'
#' @param file_grd string path to LAPOST grid file in ESRI ASCII format
#' @param epsg number epsg to set crs in the raster object
#' @param levels vector of the levels for the contourplot
#' @param export logical, export mapview object as hmtl and png files? The default value is equal to FALSE
#' @param string_filename string to name the output files
#' @param name_of_map_layer string to name the mapview layer
#' @param trans_factor number, transformation factor to be applied to calculated values, leave it as default = 1
#' @return mapview contourline object, eventually exported as html and png files
#' @export

mapview_lapost_grd_esri_contour <- function(file_grd,
                                       epsg = 32632,
                                       levels = NULL,
                                       export = FALSE,
                                       string_filename = 'export_filename',
                                       name_of_map_layer = 'mapview_layer_name',
                                       trans_factor = 1){

  # this is for getting rid of mapview warning, not to worry about
  # https://github.com/r-spatial/mapview/issues/422
  options(rgdal_show_exportToProj4_warnings = "none")

  # read grd file
  grd <- read_lapost_grd_esri(file_grd, epsg)

  #eventually apply a transf_factor
  grd <- grd * trans_factor

  # contourlines form raster: pay attention here because it gets a SpatialLinedDataFrame
  #grd<-raster::rasterToContour(grd, levels=c(1,3,5))
  #grd<-raster::rasterToContour(grd, levels=levels)

  # checking user input value
  if(is.null(levels)) {

    # use default of contour line
    grd<-raster::rasterToContour(grd)

    } else {

    # apply user defined levels
    grd<-raster::rasterToContour(grd, levels=levels)

    }

  # sort the factor levels of the spatialLinesDataFRame
  grd@data$level<-factor(grd@data$level, sort(as.numeric(grd@data$level)))


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
