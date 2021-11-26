library(tidyverse)
files=c("parliament.csv",
        "hapiscore_whr.csv",
        "aged_15plus_unemployment_rate_percent.csv",
        "right.csv",
        "sanitation.csv",
        "hdiindex.csv",
        "edu.csv",
        "internetusers.csv",
        "sdi.csv",
        "forestcoverage.csv",
        "militaryexpenditure.csv",
        "mortality.csv",
        "wateraccess.csv",
        "broadband.csv",
        "agriculture.csv",
        "debt.csv",
        "gdppercapita_growth.csv",
        "foodinsecurity.csv")
download_and_create_df=function(link){
  root="https://raw.githubusercontent.com/nangokosu/math-245-project/main/data/"
  df=read_csv(paste0(root,link))
  col_name=str_replace(link,".csv","")
  final_df=gather(df, key="year", value=col_name,-country)
  colnames(final_df)[3]=col_name
  final_df=mutate(final_df, year=as.numeric(year))
  return(final_df)
}
final_dfs=lapply(files,download_and_create_df)
full_data=final_dfs%>%reduce(full_join,by=c("country","year"))
full_data2=full_data%>%filter(year==2014)

# Renaming certain columns to match original data assembling file
full_data2$aged_15plus_unemployment_rate_percent <- as.numeric(as.character(full_data2$aged_15plus_unemployment_rate_percent))
full_data2$right <- as.numeric(as.character(full_data2$right))*100
full_data2$sanitation <- as.numeric(as.character(full_data2$sanitation))*100
full_data2$parliament <- as.numeric(as.character(full_data2$parliament))*100
full_data2$hapiscore_whr <- as.numeric(as.character(full_data2$hapiscore_whr))*100
full_data2$internetusers <- as.numeric(full_data2$internetusers)
full_data2$broadband<-as.numeric(full_data2$broadband)
full_data2$militaryexpenditure<-as.numeric(full_data2$militaryexpenditure)
full_data2$gdppercapita_growth<-as.numeric(full_data2$gdppercapita_growth)


# Write to RDS
saveRDS(full_data2,"./merged_gapminder_happiness.rds")
