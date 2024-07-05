import matplotlib.pyplot as plt


def create_plot(
    sizes: list[str],
    data_list: list[tuple[list[float], str]],
    title: str,
    image_file_path: str,
    colors=None,
):
    if colors is None:
        colors = ["blue", "orange", "green"]

    plt.figure(figsize=(10, 8))

    for (data, label), color in zip(data_list, colors):
        plt.plot(sizes, data, label=label, marker="o", color=color)

    plt.xlabel("Cantidad de registros")
    plt.ylabel("Tiempo promedio de ejecución (ms)")
    plt.title(title)
    plt.legend()
    plt.grid(True)
    plt.savefig(image_file_path, dpi=300)

    print(f"Plot saved as {image_file_path}")


def plot_execution_times(data_dict: dict[str, dict[str, float]], image_file_path: str):
    sizes = list(data_dict.keys())
    unindexed = [data_dict[size]["unindexed"] for size in sizes]
    indexed_default = [data_dict[size]["indexed_default"] for size in sizes]
    indexed_custom = [data_dict[size]["indexed_custom"] for size in sizes]

    data_1: list[tuple[list[float], str]] = [
        (unindexed, "Sin índices"),
        (indexed_default, "Con índices por defecto"),
        (indexed_custom, "Con índices por defecto más índices personalizados"),
    ]

    create_plot(
        sizes, data_1, "Comparación de todos los esquemas", image_file_path + "_1"
    )

    data_2 = data_1[1:]

    create_plot(
        sizes,
        data_2,
        "Comparación de los esquemas con índices",
        image_file_path + "_2",
        colors=["orange", "green"],
    )
