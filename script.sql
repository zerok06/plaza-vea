create database plaza_vea -- Base de Datos: Supermercado
go

drop database plaza_vea
go

-- creacion con datos especificos

CREATE DATABASE SupermercadoDB
ON 
(
    NAME = SupermercadoDB_dat,
    FILENAME = 'C:\SQLData\SupermercadoDB.mdf',  -- Ruta del archivo MDF
    SIZE = 500MB,                                -- Tamaño inicial del archivo MDF
    MAXSIZE = UNLIMITED,                         -- Sin límite de crecimiento máximo
    FILEGROWTH = 100MB                           -- Incremento del tamaño del archivo MDF
)
LOG ON
(
    NAME = SupermercadoDB_log,
    FILENAME = 'E:\SQLLogs\SupermercadoDB.ldf',  -- Ruta del archivo LDF
    SIZE = 100MB,                                -- Tamaño inicial del archivo LDF
    MAXSIZE = 1GB,                               -- Tamaño máximo del archivo LDF
    FILEGROWTH = 50MB                            -- Incremento del tamaño del archivo LDF
);

	
use plaza_vea
go
-- 1. Productos y Categorías
CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Subcategorias (
    id_subcategoria INT PRIMARY KEY IDENTITY(1, 1),
    id_categoria INT,
    nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

CREATE TABLE Marcas (
    id_marca INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE UnidadesDeMedida (
    id_unidad INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(50) NOT NULL,
    abreviacion VARCHAR(10)
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_subcategoria INT,
    id_marca INT,
    id_unidad INT,
    precio DECIMAL(10, 2),
    stock_minimo INT,
    stock_maximo INT,
    FOREIGN KEY (id_subcategoria) REFERENCES Subcategorias(id_subcategoria),
    FOREIGN KEY (id_marca) REFERENCES Marcas(id_marca),
    FOREIGN KEY (id_unidad) REFERENCES UnidadesDeMedida(id_unidad)
);

-- 2. Inventarios
CREATE TABLE InventarioGeneral (
    id_inventario INT PRIMARY KEY IDENTITY(1, 1),
    id_producto INT,
    cantidad INT,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Almacenes (
    id_almacen INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200)
);

CREATE TABLE SeccionesAlmacen (
    id_seccion INT PRIMARY KEY IDENTITY(1, 1),
    id_almacen INT,
    nombre VARCHAR(100),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen)
);

CREATE TABLE MovimientosInventario (
    id_movimiento INT PRIMARY KEY IDENTITY(1, 1),
    id_producto INT,
    id_almacen INT,
    cantidad INT,
    tipo_movimiento VARCHAR(30),
    fecha DATETIME DEFAULT GETDATE(),
	check(tipo_movimiento IN('entrada', 'salida')),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen)
);

-- 3. Ventas y Clientes
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE MetodosPago (
    id_metodo INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(50)
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    fecha DATETIME DEFAULT GETDATE(),
    id_metodo INT,
    total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_metodo) REFERENCES MetodosPago(id_metodo)
);

CREATE TABLE DetallesVenta (
    id_detalle INT PRIMARY KEY IDENTITY(1, 1),
    id_venta INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10, 2),
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- 4. Empleados y Recursos Humanos
CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    correo VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE Departamentos (
    id_departamento INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE PuestosTrabajo (
    id_puesto INT PRIMARY KEY IDENTITY(1, 1),
    id_departamento INT,
    nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);

CREATE TABLE HorariosTrabajo (
    id_horario INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    dia VARCHAR(30),
    hora_entrada TIME,
    hora_salida TIME,
	check (dia IN(
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
    )),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

-- 5. Logística y Distribución
CREATE TABLE FlotasTransporte (
    id_flota INT PRIMARY KEY IDENTITY(1, 1),
    descripcion VARCHAR(100)
);

CREATE TABLE RutasDistribucion (
    id_ruta INT PRIMARY KEY IDENTITY(1, 1),
    descripcion VARCHAR(100)
);

CREATE TABLE Despachos (
    id_despacho INT PRIMARY KEY IDENTITY(1, 1),
    id_almacen INT,
    id_ruta INT,
    fecha_salida DATETIME,
    fecha_llegada DATETIME,
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen),
    FOREIGN KEY (id_ruta) REFERENCES RutasDistribucion(id_ruta)
);

CREATE TABLE Proveedores (
    id_proveedor INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);
-- 6. Finanzas y Contabilidad
CREATE TABLE CuentasPorCobrar (
    id_cuenta INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    monto DECIMAL(10, 2),
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE CuentasPorPagar (
    id_cuenta INT PRIMARY KEY IDENTITY(1, 1),
    id_proveedor INT,
    monto DECIMAL(10, 2),
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
);

-- 2. Inventarios (Continuación)
CREATE TABLE RequisicionesInventario (
    id_requisicion INT PRIMARY KEY IDENTITY(1, 1),
    id_almacen INT,
    id_producto INT,
    cantidad INT,
    fecha DATETIME DEFAULT GETDATE(),
    estado varchar(30),
	check (estado in('pendiente', 'aprobada', 'rechazada')),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);


CREATE TABLE OrdenesCompra (
    id_orden INT PRIMARY KEY IDENTITY(1, 1),
    id_proveedor INT,
    fecha DATETIME DEFAULT GETDATE(),
    estado varchar(30),
	check (estado in('pendiente', 'completada', 'cancelada')),
    total DECIMAL(10, 2),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
);

CREATE TABLE DetallesOrdenCompra (
    id_detalle INT PRIMARY KEY IDENTITY(1, 1),
    id_orden INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10, 2),
    FOREIGN KEY (id_orden) REFERENCES OrdenesCompra(id_orden),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE RecepcionProductos (
    id_recepcion INT PRIMARY KEY IDENTITY(1, 1),
    id_orden INT,
    fecha DATETIME DEFAULT GETDATE(),
    cantidad INT,
    FOREIGN KEY (id_orden) REFERENCES OrdenesCompra(id_orden)
);

-- 3. Ventas y Clientes (Continuación)
CREATE TABLE DevolucionesClientes (
    id_devolucion INT PRIMARY KEY IDENTITY(1, 1),
    id_venta INT,
    fecha DATETIME DEFAULT GETDATE(),
    motivo VARCHAR(200),
    monto DECIMAL(10, 2),
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta)
);

CREATE TABLE CuponesDescuentos (
    id_cupon INT PRIMARY KEY IDENTITY(1, 1),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(200),
    descuento DECIMAL(5, 2),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado varchar(30),
	check (estado in('activo', 'inactivo'))
);

CREATE TABLE ProgramasFidelizacion (
    id_programa INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    puntos_por_compra DECIMAL(5, 2),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado varchar(30),
	check (estado in('activo', 'inactivo'))
);

CREATE TABLE HistorialCupones (
    id_historial INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    id_cupon INT,
    fecha_uso DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_cupon) REFERENCES CuponesDescuentos(id_cupon)
);

-- 4. Empleados y Recursos Humanos (Continuación)
CREATE TABLE Asistencias (
    id_asistencia INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    fecha DATE,
    hora_entrada TIME,
    hora_salida TIME,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE PermisosLicencias (
    id_permiso INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    tipo_permiso VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado varchar(30),
	check (estado in('pendiente', 'aprobado', 'rechazado')),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Capacitaciones (
    id_capacitacion INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    nombre VARCHAR(100),
    fecha DATE,
    duracion INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE EvaluacionesDesempeno (
    id_evaluacion INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    fecha DATE,
    calificacion DECIMAL(5, 2),
    comentarios TEXT,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Nominas (
    id_nomina INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    fecha DATETIME DEFAULT GETDATE(),
    salario_base DECIMAL(10, 2),
    bonos DECIMAL(10, 2),
    deducciones DECIMAL(10, 2),
    salario_neto DECIMAL(10, 2),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

-- 5. Logística y Distribución (Continuación)
CREATE TABLE OrdenesTransferencia (
    id_transferencia INT PRIMARY KEY IDENTITY(1, 1),
    id_almacen_origen INT,
    id_almacen_destino INT,
    fecha DATETIME DEFAULT GETDATE(),
    estado varchar(30),
	check (estado in('pendiente', 'completada', 'cancelada')),
    FOREIGN KEY (id_almacen_origen) REFERENCES Almacenes(id_almacen),
    FOREIGN KEY (id_almacen_destino) REFERENCES Almacenes(id_almacen)
);

CREATE TABLE DetallesTransferencia (
    id_detalle INT PRIMARY KEY IDENTITY(1, 1),
    id_transferencia INT,
    id_producto INT,
    cantidad INT,
    FOREIGN KEY (id_transferencia) REFERENCES OrdenesTransferencia(id_transferencia),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- 6. Finanzas y Contabilidad (Continuación)
CREATE TABLE TransaccionesFinancieras (
    id_transaccion INT PRIMARY KEY IDENTITY(1, 1),
    tipo_transaccion varchar(30),
    descripcion VARCHAR(200),
    monto DECIMAL(10, 2),
    fecha DATETIME DEFAULT GETDATE(),
	check (tipo_transaccion in('ingreso', 'egreso'))
);

CREATE TABLE BalanceGeneral (
    id_balance INT PRIMARY KEY IDENTITY(1, 1),
    fecha DATETIME DEFAULT GETDATE(),
    activos DECIMAL(15, 2),
    pasivos DECIMAL(15, 2),
    patrimonio DECIMAL(15, 2)
);

CREATE TABLE EstadoResultados (
    id_estado INT PRIMARY KEY IDENTITY(1, 1),
    fecha DATETIME DEFAULT GETDATE(),
    ingresos DECIMAL(15, 2),
    costos DECIMAL(15, 2),
    gastos DECIMAL(15, 2),
    utilidad_bruta DECIMAL(15, 2),
    utilidad_neta DECIMAL(15, 2)
);

CREATE TABLE Impuestos (
    id_impuesto INT PRIMARY KEY IDENTITY(1, 1),
    tipo_impuesto VARCHAR(100),
    monto DECIMAL(10, 2),
    fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE Presupuestos (
    id_presupuesto INT PRIMARY KEY IDENTITY(1, 1),
    año INT,
    departamento VARCHAR(100),
    monto DECIMAL(15, 2)
);

CREATE TABLE AuditoriasInternas (
    id_auditoria INT PRIMARY KEY IDENTITY(1, 1),
    fecha DATETIME DEFAULT GETDATE(),
    descripcion TEXT,
    resultados TEXT
);

-- 7. Seguridad y Control
CREATE TABLE AccesosUsuario (
    id_acceso INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    usuario VARCHAR(50) UNIQUE,
    contrasena VARCHAR(100),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE RolesPermisos (
    id_rol INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(50)
);

CREATE TABLE Permisos (
    id_permiso INT PRIMARY KEY IDENTITY(1, 1),
    descripcion VARCHAR(100)
);

CREATE TABLE RolesUsuarios (
    id_rol_usuario INT PRIMARY KEY IDENTITY(1, 1),
    id_acceso INT,
    id_rol INT,
    FOREIGN KEY (id_acceso) REFERENCES AccesosUsuario(id_acceso),
    FOREIGN KEY (id_rol) REFERENCES RolesPermisos(id_rol)
);

CREATE TABLE PermisosRoles (
    id_permiso_rol INT PRIMARY KEY IDENTITY(1, 1),
    id_rol INT,
    id_permiso INT,
    FOREIGN KEY (id_rol) REFERENCES RolesPermisos(id_rol),
    FOREIGN KEY (id_permiso) REFERENCES Permisos(id_permiso)
);

CREATE TABLE LogsActividades (
    id_log INT PRIMARY KEY IDENTITY(1, 1),
    id_acceso INT,
    actividad VARCHAR(200),
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_acceso) REFERENCES AccesosUsuario(id_acceso)
);

CREATE TABLE IncidentesSeguridad (
    id_incidente INT PRIMARY KEY IDENTITY(1, 1),
    descripcion TEXT,
    fecha DATETIME DEFAULT GETDATE(),
    id_empleado INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE ControlPerdidas (
    id_control INT PRIMARY KEY IDENTITY(1, 1),
    id_producto INT,
    cantidad INT,
    motivo VARCHAR(200),
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- 8. Marketing y Relaciones Públicas
CREATE TABLE CampanasMarketing (
    id_campana INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    presupuesto DECIMAL(15, 2),
    estado varchar(30),
	check (estado in('activa', 'inactiva'))
);

CREATE TABLE MediosPublicidad (
    id_medio INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    tipo VARCHAR(50)
);

CREATE TABLE AnalisisMercado (
    id_analisis INT PRIMARY KEY IDENTITY(1, 1),
    fecha DATETIME DEFAULT GETDATE(),
    descripcion TEXT,
    resultados TEXT
);

CREATE TABLE EncuestasSatisfaccion (
    id_encuesta INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    fecha DATETIME DEFAULT GETDATE(),
    puntuacion INT,
    comentarios TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Eventos (
    id_evento INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha DATETIME DEFAULT GETDATE(),
    ubicacion VARCHAR(200)
);

CREATE TABLE Patrocinios (
    id_patrocinio INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha DATETIME DEFAULT GETDATE(),
    monto DECIMAL(10, 2)
);

-- 9. Mantenimiento y Servicios
CREATE TABLE EquiposMaquinaria (
    id_equipo INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_adquisicion DATE,
    estado varchar(40),
	check (estado in('operativo', 'en mantenimiento', 'no operativo'))
);

CREATE TABLE MantenimientoPreventivo (
    id_mantenimiento INT PRIMARY KEY IDENTITY(1, 1),
    id_equipo INT,
    fecha DATE,
    descripcion TEXT,
    costo DECIMAL(10, 2),
    FOREIGN KEY (id_equipo) REFERENCES EquiposMaquinaria(id_equipo)
);

CREATE TABLE MantenimientoCorrectivo (
    id_mantenimiento INT PRIMARY KEY IDENTITY(1, 1),
    id_equipo INT,
    fecha DATE,
    descripcion TEXT,
    costo DECIMAL(10, 2),
    FOREIGN KEY (id_equipo) REFERENCES EquiposMaquinaria(id_equipo)
);

CREATE TABLE ContratosServicio (
    id_contrato INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    monto DECIMAL(10, 2)
);

CREATE TABLE ProveedoresServicio (
    id_proveedor_servicio INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE IncidentesMantenimiento (
    id_incidente INT PRIMARY KEY IDENTITY(1, 1),
    id_equipo INT,
    descripcion TEXT,
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_equipo) REFERENCES EquiposMaquinaria(id_equipo)
);

-- 10. Información General y Configuración
CREATE TABLE Tiendas (
    id_tienda INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);

CREATE TABLE Ubicaciones (
    id_ubicacion INT PRIMARY KEY IDENTITY(1, 1),
    id_tienda INT,
    descripcion VARCHAR(100),
    FOREIGN KEY (id_tienda) REFERENCES Tiendas(id_tienda)
);

CREATE TABLE ConfiguracionGeneral (
    id_configuracion INT PRIMARY KEY IDENTITY(1, 1),
    clave VARCHAR(100),
    valor VARCHAR(200)
);

CREATE TABLE Paises (
    id_pais INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100)
);

CREATE TABLE Regiones (
    id_region INT PRIMARY KEY IDENTITY(1, 1),
    id_pais INT,
    nombre VARCHAR(100),
    FOREIGN KEY (id_pais) REFERENCES Paises(id_pais)
);

CREATE TABLE TiposDocumento (
    id_tipo_documento INT PRIMARY KEY IDENTITY(1, 1),
    descripcion VARCHAR(100)
);

CREATE TABLE Monedas (
    id_moneda INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    simbolo VARCHAR(10)
);



-- Insertar datos de ejemplo

-- 1. Productos y Categorías
INSERT INTO Categorias (nombre) VALUES ('Alimentos');
INSERT INTO Subcategorias (id_categoria, nombre) VALUES (1, 'Lácteos');
INSERT INTO Marcas (nombre) VALUES ('Marca A');
INSERT INTO UnidadesDeMedida (nombre, abreviacion) VALUES ('Litros', 'L');
INSERT INTO Productos (nombre, descripcion, id_subcategoria, id_marca, id_unidad, precio, stock_minimo, stock_maximo) VALUES ('Leche Entera', 'Leche entera 1L', 1, 1, 1, 1.50, 10, 200);

-- 2. Inventarios
INSERT INTO InventarioGeneral (id_producto, cantidad) VALUES (1, 100);
INSERT INTO Almacenes (nombre, ubicacion) VALUES ('Almacén Central', 'Av. Principal 123');
INSERT INTO SeccionesAlmacen (id_almacen, nombre) VALUES (1, 'Sección A');
INSERT INTO MovimientosInventario (id_producto, id_almacen, cantidad, tipo_movimiento) VALUES (1, 1, 50, 'entrada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 1, 20, 'pendiente');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor X', 'Juan Perez', '123456789', 'Calle Falsa 123');
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (1, 'pendiente', 300.00);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (1, 1, 200, 1.50);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (1, 200);

-- 3. Ventas y Clientes
INSERT INTO Clientes (nombre, apellido, correo, telefono) VALUES ('Carlos', 'Gomez', 'carlos@example.com', '987654321');
INSERT INTO MetodosPago (nombre) VALUES ('Tarjeta de Crédito');
INSERT INTO Ventas (id_cliente, id_metodo, total) VALUES (1, 1, 45.00);
INSERT INTO DetallesVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 1, 30, 1.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (1, 'Producto defectuoso', 1.50);
INSERT INTO CuponesDescuentos (codigo, descripcion, descuento, fecha_inicio, fecha_fin, estado) VALUES ('DESC2024', 'Descuento del 10%', 10, '2024-01-01', '2024-12-31', 'activo');
INSERT INTO ProgramasFidelizacion (nombre, descripcion, puntos_por_compra, fecha_inicio, fecha_fin, estado) VALUES ('Fidelidad Oro', 'Programa de fidelización oro', 1.5, '2024-01-01', '2024-12-31', 'activo');
INSERT INTO HistorialCupones (id_cliente, id_cupon, fecha_uso) VALUES (1, 1, CURRENT_TIMESTAMP);

-- 4. Empleados y Recursos Humanos
INSERT INTO Empleados (nombre, apellido, fecha_nacimiento, correo, telefono, direccion) VALUES ('Ana', 'Martinez', '1990-05-15', 'ana@example.com', '123123123', 'Calle Luna 45');
INSERT INTO Departamentos (nombre) VALUES ('Ventas');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (1, 'Cajero');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (1, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO Asistencias (id_empleado, fecha, hora_entrada, hora_salida) VALUES (1, '2024-05-20', '08:00:00', '16:00:00');
INSERT INTO PermisosLicencias (id_empleado, tipo_permiso, fecha_inicio, fecha_fin, estado) VALUES (1, 'Vacaciones', '2024-06-01', '2024-06-15', 'aprobado');
INSERT INTO Capacitaciones (id_empleado, nombre, fecha, duracion) VALUES (1, 'Atención al Cliente', '2024-02-20', 8);
INSERT INTO EvaluacionesDesempeno (id_empleado, fecha, calificacion, comentarios) VALUES (1, '2024-04-30', 9.5, 'Excelente desempeño');
INSERT INTO Nominas (id_empleado, salario_base, bonos, deducciones, salario_neto) VALUES (1, 1200.00, 100.00, 50.00, 1250.00);

-- 5. Logística y Distribución
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camión Refrigerado');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Norte');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 1, '2024-05-20 08:00:00', '2024-05-20 14:00:00');
INSERT INTO OrdenesTransferencia (id_almacen_origen, id_almacen_destino, estado) VALUES (1, 1, 'pendiente');
INSERT INTO DetallesTransferencia (id_transferencia, id_producto, cantidad) VALUES (1, 1, 50);

-- 6. Finanzas y Contabilidad
INSERT INTO CuentasPorCobrar (id_cliente, monto) VALUES (1, 45.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (1, 300.00);
INSERT INTO TransaccionesFinancieras (tipo_transaccion, descripcion, monto) VALUES ('ingreso', 'Venta de productos', 100.00);
INSERT INTO BalanceGeneral (activos, pasivos, patrimonio) VALUES (50000.00, 20000.00, 30000.00);
INSERT INTO EstadoResultados (ingresos, costos, gastos, utilidad_bruta, utilidad_neta) VALUES (10000.00, 7000.00, 2000.00, 3000.00, 1000.00);
INSERT INTO Impuestos (tipo_impuesto, monto) VALUES ('IVA', 1000.00);
INSERT INTO Presupuestos (año, departamento, monto) VALUES (2024, 'Ventas', 50000.00);
INSERT INTO AuditoriasInternas (descripcion, resultados) VALUES ('Revisión anual', 'Todo en orden');

-- 7. Seguridad y Control
INSERT INTO AccesosUsuario (id_empleado, usuario, contrasena) VALUES (1, 'ana.martinez', 'hashed_password');
INSERT INTO RolesPermisos (nombre) VALUES ('Administrador');
INSERT INTO Permisos (descripcion) VALUES ('Acceso Completo');
INSERT INTO RolesUsuarios (id_acceso, id_rol) VALUES (1, 1);
INSERT INTO PermisosRoles (id_rol, id_permiso) VALUES (1, 1);
INSERT INTO LogsActividades (id_acceso, actividad) VALUES (1, 'Inicio de sesión');
INSERT INTO IncidentesSeguridad (descripcion, id_empleado) VALUES ('Intento de acceso no autorizado', 1);
INSERT INTO ControlPerdidas (id_producto, cantidad, motivo) VALUES (1, 10, 'Producto dañado');

-- 8. Marketing y Relaciones Públicas
INSERT INTO CampanasMarketing (nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, estado) VALUES ('Campaña de Verano', 'Promoción especial de verano', '2024-06-01', '2024-08-31', 10000.00, 'activa');
INSERT INTO MediosPublicidad (nombre, tipo) VALUES ('Redes Sociales', 'Digital');
INSERT INTO AnalisisMercado (descripcion, resultados) VALUES ('Estudio de mercado Q1 2024', 'Aumento de demanda en productos orgánicos');
INSERT INTO EncuestasSatisfaccion (id_cliente, puntuacion, comentarios) VALUES (1, 8, 'Buen servicio, pero puede mejorar');
INSERT INTO Eventos (nombre, descripcion, fecha, ubicacion) VALUES ('Inauguración Nueva Sucursal', 'Evento de apertura de la nueva sucursal', '2024-07-15', 'Sucursal Norte');
INSERT INTO Patrocinios (nombre, descripcion, fecha, monto) VALUES ('Patrocinio Deportivo', 'Patrocinio de equipo local', '2024-05-01', 2000.00);

-- 9. Mantenimiento y Servicios
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Refrigerador Industrial', 'Refrigerador para lácteos', '2023-01-01', 'operativo');
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (1, '2024-01-15', 'Revisión general', 100.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (1, '2024-04-20', 'Reparación de compresor', 500.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Limpieza', 'Servicio de limpieza mensual', '2024-01-01', '2024-12-31', 1200.00);
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Limpiezas Rápidas', 'Maria Lopez', '321321321', 'Calle Verde 789');
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (1, 'Fallo en el sistema de enfriamiento', CURRENT_TIMESTAMP);

-- 10. Información General y Configuración
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Central', 'Av. Principal 123', 'Lima', 'Perú');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (1, 'Pasillo 1');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaIVA', '18');
INSERT INTO Paises (nombre) VALUES ('Perú');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Lima');
INSERT INTO TiposDocumento (descripcion) VALUES ('DNI');
INSERT INTO Monedas (nombre, simbolo) VALUES ('Nuevo Sol', 'S/');
