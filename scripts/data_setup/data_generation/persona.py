import random

from scripts.utils import faker
from scripts.utils import setup_csv_writer


def generate_persona_data(schema_size: int, rows_amount: int):
    persona_keys: list[str] = []
    file, writer = setup_csv_writer(f"persona_data_{schema_size}")

    writer.writerow(
        [
            "dni",
            "nombres",
            "primer_apellido",
            "segundo_apelido",
            "nacimiento_fecha",
            "sexo",
            "email",
        ]
    )

    for _ in range(rows_amount):
        dni = faker.unique.numerify(text="%#######")
        nombres = faker.name()
        primer_apellido = faker.last_name()
        segundo_apellido = faker.last_name()
        nacimiento_fecha = faker.date_of_birth(maximum_age=70, minimum_age=5)
        sexo = random.choice(["M", "F"])
        email = faker.unique.email()

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
