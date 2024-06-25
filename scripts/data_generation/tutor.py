from typing import Iterator

from ..utils.csv_writer import setup_csv_writer


def generate_tutor_data(
        schema_size: int,
        rows_amount: int,
        colaborador_keys_iterator: Iterator[str],
        salon_keys: tuple[tuple[str, int], ...],
):
    tutor_keys: list[str] = []
    file, writer = setup_csv_writer(f"tutor_data_{schema_size}")

    writer.writerow(["dni", "salon_nombre_seccion", "sede_id"])

    for i in range(rows_amount):
        dni = next(colaborador_keys_iterator)
        salon_nombre_seccion = salon_keys[i][0]
        sede_id = salon_keys[i][1]

        tutor_keys.append(dni)

        writer.writerow([dni, salon_nombre_seccion, sede_id])

    file.close()

    return tuple(tutor_keys)
