#!/usr/bin/env Rscript
library(dplyr)
library(data.table)

w<-function(d, f) write.table(d, f, row.names=F, quote=F, sep="\t")

d <-
 Sys.glob("/Volumes/L/bea_res/Data/Tasks/BarsScan/Basic/*/*/Scored/txt/*.[1-5].trial.txt") %>%
 lapply(function(x) read.csv(x, sep="\t") %>%
 mutate(id=gsub(".*/(1[0-9.]+).trial.txt", "\\1", x)))  %>%
 bind_rows %>%
 select(id, trial, xdat, lat, Count) %>%
 tidyr::separate(id, c("luna", "date", "run"))

w(d, "deepu_all_bars_scan_trials.txt")


smry <- d %>%
 group_by(luna, date) %>%
 summarise(ncor=length(which(Count==1)),
           n=n(),
           acc=ncor/n,
           ndropped=length(which(Count==-1)),
           meanlat=mean(lat[Count==1]))

xdat_to_rtype <- function(x)
  cut(x,
      breaks=c(0, 130, 150, Inf),
      labels=c("pun", "neut", "rew"))

s_long <-
 d  %>%
 mutate(rtype =  xdat_to_rtype(as.numeric(xdat)) ) %>%
 group_by(luna, date, rtype) %>%
 summarise(ncor=length(which(Count==1)),
           n=n(),
           acc=ncor/n,
           ndropped=length(which(Count==-1)),
           meanlat=mean(lat[Count==1])) %>%
           filter(!is.na(rtype))
data.table::setDT(s_long)
s_wide <-
  data.table::dcast(s_long, luna+date~rtype, value.var=c("meanlat", "acc"))

w(smry, "deepu_all_bars_scan_smry.txt")
w(s_long, "deepu_bars_rtype_long.txt")
w(s_long, "deepu_bars_rtype_wide.txt")
