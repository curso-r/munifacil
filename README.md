
<!-- README.md is generated from README.Rmd. Please edit that file -->

# munifacil

<!-- badges: start -->

[![R-CMD-check](https://github.com/curso-r/munifacil/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/curso-r/munifacil/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

O pacote [munifacil](https://curso-r.github.io/munifacil/) tem como
objetivo facilitar a união de colunas de nome de município com o
respectivo código do IBGE.

Isso é útil para posteriormente realizar procedimentos de `join` usando
como chave a coluna do código do IBGE (como o `dplyr::left_join()`).

## Instalação

Este pacote atualmente não está disponível no CRAN, podendo ser
instalado através do GitHub, utilizando o código abaixo:

``` r
install.packages("remotes")
remotes::install_github("curso-r/munifacil")
```

## Exemplo de uso

Neste exemplo, vamos usar uma base de dados que contém o nome de
municípios e a UF, e vamos incluir o código do IBGE.

### Preparando os dados

Primeiro, vamos carregar os pacotes necessários e importar a base de
dados que usaremos neste exemplo.

``` r
library(munifacil)
library(tidyverse)
```

``` r
arquivo <- system.file("extdata/exemplo.csv", package = "munifacil")
base_de_exemplo_bruta <- read_csv(arquivo)
```

Vamos dar uma olhada na base de dados que usaremos como exemplo. Nessa
base, temos o nome do município, a UF, e o código do IBGE que usaremos
para validar posteriormente:

``` r
glimpse(base_de_exemplo_bruta)
#> Rows: 6,786
#> Columns: 6
#> $ `Cidade abrangida`                  <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOU…
#> $ `Código do IBGE - cidade abrangida` <chr> "5200050", "3100104", "5200100", "…
#> $ `Cidade abrangida UF`               <chr> "GO", "MG", "GO", "MG", "PA", "CE"…
#> $ `Tribunal UF`                       <chr> "GO", "MG", "GO", "MG", "PA", "CE"…
#> $ `Tribunal município`                <chr> "GUAPO", "COROMANDEL", "ABADIÂNIA"…
#> $ `Indicador Valor`                   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
```

Agora, vamos limpar o nome das colunas e remover uma linha que não tem
informação. Alguns valores da coluna `codigo_do_ibge_cidade_abrangida`
estão com mais de 7 dígitos, então vamos manter apenas os 7 primeiros
dígitos (o número de dígitos utilizado pelo IBGE para identificar os
municípios).

Essa etapa é feita apenas para facilitar a visualização do exemplo, e
não é necessária para o uso do pacote.

``` r
base_de_exemplo <- base_de_exemplo_bruta |>
  janitor::clean_names() |>
  filter(cidade_abrangida != "-",
         codigo_do_ibge_cidade_abrangida !=  "-") |>
  mutate(
    # manter apenas os 7 primeiros dígitos da coluna codigo_do_ibge_cidade_abrangida
    codigo_do_ibge_cidade_abrangida = str_sub(codigo_do_ibge_cidade_abrangida, 1, 7))

glimpse(base_de_exemplo)
#> Rows: 5,534
#> Columns: 6
#> $ cidade_abrangida                <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOURADO…
#> $ codigo_do_ibge_cidade_abrangida <chr> "5200050", "3100104", "5200100", "3100…
#> $ cidade_abrangida_uf             <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_uf                     <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_municipio              <chr> "GUAPO", "COROMANDEL", "ABADIÂNIA", "A…
#> $ indicador_valor                 <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
```

### Utilizando o pacote `munifacil`

Agora, vamos usar o pacote `munifacil` para incluir o código do IBGE na
base de dados.

A primeira etapa necessária é limpar o nome das colunas que contém o
nome do município e a UF. Isso é feito com a função `limpar_colunas()`.

``` r
base_colunas_limpas <- base_de_exemplo %>% 
  limpar_colunas(col_muni = cidade_abrangida,
                 col_uf = cidade_abrangida_uf)

glimpse(base_colunas_limpas)
#> Rows: 5,534
#> Columns: 8
#> $ cidade_abrangida                <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOURADO…
#> $ codigo_do_ibge_cidade_abrangida <chr> "5200050", "3100104", "5200100", "3100…
#> $ cidade_abrangida_uf             <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_uf                     <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_municipio              <chr> "GUAPO", "COROMANDEL", "ABADIÂNIA", "A…
#> $ indicador_valor                 <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ uf_join                         <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ muni_join                       <chr> "abadia de goias", "abadia dos dourado…
```

Na base `base_colunas_limpas`, agora temos duas novas colunas: `uf_join`
e `muni_join`. Essas colunas estão “limpas”, de forma que facilite a
união com a tabela de “de-para” que contém os códigos do IBGE para cada
município.

Agora, vamos incluir o código do IBGE na base de dados. Isso é feito com
a função `incluir_codigo_ibge()`.

``` r
resultado <- base_colunas_limpas %>% 
  incluir_codigo_ibge()
#> ✔ Uhul! Deu certo!
```

Veja que ao usar a função `incluir_codigo_ibge()`, por padrão uma
mensagem sobre a quantidade de resultados que não receberam o id do
município é impressa. Isso é útil para verificar se existem municípios
que não foram encontrados na base de “de-para”. Essa mensagem pode ser
desativada com o argumento `diagnostico = FALSE`.

A função `incluir_codigo_ibge()` adiciona as seguintes colunas na base
de dados:

- `id_municipio` - código do IBGE para cada município.

- `manual` - a informação utilizada para unir os valores foram incluídos
  manualmente na tabela de de-para.

- `atencao` - indica que é importante ter atenção nesses casos. Por
  exemplo: podem ser municípios com nomes similares, o mesmo nome de
  município em UFs diferentes, etc.

- `existia_1991` - O municipio existia em 1991?

- `existia_2000` - O municipio existia em 2000?

- `existia_2010` - O municipio existia em 2010?

Dentre as colunas citadas acima, a principal é a `id_municipio`, que é o
código do IBGE para cada município. As outras colunas são úteis para
verificar se a união foi feita corretamente.

``` r
glimpse(resultado)
#> Rows: 5,539
#> Columns: 14
#> $ cidade_abrangida                <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOURADO…
#> $ codigo_do_ibge_cidade_abrangida <chr> "5200050", "3100104", "5200100", "3100…
#> $ cidade_abrangida_uf             <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_uf                     <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_municipio              <chr> "GUAPO", "COROMANDEL", "ABADIÂNIA", "A…
#> $ indicador_valor                 <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ uf_join                         <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ muni_join                       <chr> "abadia de goias", "abadia dos dourado…
#> $ id_municipio                    <chr> "5200050", "3100104", "5200100", "3100…
#> $ manual                          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FAL…
#> $ atencao                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FAL…
#> $ existia_1991                    <lgl> FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, T…
#> $ existia_2000                    <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR…
#> $ existia_2010                    <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR…
```

Podemos remover as colunas que foram adicionadas e não são necessárias
para a análise.

``` r
resultado_limpo <- resultado %>%
  select(-c(manual, atencao, starts_with("existia"),
            uf_join, muni_join))
```

Verificando o resultado final:

``` r
glimpse(resultado_limpo)
#> Rows: 5,539
#> Columns: 7
#> $ cidade_abrangida                <chr> "ABADIA DE GOIÁS", "ABADIA DOS DOURADO…
#> $ codigo_do_ibge_cidade_abrangida <chr> "5200050", "3100104", "5200100", "3100…
#> $ cidade_abrangida_uf             <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_uf                     <chr> "GO", "MG", "GO", "MG", "PA", "CE", "P…
#> $ tribunal_municipio              <chr> "GUAPO", "COROMANDEL", "ABADIÂNIA", "A…
#> $ indicador_valor                 <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ id_municipio                    <chr> "5200050", "3100104", "5200100", "3100…
```

### Verificando o resultado

- Quantidade de resultados que não receberam o ID do município:

``` r
resultado_limpo %>% 
  dplyr::filter(is.na(id_municipio))
#> # A tibble: 0 × 7
#> # ℹ 7 variables: cidade_abrangida <chr>, codigo_do_ibge_cidade_abrangida <chr>,
#> #   cidade_abrangida_uf <chr>, tribunal_uf <chr>, tribunal_municipio <chr>,
#> #   indicador_valor <dbl>, id_municipio <chr>
```

Todos os municípios receberam o ID do IBGE!

- Mas esses IDs estão corretos?

``` r
# Verificando a quantidade de resultados corretos
resultado_limpo %>% 
  mutate(resultado_correto = codigo_do_ibge_cidade_abrangida == id_municipio) %>% 
  count(resultado_correto) %>% 
  mutate(porcentagem = formattable::percent(n / sum(n))) %>%
  knitr::kable()
```

| resultado_correto |    n | porcentagem |
|:------------------|-----:|------------:|
| TRUE              | 5539 |     100.00% |

## Como contribuir?

Caso encontre alguma variação de escrita de nomes de municípios que não
seja na tabela “de-para” atual do pacote munifacil, você pode contribuir
com o pacote enviando essa sugestão.

Para isso, você pode [abrir uma
issue](https://github.com/curso-r/munifacil/issues/new/choose), ou
enviar um [pull request adicionando a sugestão no arquivo
`inst/depara_muni_codigo.csv`](https://github.com/curso-r/munifacil/blob/main/inst/depara_muni_codigo.csv).
