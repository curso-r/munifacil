#' Cria coluna limpa a partir do nome bruto dos municipios
#'
#' @param data_set base de dados
#' @param col_muni coluna de municipio a ser arrumada
#' @param col_uf coluna de municipio a ser arrumada
#'
#' @export
limpar_colunas <- function(data_set, col_muni, col_uf){

  if (missing(col_muni)) {
    usethis::ui_stop("Voc\u00ea deveria me passar uma coluna com o nome bruto dos munic\u00edpios.")
  }

  if (missing(col_uf)) {
    usethis::ui_stop("Voc\u00ea deveria me passar uma coluna com as siglas das UF")
  }

  data_set %>%
    dplyr::mutate(
      muni_join = limpar_muni({{col_muni}}),
      uf_join = toupper({{col_uf}})
    )
}

#' Limpa nome bruto dos municipios
#'
#' @param col coluna a ser arrumada
#'
limpar_muni <- function(col) {
  rx_pontuacoes_tirar <- "['\"^`\u00b4.,;_@#$%&*!()]"
  col %>%
    stringr::str_to_lower() %>%
    stringi::stri_trans_general("Latin-ASCII") %>%
    stringr::str_remove_all(rx_pontuacoes_tirar) %>%
    stringr::str_squish()
}
