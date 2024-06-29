from typing import Iterator

from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_colaborador_data(
        schema_size: int, rows_amount: int, persona_keys_iterator: Iterator[str]
):
    colaborador_keys: list[str] = []
    file, writer = setup_csv_writer(f"colaborador_data_{schema_size}")

    writer.writerow(
        [
            "dni",
            "sueldo_hora",
            "cci",
            "numero_celular",
            "horas_semanales_trabajo",
            "esta_activo",
        ]
    )

    for _ in range(rows_amount):
        dni = next(persona_keys_iterator)
        sueldo_hora = faker.pyfloat(left_digits=2, right_digits=1, positive=True)
        cci = faker.numerify("####################")
        numero_celular = faker.numerify("$%#######")
        horas_semanales_trabajo = faker.random_int(1, 168)
        esta_activo = True

        colaborador_keys.append(dni)

        writer.writerow(
            [
                dni,
                sueldo_hora,
                cci,
                numero_celular,
                horas_semanales_trabajo,
                esta_activo,
            ]
        )

    file.close()

    return iter(colaborador_keys)
