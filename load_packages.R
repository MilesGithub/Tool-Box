# List of packages to check and install
packages <- c("ggplot2", "Seurat", "dplyr", "BiocManager", "SingleCellExperiment")

# Function to check if a package is installed
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    if (pkg %in% rownames(installed.packages())) {
      return(TRUE)
    } else if (pkg %in% BiocManager::available()) {
      BiocManager::install(pkg)
    } else {
      install.packages(pkg)
    }
  }
}

# Apply function to each package
lapply(packages, install_if_missing)
