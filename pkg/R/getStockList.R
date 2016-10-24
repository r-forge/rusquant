



install_github("arbuzovv/rusquant")

#http://moex.com/iss/index.xml

# shares
for(i in 0:50)
{
  list.URL = paste("http://moex.com/iss/history/engines/stock/markets/shares/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}


# bonds
for(i in 0:65)
{
  list.URL = paste("http://moex.com/iss/history/engines/stock/markets/bonds/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}


# commodity
for(i in 0:4)
{
  list.URL = paste("http://moex.com/iss/history/engines/commodity/markets/futures/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}

# commodity
for(i in 0:4)
{
  list.URL = paste("http://moex.com/iss/history/engines/commodity/markets/futures/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}



#index
for(i in 0:5)
{
  list.URL = paste("http://moex.com/iss/history/engines/stock/markets/index/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}

#Forts main срочный рынок
for(i in 0:5)
{
  list.URL = paste("http://moex.com/iss/history/engines/futures/markets/main/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}


#currency
for(i in 0:5)
{
  list.URL = paste("http://moex.com/iss/history/engines/currency/markets/basket/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}


#futures
for(i in 0:5)
{
  list.URL = paste("http://moex.com/iss/history/engines/futures/markets/forts/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}


#options
for(i in 0:5)
{
  list.URL = paste("http://moex.com/iss/history/engines/futures/markets/options/listing.csv?start=",i*100,sep='')
  tmp <- tempfile()
  download.file(list.URL, destfile=tmp,quiet = TRUE)
  if(i == 0) STOCKlist <- read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE)
  if(i != 0) STOCKlist <- rbind(STOCKlist,read.csv(tmp, sep=";", skip=2, quote = "", stringsAsFactors=FALSE))
  unlink(tmp)
}





























