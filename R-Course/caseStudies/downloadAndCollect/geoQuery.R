
if (!require(GEOquery))
  { source("http://bioconductor.org/biocLite.R")
    biocLite("GEOquery")
  }
require(GEOquery)
listOfStudies <- c("73517", "16476")# c("62564", "3446") # c("45547")
for (studyID in listOfStudies){
  gse <- getGEO(paste0("GSE",studyID), GSEMatrix =TRUE, AnnotGPL=TRUE)
  # class(gse)
  # class(gse[[1]])
  eset <- gse[[1]]
  phenoDat <- pData(eset)
  dim(phenoDat)
  # colnames(phenoDat)
  require(xlsx)
  write.xlsx(phenoDat, file="phenoData.xlsx", sheetName=paste0("GSE",studyID), append=TRUE)
}

