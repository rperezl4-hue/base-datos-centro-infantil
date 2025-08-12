-- Tabla de niños
CREATE TABLE niños (
  id INT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha_nacimiento DATE,
  nivel_educativo VARCHAR(50)
);

-- Tabla de tutores
CREATE TABLE tutores (
  id INT PRIMARY KEY,
  nombre VARCHAR(100),
  teléfono VARCHAR(20)
);

-- Tabla de asistencia
CREATE TABLE asistencia (
  id INT PRIMARY KEY,
  niño_id INT,
  fecha DATE,
  presente BOOLEAN,
  FOREIGN KEY (niño_id) REFERENCES niños(id)
);
