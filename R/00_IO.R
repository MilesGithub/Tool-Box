
# Save/Load R object .rds file
saveRDS(data, paste0("data.rds"))
data <- readRDS(paste0("data.rds"))

# Save/Load R object binary workspace (.RData)
save(data, file = paste0("data.RData"))
load(paste0("data.RData"))

# Write/Read table TSV
write.table(data, paste0("data.tsv"), sep = "\t", quote=F, row.names = F)
data <- read.table(paste0("data.tsv"), sep = "\t", header = TRUE)

# Write/Read table CSV
write.table(data, paste0("data.csv"), sep = ",", quote=F, row.names = F)
data <- read.table(paste0("data.csv"), sep = ",", header = TRUE)

# Write/Read Excel file (openxlsx package)
library(openxlsx)
write.xlsx(data, file = paste0("data.xlsx"))
data <- read.xlsx(paste0("data.xlsx"), sheet = 1)

# Write/Read JSON file (jsonlite package)
library(jsonlite)
write_json(data, path = paste0("data.json"))
data <- read_json(path = paste0("data.json"))

# Read Delim
data <- read.delim("data.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE, na.strings = "NA")

# Save plot to PDF file
p<-ggplot(data, aes(x=x, y=y)) +
  geom_point(alpha = 1.2,size=3)+
  
pdf(paste0("data.pdf"), width=3, height=5)
print(p)
dev.off()



# Arrange plots in a grid
library(gridExtra)
grid <- grid.arrange(p1, p2, p3, p4, ncol = 2)

# Save the grid as a PDF
pdf("grid_plot.pdf", width = 10, height = 8)
grid.draw(grid)
dev.off()

