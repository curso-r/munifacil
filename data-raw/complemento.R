## code to prepare `complemento` dataset goes here
library(magrittr)

municipios_oficiais <- abjData::muni %>%
  dplyr::transmute(
    muni_join = limpar_muni(muni_nm),
    uf_join = uf_sigla,
    id_municipio = muni_id,
    manual = FALSE,
    atencao = FALSE,
    existia_1991,
    existia_2000,
    existia_2010
  )

complemento <- readxl::read_excel("data-raw/complemento.xlsx") %>%
  dplyr::transmute(
    muni_join = nome_municipio_candidato,
    uf_join = estado,
    id_municipio = codigo_municipio_completo,
    manual = as.logical(manual),
    atencao = as.logical(atencao)
  )

depara_muni_codigo <- municipios_oficiais %>%
  dplyr::bind_rows(complemento) %>%
  dplyr::distinct(muni_join, uf_join, .keep_all = TRUE)

## TESTE DE QUALIDADE --- OK
depara_muni_codigo %>%
  janitor::get_dupes(muni_join, uf_join)

# \item{muni_join}{nome do municipio (arrumado)},
# \item{uf_join}{nome da uf (arrumado)},
# \item{codigo_ibge}{codigo do ibge (7 digitos)},
# \item{manual}{foi feito manualmente?},
# \item{atencao}{tomar cuidado?},
# \item{existia_1991}{municipio existia em 1991?},
# \item{existia_2000}{municipio existia em 2000?},
# \item{existia_2010}{municipio existia em 2010?}

usethis::use_data(depara_muni_codigo, overwrite = TRUE)
