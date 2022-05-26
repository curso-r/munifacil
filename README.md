
<!-- README.md is generated from README.Rmd. Please edit that file -->

# munifacil

<!-- badges: start -->

[![R-CMD-check](https://github.com/curso-r/munifacil/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/curso-r/munifacil/actions/workflows/check-standard.yaml)

<!-- badges: end -->

O pacote munifacil serve para juntar municipios facilmente!

``` r
#remotes::install_github("curso-r/munifacil")

library(munifacil)

arquivo <- system.file("extdata/exemplo.csv", package = "munifacil")

sua_base <- readr::read_csv(arquivo) %>% 
  dplyr::select(
    municipio = 1, 
    uf = 3,
    ibge = 2
  ) %>% 
  dplyr::distinct(municipio, .keep_all = TRUE)
#> Rows: 6786 Columns: 6
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (5): Cidade abrangida, Código do IBGE - cidade abrangida, Cidade abrangi...
#> dbl (1): Indicador Valor
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

resultado <- sua_base %>% 
  limpar_colunas(municipio, uf) %>% 
  # cria uma coluna "uf_join"
  incluir_codigo_ibge()
#> • Ainda faltam 1 (0%) casos...

resultado %>% 
  dplyr::filter(is.na(id_municipio))
#> # A tibble: 1 × 11
#>   municipio uf    ibge  muni_join uf_join id_municipio manual atencao
#>   <chr>     <chr> <chr> <chr>     <chr>   <chr>        <lgl>  <lgl>  
#> 1 -         -     -     -         -       <NA>         NA     NA     
#> # … with 3 more variables: existia_1991 <lgl>, existia_2000 <lgl>,
#> #   existia_2010 <lgl>

# deu certo?
resultado %>% 
  dplyr::count(ibge == id_municipio)
#> # A tibble: 3 × 2
#>   `ibge == id_municipio`     n
#>   <lgl>                  <int>
#> 1 FALSE                      9
#> 2 TRUE                    4380
#> 3 NA                         1

# deu!
```

## Tarefas

-   [ ] Escrever uma solução para fazer correções manuais
-   [ ] Facilitar o trabalho de adicionar opções na base
    `depara_muni_codigo`
-   [ ] Implementar uma opção de fuzzy join
