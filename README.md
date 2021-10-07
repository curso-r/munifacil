
<!-- README.md is generated from README.Rmd. Please edit that file -->

# munifacil

<!-- badges: start -->
<!-- badges: end -->

O pacote munifacil serve para juntar municipios facilmente!

``` r
#remotes::install_github("curso-r/munifacil")

library(munifacil)

arquivo <- system.file("extdata/exemplo.xlsx", package = "munifacil")

sua_base <- readxl::read_excel(arquivo) %>% 
  janitor::clean_names() %>% 
  dplyr::select(
    municipio = 1, 
    uf = 3,
    ibge = 2
  ) %>% 
  dplyr::distinct(municipio, .keep_all = TRUE)

resultado <- sua_base %>% 
  limpar_colunas(municipio, uf) %>% 
  # cria uma coluna "uf_join"
  incluir_codigo_ibge()
#> • Ainda faltam 10 (0%) casos...

resultado %>% 
  dplyr::filter(is.na(id_municipio))
#> # A tibble: 10 × 11
#>    municipio          uf    ibge   muni_join uf_join id_municipio manual atencao
#>    <chr>              <chr> <chr>  <chr>     <chr>   <chr>        <lgl>  <lgl>  
#>  1 ÁGUAS CLARAS       DF    -      aguas cl… DF      <NA>         NA     NA     
#>  2 BRAZLÂNDIA         DF    53001… brazland… DF      <NA>         NA     NA     
#>  3 CEILANDIA          DF    53001… ceilandia DF      <NA>         NA     NA     
#>  4 GAMA               DF    53001… gama      DF      <NA>         NA     NA     
#>  5 NÚCLEO BANDEIRANTE DF    53001… nucleo b… DF      <NA>         NA     NA     
#>  6 PARANOÁ            DF    53001… paranoa   DF      <NA>         NA     NA     
#>  7 RIACHO FUNDO       DF    53001… riacho f… DF      <NA>         NA     NA     
#>  8 SAMAMBAIA          DF    53001… samambaia DF      <NA>         NA     NA     
#>  9 SÃO SEBASTIÃO      DF    53001… sao seba… DF      <NA>         NA     NA     
#> 10 -                  -     -      -         -       <NA>         NA     NA     
#> # … with 3 more variables: existia_1991 <int>, existia_2000 <int>,
#> #   existia_2010 <int>

# deu certo?
resultado %>% 
  dplyr::count(ibge == id_municipio)
#> # A tibble: 2 × 2
#>   `ibge == id_municipio`     n
#>   <lgl>                  <int>
#> 1 TRUE                    4380
#> 2 NA                        10

# deu!
```

## Tarefas

-   [ ] Escrever uma solução para fazer correções manuais
-   [ ] Facilitar o trabalho de adicionar opções na base
    `depara_muni_codigo`
-   [ ] Implementar uma opção de fuzzy join
