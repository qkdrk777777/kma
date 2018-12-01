library(DUcj)
library(devtools)

install_version("binman", version = "0.1.0", repos = "https://cran.uni-muenster.de/")
install_version("wdman", version = "0.2.2", repos = "https://cran.uni-muenster.de/")
install_version("RSelenium", version = "1.7.1", repos = "https://cran.uni-muenster.de/")
library(RSelenium);library(rvest);library(httr);library(stringr);library(RCurl)#등등
package(rvest)
package(httr)
package(XML)
package(RCurl)
package(stringr)
package(progress)
library(XML);library(progress)
pJS=NULL;n=4500
while(length(pJS)==0){
  try(silent = T,{
    n=as.integer(n)+1L
    pJS <- wdman::phantomjs(port = n)
  })
}
#############
rD=NULL;eCaps=NULL
while((length(rD)==0)|(length(eCaps)==0)){
  n=as.integer(n)+1L
  eCaps <- list(
    chromeOptions =
      list(prefs = list(
        "profile.default_content_settings.popups" = n,
        "download.prompt_for_download" = FALSE,
        "download.default_directory" = "D:/del"
      )
      )
  )
  try(silent = T,{
    rD <- rsDriver(extraCapabilities = eCaps)
  })
}
remDr <- rD$client
#############
cprof=getChromeProfile('C:/Users/qkdrk/Desktop/예보',"Profile 1")
remDr <- remoteDriver(port=4567, browserName = 'chrome',extraCapabilities =cprof)
remDr$open()#드라이버 실행


setwd('S:/Users/창제/예보')
area=read.csv(list.files(pattern='위경도.csv'))

xy=unique(area[,5:6])
xy$lat=NA
xy$lon=NA
for(i in i:nrow(xy)){
url=paste0('http://www.weather.go.kr/weather/forecast/digital_forecast.jsp?x=',xy[i,1],'&y=',xy[i,2])
remDr$navigate(url)
lonlat=remDr$findElement(using='class name',value='timeseries_subn3')
line=lonlat$getElementText()[[1]]
del=substr(line,1,gregexpr(',',line)[[1]][2]-1)
library(stringr)
xy[i,4]=as.numeric(substr(del,regexpr('\\(',del)+1,regexpr(',',del)-1))
xy[i,3]=as.numeric(substr(del,regexpr(',',del)+1,regexpr(')',del)-1))
print(round(i/nrow(xy)*100),1)
}
i=3

for(i in 3:6)
  area[,i]=as.character(area[,i])
area=merge(area,xy,by=c('격자.X','격자.Y'))

from_crs='+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs'
setwd('D:/package/kma')
devtools::use_data(area, internal = F,overwrite=T)
remDr$close()
# library(devtools)
# install_github('qkdrk777777/kma')
# data()
# library(kma)
# area
