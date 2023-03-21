
# gerar links pix ---------------------------------------------------------


url_sheets <- "https://docs.google.com/spreadsheets/d/1_VsPKJZ6wz2HvabvGI6V-oW-1923KE_FyfKsvy-T2yc/edit#gid=0"

googlesheets4::gs4_auth(email = Sys.getenv("GSHEETS_EMAIL"))

planilha_presentes <- googlesheets4::read_sheet(url_sheets) |> 
  dplyr::select(categoria, item, pix_code)


pix_code <- planilha_presentes$pix_code[1]

transforma_pix_em_link <- function(pix_code) {
  
  f <- tempfile("pix", fileext = ".svg")
  img_qrcode <- tempfile("pix", fileext = ".png")
  
  pix_code |>
    qrcode::qr_code() |>
    qrcode::generate_svg(f, show = FALSE, size = 300)
  
  rsvg::rsvg_png(f, img_qrcode)
  imgur <- knitr::imgur_upload(img_qrcode, key = Sys.getenv("IMGUR_CASAMENTO"))
  imgur[1]
}
transforma_pix_em_link(pix_code)

