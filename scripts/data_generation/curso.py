from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_curso_data(schema_size: int, rows_amount: int):
    curso_keys: list[int] = []
    file, writer = setup_csv_writer(f"curso_{schema_size}.csv")

    writer.writerow(["id", "nombre"])

    for i in range(rows_amount):
        curso_id = i
        nombre = faker.name()

        curso_keys.append(curso_id)

        writer.writerow([curso_id, nombre])

    file.close()

    return tuple(curso_keys)
