import kagglehub # type: ignore
import shutil
import os

path = kagglehub.dataset_download("emanfatima2/spotify-global-hits-and-artist-analytics")
destination = "./seeds"

print(path)

try:
    # If path contains a single directory (like '1/'), extract its contents
    contents = os.listdir(path)

    for item in os.listdir(path):
        shutil.move(os.path.join(path, item), os.path.join(destination, item))
        
    print(f"Moved files to {destination}")
except Exception as e:
    print(f"An error occurred: {e}")
