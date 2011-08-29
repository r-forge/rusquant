"getSymbols.Finam" <-
function(Symbols,env,return.class='xts',index.class='Date',
         from='2007-01-01',
         to=Sys.Date(),
         adjust=FALSE,
         period='day',
         ...)
{
     importDefaults("getSymbols.Finam")
     this.env <- environment()
     for(var in names(list(...))) {
        # import all named elements that are NON formals
        assign(var, list(...)[[var]], this.env)
     }

     default.return.class <- return.class
     default.from <- from
     default.to <- to

     if(missing(verbose)) verbose <- FALSE
     if(missing(auto.assign)) auto.assign <- TRUE

     p <- 0

     if ("1min" == period) p <- 2
     if ("5min" == period) p <- 3
     if ("10min" == period) p <- 4
     if ("15min" == period) p <- 5
     if ("30min" == period) p <- 6
     if ("hour" == period) p <- 7
     if ("day" == period) p <- 8
     if ("week" == period) p <- 9
     if ("month" == period) p <- 10

     if (p==0) {
        message(paste("Unkown period ", period))
     }

     finam.URL <- "http://195.128.78.52/table.csv?d=d&market=1&f=table&e=.csv&dtf=1&tmf=1&MSOR=0&sep=1&sep2=1&datf=1&at=1&"

     if (!exists("finam.stock.list")){
        finam.stock.list <- loadStockList()
        assign('finam.stock.list', finam.stock.list, env)
     }

     for(i in 1:length(Symbols)) {

       return.class <- getSymbolLookup()[[Symbols[[i]]]]$return.class
       return.class <- ifelse(is.null(return.class),default.return.class,
                              return.class)
       from <- getSymbolLookup()[[Symbols[[i]]]]$from
       from <- if(is.null(from)) default.from else from
       to <- getSymbolLookup()[[Symbols[[i]]]]$to
       to <- if(is.null(to)) default.to else to

       from.y <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][1])
       from.m <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][2])-1
       from.d <- as.numeric(strsplit(as.character(as.Date(from,origin='1970-01-01')),'-',)[[1]][3])
       to.y <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][1])
       to.m <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][2])-1
       to.d <- as.numeric(strsplit(as.character(as.Date(to,origin='1970-01-01')),'-',)[[1]][3])

       Symbols.name <- getSymbolLookup()[[Symbols[[i]]]]$name
       Symbols.name <- ifelse(is.null(Symbols.name),Symbols[[i]],Symbols.name)
       if(verbose) cat("downloading ",Symbols.name,".....\n\n")
       Symbols.id <- finam.stock.list[Symbols.name]
       tmp <- tempfile()
       stock.URL <- paste(finam.URL,
                           "p=", p,
                           "&em=",Symbols.id,
                           "&df=",from.d,
                           "&mf=",from.m,
                           "&yf=",from.y,
                           "&dt=",to.d,
                           "&mt=",to.m,
                           "&yt=",to.y,
                           "&cn=",Symbols.name,
                           sep='')

       download.file(stock.URL, destfile=tmp, quiet=!verbose)

       fr <- read.csv(tmp, as.is=TRUE)
       unlink(tmp)

       if(verbose) cat("done.\n")

       if (p>7) {
            fr <- xts(as.matrix(fr[,(5:9)]), as.Date(strptime(fr[,3], "%Y%m%d")),
                 src='finam',updated=Sys.time())
       }else {
            fr <- xts(as.matrix(fr[,(5:9)]), as.POSIXct(strptime(paste(fr[,3],fr[,4]), "%Y%m%d %H%M%S")),
                    src='finam',updated=Sys.time())
       }
       colnames(fr) <- paste(toupper(gsub('\\^','',Symbols.name)),
                             c('Open','High','Low','Close','Volume'),
                             sep='.')

       fr <- convert.time.series(fr=fr,return.class=return.class)
       if(is.xts(fr) && p>7)
         indexClass(fr) <- index.class

       Symbols[[i]] <-toupper(gsub('\\^','',Symbols[[i]]))
       if(auto.assign)
         assign(Symbols[[i]],fr,env)
       if(i >= 5 && length(Symbols) > 5) {
         message("pausing 1 second between requests for more than 5 symbols")
         Sys.sleep(1)
       }
     }
     if(auto.assign)
       return(Symbols)

     return(fr)

}


"loadStockList" <-
function (verbose = FALSE){
    stocklist.URL = 'http://www.finam.ru/scripts/export.js'
    tmp <- tempfile()
    download.file(stocklist.URL, destfile=tmp,quiet=!verbose)
    fr <- readLines(con = tmp, warn=FALSE)
    unlink(tmp)
    ids <- sub("var .*?=new Array\\(", "", fr[1])
    ids <- sub("\\);", "", ids)
    ids <- strsplit(ids, ",")

    names <- sub("var .*?=new Array\\(", "", fr[3])
    names <- sub("\\);", "", names)
    names <- gsub("'", "", names)
    names <- strsplit(names, ",")
    res <- unlist(ids)
    names(res) <- unlist(names)
    return(res)
}

#This one is taken from quanmod package since it's not available through the API
"convert.time.series" <-
function (fr, return.class)
{
    if ("quantmod.OHLC" %in% return.class) {
        class(fr) <- c("quantmod.OHLC", "zoo")
        return(fr)
    }
    else if ("xts" %in% return.class) {
        return(fr)
    }
    if ("zoo" %in% return.class) {
        return(as.zoo(fr))
    }
    else if ("ts" %in% return.class) {
        fr <- as.ts(fr)
        return(fr)
    }
    else if ("data.frame" %in% return.class) {
        fr <- as.data.frame(fr)
        return(fr)
    }
    else if ("matrix" %in% return.class) {
        fr <- as.data.frame(fr)
        return(fr)
    }
    else if ("its" %in% return.class) {
        if ("package:its" %in% search() || suppressMessages(require("its",
            quietly = TRUE))) {
            fr.dates <- as.POSIXct(as.character(index(fr)))
            fr <- its::its(coredata(fr), fr.dates)
            return(fr)
        }
        else {
            warning(paste("'its' from package 'its' could not be loaded:",
                " 'xts' class returned"))
        }
    }
    else if ("timeSeries" %in% return.class) {
        if ("package:fSeries" %in% search() || suppressMessages(require("fSeries",  quietly = TRUE))) {
            fr <- timeSeries(coredata(fr), charvec = as.character(index(fr)))
            return(fr)
        }
        else {
            warning(paste("'timeSeries' from package 'fSeries' could not be loaded:", " 'xts' class returned"))
        }
    }
}

"getSymbols.Forts" <-
function(Symbols,env,return.class='xts',index.class='Date',
         from='2007-01-01',
         to=Sys.Date(),
         adjust=FALSE,
         period='day',
         ...)
{
     importDefaults("getSymbols.Forts")
     this.env <- environment()
     for(var in names(list(...))) {
        # import all named elements that are NON formals
        assign(var, list(...)[[var]], this.env)
     }

     default.return.class <- return.class
     default.from <- from
     default.to <- to

     if(missing(verbose)) verbose <- FALSE
     if(missing(auto.assign)) auto.assign <- TRUE

     finam.URL <- "http://www.rts.ru/ru/forts/contractresults-exp.html?"

     for(i in 1:length(Symbols)) {

       return.class <- getSymbolLookup()[[Symbols[[i]]]]$return.class
       return.class <- ifelse(is.null(return.class),default.return.class,
                              return.class)
       from <- getSymbolLookup()[[Symbols[[i]]]]$from
       from <- if(is.null(from)) default.from else from
       to <- getSymbolLookup()[[Symbols[[i]]]]$to
       to <- if(is.null(to)) default.to else to

       from.f <- format(as.Date(from,origin='1970-01-01'), '%Y%m%d')
       to.f <- format(as.Date(to,origin='1970-01-01'), '%Y%m%d')

       Symbols.name <- getSymbolLookup()[[Symbols[[i]]]]$name
       Symbols.name <- ifelse(is.null(Symbols.name),Symbols[[i]],Symbols.name)
       if(verbose) cat("downloading ",Symbols.name,".....\n\n")

       tmp <- tempfile()
       stock.URL <- paste(finam.URL,
                           "day1=", from.f,
                           "&day2=", to.f,
                           "&isin=",gsub(' ', '%20', Symbols.name),
                           sep='')

       download.file(stock.URL, destfile=tmp, quiet=!verbose)

       fr <- read.csv(tmp, as.is=TRUE)
       unlink(tmp)

       if(verbose) cat("done.\n")

      fr <- xts(as.matrix(cbind(fr[,(4:7)], fr[,12]) ), as.Date(strptime(fr[,1], "%d.%m.%Y")),
                src='forts',updated=Sys.time())

       colnames(fr) <- paste(toupper(gsub('[ -.]','',Symbols.name)),
                             c('Open','High','Low','Close', 'Volume'),
                             sep='.')

       fr <- convert.time.series(fr=fr,return.class=return.class)
       if(is.xts(fr))
         indexClass(fr) <- index.class

       Symbols[[i]] <-toupper(gsub('[ -.]','',Symbols[[i]]))
       if(auto.assign)
         assign(Symbols[[i]],fr,env)
       if(i >= 5 && length(Symbols) > 5) {
         message("pausing 1 second between requests for more than 5 symbols")
         Sys.sleep(1)
       }
     }
     if(auto.assign)
       return(Symbols)

     return(fr)

}

"select.hours" <-
function(data, hour){
    return(data[format(index(data), format="%H")==hour])
}