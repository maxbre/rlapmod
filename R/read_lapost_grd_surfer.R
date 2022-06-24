#' read_lapost_grd_surfer
#'
#' Read LAPOST grid file in surfer format
#'
#' @param file_grd string path to LAPOST grid file in surfer format
#' @param epsg number epsg to set crs in the raster object
#' @return raster object
#' @keywords internal

read_lapost_grd_surfer <- function(file_grd, epsg = 32632){

  #read grd as raster
  grd <- raster::raster(file_grd)

  # define the new extent by applying a transformation factor 10^3 from km to m
  # remember calpuff is using km as distance units
  # new_extent <- raster::extent(raster::xmin(grd)*1000,
  #                             raster::xmax(grd)*1000,
  #                             raster::ymin(grd)*1000,
  #                            raster::ymax(grd)*1000)

  # set new extent
  # grd <- raster::setExtent(grd, new_extent)

  # epsg 32632
  #crs_string <- "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs"
  #crs_string <- 32632
  #crs_string <- "EPSG:32632"
  #crs_string <- sp::CRS(SRS_string = "EPSG:32632") # an sp CRS object
  #crs_string <- sf::st_crs(32632)$wkt # a WKT string

  # set raster crs
  #raster::crs(grd) <- crs_string
  raster::crs(grd) <- epsg

  grd

}
