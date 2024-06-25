import random
from typing import Iterator

from ..utils.csv_writer import setup_csv_writer


def generate_secretario_data(
    schema_size: int,
    rows_amount: int,
    colaborador_keys_iterator: Iterator[str],
    sede_keys: tuple[int, ...],
):
    secretario_keys: list[str] = []
    file, writer = setup_csv_writer(f"secretario_{schema_size}")

    writer.writerow(["dni", "sede_id"])

    for _ in range(rows_amount):
        dni = next(colaborador_keys_iterator)
        sede_id = random.choice(sede_keys)

        secretario_keys.append(dni)

        writer.writerow([dni, sede_id])

    file.close()

    return tuple(secretario_keys)
