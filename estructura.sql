--roles 
CREATE TABLE roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rol VARCHAR(50),
    descripcion VARCHAR(150)
);
--- usuarios

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50),
    clave VARCHAR(100),
    correo VARCHAR(100),
    id_rol INT,
    estado VARCHAR(20),
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);
--tabla de estudiantes
CREATE TABLE estudiantes (
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre NVARCHAR(100) NOT NULL,
  apellido NVARCHAR(100) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  edad AS DATEDIFF(YEAR, fecha_nacimiento, GETDATE()), -- campo calculado
  sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
  alergias NVARCHAR(255),
  observaciones TEXT,
  fecha_ingreso DATE
);
--Docentes
CREATE TABLE docentes (
    id_docente INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    cedula VARCHAR(20),
    correo VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    especialidad VARCHAR(100),
    fecha_ingreso DATE,
    sueldo DECIMAL(10,2),
    estado VARCHAR(20)
);
--Salones
CREATE TABLE salones (
    id_salon INT PRIMARY KEY AUTO_INCREMENT,
    nombre_salon VARCHAR(50),
    nivel VARCHAR(50),
    capacidad INT,
    docente_id INT,
    estado VARCHAR(20),
    FOREIGN KEY (docente_id) REFERENCES docentes(id_docente)
);
--matriculas 
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_salon INT,
    id_periodo INT,
    fecha_matricula DATE,
    estado VARCHAR(20),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_salon) REFERENCES salones(id_salon),
    FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
);
--periodos
CREATE TABLE periodos (
    id_periodo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_periodo VARCHAR(20),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(20)
);


-- tipo de servicio
CREATE TABLE tipos_servicio (
    id_tipo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    recurrente BOOLEAN,
    descripcion VARCHAR(150),
    estado VARCHAR(20)
);
-- valores
CREATE TABLE valores (
    id_valor INT PRIMARY KEY AUTO_INCREMENT,
    id_tipo INT,
    descripcion VARCHAR(100),
    monto DECIMAL(10,2),
    id_periodo INT,
    estado VARCHAR(20),
    FOREIGN KEY (id_tipo) REFERENCES tipos_servicio(id_tipo),
    FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo)
);

-- descuentos
CREATE TABLE descuentos (
    id_descuento INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT NOT NULL,
    id_tipo INT NOT NULL, -- tipo de servicio: matrícula, mensualidad, etc.
    porcentaje DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    motivo VARCHAR(100),
    fecha_registro DATE DEFAULT CURRENT_DATE,
    estado VARCHAR(20) DEFAULT 'Activo',
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_tipo) REFERENCES tipos_servicio(id_tipo)
);
-- pagos

CREATE TABLE cobros (
    id_cobro INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT NOT NULL,
    id_valor INT NOT NULL,
    id_descuento INT, -- puede ser NULL si no aplica descuento
    fecha_generacion DATE DEFAULT CURRENT_DATE,
    monto_original DECIMAL(10,2) NOT NULL,
    monto_descuento DECIMAL(10,2) DEFAULT 0.00,
    monto_total DECIMAL(10,2) NOT NULL, -- monto a pagar después del descuento
    estado VARCHAR(20) DEFAULT 'Pendiente', -- Pagado, Parcial, Pendiente, Anulado
    observaciones TEXT,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_valor) REFERENCES valores(id_valor),
    FOREIGN KEY (id_descuento) REFERENCES descuentos(id_descuento)
);
-- Índices para acelerar consultas
CREATE INDEX idx_cobros_estudiante ON cobros(id_estudiante);
CREATE INDEX idx_cobros_valor ON cobros(id_valor);
CREATE INDEX idx_cobros_estado ON cobros(estado);
CREATE INDEX idx_cobros_fecha ON cobros(fecha_pago);
CREATE INDEX idx_cobros_periodo ON cobros(id_valor);

---detalles de cobros
INSERT INTO cobros (
    id_estudiante, id_valor, id_descuento,
    monto_original, monto_descuento, monto_total,
    estado, observaciones
)
VALUES (
    101, 5, 12,
    60.00, 30.00, 30.00,
    'Pendiente', 'Descuento del 50% aplicado'
);




