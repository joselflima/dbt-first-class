import kagglehub # type: ignore
import shutil
import os

path = kagglehub.dataset_download("abbas829/bank-customer-churn")
destination = "./seeds"

try:
    # If path contains a single directory (like '1/'), extract its contents
    contents = os.listdir(path)
    if len(contents) == 1 and os.path.isdir(os.path.join(path, contents[0])):
        inner_path = os.path.join(path, contents[0])
        for item in os.listdir(inner_path):
            shutil.move(os.path.join(inner_path, item), os.path.join(destination, item))
    else:
        # Move all contents directly
        for item in os.listdir(path):
            shutil.move(os.path.join(path, item), os.path.join(destination, item))
    print(f"Moved files to {destination}")
except Exception as e:
    print(f"An error occurred: {e}")
