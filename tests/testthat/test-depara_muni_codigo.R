test_that("depara_muni_codigo() works", {

  df <-  munifacil::depara_muni_codigo()

  # espero que `df` seja uma tibble
  testthat::expect_s3_class(df, class = "tbl_df")
  # espero que `df` tenha 2 linhas e 2 colunas
  testthat::expect_gte(nrow(df), 5775)
  testthat::expect_equal(ncol(df), 8)
  # pelo menos 4380 ocorrencias tem que dar certo
  testthat::expect_gte(length(unique(df$id_municipio)), 5500)

})
