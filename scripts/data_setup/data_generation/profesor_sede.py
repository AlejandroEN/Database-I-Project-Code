import random

from scripts.utils import setup_csv_writer


def generate_profesor_sede_data(
    schema_size: int,
    rows_amount: int,
    profesor_keys: tuple[str, ...],
    sede_keys: tuple[int, ...],
):
    profesor_sede_keys: set[tuple[str, int]] = set()
    file, writer = setup_csv_writer(f"profesor_sede_data_{schema_size}")

    writer.writerow(["profesor_dni", "sede_id"])

    while len(profesor_sede_keys) < rows_amount:
        profesor_dni = random.choice(profesor_keys)
        sede_id = random.choice(sede_keys)

        if (profesor_dni, sede_id) not in profesor_sede_keys:
            profesor_sede_keys.add((profesor_dni, sede_id))
            writer.writerow([profesor_dni, sede_id])

    file.close()

    return tuple(profesor_sede_keys)
