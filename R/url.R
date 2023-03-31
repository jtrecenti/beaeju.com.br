url <- "https://docs.google.com/spreadsheets/d/1xea8IfIc69z06u2vI5EotAYd2m5salQfpvrDM6OR83s/edit#gid=505362067"

convidados <- googlesheets4::read_sheet(url, "convidados_nucleo")  |>
  tidyr::drop_na(mesa) |> 
  janitor::clean_names()


convidados |>
  dplyr::group_by(mesa) |> 
  dplyr::summarise(total_cadeiras = sum(
    as.numeric(quantidade_criancas_0_5_anos),
    as.numeric(quantidade_criancas_6_10_anos),
    as.numeric(quantidade_adultos_acima_de_11_anos)
  )) |> View()
