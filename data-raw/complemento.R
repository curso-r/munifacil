## code to prepare `complemento` dataset goes here

municipios_oficiais <- abjData::muni

complemento <- readxl::read_excel("data-raw/complemento.xlsx") %>%
  dplyr::rename(
    muni_join = nome_municipio_candidato,
    uf_join = estado,
    muni_id = codigo_municipio_completo
  )

depara_muni_codigo <- municipios_oficiais %>%
  bind_rows(complemento)
# muni_join, uf_join, codigo_ibge, manual, atencao,
# existia_1991, existia_2000, existia_2010

usethis::use_data(depara_muni_codigo, overwrite = TRUE)
