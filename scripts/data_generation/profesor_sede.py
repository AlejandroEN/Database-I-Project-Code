import random

from ..utils.csv_writer import setup_csv_writer


def generate_profesor_sede_data(
    schema_size: int,
    rows_amount: int,
    profesor_keys: tuple[str, ...],
    sede_keys: tuple[int, ...],
):
    profesor_sede_keys: list[tuple[str, int]] = []
    file, writer = setup_csv_writer(f"profesor_sede_{schema_size}")

    writer.writerow(["profesorDni", "sedeId"])

    for _ in range(rows_amount):
        profesor_dni = random.choice(profesor_keys)
        sede_id = random.choice(sede_keys)

        profesor_sede_keys.append((profesor_dni, sede_id))

        writer.writerow([profesor_dni, sede_id])

    file.close()

    return tuple(profesor_sede_keys)
