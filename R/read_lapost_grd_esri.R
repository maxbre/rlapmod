#' read_lapost_grd_esri
#'
#' Read LAPOST grid file in ESRI ASCII format
#'
#' @param file_grd string path to LAPOST grid file in ESRI ASCII format
#' @param epsg number epsg to set crs in the raster object
#' @return raster object
#' @keywords internal

read_lapost_grd_esri <- function(file_grd, epsg = 32632){

  # compose valid epsg string
  epsg <- paste0('+init=epsg:', epsg)
  #epsg <- paste0('EPSG:', epsg)

  # read ascii grid
  grd <- sp::read.asciigrid(file_grd, proj4string = sp::CRS(epsg))

  # set it as a grid
  sp::gridded(grd) <- TRUE

  # convert to a raster
  grd <- raster::raster(grd)

  grd

}
