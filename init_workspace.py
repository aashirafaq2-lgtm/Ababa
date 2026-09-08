import os

folders = [
    "assets/branding",
    "assets/animations",
    "lib/core/network",
    "lib/core/theme",
    "lib/core/errors",
    "lib/features/product_catalog/data/datasources",
    "lib/features/product_catalog/data/models",
    "lib/features/product_catalog/domain/entities",
    "lib/features/product_catalog/domain/usecases",
    "lib/features/product_catalog/presentation/bloc",
    "lib/features/product_catalog/presentation/pages",
    "lib/features/instant_negotiation/presentation/pages"
]

for folder in folders:
    os.makedirs(folder, exist_ok=True)
    print(f"Created: {folder}")

# Move logo if exists
import glob
logos = glob.glob("assets/baba_logo_*.png")
if logos:
    os.rename(logos[0], "assets/branding/logo.png")
    print("Moved logo to assets/branding/logo.png")
