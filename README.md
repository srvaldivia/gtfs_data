# gtfs_data

GTFS datasets

```{r packages, echo = FALSE}
library(tidyverse)
library(sf)
library(mapview)
```

```{r}
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


zonas <- st_read(dsn =here::here("input_data", "zonas_censales.geojson"),
                 as_tibble = TRUE)




# transform data ----------------------------------------------------------


rutas_bus <- shapes %>% 
  filter(!str_detect(shape_id, "^L")) %>%
  group_by(shape_id) %>% 
  summarise(do_union = FALSE) %>% 
  st_cast("LINESTRING")


red_metro <- rutas %>% 
  filter(str_detect(shape_id, "^L")) %>%
  mutate(line = str_split_n(shape_id, pattern = "-", n = 1)) %>% 
  select(line, geometry) %>% 
  distinct()

estaciones_metro <- stops %>% 
  filter(str_detect(stop_url, "metro"))

paradas_bus <- stops %>% 
  st_join(y = zonas %>% select(comuna, nom_comuna, geocode)) %>%
  mutate(nom_comuna = str_to_title(nom_comuna))
```

```{r map-dyn, echo = FALSE}
mapview(estaciones_metro) + mapview(red_metro)
```
