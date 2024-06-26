from typing import Iterator

from ..utils.csv_writer import setup_csv_writer


def generate_director_data(
        schema_size: int,
        rows_amount: int,
        colaborator_keys_iterator: Iterator[str],
        sede_keys: tuple[int, ...],
):
    file, writer = setup_csv_writer(f"director_data_{schema_size}")
    director_keys: list[str] = []

    writer.writerow(["dni", "sede_id"])

    for i in range(rows_amount):
        dni = next(colaborator_keys_iterator)
        sede_id = sede_keys[i]

        director_keys.append(dni)

        writer.writerow([dni, sede_id])

    file.close()

    return tuple(director_keys)
