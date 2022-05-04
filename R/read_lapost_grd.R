#' read_lapost_grd
#'
#' Read LAPOST ascii grid file
#'
#' @param file_grd string path to LAPOST ascii grid file
#' @param epsg number epsg to set crs in the raster object
#' @return raster object
#' @keywords internal

read_lapost_grd <- function(file_grd, epsg = 32632){

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
