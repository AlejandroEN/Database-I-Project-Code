import random
from typing import Iterator

from ..utils.csv_writer import setup_csv_writer


def generate_alumno_data(
    schema_size: int,
    rows_amount: int,
    persona_keys_iterator: Iterator[str],
    salon_keys: tuple[tuple[str, int], ...],
    apoderado_keys: tuple[str, ...],
):
    alumno_keys: list[str] = []
    file, writer = setup_csv_writer(f"alumno_{schema_size}.csv")

    writer.writerow(["dni", "nombreSeccion", "sedeId", "apoderadoDni"])

    for i in range(rows_amount):
        salon_key = random.choice(salon_keys)

        dni = next(persona_keys_iterator)
        nombre_seccion = salon_key[0]
        sede_id = salon_key[1]
        apoderado_dni = random.choice(apoderado_keys)

        alumno_keys.append(dni)

        writer.writerow([dni, nombre_seccion, sede_id, apoderado_dni])

    file.close()

    return tuple(alumno_keys)
