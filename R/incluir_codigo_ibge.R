#' Incluir o codigo do IBGE
#'
#' @param data_set base de dados arrumada, com colunas muni_join e uf_join
#' @param tabela_referencia tabela de referencia. Por padrão usa uma base interna
#' @param diagnostico imprimir diagnostico?
#'
#' @export
incluir_codigo_ibge <- function (data_set,
                                 tabela_referencia = munifacil::depara_muni_codigo(),
                                 diagnostico = TRUE) {

  resultado <- data_set %>%
    dplyr::left_join(
      tabela_referencia,
      c("muni_join", "uf_join")
    )

  if (diagnostico) {
    diagnostico_join(resultado)
  }

  resultado
}

#' Realizar diagnóstico do join
#'
#' @param resultado Tibble que é resultado do left_join entre a tabela de referência
#' e a base de dados passada para a função `incluir_codigo_ibge()`
#'
#' @return A função imprime um diagnóstico na tela, informando se o join foi bem
#' sucedido ou não. Caso o join tenha falhado, a função imprime uma lista com os
#' municípios que não foram encontrados na tabela de referência.
diagnostico_join <- function(resultado) {

  quantidade_na <- sum(is.na(resultado[["id_municipio"]]))
  pct_na <- scales::percent(mean(is.na(resultado[["id_municipio"]])))

  if (quantidade_na == 0) {
    usethis::ui_done("Uhul! Deu certo!")
  } else {
    usethis::ui_todo("Ainda faltam {quantidade_na} ({pct_na}) casos... Sao eles:")

    resultado %>%
      dplyr::filter(is.na(id_municipio)) %>%
      dplyr::select(muni_join, uf_join) %>%
      dplyr::distinct() %>%
      tidyr::unite(c(muni_join, uf_join), col = "UF - Municipio" , sep = " - ") %>%
      dplyr::pull() %>%
      as.list() %>%
      purrr::map(usethis::ui_todo)

  }

}
