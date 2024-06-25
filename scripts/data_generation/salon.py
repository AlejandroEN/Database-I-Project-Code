import random

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_salon_data(
    schema_size: int,
    rows_amount: int,
    grado_keys: tuple[int, ...],
    sede_keys: tuple[int, ...],
):
    salon_keys: list[tuple[str, int]] = []
    file, writer = setup_csv_writer(f"salon_data_{schema_size}")

    writer.writerow(["aforo", "nombreSeccion", "gradoId", "sedeId"])

    for _ in range(rows_amount):
        aforo = faker.random_int(30, 50)
        nombre_seccion = faker.color_name()
        grado_id = random.choice(grado_keys)
        sede_id = random.choice(sede_keys)

        salon_keys.append((nombre_seccion, grado_id))

        writer.writerow([aforo, nombre_seccion, grado_id, sede_id])

    file.close()

    return tuple(salon_keys)
