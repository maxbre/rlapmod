#' mapview_lalpost_grd
#'
#' Create a mapview object from LAPOST ascii grid file and export as html and png files
#'
#' @param file_grd string path to the LAPOST ascii grid file
#' @param epsg number epsg to set crs in the raster object
#' @param string_filename string to name the output files
#' @param name_of_map_layer string to name the mapview layer
#' @return mapview object exported as html and png files
#' @export

mapview_lapost_grd <- function(file_grd, epsg = 32632, string_filename = ' file_name', name_of_map_layer = 'layer_name'){

  grd <- read_lapost_grd(file_grd, epsg)

  # eventually to hardcode the binning in mapview
  #my_bins<-c(0, 1, 2, 3, 4, 5, 10, 100, round(max(raster::values(grd)),0))
  #my_bins<-pretty(range(raster::values(grd)))

  # mapview
  map <- mapview::mapview(grd,
                   # define the palette
                   col.regions = grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(8, 'RdYlBu'))),
                   # here eventually define the binning
                   #at = my_bins,
                   na.color ='transparent',
                   alpha.region= 0.5,
                   legend.opacity=0.5,
                   layer.name = name_of_map_layer)


  rfunctions::export_mapview(map, string_filename)

}
