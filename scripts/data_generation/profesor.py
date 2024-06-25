from typing import Iterator

from ..utils.csv_writer import setup_csv_writer


def generate_profesor_data(schema_size: int, rows_amount: int, colaborador_keys_iterator: Iterator[str]):
    profesor_keys: list[str] = []
    file, writer = setup_csv_writer(f"profesor_{schema_size}.csv")

    writer.writerow(["dni"])

    for _ in range(rows_amount):
        dni = next(colaborador_keys_iterator)

        profesor_keys.append(dni)

        writer.writerow([dni])

    file.close()

    return tuple(profesor_keys)
