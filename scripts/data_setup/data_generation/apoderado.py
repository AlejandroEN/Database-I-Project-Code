from typing import Iterator

from scripts.utils import faker
from scripts.utils import setup_csv_writer


def generate_apoderado_data(
    schema_size: int, rows_amount: int, persona_keys_iterator: Iterator[str]
):
    apoderado_keys: list[str] = []
    file, writer = setup_csv_writer(f"apoderado_data_{schema_size}")

    writer.writerow(["dni", "numero_celular"])

    for _ in range(rows_amount):
        dni = next(persona_keys_iterator)
        numero_celular = faker.numerify("$%#######")

        apoderado_keys.append(dni)

        writer.writerow([dni, numero_celular])

    file.close()

    return tuple(apoderado_keys)
