import subprocess
import sys
import importlib

packages = {
    "matplotlib": "matplotlib",
    "seaborn": "seaborn",
    "scanpy": "scanpy",
    "pandas": "pandas",
    "bioconda-bioconductor-singlecellexperiment": "SingleCellExperiment"
}


def install_package(package_name, pip_name=None):
    """Check if a package is installed, install if missing, and import it."""
    if pip_name is None:
        pip_name = package_name
    
    try:
        importlib.import_module(package_name)
        print(f"Package already installed: {package_name}")
    except ImportError:
        print(f"Installing: {package_name}")
        subprocess.check_call([sys.executable, "-m", "pip", "install", pip_name])
        print(f"Installed: {package_name}")

# Apply function to each package
for pkg_name, pip_name in packages.items():
    install_package(pkg_name, pip_name)

# Load the packages
for pkg_name in packages.keys():
    globals()[pkg_name] = importlib.import_module(pkg_name)
    print(f"Loaded: {pkg_name}")
