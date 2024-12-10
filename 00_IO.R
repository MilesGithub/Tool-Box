
# Save/Load R object .rds file
saveRDS(data, paste0("data.rds"))
data <- readRDS(paste0("data.rds"))

# Write/Read table TSV
write.table(data, paste0("data.tsv"), sep = "\t", quote=F, row.names = F)
data <- read.table(paste0("data.tsv"), sep = "\t", header = TRUE)

# Write/Read table TSV
write.table(data, paste0("data.csv"), sep = ",", quote=F, row.names = F)
data <- read.table(paste0("data.csv"), sep = ",", header = TRUE)

# Read Delim
data <- read.delim("data.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE, na.strings = "NA")

# Save plot to PDF file
p<-ggplot(data, aes(x=x, y=y)) +
  geom_point(alpha = 1.2,size=3)+
  
pdf(paste0("data.pdf"), width=3, height=5)
print(p)
dev.off()

