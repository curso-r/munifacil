#' Cria coluna limpa a partir do nome bruto dos municipios
#'
#' @param data_set
#' @param col
#'
#' @return
#' @export
limpa_coluna_muni <- function(data_set, col){

  if(missing(col)){
    usethis::ui_stop("Você deveria me passar uma coluna com o nome bruto dos municípios.")
  }

  data_set %>%
    dplyr::mutate(
      muni_join = limpar_muni({{col}})
    )
}

#' Limpa nome bruto dos municipios
#'
#' @param col
#'
#' @return
limpar_muni <- function(col){
  col %>%
    stringr::str_to_lower()
}
