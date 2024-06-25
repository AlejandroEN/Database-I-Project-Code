from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_grado_data(schema_size: int, rows_amount: int):
    grado_keys: list[int] = []
    file, writer = setup_csv_writer(f"grado_{schema_size}.csv")

    writer.writerow(["id", "nombre"])

    for i in range(rows_amount):
        grado_id = i
        nombre = faker.name()

        grado_keys.append(grado_id)

        writer.writerow([grado_id, nombre])

    file.close()

    return tuple(grado_keys)
