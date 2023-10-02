url_sheet <- "https://docs.google.com/spreadsheets/d/1xea8IfIc69z06u2vI5EotAYd2m5salQfpvrDM6OR83s/edit#gid=1246342455"

tab <- googlesheets4::read_sheet(url_sheet, "convidados_por_pessoa") |> 
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

tab |> 
  dplyr::ungroup() |> 
  dplyr::distinct(mesa, numero_pessoas) |> 
  dplyr::count(numero_pessoas)
