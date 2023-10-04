url_sheet <- "~/Downloads/73397-4d34f530-62ab-11ee-ad03-f16b9b3064c7.xlsx"

tab_raw <- readxl::read_excel(url_sheet, skip = 1) |> 
  janitor::clean_names() |> 
  tidyr::fill(nome_do_convite, ddi,
              ddd_telefone_para_confirmacao_de_presenca,
              grupo_do_convite,
              .direction = "down") |> 
  dplyr::mutate(mesa = as.numeric(mesa)) |> 
  dplyr::filter(situacao != "Não comparecerá")


tab_raw


tab <- tab_raw |> 
  dplyr::group_by(mesa) |> 
  dplyr::mutate(numero_pessoas = dplyr::n())

library(ggplot2)
tab |> 
  dplyr::group_by(mesa) |> 
  dplyr::summarise(numero_pessoas = dplyr::n()) |> 
  dplyr::filter(mesa != "m00") |> 
  ggplot() +
  aes(x = numero_pessoas) |> 
  geom_histogram(binwidth = 1)




tab |> 
  dplyr::filter(numero_pessoas != 8) |> 
  dplyr::group_split(mesa)

tab_raw |> 
  dplyr::arrange(mesa) |> 
  dplyr::count(mesa) 
