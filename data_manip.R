library(tidyverse)
library(sf)
library(mapview)


usethis::use_zip(
  url = "https://www.dtpm.cl/descargas/gtfs/GTFS-V70-PO20220228.zip",
  destdir = here::here("input_data"),
  cleanup = FALSE
  )


stops <- read_csv(file = here::here("input_data", "GTFS-V70-PO20220228", "stops.txt"),
                  col_types = cols(
                    stop_id = col_character(),
                    stop_code = col_character(),
                    stop_name = col_character(),
                    stop_lat = col_double(),
                    stop_lon = col_double(),
                    stop_url = col_character()
                    )
                  ) %>% 
  st_as_sf(coords = c("stop_lon", "stop_lat"),
           crs = 4326) %>% 
  st_transform(crs = 32719)


shapes <- read_csv(file = here::here("input_data", "GTFS-V70-PO20220228", "shapes.txt")) %>% 
  st_as_sf(coords = c("shape_pt_lon", "shape_pt_lat"),
           crs = 4326) %>% 
  st_transform(crs = 32719)

