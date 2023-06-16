
<!-- README.md is generated from README.Rmd. Please edit that file -->

# munifacil

<!-- badges: start -->

[![R-CMD-check](https://github.com/curso-r/munifacil/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/curso-r/munifacil/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

O pacote [munifacil](https://curso-r.github.io/munifacil/) tem como
objetivo facilitar a união de colunas de nome de município com o
respectivo código do IBGE. Isso é útil para posteriormente realizar
procedimentos de `join` usando como chave a coluna do código do IBGE
(como o `dplyr::left_join()`).

## Instalação

Este pacote atualmente não está disponível no CRAN, podendo ser
instalado através do GitHub, utilizando o código abaixo:

``` r
install.packages("remotes")
remotes::install_github("curso-r/munifacil")
```

## Exemplo de uso

``` r
# Carregar o pacote munifacil
library(munifacil)

# Importar uma base de dados usada neste exemplo
arquivo <- system.file("extdata/exemplo.csv", package = "munifacil")
base_de_exemplo_bruta <- readr::read_csv(arquivo)
#> Rows: 6786 Columns: 6
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (5): Cidade abrangida, Código do IBGE - cidade abrangida, Cidade abrangi...
#> dbl (1): Indicador Valor
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

# ver quais são as colunas disponíveis
# Nessa base, temos o nome do município, a UF, e o código do IBGE que usaremos para validar posteriormente
dplyr::glimpse(base_de_exemplo_bruta)
#> Rows: 6,786
#> Columns: 6
#> $ `Cidade abrangida`                  <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOU…
#> $ `Código do IBGE - cidade abrangida` <chr> "5200050", "3100104", "5200100", "…
#> $ `Cidade abrangida UF`               <chr> "GO", "MG", "GO", "MG", "PA", "CE"…
#> $ `Tribunal UF`                       <chr> "GO", "MG", "GO", "MG", "PA", "CE"…
#> $ `Tribunal município`                <chr> "GUAPO", "COROMANDEL", "ABADIÂNIA"…
#> $ `Indicador Valor`                   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

# vamos limpar o nome das colunas
base_de_exemplo <- base_de_exemplo_bruta |> 
  janitor::clean_names() |> 
  # buscar apenas linhas distintas segundo essas colunas
  dplyr::distinct(cidade_abrangida, codigo_do_ibge_cidade_abrangida, cidade_abrangida_uf)


# ver novamente a base de exemplo limpa
dplyr::glimpse(base_de_exemplo)
#> Rows: 4,578
#> Columns: 3
#> $ cidade_abrangida                <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOURADO…
#> $ codigo_do_ibge_cidade_abrangida <chr> "5200050", "3100104", "5200100", "3100…
#> $ cidade_abrangida_uf             <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…

# Usar o munifacil

resultado <- base_de_exemplo %>% 
  # aqui é necessario indicar o nome da coluna que contém o nome das cidades, e 
  # o nome da coluna que contém o nome das UFs
  limpar_colunas(col_muni = cidade_abrangida, col_uf = cidade_abrangida_uf) %>% 
  # cria uma coluna "id_municipio"
  incluir_codigo_ibge()
#> • Ainda faltam 1 (0%) casos... São eles:
#> • - - -

# ver o resultado
dplyr::glimpse(resultado)
#> Rows: 4,578
#> Columns: 11
#> $ cidade_abrangida                <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOURADO…
#> $ codigo_do_ibge_cidade_abrangida <chr> "5200050", "3100104", "5200100", "3100…
#> $ cidade_abrangida_uf             <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ uf_join                         <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ muni_join                       <chr> "abadia de goias", "abadia dos dourado…
#> $ id_municipio                    <chr> "5200050", "3100104", "5200100", "3100…
#> $ manual                          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FAL…
#> $ atencao                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FAL…
#> $ existia_1991                    <lgl> FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, T…
#> $ existia_2000                    <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR…
#> $ existia_2010                    <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR…

# resultados que nao receberam o id do municipio
resultado %>% 
  dplyr::filter(is.na(id_municipio))
#> # A tibble: 1 × 11
#>   cidade_abrangida codigo_do_ibge_cidade…¹ cidade_abrangida_uf uf_join muni_join
#>   <chr>            <chr>                   <chr>               <chr>   <chr>    
#> 1 -                -                       -                   -       -        
#> # ℹ abbreviated name: ¹​codigo_do_ibge_cidade_abrangida
#> # ℹ 6 more variables: id_municipio <chr>, manual <lgl>, atencao <lgl>,
#> #   existia_1991 <lgl>, existia_2000 <lgl>, existia_2010 <lgl>

# Verificando a quantidade de resultados corretos
resultado %>% 
  dplyr::count(codigo_do_ibge_cidade_abrangida == id_municipio)
#> # A tibble: 3 × 2
#>   `codigo_do_ibge_cidade_abrangida == id_municipio`     n
#>   <lgl>                                             <int>
#> 1 FALSE                                                14
#> 2 TRUE                                               4563
#> 3 NA                                                    1
```
