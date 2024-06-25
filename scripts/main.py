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

from random import randint


def main() -> None:
    data_sizes: list[int] = [100_000]

    for size in data_sizes:
        institucion_keys = generate_institucion_data(size, int(size/1000))

        persona_keys = generate_persona_data(size, size * 7)

        colaborador_keys = generate_colaborador_data(size, size * 5, persona_keys)

        sedes_amount = int(size/250)

        sede_keys = generate_sede_data(size, sedes_amount, institucion_keys)

        generate_director_data(size, sedes_amount, colaborador_keys, sede_keys)

        generate_consejero_data(size, sedes_amount * 3, colaborador_keys, sede_keys)

        secretario_keys = generate_secretario_data(
            size, sedes_amount * 5, colaborador_keys, sede_keys
        )

        profesores_amount = sedes_amount * 20

        profesor_keys = generate_profesor_data(size, profesores_amount, colaborador_keys)

        grado_keys = generate_grado_data(size)

        curso_keys = generate_curso_data(size)

        salones_amount = int(size/40)

        salon_keys = generate_salon_data(size, salones_amount, grado_keys, sede_keys)

        generate_tutor_data(size, salones_amount, colaborador_keys, salon_keys)

        apoderado_keys = generate_apoderado_data(size, int(size * 0.8), persona_keys)

        alumno_keys = generate_alumno_data(
            size, size, persona_keys, salon_keys, apoderado_keys
        )

        generate_profesor_sede_data(size, sedes_amount * randint(5, 15), profesor_keys, sede_keys)

        generate_profesor_curso_grado_data(
            size, size, curso_keys, grado_keys, profesor_keys
        )

        generate_matricula_data(
            size, size, alumno_keys, sede_keys, grado_keys, secretario_keys
        )


if __name__ == "__main__":
    main()
