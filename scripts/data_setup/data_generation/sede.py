import random

from scripts.utils import faker
from scripts.utils import setup_csv_writer


def generate_sede_data(
    schema_size: int, rows_amount: int, institucion_keys: tuple[str, ...]
):
    sede_keys: list[int] = []
    file, writer = setup_csv_writer(f"sede_data_{schema_size}")

    writer.writerow(
        [
            "id",
            "coordenada_longitud",
            "coordenada_latitud",
            "direccion",
            "construccion_fecha",
            "institucion_ruc",
        ]
    )

    for i in range(rows_amount):
        sede_id = i
        coordenada_longitud = faker.longitude()
        coordenada_latitud = faker.latitude()
        direccion = faker.address()
        construccion_fecha = faker.date_between()
        institucion_ruc = random.choice(institucion_keys)

        sede_keys.append(sede_id)

        writer.writerow(
            [
                sede_id,
                coordenada_longitud,
                coordenada_latitud,
                direccion,
                construccion_fecha,
                institucion_ruc,
            ]
        )

    file.close()

    return tuple(sede_keys)
