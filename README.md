
<!-- README.md is generated from README.Rmd. Please edit that file -->

# munifacil

<!-- badges: start -->
<!-- badges: end -->

O pacote munifacil serve para juntar municipios facilmente!

``` r
#remotes::install_github("curso-r/munifacil")

library(munifacil)

tabela_arrumacao <- munifacil::depara_muni_codigo

sua_base %>% 
  limpa_coluna_muni(sua_coluna_muni) %>% 
  # isso aqui vai criar no seu df
  # uma coluna "muni_join"
  limpa_coluna_uf(sua_coluna_uf) %>% 
  # cria uma coluna "uf_join"
  inclui_codigo_ibge(depara = tabela_arrumacao)
  # criar uma coluna "codigo_ibge" dando join
  # com um base interna do pacote que tem
  # os codigos do ibge e os nomes candidatos
  # (muni join)
  #
  # DESAFIO:
  # pimenta nivel 1 No final seria bom se essa função soltasse um
  # report.
  # 
  # pimenta nivel michael douglas Desse report seria bom
  # se o pacote desse um jeito
  # de resolver o problema.
  
```
