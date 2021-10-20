#' Lista de candidatos a municipios do Brasil
#'
#' Uma base de dados manual com varias opções de nomes
#' de municipios para dar join
#'
#' @return Um data frame com 8 colunas
#' \describe{
#' \item{muni_join}{nome do municipio (arrumado)},
#' \item{uf_join}{nome da uf (arrumado)},
#' \item{codigo_ibge}{codigo do ibge (7 digitos)},
#' \item{manual}{foi feito manualmente?},
#' \item{atencao}{tomar cuidado?},
#' \item{existia_1991}{municipio existia em 1991?},
#' \item{existia_2000}{municipio existia em 2000?},
#' \item{existia_2010}{municipio existia em 2010?}
#' }
#' @export
#'
#' @examples depara_muni_codigo()
depara_muni_codigo <- function() {
  path <- system.file("depara_muni_codigo.csv",
                      package = "munifacil")

  df <- readr::read_csv(
    file = path,
    col_types = readr::cols(
      muni_join = readr::col_character(),
      uf_join = readr::col_character(),
      id_municipio = readr::col_character(),
      manual = readr::col_logical(),
      atencao = readr::col_logical(),
      existia_1991 = readr::col_logical(),
      existia_2000 = readr::col_logical(),
      existia_2010 = readr::col_logical()
    )
  )

  df
}
