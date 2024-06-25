from ..utils.csv_writer import setup_csv_writer
from ..utils.shared_faker import faker


def generate_institucion_data(schema_size: int, rows_amount: int):
    institucion_keys: list[str] = []
    file, writer = setup_csv_writer(f"institucion_data_{schema_size}.csv")

    writer.writerow(
        ["ruc", "descripcion", "fundador", "fundacionFecha", "bannerUrl", "nombre"]
    )

    for _ in range(rows_amount):
        ruc = faker.numerify("%##########")
        descripcion = faker.text()
        fundador = faker.name()
        fundacion_fecha = faker.date_between()
        banner_url = faker.image_url()
        nombre = faker.street_name()

        institucion_keys.append(ruc)

        writer.writerow(
            [ruc, descripcion, fundador, fundacion_fecha, banner_url, nombre]
        )

    file.close()

    return tuple(institucion_keys)
