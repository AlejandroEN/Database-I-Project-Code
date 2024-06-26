import random

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_profesor_curso_grado_data(
        schema_size: int,
        rows_amount: int,
        curso_keys: tuple[int, ...],
        grado_keys: tuple[int, ...],
        profesor_keys: tuple[str, ...],
):
    file, writer = setup_csv_writer(f"profesor_curso_grado_data_{schema_size}")
    profesor_curso_grado_keys: set[tuple[int, int, str]] = set()

    writer.writerow(["curso_id", "grado_id", "profesor_dni", "periodo_academico"])

    while len(profesor_curso_grado_keys) < rows_amount:
        curso_id = random.choice(curso_keys)
        grado_id = random.choice(grado_keys)
        profesor_dni = random.choice(profesor_keys)

        if (curso_id, grado_id, profesor_dni) not in profesor_curso_grado_keys:
            periodo_academico = faker.date_between()
            profesor_curso_grado_keys.add((curso_id, grado_id, profesor_dni))
            writer.writerow([curso_id, grado_id, profesor_dni, periodo_academico])

    file.close()

    return tuple(profesor_curso_grado_keys)
