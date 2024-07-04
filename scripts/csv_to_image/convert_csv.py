import matplotlib.font_manager as fm
import pandas as pd
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure


def convert_csv_to_image(csv_file_path: str, image_file_path: str):
    df = pd.read_csv(csv_file_path, dtype=str)

    figure = Figure(figsize=(12, 8), dpi=300)
    canvas = FigureCanvas(figure)

    axes = figure.add_subplot(111)
    axes.axis("tight")
    axes.axis("off")

    table = axes.table(
        cellText=df.values, colLabels=df.columns, cellLoc="left", loc="center"
    )

    for key, cell in table.get_celld().items():
        cell.set_text_props(ha="left", font=fm.FontProperties(family="monospace"))
        cell.set_edgecolor("white")

    figure.tight_layout(pad=0.5)
    table.auto_set_font_size(False)
    table.set_fontsize(10)

    table.scale(1.2, 1.2)

    bbox = table.get_window_extent(canvas.get_renderer())
    figure.set_size_inches(bbox.width / figure.dpi, bbox.height / figure.dpi)

    figure.savefig(image_file_path, bbox_inches="tight", pad_inches=0.1)

    print(f"Table saved as {image_file_path}")
