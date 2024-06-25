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
    file, writer = setup_csv_writer(f"profesor_curso_grado_{schema_size}.csv")

    writer.writerow(["cursoId", "gradoId", "profesorDni", "periodoAcademico"])

    for _ in range(rows_amount):
        curso_id = random.choice(curso_keys)
        grado_id = random.choice(grado_keys)
        profesor_dni = random.choice(profesor_keys)
        periodo_academico = faker.date_between()

        writer.writerow([curso_id, grado_id, profesor_dni, periodo_academico])

    file.close()
