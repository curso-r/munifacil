#' Cria coluna limpa a partir do nome bruto dos municipios
#'
#' @param data_set base de dados
#' @param col_muni nome da coluna de municipio a ser arrumada, sem aspas.
#' @param col_uf nome da coluna de UF a ser arrumada, sem aspas.
#' @param default_muni (opcional) String. Ao invés de passar o nome de uma coluna de entrada, você pode preencher a coluna de saída com uma string fixa.
#' @param default_uf (opcional)  String. Ao invés de passar o nome de uma coluna de entrada, você pode preencher a coluna de saída com uma string fixa.
#'
#' @details Por padrao, o pacote espera receber os nomes das colunas nao em formato string, ou seja, sem aspas. Strings podem ser fornecidas para preencher as colunas de saida com valores fixo, o seu valor sera utilizado para preencher as colunas novas.
#'
#' @returns Esta funcao retorna a base data_set acrescida das colunas "muni_join" e "uf_join". Essas colunas serao usadas na funcao incluir_codigo_ibge.
#'
#' @export
limpar_colunas <- function(data_set, col_muni, col_uf, default_muni, default_uf){

  if (missing(col_muni) & missing(default_muni)) {
    usethis::ui_stop("Voc\u00ea deveria me passar uma coluna com o nome bruto dos munic\u00edpios.")
  }

  if (missing(col_uf) & missing(default_uf)) {
    usethis::ui_stop("Voc\u00ea deveria me passar uma coluna com as siglas das UF")
  }

  expr_col_uf <- rlang::enexpr(col_uf)
  expr_col_muni <- rlang::enexpr(col_muni)
  # aqui avaliamos a (possível) expressão fornecida
  # para selecionar as colunas

  if(class(expr_col_uf) == "character" | class(expr_col_muni) == "character"){
    # nada pode ser character!
    usethis::ui_stop("Voc\u00ea nao deveria me passar strings com os nomes das colunas.\nCaso queira preencher alguma das colunas muni_join ou uf_join com algum valor especifico, experimente usar os parametros default_uf ou default_muni.")
  }

  if(class(expr_col_uf) == "name"){
    aux <- data_set %>%
          dplyr::mutate(
            uf_join = toupper({{col_uf}}))
  } else {
    aux <- data_set %>%
      dplyr::mutate(
        uf_join = default_uf
      )
  }

  if(class(expr_col_muni) == "name"){
    aux <- aux %>%
      dplyr::mutate(
        muni_join = limpar_muni({{col_muni}}))
  } else {
    aux <- aux %>%
      dplyr::mutate(
        muni_join = default_muni)
  }

  return(aux)
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
