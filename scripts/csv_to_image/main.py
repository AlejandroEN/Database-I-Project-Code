import os

from scripts.csv_to_image.convert_csv import convert_csv_to_image

for root, dirs, files in os.walk(r".\assets\csv"):
    for subdir in dirs:
        subdir_path = os.path.join(root, subdir)
        for csv_file in os.listdir(subdir_path):
            csv_file_path = os.path.join(root, subdir, csv_file)
            image_file_dir = csv_file[0:7] + "_csv"
            image_file_path = os.path.join(r".\assets\images", image_file_dir, csv_file[0:-4])
            convert_csv_to_image(csv_file_path, image_file_path)
