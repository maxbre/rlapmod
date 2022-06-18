#' Plot LAPOST ascii grid file in mapview
#'
#' Create a mapview raster object from LAPOST ascii grid file.
#'
#' Beware: it works ONLY with grid files in ascii format (i.e. NOT with grid files in surfer format... yet!).
#'
#' @param file_grd string path to the LAPOST ascii grid file
#' @param epsg number epsg to set crs in the raster object
#' @param at numeric vector defining breakpoints for the visualization,
#'        default value is NULL by using continuous 'pretty' breakpoints, see lattice::levelplot function for details
#' @param export logical, export mapview object as hmtl and png files? The default value is equal to FALSE
#' @param string_filename string to name the output files
#' @param name_of_map_layer string to name the mapview layer
#' @param trans_factor number, transformation factor to be applied to calculated values, leave it as default = 1
#' @return mapview raster object, eventually exported as html and png files
#' @export

mapview_lapost_grd <- function(file_grd,
                               epsg = 32632,
                               at = NULL,
                               export = FALSE,
                               string_filename = ' file_name',
                               name_of_map_layer = 'layer_name',
                               trans_factor = 1){

  # this is for getting rid of mapview warning, not to worry about
  # https://github.com/r-spatial/mapview/issues/422
  options(rgdal_show_exportToProj4_warnings = "none")

  # read grd file
  grd <- read_lapost_grd(file_grd, epsg)

  #eventually apply a transf_factor
  grd <- grd * trans_factor

  # eventually to hardcode the binning in mapview
  #my_bins<-c(0, 1, 2, 3, 4, 5, 10, 100, round(max(raster::values(grd)),0))
  #my_bins<-pretty(range(raster::values(grd)))

  if(!is.null(at)) at=c(at, round(max(raster::values(grd))))

  # mapview
  map <- mapview::mapview(grd,
                   # define the palette
                   col.regions = grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(8, 'RdYlBu'))),
                   # here eventually define the binning
                   at = at,
                   na.color ='transparent',
                   alpha.region= 0.5,
                   legend.opacity=0.5,
                   layer.name = name_of_map_layer)

  # eventually export the map to hml and png
  if(export) rfunctions::export_mapview(map, string_filename)

  # and finally return the map
  map

}
