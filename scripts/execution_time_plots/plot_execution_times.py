import matplotlib.pyplot as plt


def plot_execution_times(data_dict: dict[str, dict[str, float]], image_file_path: str):
    sizes = list(data_dict.keys())
    unindexed = [data_dict[size]["unindexed"] for size in sizes]
    indexed_default = [data_dict[size]["indexed_default"] for size in sizes]
    indexed_custom = [data_dict[size]["indexed_custom"] for size in sizes]

    plt.figure(figsize=(10, 8))
    plt.plot(sizes, unindexed, label="Sin índices", marker="o")
    plt.plot(sizes, indexed_default, label="Con índices por defecto", marker="o")
    plt.plot(
        sizes,
        indexed_custom,
        label="Con índices por defecto más índices personalizados",
        marker="o",
    )

    plt.xlabel("Cantidad de registros")
    plt.ylabel("Tiempo promedio de ejecución (ms)")
    plt.title("Comparación de Consultas")
    plt.legend()
    plt.grid(True)
    plt.savefig(image_file_path, dpi=300)

    print(f"Plot saved as {image_file_path}")
