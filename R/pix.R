
# gerar links pix ---------------------------------------------------------


url_sheets <- "https://docs.google.com/spreadsheets/d/1_VsPKJZ6wz2HvabvGI6V-oW-1923KE_FyfKsvy-T2yc/edit#gid=0"

categorias <- c("utensilios_domesticos", "cama_mesa_banho", "mimos_noiva", "mimos_noivo", "eletroportateis", "moveis", "eletrodomesticos", "luademel")
googlesheets4::gs4_auth(email = Sys.getenv("GSHEETS_EMAIL"))

planilha_presentes <- googlesheets4::read_sheet(url_sheets) |> 
  dplyr::select(categoria, item, pix_code, pix_img) |> 
  dplyr::filter(is.na(pix_img)) |> 
  dplyr::filter(categoria %in% categorias)


transforma_pix_em_link <- function(pix_code) {
  if (is.na(pix_code)) return(NA_character_)
  f <- tempfile("pix", fileext = ".svg")
  img_qrcode <- tempfile("pix", fileext = ".png")
  
  pix_code |>
    qrcode::qr_code() |>
    qrcode::generate_svg(f, show = FALSE, size = 300)
  
  rsvg::rsvg_png(f, img_qrcode)
  imgur <- knitr::imgur_upload(img_qrcode, key = Sys.getenv("IMGUR_CASAMENTO"))
  imgur[1]
}

planilha_com_codigo <- planilha_presentes |> 
  dplyr::mutate(
    pix_img = purrr::map_chr(pix_code, transforma_pix_em_link, .progress = TRUE)
  )

cat(planilha_com_codigo$pix_img, sep = "\n")
