from typing import Iterator

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_apoderado_data(
    schema_size: int, rows_amount: int, persona_keys_iterator: Iterator[str]
):
    apoderado_keys: list[str] = []
    file, writer = setup_csv_writer(f"apoderado_data_{schema_size}")

    writer.writerow(["dni", "numeroCelular"])

    for _ in range(rows_amount):
        dni = next(persona_keys_iterator)
        numero_celular = faker.phone_number()

        apoderado_keys.append(dni)

        writer.writerow([dni, numero_celular])

    file.close()

    return tuple(apoderado_keys)
