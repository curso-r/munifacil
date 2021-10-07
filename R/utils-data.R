#' Lista de candidatos a municipios do Brasil
#'
#' Uma base de dados manual com varias opções de nomes
#' de municipios para dar join
#'
#' @format Um data frame com 8 colunas
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
"depara_muni_codigo"
