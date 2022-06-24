#' Calculate separation distances
#'
#' Get a a simple feature data frame of separation distances from the source
#' (origin) point to some predefined concentration contour lines.
#' \emph{Beware: it works ONLY with grid files in ESRI ASCII format (i.e. NOT with grid files in SURFER ASCII format).
#' This function is highly EXPERIMENTAL and in FULL DEVELOPMENT!}
#'
#' @param file_grd string path to the LAPOST grid file in ESRI ASCII format
#' @param epsg number epsg to set crs in the raster object
#' @param x_source x coordinates of the source (origin) point
#' @param y_source y coordinates of the source (origin) point
#' @param levels vector of defined levels for the contour lines
#' @param degree_step angle degree to scan directions where calculate distances from source (origin) point
#' @param trans_factor number, transformation factor to be applied to calculated values, leave it as default = 1
#' @return a simple feature data frame
#' @export

get_sep_dist_lapost_grd_esri <- function(file_grd,
                                    epsg = 32632,
                                    x_source,
                                    y_source,
                                    levels = NULL,
                                    degree_step = 5,
                                    trans_factor = 1){


  # this is for getting rid of mapview warning, not to worry about
  # https://github.com/r-spatial/mapview/issues/422
  options(rgdal_show_exportToProj4_warnings = "none")

  # read grd fle
  grd <- read_lapost_grd_esri(file_grd, epsg)

  #eventually apply a transf_factor
  grd <- grd * trans_factor

  # re-project raster to new crs
  grd<- raster::projectRaster(grd, crs=sp::CRS(paste0('+init=epsg:', 4326)))

  # checking user input value
  if(is.null(levels)) {

    # use default of contour line
    # spatial lines data frame
    cl<-raster::rasterToContour(grd)

  } else {

    # spatial lines data frame
    cl<-raster::rasterToContour(grd, levels=levels)

  }

  # transform contour lines to sf feature
  cl_sf <- sf::st_as_sf(cl)

  # order levels
  cl_sf$level<-factor(cl_sf$level, levels=sort(as.numeric(cl_sf$level)))

  # define coordinates of the origin point
  # create simple feature with appropriate crs
  pt_source <- sf::st_sfc(sf::st_point(c(x_source, y_source)), crs = epsg)

  # # transform sf crs to geo, epsg 4326
  pt_source <- sf::st_transform(pt_source, crs =  4326)

  # get lng and lat coordinates of the source point
  lng_source <- sf::st_coordinates(pt_source)[1]
  lat_source <- sf::st_coordinates(pt_source)[2]

  # get the max value of the minimum distance (shortest path) from origin to contourlines
  dist_orig_contour <- max(sf::st_distance(cl_sf, pt_source))

  # create vector of bearing angles of predefined amplitude as degree_step
  #degree_step <- 5
  bearing_angles <- seq(0, 360-degree_step, degree_step)

  # get destination point at a given bearing angle
  # returning coordinates of destination point
  # keep it a safe factor 100 for distance
  pts_dest <- geosphere::destPoint(p = c(lng_source, lat_source),
                                   b = bearing_angles,
                                   d = dist_orig_contour*100)

  # https://gis.stackexchange.com/questions/312289/r-create-multiple-linestrings-from-multiple-coordinates

  # create dataframe: lon, lat from origin to destination points
  orig_dest_ls_sf<-data.frame(lng_source, lat_source, pts_dest)

  # create an helper function for dealing with calculation by rows fo df
  st_segment <- function(r){sf::st_linestring(t(matrix(unlist(r), 2, 2)))}

  # add geometry to df
  orig_dest_ls_sf$geom <- sf::st_sfc(sapply(1:nrow(orig_dest_ls_sf), function(i){st_segment(orig_dest_ls_sf[i,])}, simplify=FALSE))

  # tranSform to sf linestring: from origin to destination points
  orig_dest_ls_sf <-sf::st_sf(orig_dest_ls_sf, crs = 4326)

  # add bearing angles to sf
  orig_dest_ls_sf$bearing_angle <- bearing_angles

  # get sf of the intersection points between the two features
  intersect_sf <- sf::st_intersection(cl_sf, orig_dest_ls_sf)

  # get the distance matrix
  dist_m <- sf::st_distance(pt_source, intersect_sf)

  # add distance to sf
  intersect_sf$distance <- as.vector(units::drop_units(t(dist_m)))

  intersect_sf

}
