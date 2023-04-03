library(rjson)
library(ggplot2)
library(ggtree)
library(tidytree)


#url<-"https://github.com/irepansalvador/Challenge_2/blob/16f9b497e854385da6a8adf3bf178acc21920f07/json-celllineage_MOD.js"



# get timings from http://wormweb.org/celllineage#c=Eprp&z=0.37
timings=data.frame(stage=c("fertilisation","hatch","L1molt","L2molt",
                            "L3molt","L4molt"),
                   time=c(0,800,1760,2300,2840,3500))



tbl<-read.delim(file="lineage_wormweb.tsv",header=F)
names(tbl)<-c("did","id","name","levelTime","totalTime","deathTime","type","children","childBirth")
head(tbl)
dim(tbl[tbl$deathTime==0 & !is.na(tbl$childBirth),])
#tbl<-tbl[,c(2,1,3:ncol(tbl))]

# how many cells at hatch
tbl %>% dplyr::filter(totalTime<timings$time[timings$stage=="hatch"],
  childBirth>timings$time[timings$stage=="hatch"] | children=="",deathTime==0)
#should be 558

# how many cells are born between L1 and L3
tbl %>% dplyr::filter(totalTime>timings$time[timings$stage=="hatch"] , totalTime<timings$time[timings$stage=="L3molt"]) %>% filter(children!="") %>% nrow()

tbl

# how many mitoses between L1 and L3
tbl %>% dplyr::filter(childBirth>timings$time[timings$stage=="hatch"]+180 , childBirth<timings$time[timings$stage=="L3molt"]) %>% nrow()

which.min(abs(tbl$totalTime-800))

tree <- read.tree("lineage_wormweb.nwk")
progenitors<-c("P0","P1","P2","P3","P4","D","C","EMS","E","MS","AB")
tbl[tbl$name %in% progenitors & tbl$childBirth<800,]


p<-ggtree(tree) + theme_tree2() +
  geom_vline(xintercept=timings$totalTime,colour="lightgrey",alpha=0.5) +
  geom_text(data=timings,mapping=aes(x=time,y=1150,label=stage)) +
  coord_cartesian(ylim=c(-20,1170))
p <-p %<+% tbl + geom_tippoint(aes(color=type))+
    scale_fill_gradientn(colors = RColorBrewer::brewer.pal(9, "YlGnBu"))
p%<+% tbl[tbl$name %in% progenitors & tbl$childBirth<800,] +
  geom_nodelab(aes(x=totalTime,label=name),geom="label")

  ggsave("LineageByTissue.png",plot=p,device="png",width=10,height=8)
