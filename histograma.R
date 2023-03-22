library(ggplot2)
url_sheets <- "https://docs.google.com/spreadsheets/d/1_VsPKJZ6wz2HvabvGI6V-oW-1923KE_FyfKsvy-T2yc/edit#gid=0"

googlesheets4::gs4_auth(email = Sys.getenv("GSHEETS_EMAIL"))

planilha_presentes <- googlesheets4::read_sheet(url_sheets) 


sum(planilha_presentes$estimativa_preco)


# hist(planilha_presentes$preco_cota)


planilha_presentes |> 
  ggplot() +
  geom_histogram(aes(x = preco_cota),
                 binwidth = 100) #+
  # scale_x_continuous(breaks = seq(0, 1000, 100))
