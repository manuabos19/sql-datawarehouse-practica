---Creamos la tabla alumnos con unos ejemplos
create table alumno (
    id_alumno serial primary key,
    nombre VARCHAR(50) not null,
    apellidos VARCHAR(100) not null,
    telefono VARCHAR(10) not null,
    correo VARCHAR(100) not null,
    dni VARCHAR(10) not null unique
);
insert into
    alumno (nombre, apellidos, telefono, correo, dni)
values
    (
        'Carlos',
        'García López',
        '612345678',
        'carlos.garcia@example.com',
        '12345678A'
    ),
    (
        'María',
        'Rodríguez Fernández',
        '622345678',
        'maria.rodriguez@example.com',
        '23456789B'
    ),
    (
        'Juan',
        'Martínez Gómez',
        '632345678',
        'juan.martinez@example.com',
        '34567890C'
    ),
    (
        'Ana',
        'López Pérez',
        '642345678',
        'ana.lopez@example.com',
        '45678901D'
    ),
    (
        'Luis',
        'Sánchez Ruiz',
        '652345678',
        'luis.sanchez@example.com',
        '56789012E'
    );
--------------------Creamos la tabla profesor con algunos ejemplos
    create table profesor (
        id_profesor serial primary key,
        nombre VARCHAR(50) not null,
        apellidos VARCHAR(100) not null,
        telefono VARCHAR(10) not null,
        correo VARCHAR(100) not null
    );
insert into
    profesor (nombre, apellidos, telefono, correo)
values
    (
        'Alejandro',
        'Lopez Sanchez',
        '612345679',
        'alejandro.lopez@keepcoding.com'
    ),
    (
        'Pedro',
        'Hernández López',
        '622345679',
        'pedro.hernandez@keepcoding.com'
    ),
    (
        'Sofía',
        'Ramírez Torres',
        '632345679',
        'sofia.ramirez@keepcoding.com'
    ),
    (
        'Miguel',
        'Díaz Sánchez',
        '642345679',
        'miguel.diaz@keepcoding.com'
    );
-------------Creamos la tabla modulo con algunos ejemplos
    create table modulo (
        id_modulo serial primary key,
        nombre VARCHAR(100) not null,
        id_profesor int,
        FOREIGN KEY(id_profesor) REFERENCES profesor(id_profesor)
    );
insert into
    modulo (nombre, id_profesor)
values
    ('SQL Avanzado, ETL y DataWarehouse', 1),
    ('Machine Learning', 2),
    ('Deep Learning & Computer Vision', 3),
    ('NLP & Searching', 4),
    ('Despliegue algoritmos', 1),
    ('Visualizacion de datos', 1);
---------------Creamos la tabla bootcamp con algunos ejemplos
    create table bootcamp (
        id_bootcamp serial PRIMARY key,
        nombre VARCHAR(50) not null
    )
insert into
    bootcamp(nombre)
values
    ('IA'),('Big data');
-------Creamos la tabla alumno bootcamp para relacion bootcamps con alumnos, puesto que pueden existir alumno con varias bootcamps y bootcamps para varios alumnos
    create table alumno_bootcamp(
        id_alumno_bootcamp serial PRIMARY key,
        id_alumno int not null,
        id_bootcamp int not null,
        FOREIGN KEY(id_alumno) REFERENCES alumno(id_alumno),
        FOREIGN KEY(id_bootcamp) REFERENCES bootcamp(id_bootcamp)
    );
insert into
    alumno_bootcamp (id_alumno, id_bootcamp)
values
    (1, 1),
    (2, 1),
    (3, 2);
----------------Creamos la tabla de pagos que relaciona los pagos con el bootcamp-alumno que lo paga
    create table pagos (
        id_pago serial primary key,
        concepto VARCHAR(150) not null,
        fecha_pago date not null,
        importe float not null,
        id_alumno_bootcamp int,
        FOREIGN KEY(id_alumno_bootcamp) REFERENCES alumno_bootcamp(id_alumno_bootcamp)
    );
insert into
    pagos (
        concepto,
        fecha_pago,
        importe,
        id_alumno_bootcamp
    )
values
    ('Matrícula IA', '2023-01-15', 4500, 1),
    ('Matricula IA', '2023-02-15', 4500, 2),
    ('Matricula Big data', '2023-03-15', 4000, 3);
----Creamos la tabla bootcamp modulos para relacion los distintos modulos con los bootcamps
    create table bootcamp_modulos(
        id_bootcamp_modulos serial PRIMARY key,
        id_bootcamp int not null,
        id_modulo int not null,
        FOREIGN KEY(id_bootcamp) REFERENCES bootcamp(id_bootcamp),
        FOREIGN KEY(id_modulo) REFERENCES modulo(id_modulo)
    );
insert into
    bootcamp_modulos(id_bootcamp, id_modulo)
values
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 3);