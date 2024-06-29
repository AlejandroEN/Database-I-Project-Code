import time
from random import randint

from .data_generation.alumno import generate_alumno_data
from .data_generation.apoderado import generate_apoderado_data
from .data_generation.colaborador import generate_colaborador_data
from .data_generation.consejero import generate_consejero_data
from .data_generation.curso import generate_curso_data
from .data_generation.director import generate_director_data
from .data_generation.grado import generate_grado_data
from .data_generation.institucion import generate_institucion_data
from .data_generation.matricula import generate_matricula_data
from .data_generation.persona import generate_persona_data
from .data_generation.profesor import generate_profesor_data
from .data_generation.profesor_curso_grado import generate_profesor_curso_grado_data
from .data_generation.profesor_sede import generate_profesor_sede_data
from .data_generation.salon import generate_salon_data
from .data_generation.secretario import generate_secretario_data
from .data_generation.sede import generate_sede_data
from .data_generation.tutor import generate_tutor_data


def main() -> None:
    start_time = time.time()
    data_sizes: list[int] = [1_000, 10_000, 100_000]

    for size in data_sizes:
        institucion_keys = generate_institucion_data(size, size // 1000)

        persona_keys = generate_persona_data(size, size)

        colaborador_keys = generate_colaborador_data(size, size // 10, persona_keys)

        sede_keys = generate_sede_data(size, size // 500, institucion_keys)

        director_keys = generate_director_data(
            size, len(sede_keys), colaborador_keys, sede_keys
        )

        consejero_keys = generate_consejero_data(
            size, len(sede_keys) * 3, colaborador_keys, sede_keys
        )

        secretario_keys = generate_secretario_data(
            size, len(sede_keys) * 6, colaborador_keys, sede_keys
        )

        profesor_keys = generate_profesor_data(
            size, len(sede_keys) * 25, colaborador_keys
        )

        grado_keys = generate_grado_data(size)

        curso_keys = generate_curso_data(size)

        salon_keys = generate_salon_data(
            size, len(sede_keys) * 15, grado_keys, sede_keys
        )

        tutor_keys = generate_tutor_data(
            size, len(salon_keys), colaborador_keys, salon_keys
        )

        apoderado_keys = generate_apoderado_data(size, int(size * 0.4), persona_keys)

        alumno_keys = generate_alumno_data(
            size, size // 2, persona_keys, salon_keys, apoderado_keys
        )

        profesor_sede_keys = generate_profesor_sede_data(
            size, len(sede_keys) * randint(25, 50), profesor_keys, sede_keys
        )

        profesor_curso_grado_keys = generate_profesor_curso_grado_data(
            size, len(profesor_keys) * 30, curso_keys, grado_keys, profesor_keys
        )

        matricula_keys = generate_matricula_data(
            size,
            int(len(alumno_keys) * 0.6),
            alumno_keys,
            sede_keys,
            grado_keys,
            secretario_keys,
        )

    end_time = time.time()
    print(f"Total execution time: {end_time - start_time}")


if __name__ == "__main__":
    main()
