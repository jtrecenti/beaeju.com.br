# lista do chatgpt --------------------------------------------------------


imagens <- readr::read_csv("data-raw/chatgpt.csv") |> 
  with(item) |> 
  purrr::map(openai::create_image, size = "256x256")


links_img <- imagens |> 
  purrr::map_chr(\(x) x$data[[1]])


tab_img <- readr::read_csv("data-raw/chatgpt.csv") |> 
  dplyr::mutate(url_imagem = links_img) |> 
  dplyr::transmute(
    categoria = "chatgpt", item = paste(item, descricao, sep = " - "),
    estimativa_preco = valor, foto = url_imagem
  ) |> 
  dplyr::mutate(
    estimativa_preco = dplyr::if_else(
      estimativa_preco < 200, 
      estimativa_preco * 10, 
      estimativa_preco
    )
  )

googlesheets4::sheet_append(
  "https://docs.google.com/spreadsheets/d/1_VsPKJZ6wz2HvabvGI6V-oW-1923KE_FyfKsvy-T2yc/edit#gid=0", 
  tab_img, 1
)



# lua de mel --------------------------------------------------------------


imagens <- readr::read_csv("data-raw/chatgpt_luademel.csv") |> 
  with(item) |> 
  purrr::map(openai::create_image, size = "256x256", .progress = TRUE)

links_img <- imagens |> 
  purrr::map_chr(\(x) x$data[[1]])

tab_img <- readr::read_csv("data-raw/chatgpt_luademel.csv") |> 
  dplyr::mutate(url_imagem = links_img) |> 
  dplyr::transmute(
    categoria = "luademel", item = paste(item, descricao, sep = " - "),
    estimativa_preco = valor, foto = url_imagem
  ) |> 
  dplyr::mutate(
    estimativa_preco = dplyr::if_else(
      estimativa_preco < 200, 
      estimativa_preco * 10, 
      estimativa_preco
    )
  )

googlesheets4::sheet_append(
  "https://docs.google.com/spreadsheets/d/1_VsPKJZ6wz2HvabvGI6V-oW-1923KE_FyfKsvy-T2yc/edit#gid=0", 
  tab_img, 1
)
