from ..utils.csv_writer import setup_csv_writer


def generate_curso_data(schema_size: int):
    curso_keys: list[int] = []
    file, writer = setup_csv_writer(f"curso_data_{schema_size}")

    writer.writerow(["id", "nombre"])

    cursos_names: list[str] = [
        "Física",
        "Aritmética",
        "Álgebra",
        "Geometría",
        "Trigonometría",
        "Historia",
        "Filosofía",
        "Biología",
        "Química",
        "Inglés",
        "Francés"
    ]

    for i in range(len(cursos_names)):
        curso_id = i
        nombre = cursos_names[i]

        curso_keys.append(curso_id)

        writer.writerow([curso_id, nombre])

    file.close()

    return tuple(curso_keys)
