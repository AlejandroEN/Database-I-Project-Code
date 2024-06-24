import random

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_persona_data(schema_size: int, rows_amount: int):
    persona_keys: list[str] = []
    file, writer = setup_csv_writer(f"persona_{schema_size}.csv")

    writer.writerow(
        [
            "dni",
            "nombres",
            "primerApellido",
            "segundoApellido",
            "nacimientoFecha",
            "sexo",
            "email",
        ]
    )

    for _ in range(rows_amount):
        dni = faker.numerify(text="%#######")
        nombres = faker.name()
        primer_apellido = faker.last_name()
        segundo_apellido = faker.last_name()
        nacimiento_fecha = faker.date_of_birth()
        sexo = random.choice(["M", "F"])
        email = faker.email()

        persona_keys.append(dni)

        writer.writerow(
            [
                dni,
                nombres,
                primer_apellido,
                segundo_apellido,
                nacimiento_fecha,
                sexo,
                email,
            ]
        )

    file.close()

    return iter(persona_keys)
