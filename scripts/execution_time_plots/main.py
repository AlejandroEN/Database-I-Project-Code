import json
import os

from scripts.execution_time_plots.plot_execution_times import plot_execution_times
from scripts.utils.get_file_content import get_file_content


for root, dirs, files in os.walk(r".\assets\json"):
    for file in files:
        json_file_path = os.path.join(root, file)
        json_file = get_file_content(json_file_path)
        data = json.loads(json_file)
        image_file_path = os.path.join(r".\assets\images", file[0:-5])
        plot_execution_times(data, image_file_path)
