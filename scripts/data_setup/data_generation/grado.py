from scripts.utils import setup_csv_writer


def generate_grado_data(schema_size: int):
    grado_keys: list[int] = []
    file, writer = setup_csv_writer(f"grado_data_{schema_size}")

    writer.writerow(["id", "nombre"])

    grados_names: list[str] = [
        "1er grado de primaria",
        "2do grado de primaria",
        "3er grado de primaria",
        "4to grado de primaria",
        "5to grado de primaria",
        "6to grado de primaria",
        "1er grado de secundaria",
        "2do grado de secundaria",
        "3er grado de secundaria",
        "4to grado de secundaria",
        "5to grado de secundaria",
    ]

    for i in range(len(grados_names)):
        grado_id = i
        nombre = grados_names[i]

        grado_keys.append(grado_id)

        writer.writerow([grado_id, nombre])

    file.close()

    return tuple(grado_keys)
