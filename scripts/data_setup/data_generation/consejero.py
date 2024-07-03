import random
from typing import Iterator

from scripts.utils import setup_csv_writer


def generate_consejero_data(
    schema_size: int,
    rows_amount: int,
    colaborador_keys_iterator: Iterator[str],
    sede_keys: tuple[int, ...],
):
    file, writer = setup_csv_writer(f"consejero_data_{schema_size}")
    consejero_keys: list[str] = []

    writer.writerow(["dni", "sede_id"])

    for _ in range(rows_amount):
        dni = next(colaborador_keys_iterator)
        sede_id = random.choice(sede_keys)

        consejero_keys.append(dni)

        writer.writerow([dni, sede_id])

    file.close()

    return tuple(consejero_keys)
