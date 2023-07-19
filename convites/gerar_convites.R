url_google_forms <- "https://docs.google.com/spreadsheets/d/1xea8IfIc69z06u2vI5EotAYd2m5salQfpvrDM6OR83s/edit#gid=505362067"

form_raw <-
  googlesheets4::read_sheet(url_google_forms, sheet = "convidados_nucleo") # Aqui será solicitado a autenticação do google

lista_convite <- form_raw |>
  tidyr::drop_na(nomes_arrumados) |>
  dplyr::filter(status_envio == FALSE) |> 
  # dplyr::filter(stringr::str_detect(nomes_arrumados, "João")) |> 
  tibble::rowid_to_column() |> 
  dplyr::mutate(
    data_envio = Sys.Date(),
    data_max_resposta = data_envio + 30,
    data_max = format(data_max_resposta, "%d/%m/%y"),
    url_site = "https://beaeju.com.br/",
    nome_clean = janitor::make_clean_names(nomes_arrumados),
    nome_arquivo = glue::glue("convites/convites_{parte}/Convite_{nome_clean}.png")
  )

# criar as pastas
lista_convite$nome_arquivo |> dirname() |> unique() |> fs::dir_create()


gerar_convite <- function(dados_convite) {
  magick::image_read("convites/convite-base.png") |>
    magick::image_annotate(
      text = dados_convite$nomes_arrumados,
      size = 100,
      location = "0x0 +0 -200",
      gravity = "center",
      font = "PT Serif"
    ) |>
    magick::image_annotate(
      text = dados_convite$data_max,
      size = 80,
      location = "0x0 +0 +1750",
      gravity = "center",
      font = "PT Serif"
    ) |> 
    magick::image_write(path = dados_convite$nome_arquivo)
  
  usethis::ui_info("Convite gerado: {dados_convite$nome_arquivo}")
}

lista_convite |> 
  dplyr::group_split(rowid) |> 
  purrr::map(gerar_convite)
