import random

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_matricula_data(
    schema_size: int,
    rows_amount: int,
    alumno_keys: tuple[str, ...],
    sede_keys: tuple[int, ...],
    grado_keys: tuple[int, ...],
    secretario_keys: tuple[str, ...],
):
    file, writer = setup_csv_writer(f"matricula_data_{schema_size}")

    writer.writerow(["year", "alumnoDni", "sedeId", "gradoId", "secretarioDni"])

    for _ in range(rows_amount):
        year = faker.year()
        alumno_dni = random.choice(alumno_keys)
        sede_id = random.choice(sede_keys)
        grado_id = random.choice(grado_keys)
        secretario_dni = random.choice(secretario_keys)

        writer.writerow([year, alumno_dni, sede_id, grado_id, secretario_dni])

    file.close()
