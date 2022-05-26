test_that("incluir_codigo_ibge() works", {

  # codigo que esta no readme
  # carrega um arquivo de exemplo
  arquivo <- system.file("extdata/exemplo.csv", package = "munifacil")

  # limpa a base de exemplo
  sua_base <- readr::read_csv(arquivo) %>%
    dplyr::select(
      municipio = 1,
      uf = 3,
      ibge = 2
    ) %>%
    dplyr::distinct(municipio, .keep_all = TRUE)

  # limpar colunas e incluir codigo IBGE
  resultado <- sua_base %>%
    limpar_colunas(municipio, uf) %>%
    # cria uma coluna "uf_join"
    incluir_codigo_ibge()

  deu_certo <- resultado |>
    dplyr::mutate(ibge = stringr::str_sub(ibge, 1, 7)) |>
    dplyr::count(ibge == id_municipio) |>
    dplyr::rename("ibge_igual_id_municipio" = 1)

  # espero que `deu_certo` seja uma tibble
  testthat::expect_s3_class(deu_certo, class = "tbl_df")

  # espero que `deu_certo` tenha 2 linhas e 2 colunas
  testthat::expect_equal(nrow(deu_certo), 3)
  testthat::expect_equal(ncol(deu_certo), 2)
  # pelo menos 4380 ocorrencias tem que dar certo
  deu_certo |>
    dplyr::filter(ibge_igual_id_municipio == TRUE) |>
    dplyr::pull(n) |>
    testthat::expect_gte(4380)

})
