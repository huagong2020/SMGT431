#create seasons
season <- 2010:2019

#we use lapply function to loop through 5 MLB seasons
mlb_team_standings_2015191 <- lapply(season,function(x) {
  
  mlb_data1 <- read_html(paste0('https://www.basketball-reference.com/leagues/NBA_',x,'.html'))  %>% #note here I concatenate season with baseball reference url
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%    # find comment sections
    paste(collapse = '') %>%    # convert to strings
    read_html() %>%    # reparse to HTML
    html_nodes('#misc_stats tr td') %>% #the 'expanded_standings_overall' table contains data we want
    html_text()
  

  #convert a vector to a date frame
  mlb_data <- data.frame(matrix(mlb_data1,ncol=27,byrow=T),stringsAsFactors = F)
  #add seasons to each data frame
  mlb_data$season <- x
  #remove the last row of the data

  return(mlb_data)
  
})

#mlb_team_standings_1915191 is a list of data frames. Here we are trying to combine the list of data frames into one big data frame
mlb_team_standings_201519 <- do.call(rbind,mlb_team_standings_2015191)

mlb_team_standings_201519  <- mlb_team_standings_201519 %>% filter( X1 != 'League Average')



mlb_data_header <- read_html(paste0('https://www.basketball-reference.com/leagues/NBA_',x,'.html'))  %>% #note here I concatenate season with baseball reference url
  html_nodes(xpath = '//comment()') %>%
  html_text() %>%    # find comment sections
  paste(collapse = '') %>%    # convert to strings
  read_html() %>%    # reparse to HTML
  html_nodes('#misc_stats thead tr:nth-child(2) th') %>% #the 'expanded_standings_overall' table contains data we want
  html_text()

colnames(mlb_team_standings_201519)[1:27] <-mlb_data_header[2:28]

colnames(mlb_team_standings_201519)[21:24] <-paste0('OPP_',colnames(mlb_team_standings_201519)[21:24])

mlb_team_standings_201519[,17:24] <- sapply(mlb_team_standings_201519[,17:24],function(x){
                                          as.numeric(x)
                                            
                                      })


write.csv(mlb_team_standings_201519,'four_factor_model_data.csv',row.names = F)
