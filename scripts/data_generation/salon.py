import random

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_salon_data(
        schema_size: int,
        rows_amount: int,
        grado_keys: tuple[int, ...],
        sede_keys: tuple[int, ...],
):
    salon_keys: set[tuple[str, int]] = set()
    file, writer = setup_csv_writer(f"salon_data_{schema_size}")

    writer.writerow(["aforo", "nombre_seccion", "grado_id", "sede_id"])

    while len(salon_keys) < rows_amount:
        nombre_seccion = faker.color_name()
        sede_id = random.choice(sede_keys)

        if (nombre_seccion, sede_id) not in salon_keys:
            aforo = faker.random_int(30, 50)
            grado_id = random.choice(grado_keys)
            salon_keys.add((nombre_seccion, sede_id))

            writer.writerow([aforo, nombre_seccion, grado_id, sede_id])

    file.close()

    return tuple(salon_keys)
