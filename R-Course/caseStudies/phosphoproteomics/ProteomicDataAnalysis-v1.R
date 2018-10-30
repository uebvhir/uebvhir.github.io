## ----global_options, include=FALSE---------------------------------------
knitr::opts_chunk$set(fig.width=10, fig.height=6, cache=FALSE, 
                      echo=TRUE, warning=FALSE, message=FALSE, results ='markup')
options(warn=-1, width=100)

## ----installation, echo=FALSE--------------------------------------------
installifnot <- function (packageName){
 if (!(require(packageName, character.only=TRUE))) {
    install.packages(packageName)
  }else{
    detach(paste ("package", packageName, sep=":"), character.only=TRUE)
  } 
}
installifnot("knitr")
installifnot("readxl")
installifnot("writexl")
installifnot("tidyverse")

## ------------------------------------------------------------------------
require(readxl)
phData <- read_excel(path= "TIO2+PTYR-human-MSS+MSIvsPD.XLSX", sheet=1)
head(phData)
targets <- read_excel(path= "TIO2+PTYR-human-MSS+MSIvsPD.XLSX", sheet=2)
show(targets)

## ------------------------------------------------------------------------
library(tidyverse)
abundances <- phData %>% select (5:16) 
head(abundances)

## ------------------------------------------------------------------------
newRownames <- make.names(phData$Accession, unique=TRUE)
abundances <- as.data.frame(abundances)
rownames(abundances) <- newRownames
head(abundances)

## ------------------------------------------------------------------------
summary(abundances)

## ------------------------------------------------------------------------
library(ggplot2)
ggplot(abundances)+geom_histogram(aes(x=M1_1_MSS),bins=20)

## ------------------------------------------------------------------------
boxplot(abundances)

## ------------------------------------------------------------------------
boxplot(log10(abundances+1), las=2, main="Phosphoproteomics Experiment. Abundance in log 10 scale")

## ------------------------------------------------------------------------
logDat <- abundances %>% 
  gather() %>%
  mutate (logvalues= log (value+1)) %>%
  select (logvalues, key)
head(logDat)

## ------------------------------------------------------------------------
library(ggplot2)
ggplot(logDat) + 
  geom_boxplot(aes(x = key, y = logvalues))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("Phosphoproteomics Abundances (log 10 scale)")

## ------------------------------------------------------------------------
originalKey <- factor(logDat$key, levels=colnames(abundances))
ggplot(logDat) + 
  geom_boxplot(aes(x = originalKey, y = logvalues))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("Phosphoproteomics Abundances (log 10 scale)")

## ------------------------------------------------------------------------
library(stringr)
covs <- str_split(logDat$key, "_", simplify=TRUE)
colnames(covs)<- c("Sample", "Replicate", "Group")
logDat2 <- cbind(logDat,covs)

## ------------------------------------------------------------------------
ggplot(logDat2) + 
  geom_boxplot(aes(x = originalKey, y = logvalues, fill=Group, colour=Replicate))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("Phosphoproteomics Abundances (log 10 scale)")

## ------------------------------------------------------------------------
source("https://raw.githubusercontent.com/uebvhir/UEB_PCA/master/UEB_plotPCA3.R")
plotPCA3(datos=as.matrix(log10(abundances+1)), labels=colnames(abundances), 
         factor=targets$Phenotype,title ="Phosphoproteomic data",
         scale=FALSE, colores=1:2, size = 3.5, glineas = 2.5)

## ------------------------------------------------------------------------
if (!(require(limma))){
  source("http://bioconductor.org/biocLite.R")
  biocLite("limma")
}

## ------------------------------------------------------------------------
library(limma)
targets <- as.data.frame(targets)
groups <- as.factor(targets$Phenotype)
designMat <- model.matrix(~ -1 + groups)
show(designMat)

## ------------------------------------------------------------------------
if (!require(statmod)) install.packages("statmod")
dupcor <- duplicateCorrelation(abundances, designMat,block=targets$Individual)
dupcor$consensus.correlation

## ------------------------------------------------------------------------
require(limma)
contMat <- makeContrasts(mainEff=groupsPD-groupsMSS, levels=designMat)
show(contMat)

## ------------------------------------------------------------------------
fit <- lmFit(abundances, designMat, block=targets$Individual,correlation=dupcor$consensus)
fit2 <- contrasts.fit(fit, contMat)
fit2 <- eBayes(fit2)
results<- topTableF(fit2, adjust="BH",  number=nrow(abundances))
head(results)

## ------------------------------------------------------------------------
volcanoplot(fit2, highlight=10, names=rownames(abundances), cex=0.75,
            xlim=c(-1e+06,1e+06))

