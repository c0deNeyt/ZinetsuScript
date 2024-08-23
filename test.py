import importlib

def check_library_installed(library_name):
    try:
        module = importlib.import_module(library_name)
        print(f"{library_name} is installed. Version: {module.__version__}")
    except ImportError:
        print(f"{library_name} is not installed.")

# List of libraries to check
libraries = ["numpy", "openpyxl", "pandas", "pytest", "flask"]

for library in libraries:
    check_library_installed(library)

