create database plaza_vea -- Base de Datos: Supermercado
go

drop database plaza_vea
go

-- creacion con datos especificos

CREATE DATABASE plaza_vea
ON 
(
    NAME = plaza_vea_dat,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROK\MSSQL\DATA\plaza_vea_dat.mdf',  -- Ruta del archivo MDF
    SIZE = 500MB,                                -- Tamaño inicial del archivo MDF
    MAXSIZE = UNLIMITED,                         -- Sin límite de crecimiento máximo
    FILEGROWTH = 100MB                           -- Incremento del tamaño del archivo MDF
)
LOG ON
(
    NAME = plaza_vea_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROK\MSSQL\DATA\plaza_vea_log.ldf',  -- Ruta del archivo LDF
    SIZE = 100MB,                                -- Tamaño inicial del archivo LDF
    MAXSIZE = 1GB,                               -- Tamaño máximo del archivo LDF
    FILEGROWTH = 50MB                            -- Incremento del tamaño del archivo LDF
);

	
use plaza_vea
go

-- FABIOLA
-- GUSTABO
-- IVAN
-- MICHAEL
-- JOSE

	--  DDL (DROP)
	-- DML (SELECT, UPDATE, INSERT y DELETE)
	

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

-- Insercion de datos
-- Categorias
-- insert

INSERT INTO Categorias (nombre) 
VALUES 
('Alimentos'),
('Electrónica'),
('Ropa'),
('Muebles'),
('Hogar y Cocina'),
('Juguetes'),
('Zapatillas'),
('Salud y Belleza'),
('Libros'),
('Deportes'),
('Accesorios para Vehículos'),
('Bebidas'),
('Computadoras'),
('Teléfonos'),
('Videojuegos'),
('Instrumentos Musicales'),
('Oficina y Papelería'),
('Mascotas'),
('Jardinería'),
('Herramientas'),
('Relojes'),
('Joyas'),
('Cámaras y Fotografía'),
('Software'),
('Productos de Limpieza'),
('Artículos de Viaje'),
('Maternidad'),
('Baño'),
('Bolsos y Carteras'),
('Decoración'),
('Fitness'),
('Moda Infantil'),
('Cuidado del Cabello'),
('Perfumes'),
('Protección y Seguridad'),
('Artículos de Bebé'),
('Electrodomésticos'),
('Lencería'),
('Accesorios para Mascotas'),
('Almacenamiento y Organización'),
('Audio y Video'),
('Artículos de Caza y Pesca'),
('Bicicletas y Accesorios'),
('Cuidado de la Piel'),
('Cuidado Oral'),
('Lentes y Accesorios'),
('Ropa Deportiva'),
('Suplementos Nutricionales'),
('Video y Entretenimiento');
-- select
Select*from Categorias;
SELECT * FROM Categorias WHERE id_categoria = 1;
SELECT * FROM Categorias WHERE nombre LIKE '%Electro%';
SELECT nombre FROM Categorias;
SELECT COUNT(*) AS total_categorias FROM Categorias;
---update
UPDATE Categorias SET nombre= 'Electrodomesticos'where id_categoria = 2;
UPDATE Categorias SET nombre = 'Casa' WHERE nombre LIKE '%Hogar%';
UPDATE Categorias SET nombre = 'Vestimenta' WHERE id_categoria = 3;
UPDATE Categorias SET nombre = 'Juguetes y Juegos' WHERE nombre = 'Juguetes';
UPDATE Categorias SET nombre = 'Alimentos y Bebidas' WHERE id_categoria = 1;

---delete
DELETE FROM Categorias WHERE id_categoria=2;
DELETE FROM Categorias WHERE id_categoria = 4;
DELETE FROM Categorias WHERE nombre LIKE '%Electro%';
DELETE FROM Categorias WHERE id_categoria = 5 AND nombre = 'Hogar y Cocina';
DELETE FROM Categorias WHERE id_categoria > 7;

---drop
DROP TABLE Categorias;


-- Subcategorias
---select
Select*from Subcategorias;
SELECT * FROM Subcategorias WHERE id_subcategoria = 1;
SELECT * FROM Subcategorias WHERE id_categoria = 2;
SELECT nombre FROM Subcategorias;
SELECT id_categoria, COUNT(*) AS total_subcategorias FROM Subcategorias GROUP BY id_categoria;

---insert
INSERT INTO Subcategorias (id_categoria, nombre) 
VALUES 
(1, 'Frescos'),
(1, 'Congelados'),
(1, 'Lácteos'),
(1, 'Panadería'),
(1, 'Bebidas no Alcohólicas'),
(1, 'Snacks'),
(1, 'Despensa'),
(2, 'Celulares'),
(2, 'Cámaras'),
(2, 'Audio y Video'),
(2, 'Televisores'),
(2, 'Computadoras'),
(2, 'Consolas de Videojuegos'),
(2, 'Accesorios Electrónicos'),
(3, 'Ropa de Niños'),
(3, 'Ropa Deportiva'),
(3, 'Accesorios de Ropa'),
(3, 'Calzado'),
(3, 'Ropa Interior'),
(3, 'Hombres'),
(3, 'Mujeres'),
(4, 'Sala'),
(4, 'Dormitorio'),
(4, 'Comedor'),
(4, 'Oficina'),
(4, 'Exterior'),
(4, 'Cocina'),
(4, 'Baño'),
(5, 'Cocina'),
(5, 'Decoración Hogar'),
(5, 'Electrodomésticos'),
(5, 'Organización Hogar'),
(5, 'Jardín'),
(6, 'Muñecas'),
(6, 'Juegos de Mesa'),
(6, 'Juguetes Educativos'),
(6, 'Juguetes Electrónicos'),
(6, 'Juguetes de Construcción'),
(6, 'Juguetes de Aventura'),
(6, 'Vehículos de Juguete'),
(7, 'Zapatillas de Hombre'),
(7, 'Zapatillas de Mujer'),
(7, 'Zapatillas de Niños'),
(7, 'Zapatillas Deportivas'),
(7, 'Botas'),
(8, 'Maquillaje'),
(8, 'Cuidado de la Piel'),
(8, 'Cuidado del Cabello'),
(8, 'Perfumes'),
(8, 'Salud y Bienestar');

---update
UPDATE Subcategorias SET nombre= 'TV y Video' where id_subcategoria = 3;
UPDATE Subcategorias SET nombre = 'Electrodomésticos' WHERE id_subcategoria = 2;
UPDATE Subcategorias SET nombre = 'Electrónica para el hogar' WHERE id_categoria = 2;
UPDATE Subcategorias SET id_categoria = 3 WHERE id_subcategoria = 4;
UPDATE Subcategorias SET nombre = 'Verduras Frescas' WHERE id_subcategoria = 1;

---delete
DELETE FROM Subcategorias WHERE id_subcategoria=4;
DELETE FROM Subcategorias WHERE nombre LIKE '%Electro%';
DELETE FROM Subcategorias WHERE id_categoria > 5;
DELETE FROM Subcategorias WHERE id_subcategoria = 5 AND nombre = 'Juguetes Educativos';
DELETE FROM Subcategorias WHERE id_categoria = 3;

---drop
DROP TABLE Subcategorias;


--- Marcas
--select
Select*from Marcas;
SELECT * FROM Marcas WHERE id_marca = 1;
SELECT * FROM Marcas WHERE nombre LIKE '%Nike%';
SELECT nombre FROM Marcas;
SELECT COUNT(*) AS total_marcas FROM Marcas;

---insert
INSERT INTO Marcas (nombre) 
VALUES 
('Nike'),
('Adidas'),
('Apple'),
('Samsung'),
('Microsoft'),
('Sony'),
('LG'),
('Lenovo'),
('Huawei'),
('Dell'),
('HP'),
('Asus'),
('Bosch'),
('Whirlpool'),
('Philips'),
('Panasonic'),
('Tefal'),
('Nestlé'),
('Coca-Cola'),
('Pepsi'),
('Unilever'),
('Procter & Gamble'),
('LÓ\Oréal'),
('Maybelline'),
('Nivea'),
('Colgate'),
('Gillette'),
('Johnson & Johnson'),
('Kellogg\s'),
('Heinz'),
('Danone'),
('Red Bull'),
('Xiaomi'),
('Google'),
('Amazon'),
('Intel'),
('AMD'),
('Logitech'),
('Canon'),
('Nikon'),
('Puma'),
('Reebok'),
('Under Armour'),
('New Balance'),
('Tommy Hilfiger'),
('Levi\s'),
('Zara'),
('H&M'),
('Gucci'),
('Prada');

---update
UPDATE Marcas SET nombre= 'Apple Inc.' where id_marca = 3;
UPDATE Marcas SET nombre = 'Adidas Originals' WHERE nombre LIKE '%Adidas%';
UPDATE Marcas SET nombre = 'Sony Corporation' WHERE nombre = 'Sony';
UPDATE Marcas SET nombre = 'Adidas AG' WHERE id_marca = 2;
UPDATE Marcas SET nombre = 'Nike Inc.' WHERE id_marca = 1;

---delete
DELETE FROM Marcas WHERE id_marca=2;
DELETE FROM Marcas WHERE nombre LIKE '%Microsoft%';
DELETE FROM Marcas WHERE nombre = 'Huawei';
DELETE FROM Marcas WHERE id_marca > 7;
DELETE FROM Marcas WHERE id_marca = 5 AND nombre = 'Samsung';

---drop
DROP TABLE Marcas;


---UNIDADES DE MEDIDA
--select
SELECT * FROM UnidadesDeMedida;
SELECT * FROM UnidadesDeMedida WHERE id_unidad = 1;
SELECT * FROM UnidadesDeMedida WHERE nombre LIKE '%Metro%';
Select*from UnidadesDeMedida WHERE nombre LIKE '%o%';
SELECT nombre, abreviacion FROM UnidadesDeMedida;

---insert
INSERT INTO UnidadesDeMedida (nombre, abreviacion) 
VALUES 
('Metro', 'm'),
('Kilogramo', 'kg'),
('Litro', 'L'),
('Pieza', 'pz'),
('Metro cuadrado', 'm²'),
('Centímetro', 'cm'),
('Milímetro', 'mm'),
('Gramo', 'g'),
('Mililitro', 'ml'),
('Tonelada', 't'),
('Hora', 'h'),
('Minuto', 'min'),
('Segundo', 's'),
('Día', 'd'),
('Semana', 'sem'),
('Mes', 'mes'),
('Año', 'año'),
('Decímetro', 'dm'),
('Microgramo', 'µg'),
('Nanogramo', 'ng'),
('Pulgada', 'in'),
('Pie', 'ft'),
('Yarda', 'yd'),
('Milla', 'mi'),
('Onza', 'oz'),
('Libra', 'lb'),
('Galón', 'gal'),
('Cuarto de galón', 'qt'),
('Pinta', 'pt'),
('Taza', 'cup'),
('Decilitro', 'dl'),
('Hectolitro', 'hl'),
('Celsius', '°C'),
('Fahrenheit', '°F'),
('Kelvin', 'K'),
('Newton', 'N'),
('Joule', 'J'),
('Watt', 'W'),
('Pascal', 'Pa'),
('Volt', 'V'),
('Ampere', 'A'),
('Ohm', 'Ω'),
('Siemens', 'S'),
('Hertz', 'Hz'),
('Lux', 'lx'),
('Candela', 'cd'),
('Mole', 'mol'),
('Rad', 'rd'),
('Gray', 'Gy');

---update
UPDATE UnidadesDeMedida SET nombre= 'Galon' where id_unidad = 3;
UPDATE UnidadesDeMedida SET nombre = 'Centímetro', abreviacion = 'cm' WHERE id_unidad = 1;
UPDATE UnidadesDeMedida SET nombre = 'Kilo' WHERE nombre LIKE '%Kilogramo%';
UPDATE UnidadesDeMedida SET nombre = 'Metro Cúbico', abreviacion = 'm³' WHERE id_unidad = 4;
UPDATE UnidadesDeMedida SET nombre = 'Unidad', abreviacion = 'unid' WHERE nombre = 'Pieza';

---delete
DELETE FROM UnidadesDeMedida WHERE len(abreviacion)>3;
DELETE FROM UnidadesDeMedida WHERE id_unidad = 4;
DELETE FROM UnidadesDeMedida WHERE nombre LIKE '%Metro%';
DELETE FROM UnidadesDeMedida WHERE nombre = 'Litro';
DELETE FROM UnidadesDeMedida WHERE id_unidad > 3;

---drop
DROP TABLE UnidadesDeMedida;


---PRODUCTOS
--select
Select*from Productos;
SELECT * FROM Productos WHERE id_producto = 1;
SELECT * FROM Productos WHERE precio > 100;
SELECT nombre, precio FROM Productos;
SELECT id_subcategoria, COUNT(*) AS total_productos FROM Productos GROUP BY id_subcategoria;

---insert
INSERT INTO Productos (nombre, descripcion, id_subcategoria, id_marca, id_unidad, precio, stock_minimo, stock_maximo)
VALUES 
('Laptop', 'Laptop de última generación', 2, 4, 1, 1299.99, 5, 50),
('Camisa', 'Camisa de algodón para hombre', 3, 2, 4, 29.99, 20, 200),
('Cama King Size', 'Cama King Size con cabecera de madera', 4, 1, 5, 899.99, 2, 20),
('Libro de Cocina', 'Libro de recetas internacionales', 7, 6, 7, 19.99, 10, 100),
('Reproductor de MP3', 'Reproductor de MP3 con capacidad de 32GB', 2, 5, 1, 49.99, 15, 150),
('Smartphone', 'Smartphone con pantalla de 6.5 pulgadas', 2, 4, 1, 599.99, 10, 100),
('Televisor 4K', 'Televisor 4K UHD de 55 pulgadas', 2, 3, 1, 799.99, 3, 30),
('Zapatillas Deportivas', 'Zapatillas deportivas para correr', 7, 1, 4, 89.99, 25, 250),
('Guitarra Eléctrica', 'Guitarra eléctrica con amplificador', 6, 8, 1, 199.99, 5, 50),
('Microondas', 'Microondas con grill de 25L', 5, 12, 1, 99.99, 8, 80),
('Mesa de Comedor', 'Mesa de comedor de madera para 6 personas', 4, 14, 5, 299.99, 2, 20),
('Cámara Digital', 'Cámara digital de 24MP', 2, 10, 1, 349.99, 4, 40),
('Perfume', 'Perfume de 100ml para mujer', 8, 22, 3, 79.99, 15, 150),
('Monitor 27"', 'Monitor LED de 27 pulgadas', 2, 4, 1, 199.99, 10, 100),
('Tostadora', 'Tostadora de 4 ranuras', 5, 13, 1, 49.99, 10, 100),
('Tablet', 'Tablet con pantalla de 10 pulgadas', 2, 4, 1, 399.99, 5, 50),
('Sofá', 'Sofá de tres plazas', 4, 1, 5, 499.99, 1, 10),
('Reloj Inteligente', 'Reloj inteligente con GPS', 2, 6, 1, 149.99, 20, 200),
('Auriculares Bluetooth', 'Auriculares Bluetooth con cancelación de ruido', 2, 5, 1, 129.99, 30, 300),
('Impresora Láser', 'Impresora láser multifuncional', 2, 9, 1, 249.99, 2, 20),
('Frigorífico', 'Frigorífico con congelador inferior', 5, 12, 1, 999.99, 1, 10),
('Batidora', 'Batidora de mano', 5, 13, 1, 29.99, 20, 200),
('Altavoz Bluetooth', 'Altavoz Bluetooth portátil', 2, 10, 1, 59.99, 15, 150),
('Cafetera', 'Cafetera de cápsulas', 5, 15, 1, 89.99, 10, 100),
('Barra de Sonido', 'Barra de sonido con subwoofer', 2, 3, 1, 199.99, 5, 50),
('Ventilador', 'Ventilador de torre', 5, 16, 1, 49.99, 8, 80),
('Plancha de Vapor', 'Plancha de vapor con sistema antical', 5, 11, 1, 39.99, 12, 120),
('Cámara de Seguridad', 'Cámara de seguridad para exterior', 2, 17, 1, 99.99, 5, 50),
('Lámpara LED', 'Lámpara LED de escritorio', 5, 13, 1, 19.99, 20, 200),
('Cuna para Bebé', 'Cuna de madera con barandillas', 4, 18, 5, 299.99, 2, 20),
('Robot Aspirador', 'Robot aspirador con conexión WiFi', 5, 19, 1, 299.99, 3, 30),
('Máquina de Coser', 'Máquina de coser portátil', 5, 11, 1, 199.99, 4, 40),
('Cámara Deportiva', 'Cámara deportiva resistente al agua', 2, 10, 1, 149.99, 10, 100),
('Espejo Inteligente', 'Espejo inteligente con luz LED', 8, 20, 1, 89.99, 10, 100),
('Impresora 3D', 'Impresora 3D de alta precisión', 2, 21, 1, 499.99, 1, 10),
('Juego de Ollas', 'Juego de ollas de acero inoxidable', 5, 14, 1, 129.99, 10, 100),
('Taladro Inalámbrico', 'Taladro inalámbrico con batería recargable', 5, 16, 1, 89.99, 8, 80),
('Router WiFi', 'Router WiFi de doble banda', 2, 17, 1, 69.99, 10, 100),
('Impresora Fotográfica', 'Impresora fotográfica de alta calidad', 2, 9, 1, 249.99, 2, 20),
('Teclado Mecánico', 'Teclado mecánico retroiluminado', 2, 22, 1, 99.99, 20, 200),
('Bicicleta Eléctrica', 'Bicicleta eléctrica con motor de 250W', 10, 23, 1, 899.99, 2, 20),
('Reloj de Pulsera', 'Reloj de pulsera de acero inoxidable', 8, 24, 1, 149.99, 10, 100),
('Mochila', 'Mochila resistente al agua', 8, 25, 4, 39.99, 30, 300),
('Cafetera Espresso', 'Cafetera espresso automática', 5, 15, 1, 149.99, 5, 50),
('Deshumidificador', 'Deshumidificador de 20L', 5, 19, 1, 199.99, 5, 50),
('Barbacoa', 'Barbacoa de carbón portátil', 5, 26, 1, 99.99, 8, 80),
('Aspiradora', 'Aspiradora sin bolsa', 5, 12, 1, 149.99, 5, 50),
('Cámara Instantánea', 'Cámara instantánea con 10 películas', 2, 10, 1, 99.99, 10, 100),
('Freidora de Aire', 'Freidora de aire de 3.5L', 5, 27, 1, 79.99, 10, 100),
('Juego de Maletas', 'Juego de maletas rígidas', 4, 28, 5, 199.99, 3, 30);

---update
UPDATE Productos SET precio= 549.99 where id_producto = 1;
UPDATE Productos SET nombre = 'Laptop Gaming', precio = 1599.99 WHERE id_producto = 1;
UPDATE Productos SET precio = 39.99 WHERE id_subcategoria = 3;
UPDATE Productos SET stock_maximo = 200 WHERE id_producto = 5;
UPDATE Productos SET descripcion = 'Camisa de algodón para hombre de alta calidad' WHERE nombre = 'Camisa';

---delete
DELETE FROM Productos WHERE id_producto=2;
DELETE FROM Productos WHERE precio < 10;
DELETE FROM Productos WHERE id_producto = 5 AND nombre = 'Reproductor de MP3';
DELETE FROM Productos WHERE id_producto > 7;
DELETE FROM Productos WHERE id_producto = 4;

---drop
DROP TABLE Productos;


---INVENTARIO GENERAL
--select
Select*from InventarioGeneral;
SELECT COUNT(*) AS total_registros FROM InventarioGeneral;
SELECT * FROM InventarioGeneral WHERE cantidad < 10;
SELECT cantidad FROM InventarioGeneral WHERE id_producto = 1;
SELECT P.nombre AS nombre_producto, IG.cantidad FROM InventarioGeneral IG INNER JOIN Productos P ON IG.id_producto = P.id_producto;

---insert
INSERT INTO InventarioGeneral (id_producto, cantidad) 
VALUES 
(1, 50),
(2, 100),
(3, 25),
(4, 10),
(5, 150),
(6, 75),
(7, 30),
(8, 200),
(9, 40),
(10, 60),
(11, 15),
(12, 120),
(13, 45),
(14, 90),
(15, 35),
(16, 110),
(17, 80),
(18, 140),
(19, 70),
(20, 55),
(21, 130),
(22, 25),
(23, 95),
(24, 85),
(25, 20),
(26, 105),
(27, 50),
(28, 75),
(29, 100),
(30, 150),
(31, 60),
(32, 40),
(33, 200),
(34, 30),
(35, 15),
(36, 80),
(37, 140),
(38, 110),
(39, 70),
(40, 55),
(41, 45),
(42, 95),
(43, 120),
(44, 35),
(45, 130),
(46, 85),
(47, 25),
(48, 105),
(49, 50),
(50, 90);

---update
UPDATE InventarioGeneral SET cantidad= 75 where id_producto = 4;
UPDATE InventarioGeneral SET cantidad = 15 WHERE id_producto = 2;
UPDATE InventarioGeneral SET cantidad = 20 WHERE id_producto = 3;
UPDATE InventarioGeneral SET cantidad = cantidad + 10;
UPDATE InventarioGeneral SET cantidad = 50 WHERE id_producto = 1;

---delete
DELETE FROM InventarioGeneral WHERE id_inventario = 2;
DELETE FROM InventarioGeneral WHERE id_inventario > 10;
DELETE FROM InventarioGeneral WHERE id_producto = 5 AND cantidad = 25;
DELETE FROM InventarioGeneral WHERE cantidad < 5;
DELETE FROM InventarioGeneral WHERE id_inventario = 4;

---drop
DROP TABLE InventarioGeneral;


---INVENTARIO GENERAL
--select
Select*from InventarioGeneral;
SELECT COUNT(*) AS total_registros FROM InventarioGeneral;
SELECT * FROM InventarioGeneral WHERE cantidad < 10;
SELECT cantidad FROM InventarioGeneral WHERE id_producto = 1;
SELECT P.nombre AS nombre_producto, IG.cantidad FROM InventarioGeneral IG INNER JOIN Productos P ON IG.id_producto = P.id_producto;

---insert
INSERT INTO InventarioGeneral (id_producto, cantidad) 
VALUES 
(1, 50),
(2, 100),
(3, 25),
(4, 10),
(5, 150),
(6, 75),
(7, 30),
(8, 200),
(9, 40),
(10, 60),
(11, 15),
(12, 120),
(13, 45),
(14, 90),
(15, 35),
(16, 110),
(17, 80),
(18, 140),
(19, 70),
(20, 55),
(21, 130),
(22, 25),
(23, 95),
(24, 85),
(25, 20),
(26, 105),
(27, 50),
(28, 75),
(29, 100),
(30, 150),
(31, 60),
(32, 40),
(33, 200),
(34, 30),
(35, 15),
(36, 80),
(37, 140),
(38, 110),
(39, 70),
(40, 55),
(41, 45),
(42, 95),
(43, 120),
(44, 35),
(45, 130),
(46, 85),
(47, 25),
(48, 105),
(49, 50),
(50, 90);

---update
UPDATE InventarioGeneral SET cantidad= 75 where id_producto = 4;
UPDATE InventarioGeneral SET cantidad = 15 WHERE id_producto = 2;
UPDATE InventarioGeneral SET cantidad = 20 WHERE id_producto = 3;
UPDATE InventarioGeneral SET cantidad = cantidad + 10;
UPDATE InventarioGeneral SET cantidad = 50 WHERE id_producto = 1;

---delete
DELETE FROM InventarioGeneral WHERE id_inventario = 2;
DELETE FROM InventarioGeneral WHERE id_inventario > 10;
DELETE FROM InventarioGeneral WHERE id_producto = 5 AND cantidad = 25;
DELETE FROM InventarioGeneral WHERE cantidad < 5;
DELETE FROM InventarioGeneral WHERE id_inventario = 4;

---drop
DROP TABLE InventarioGeneral;

---ALMACENES
--select
Select*from Almacenes;
SELECT * FROM Almacenes WHERE id_almacen = 1;
SELECT * FROM Almacenes WHERE nombre LIKE '%Central%';
SELECT nombre, ubicacion FROM Almacenes;
SELECT COUNT(*) AS total_almacenes FROM Almacenes;

---insert
INSERT INTO Almacenes (nombre, ubicacion) 
VALUES 
('Almacén de Reservas', 'Calle Reservas 789, Ciudad'),
('Almacén Central', 'Avenida Central 012, Ciudad'),
('Almacén Norte', 'Calle Norte 456, Ciudad'),
('Almacén Sur', 'Avenida Sur 789, Ciudad'),
('Almacén de Pruebas', 'Calle de Pruebas 123, Ciudad'),
('Almacén Este', 'Avenida Este 345, Ciudad'),
('Almacén Oeste', 'Calle Oeste 678, Ciudad'),
('Almacén Internacional', 'Avenida Internacional 910, Ciudad'),
('Almacén de Exportación', 'Calle Exportación 111, Ciudad'),
('Almacén de Importación', 'Avenida Importación 222, Ciudad'),
('Almacén de Productos Perecederos', 'Calle Perecederos 333, Ciudad'),
('Almacén de Equipos Electrónicos', 'Avenida Electrónicos 444, Ciudad'),
('Almacén de Muebles', 'Calle Muebles 555, Ciudad'),
('Almacén de Textiles', 'Avenida Textiles 666, Ciudad'),
('Almacén de Juguetes', 'Calle Juguetes 777, Ciudad'),
('Almacén de Alimentos', 'Avenida Alimentos 888, Ciudad'),
('Almacén de Bebidas', 'Calle Bebidas 999, Ciudad'),
('Almacén de Ropa', 'Avenida Ropa 101, Ciudad'),
('Almacén de Calzado', 'Calle Calzado 202, Ciudad'),
('Almacén de Accesorios', 'Avenida Accesorios 303, Ciudad'),
('Almacén de Herramientas', 'Calle Herramientas 404, Ciudad'),
('Almacén de Deportes', 'Avenida Deportes 505, Ciudad'),
('Almacén de Cosméticos', 'Calle Cosméticos 606, Ciudad'),
('Almacén de Papelería', 'Avenida Papelería 707, Ciudad'),
('Almacén de Libros', 'Calle Libros 808, Ciudad'),
('Almacén de Juguetes Electrónicos', 'Avenida Juguetes Electrónicos 909, Ciudad'),
('Almacén de Material Escolar', 'Calle Material Escolar 100, Ciudad'),
('Almacén de Productos de Limpieza', 'Avenida Productos de Limpieza 200, Ciudad'),
('Almacén de Artículos para Mascotas', 'Calle Artículos para Mascotas 300, Ciudad'),
('Almacén de Jardinería', 'Avenida Jardinería 400, Ciudad'),
('Almacén de Decoración', 'Calle Decoración 500, Ciudad'),
('Almacén de Automóviles', 'Avenida Automóviles 600, Ciudad'),
('Almacén de Motocicletas', 'Calle Motocicletas 700, Ciudad'),
('Almacén de Bicicletas', 'Avenida Bicicletas 800, Ciudad'),
('Almacén de Suministros Médicos', 'Calle Suministros Médicos 900, Ciudad'),
('Almacén de Electrodomésticos', 'Avenida Electrodomésticos 1000, Ciudad'),
('Almacén de Productos Orgánicos', 'Calle Productos Orgánicos 110, Ciudad'),
('Almacén de Artículos de Oficina', 'Avenida Artículos de Oficina 220, Ciudad'),
('Almacén de Artículos para el Hogar', 'Calle Artículos para el Hogar 330, Ciudad'),
('Almacén de Ferretería', 'Avenida Ferretería 440, Ciudad'),
('Almacén de Pinturas', 'Calle Pinturas 550, Ciudad'),
('Almacén de Material de Construcción', 'Avenida Material de Construcción 660, Ciudad'),
('Almacén de Productos para Bebés', 'Calle Productos para Bebés 770, Ciudad'),
('Almacén de Electrónica de Consumo', 'Avenida Electrónica de Consumo 880, Ciudad'),
('Almacén de Mantenimiento', 'Calle Mantenimiento 990, Ciudad'),
('Almacén de Logística', 'Avenida Logística 111, Ciudad');

---update
UPDATE Almacenes SET ubicacion= 'Nueva ubicacion' where id_almacen = 1;
UPDATE Almacenes SET nombre = 'Almacén Principal', ubicacion = 'Avenida Principal 123, Ciudad' WHERE id_almacen = 1;
UPDATE Almacenes SET nombre = 'Norte 2' WHERE nombre LIKE '%Norte%';
UPDATE Almacenes SET ubicacion = 'Calle Nueva 456, Ciudad' WHERE id_almacen = 3;
UPDATE Almacenes SET ubicacion = 'Calle Vieja 789, Ciudad' WHERE id_almacen = 2;
UPDATE Almacenes SET nombre = 'Almacén de Reservas y Devoluciones' WHERE nombre = 'Almacén de Reservas';

---delete
DELETE FROM Almacenes WHERE nombre='Almacen Central';
DELETE FROM Almacenes WHERE id_almacen = 4;
DELETE FROM Almacenes WHERE nombre LIKE '%Pruebas%';
DELETE FROM Almacenes WHERE id_almacen = 5 AND nombre = 'Almacén de Pruebas';
DELETE FROM Almacenes WHERE id_almacen > 7;

---drop
DROP TABLE Almacenes;

---SECCIONES ALMACEN
--select
Select*from SeccionesAlmacen;
SELECT * FROM SeccionesAlmacen WHERE id_almacen = 2;
SELECT SA.nombre AS nombre_seccion, A.nombre AS nombre_almacen FROM SeccionesAlmacen SA INNER JOIN Almacenes A ON SA.id_almacen = A.id_almacen;
SELECT * FROM SeccionesAlmacen WHERE nombre LIKE '%Libros%';
SELECT COUNT(*) AS total_secciones FROM SeccionesAlmacen;

---insert
INSERT INTO SeccionesAlmacen (id_almacen, nombre) 
VALUES 
(2, 'Sección de Hogar'),
(3, 'Sección de Alimentos'),
(1, 'Sección de Muebles'),
(2, 'Sección de Libros'),
(3, 'Sección de Cuidado Personal'),
(1, 'Sección de Electrónica'),
(2, 'Sección de Juguetes'),
(3, 'Sección de Ropa'),
(1, 'Sección de Deportes'),
(2, 'Sección de Ferretería'),
(3, 'Sección de Jardinería'),
(1, 'Sección de Automóviles'),
(2, 'Sección de Mascotas'),
(3, 'Sección de Bebidas'),
(1, 'Sección de Lácteos'),
(2, 'Sección de Congelados'),
(3, 'Sección de Vinos'),
(1, 'Sección de Panadería'),
(2, 'Sección de Frutas'),
(3, 'Sección de Verduras'),
(1, 'Sección de Pescados'),
(2, 'Sección de Carnes'),
(3, 'Sección de Material Escolar'),
(1, 'Sección de Papelería'),
(2, 'Sección de Artículos de Oficina'),
(3, 'Sección de Juguetes Electrónicos'),
(1, 'Sección de Cosméticos'),
(2, 'Sección de Herramientas'),
(3, 'Sección de Decoración'),
(1, 'Sección de Pinturas'),
(2, 'Sección de Material de Construcción'),
(3, 'Sección de Productos Orgánicos'),
(1, 'Sección de Electrodomésticos'),
(2, 'Sección de Bicicletas'),
(3, 'Sección de Motocicletas'),
(1, 'Sección de Productos de Limpieza'),
(2, 'Sección de Suministros Médicos'),
(3, 'Sección de Artículos para el Hogar'),
(1, 'Sección de Electrónica de Consumo'),
(2, 'Sección de Mantenimiento'),
(3, 'Sección de Logística'),
(1, 'Sección de Productos para Bebés'),
(2, 'Sección de Decoración'),
(3, 'Sección de Textiles'),
(1, 'Sección de Calzado'),
(2, 'Sección de Accesorios');

---update
UPDATE SeccionesAlmacen SET nombre= 'Seccion de Moda' where id_seccion = 2;
UPDATE SeccionesAlmacen SET nombre = 'Electrónicos y Tecnología' WHERE nombre LIKE '%Electrónicos%';
UPDATE SeccionesAlmacen SET nombre = 'Sección de Hogar y Cocina' WHERE id_almacen = 3;
UPDATE SeccionesAlmacen SET nombre = 'Sección de Moda' WHERE nombre = 'Sección de Ropa';
UPDATE SeccionesAlmacen SET nombre = 'Sección de Accesorios' WHERE id_almacen = 1;

---delete
DELETE FROM SeccionesAlmacen WHERE id_seccion=3;
DELETE FROM SeccionesAlmacen WHERE nombre LIKE '%Herramientas%';
DELETE FROM SeccionesAlmacen WHERE nombre = 'Sección de Juguetes';
DELETE FROM SeccionesAlmacen WHERE id_seccion = 5 AND nombre = 'Sección de Tecnología';
DELETE FROM SeccionesAlmacen WHERE id_seccion > 7;

---drop
DROP TABLE SeccionesAlmacen;



---MOVIMIENTOS INVENTARIO
--select
Select*from MovimientosInventario;
SELECT * FROM MovimientosInventario WHERE id_producto = 3 AND tipo_movimiento = 'entrada';
SELECT * FROM MovimientosInventario WHERE id_almacen = 2 AND tipo_movimiento = 'salida';
SELECT * FROM MovimientosInventario WHERE CAST(fecha AS DATE) = '2024-05-28';
SELECT COUNT(*) AS total_entradas FROM MovimientosInventario WHERE tipo_movimiento = 'entrada';

---insert
INSERT INTO MovimientosInventario (id_producto, id_almacen, cantidad, tipo_movimiento)
VALUES 
(1, 1, 20, 'entrada'),
(2, 2, 15, 'salida'),
(3, 1, 10, 'entrada'),
(4, 2, 5, 'salida'),
(5, 3, 25, 'entrada'),
(6, 2, 30, 'entrada'),
(7, 1, 40, 'salida'),
(8, 3, 50, 'entrada'),
(9, 1, 20, 'salida'),
(10, 2, 15, 'entrada'),
(11, 1, 25, 'salida'),
(12, 3, 10, 'entrada'),
(13, 2, 35, 'entrada'),
(14, 1, 45, 'salida'),
(15, 3, 55, 'entrada'),
(16, 2, 20, 'salida'),
(17, 1, 30, 'entrada'),
(18, 3, 40, 'entrada'),
(19, 2, 50, 'salida'),
(20, 1, 25, 'entrada'),
(21, 3, 35, 'salida'),
(22, 2, 45, 'entrada'),
(23, 1, 55, 'salida'),
(24, 3, 20, 'entrada'),
(25, 2, 30, 'entrada'),
(26, 1, 40, 'salida'),
(27, 3, 50, 'entrada'),
(28, 2, 20, 'salida'),
(29, 1, 30, 'entrada'),
(30, 3, 40, 'entrada'),
(31, 2, 25, 'salida'),
(32, 1, 35, 'entrada'),
(33, 3, 45, 'entrada'),
(34, 2, 20, 'salida'),
(35, 1, 30, 'entrada'),
(36, 3, 40, 'entrada'),
(37, 2, 50, 'salida'),
(38, 1, 25, 'entrada'),
(39, 3, 35, 'salida'),
(40, 2, 45, 'entrada'),
(41, 1, 55, 'salida'),
(42, 3, 20, 'entrada'),
(43, 2, 30, 'entrada'),
(44, 1, 40, 'salida'),
(45, 3, 50, 'entrada'),
(46, 2, 20, 'salida'),
(47, 1, 30, 'entrada'),
(48, 3, 40, 'entrada'),
(49, 2, 25, 'salida'),
(50, 1, 35, 'entrada');
---update
UPDATE MovimientosInventario SET cantidad= 30 where id_movimiento = 1;
UPDATE MovimientosInventario SET tipo_movimiento = 'salida' WHERE id_movimiento = 3;
UPDATE MovimientosInventario SET fecha = '2024-05-30 09:45:00' WHERE id_movimiento = 2;
UPDATE MovimientosInventario SET cantidad = 15 WHERE id_movimiento = 4;
UPDATE MovimientosInventario SET tipo_movimiento = 'entrada' WHERE id_movimiento = 5;

---delete
DELETE FROM MovimientosInventario WHERE id_movimiento=2;
DELETE FROM MovimientosInventario WHERE tipo_movimiento = 'salida';
DELETE FROM MovimientosInventario WHERE id_producto = 2;
DELETE FROM MovimientosInventario WHERE id_movimiento = 7 AND cantidad = 25;
DELETE FROM MovimientosInventario WHERE id_movimiento > 15;

---drop
DROP TABLE MovimientosInventario;


---CLIENTES
--select
Select*from Clientes;
SELECT * FROM Clientes WHERE nombre = 'Juan';
SELECT * FROM Clientes WHERE correo IS NOT NULL;
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo FROM Clientes;
SELECT COUNT(*) AS total_clientes FROM Clientes;

---insert
INSERT INTO Clientes (nombre, apellido, correo, telefono)
VALUES 
('Juan', 'Perez', 'juan.perez@example.com', '123-456-789'),
('Ana', 'Gomez', 'ana.gomez@example.com', '234-567-890'),
('Luis', 'Martinez', 'luis.martinez@example.com', '345-678-901'),
('Maria', 'Lopez', 'maria.lopez@example.com', '456-789-012'),
('Carlos', 'Diaz', 'carlos.diaz@example.com', '567-890-123'),
('Sofia', 'Rodriguez', 'sofia.rodriguez@example.com', '678-901-234'),
('Jorge', 'Hernandez', 'jorge.hernandez@example.com', '789-012-345'),
('Fernanda', 'Garcia', 'fernanda.garcia@example.com', '890-123-456'),
('Diego', 'Sanchez', 'diego.sanchez@example.com', '901-234-567'),
('Valentina', 'Perez', 'valentina.perez@example.com', '012-345-678'),
('Mateo', 'Gonzalez', 'mateo.gonzalez@example.com', '123-456-789'),
('Camila', 'Ramirez', 'camila.ramirez@example.com', '234-567-890'),
('Nicolas', 'Torres', 'nicolas.torres@example.com', '345-678-901'),
('Isabella', 'Diaz', 'isabella.diaz@example.com', '456-789-012'),
('Daniel', 'Martinez', 'daniel.martinez@example.com', '567-890-123'),
('Paula', 'Lopez', 'paula.lopez@example.com', '678-901-234'),
('Gabriel', 'Castro', 'gabriel.castro@example.com', '789-012-345'),
('Alejandra', 'Gomez', 'alejandra.gomez@example.com', '890-123-456'),
('Santiago', 'Hernandez', 'santiago.hernandez@example.com', '901-234-567'),
('Valeria', 'Santos', 'valeria.santos@example.com', '012-345-678'),
('Martin', 'Alvarez', 'martin.alvarez@example.com', '123-456-789'),
('Emma', 'Gutierrez', 'emma.gutierrez@example.com', '234-567-890'),
('Juan', 'Flores', 'juan.flores@example.com', '345-678-901'),
('Luciana', 'Molina', 'luciana.molina@example.com', '456-789-012'),
('Facundo', 'Rojas', 'facundo.rojas@example.com', '567-890-123'),
('Catalina', 'Suarez', 'catalina.suarez@example.com', '678-901-234'),
('Benjamin', 'Castillo', 'benjamin.castillo@example.com', '789-012-345'),
('Emilia', 'Acosta', 'emilia.acosta@example.com', '890-123-456'),
('Tomas', 'Blanco', 'tomas.blanco@example.com', '901-234-567'),
('Renata', 'Ibanez', 'renata.ibanez@example.com', '012-345-678'),
('Julian', 'Vargas', 'julian.vargas@example.com', '123-456-789'),
('Agustina', 'Luna', 'agustina.luna@example.com', '234-567-890'),
('Matias', 'Paz', 'matias.paz@example.com', '345-678-901'),
('Julieta', 'Moreno', 'julieta.moreno@example.com', '456-789-012'),
('Maximiliano', 'Ortega', 'maximiliano.ortega@example.com', '567-890-123'),
('Mia', 'Vazquez', 'mia.vazquez@example.com', '678-901-234'),
('Lorenzo', 'Gimenez', 'lorenzo.gimenez@example.com', '789-012-345'),
('Emma', 'Aguirre', 'emma.aguirre@example.com', '890-123-456'),
('Bautista', 'Rivas', 'bautista.rivas@example.com', '901-234-567'),
('Renata', 'Mendez', 'renata.mendez@example.com', '012-345-678'),
('Alex', 'Herrera', 'alex.herrera@example.com', '123-456-789'),
('Valentino', 'Silva', 'valentino.silva@example.com', '234-567-890'),
('Delfina', 'Pereyra', 'delfina.pereyra@example.com', '345-678-901'),
('Thiago', 'Fernandez', 'thiago.fernandez@example.com', '456-789-012'),
('Martina', 'Martinez', 'martina.martinez@example.com', '567-890-123');
---update
UPDATE Clientes SET telefono= '987-654-321' where id cliente = 1;
UPDATE Clientes SET correo = 'nuevo.correo@example.com' WHERE id_cliente = 1;
UPDATE Clientes SET apellido = 'González' WHERE id_cliente = 3;
UPDATE Clientes SET nombre = 'María' WHERE id_cliente = 4;
UPDATE Clientes SET correo = 'otro.correo@example.com' WHERE id_cliente = 5;

---delete
DELETE FROM Clientes WHERE id_cliente=3;
DELETE FROM Clientes WHERE id_cliente = 10;
DELETE FROM Clientes WHERE correo IS NULL;
DELETE FROM Clientes WHERE nombre = 'Carlos' AND apellido = 'Díaz';
DELETE FROM Clientes WHERE id_cliente > 15;

---drop
DROP TABLE Clientes;


---METODOS PAGO
--select
Select*from MetodosPago WHERE nombre='Paypal';
SELECT * FROM MetodosPago;
SELECT * FROM MetodosPago WHERE id_metodo = 3;
SELECT * FROM MetodosPago WHERE nombre LIKE '%Tarjeta%';
SELECT COUNT(*) AS total_metodos_pago FROM MetodosPago;

---insert
INSERT INTO MetodosPago (nombre)
VALUES
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('PayPal'),
('Transferencia Bancaria'),
('Efectivo'),
('Bitcoin'),
('Apple Pay'),
('Google Pay'),
('Samsung Pay'),
('Venmo'),
('Zelle'),
('Stripe'),
('Square'),
('American Express'),
('Mastercard'),
('Visa'),
('Discover'),
('Diners Club'),
('JCB'),
('Alipay'),
('WeChat Pay'),
('Pagaré'),
('Cheque'),
('Giro Postal'),
('Western Union'),
('MoneyGram'),
('Bitcoin Cash'),
('Ethereum'),
('Litecoin'),
('Stellar'),
('Ripple'),
('Dash'),
('Monero'),
('Zcash'),
('Tron'),
('Dogecoin'),
('Cardano'),
('EOS'),
('Tezos'),
('Chainlink'),
('Polkadot'),
('USD Coin'),
('Tether'),
('Binance Coin'),
('Solana'),
('Aave'),
('Uniswap'),
('Compound');

---update
UPDATE MetodosPago SET nombre= 'Pago en Efectivo' where id_metodo=5;
UPDATE MetodosPago SET nombre = 'Tarjeta de Crédito' WHERE id_metodo = 1;
UPDATE MetodosPago SET nombre = 'Transferencia Bancaria' WHERE nombre LIKE '%Bancaria%';
UPDATE MetodosPago SET nombre = 'Cheque' WHERE id_metodo = 4;
UPDATE MetodosPago SET nombre = 'PayPal' WHERE id_metodo = 5;

---delete
DELETE FROM MetodosPago WHERE nombre LIKE '%Tarjeta%';
DELETE FROM MetodosPago WHERE id_metodo = 10;
DELETE FROM MetodosPago WHERE nombre = 'Transferencia Bancaria';
DELETE FROM MetodosPago WHERE id_metodo = 15 AND nombre = 'Cheque';
DELETE FROM MetodosPago WHERE id_metodo > 7;

---drop
DROP TABLE MetodosPago;


---VENTAS
--select
Select*from Ventas;
SELECT * FROM Ventas WHERE id_cliente = 3;
SELECT * FROM Ventas WHERE CAST(fecha AS DATE) = '2024-05-28';
SELECT COUNT(*) AS total_ventas FROM Ventas;
SELECT * FROM Ventas WHERE id_metodo = 2;

---insert
INSERT INTO Ventas (id_cliente, id_metodo, total) 
VALUES
(1, 1, 150.75),
(2, 3, 230.50),
(3, 2, 99.99),
(4, 5, 320.00),
(5, 4, 180.25),
(6, 1, 275.00),
(7, 3, 150.25),
(8, 2, 200.99),
(9, 5, 425.75),
(10, 4, 150.50),
(11, 1, 210.00),
(12, 3, 175.25),
(13, 2, 300.99),
(14, 5, 150.75),
(15, 4, 180.50),
(16, 1, 250.00),
(17, 3, 200.25),
(18, 2, 175.99),
(19, 5, 350.75),
(20, 4, 120.50),
(21, 1, 185.00),
(22, 3, 250.25),
(23, 2, 225.99),
(24, 5, 280.75),
(25, 4, 190.50),
(26, 1, 275.00),
(27, 3, 150.25),
(28, 2, 200.99),
(29, 5, 425.75),
(30, 4, 150.50),
(31, 1, 210.00),
(32, 3, 175.25),
(33, 2, 300.99),
(34, 5, 150.75),
(35, 4, 180.50),
(36, 1, 250.00),
(37, 3, 200.25),
(38, 2, 175.99),
(39, 5, 350.75),
(40, 4, 120.50),
(41, 1, 185.00),
(42, 3, 250.25),
(43, 2, 225.99),
(44, 5, 280.75),
(45, 4, 190.50)

---update
UPDATE Ventas SET total=250.00 where id_venta = 2;
UPDATE Ventas SET id_metodo = 1 WHERE id_venta = 1;
UPDATE Ventas SET fecha = '2024-05-30 15:30:00' WHERE id_venta = 3;
UPDATE Ventas SET id_metodo = 4 WHERE id_venta = 4;
UPDATE Ventas SET total = 180.50 WHERE id_venta = 5;

---delete
DELETE FROM Ventas WHERE id_cliente=4;
DELETE FROM Ventas WHERE id_venta = 10;
DELETE FROM Ventas WHERE CAST(fecha AS DATE) = '2024-05-27';
DELETE FROM Ventas WHERE id_venta = 7 AND total = 320.00;
DELETE FROM Ventas WHERE id_venta > 15;

---drop
DROP TABLE Ventas;


---DETALLES VENTA
--select
SELECT * FROM DetallesVenta;
Select id_detalle, id_venta, id_producto, cantidadn precio_unitario FROM DetallesVenta;
SELECT * FROM DetallesVenta WHERE id_venta = 3;
SELECT id_producto, SUM(cantidad) AS total_vendido FROM DetallesVenta GROUP BY id_producto;
SELECT id_producto, SUM(cantidad * precio_unitario) AS total_ingresos FROM DetallesVenta GROUP BY id_producto;

---insert
INSERT INTO DetallesVenta (id_venta, id_producto, cantidad, precio_unitario) 
VALUES 
(1, 1, 2, 75.38),
(2, 2, 3, 76.83),
(3, 4, 5, 19.99),
(4, 5, 1, 320.00),
(5, 1, 3, 70.50),
(6, 2, 2, 75.25),
(7, 3, 1, 99.50),
(8, 4, 4, 22.75),
(9, 5, 2, 310.50),
(10, 1, 4, 72.80),
(11, 2, 2, 80.25),
(12, 3, 3, 98.75),
(13, 4, 6, 20.50),
(14, 5, 2, 300.25),
(15, 1, 5, 70.75),
(16, 2, 1, 78.99),
(17, 3, 2, 97.25),
(18, 4, 7, 18.50),
(19, 5, 3, 312.75),
(20, 1, 2, 73.80),
(21, 2, 3, 79.25),
(22, 3, 4, 96.75),
(23, 4, 8, 17.50),
(24, 5, 4, 315.25),
(25, 1, 6, 75.75),
(26, 2, 2, 76.99),
(27, 3, 1, 95.25),
(28, 4, 9, 16.50),
(29, 5, 5, 318.75),
(30, 1, 3, 78.80),
(31, 2, 4, 77.25),
(32, 3, 2, 94.75),
(33, 4, 10, 15.50),
(34, 5, 6, 321.25),
(35, 1, 7, 80.75),
(36, 2, 1, 75.99),
(37, 3, 3, 93.25),
(38, 4, 11, 14.50),
(39, 5, 7, 323.75),
(40, 1, 4, 82.80),
(41, 2, 5, 74.25),
(42, 3, 4, 92.75),
(43, 4, 12, 13.50),
(44, 5, 8, 326.25),
(45, 1, 8, 85.75)

---update
UPDATE DetallesVenta SET precio_unitario= 85.00 where id_categoria_detalle = 3;
UPDATE DetallesVenta SET cantidad = 5 WHERE id_detalle = 1;
UPDATE DetallesVenta SET cantidad = 10 WHERE id_detalle = 3;
UPDATE DetallesVenta SET precio_unitario = 29.99 WHERE id_detalle = 2;
UPDATE DetallesVenta SET precio_unitario = 19.99 WHERE id_detalle = 4;

---delete
DELETE FROM DetallesVenta WHERE id_detalle=4;
DELETE FROM DetallesVenta WHERE id_detalle = 10;
DELETE FROM DetallesVenta WHERE id_producto = 3;
DELETE FROM DetallesVenta WHERE id_detalle = 7 AND cantidad = 5;
DELETE FROM DetallesVenta WHERE id_detalle > 15;

---drop
DROP TABLE DetallesVenta;


---EMPLEADOS
--select
Select nombre,correo from Empleados;
SELECT e.nombre, e.apellido, v.id_venta, v.fecha, v.total FROM Empleados e INNER JOIN Ventas v ON e.id_empleado = v.id_empleado;
SELECT e.nombre, e.apellido, v.id_venta, v.fecha, v.total FROM Empleados e LEFT JOIN Ventas v ON e.id_empleado = v.id_empleado;
SELECT e.nombre, e.apellido, e.correo FROM Empleados e LEFT JOIN Ventas v ON e.id_empleado = v.id_empleado;
SELECT CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo, e.fecha_nacimiento FROM Empleados e;

---insert
INSERT INTO Empleados (nombre, apellido, fecha_nacimiento, correo, telefono, direccion) 
VALUES 
('Juan', 'Perez', '1985-03-15', 'juan.perez@example.com', '123-456-7890', 'Calle Falsa 123, Ciudad'),
('Ana', 'Gomez', '1990-07-22', 'ana.gomez@example.com', '234-567-8901', 'Avenida Siempre Viva 742, Ciudad'),
('Luis', 'Martinez', '1978-11-30', 'luis.martinez@example.com', '345-678-9012', 'Boulevard Central 456, Ciudad'),
('Maria', 'Lopez', '1982-05-20', 'maria.lopez@example.com', '456-789-0123', 'Calle del Sol 789, Ciudad'),
('Carlos', 'Diaz', '1988-09-10', 'carlos.diaz@example.com', '567-890-1234', 'Plaza Mayor 321, Ciudad'),
('Sofia', 'Rodriguez', '1987-04-18', 'sofia.rodriguez@example.com', '678-901-2345', 'Avenida Libertad 987, Ciudad'),
('Jorge', 'Hernandez', '1992-10-25', 'jorge.hernandez@example.com', '789-012-3456', 'Calle Principal 654, Ciudad'),
('Fernanda', 'Garcia', '1984-08-12', 'fernanda.garcia@example.com', '890-123-4567', 'Avenida Independencia 345, Ciudad'),
('Diego', 'Sanchez', '1989-06-28', 'diego.sanchez@example.com', '901-234-5678', 'Calle de la Paz 876, Ciudad'),
('Valentina', 'Perez', '1995-12-05', 'valentina.perez@example.com', '012-345-6789', 'Boulevard Estrella 210, Ciudad'),
('Mateo', 'Gonzalez', '1986-02-14', 'mateo.gonzalez@example.com', '123-456-7890', 'Plaza del Sol 543, Ciudad'),
('Camila', 'Ramirez', '1993-09-03', 'camila.ramirez@example.com', '234-567-8901', 'Avenida Central 876, Ciudad'),
('Nicolas', 'Torres', '1983-07-17', 'nicolas.torres@example.com', '345-678-9012', 'Calle Mayor 109, Ciudad'),
('Isabella', 'Diaz', '1980-04-30', 'isabella.diaz@example.com', '456-789-0123', 'Boulevard del Río 876, Ciudad'),
('Daniel', 'Martinez', '1991-11-20', 'daniel.martinez@example.com', '567-890-1234', 'Plaza de la Constitución 543, Ciudad'),
('Paula', 'Lopez', '1987-03-08', 'paula.lopez@example.com', '678-901-2345', 'Calle del Mar 987, Ciudad'),
('Gabriel', 'Castro', '1982-08-25', 'gabriel.castro@example.com', '789-012-3456', 'Avenida del Bosque 210, Ciudad'),
('Alejandra', 'Gomez', '1989-01-12', 'alejandra.gomez@example.com', '890-123-4567', 'Calle de la Luna 654, Ciudad'),
('Santiago', 'Hernandez', '1994-06-19', 'santiago.hernandez@example.com', '901-234-5678', 'Boulevard del Centro 876, Ciudad'),
('Valeria', 'Santos', '1986-11-03', 'valeria.santos@example.com', '012-345-6789', 'Plaza del Carmen 543, Ciudad'),
('Martin', 'Alvarez', '1990-02-18', 'martin.alvarez@example.com', '123-456-7890', 'Avenida del Parque 876, Ciudad'),
('Emma', 'Gutierrez', '1981-09-15', 'emma.gutierrez@example.com', '234-567-8901', 'Calle del Campo 987, Ciudad'),
('Juan', 'Flores', '1984-05-28', 'juan.flores@example.com', '345-678-9012', 'Boulevard del Norte 210, Ciudad'),
('Luciana', 'Molina', '1993-03-10', 'luciana.molina@example.com', '456-789-0123', 'Avenida del Este 543, Ciudad'),
('Facundo', 'Rojas', '1988-10-27', 'facundo.rojas@example.com', '567-890-1234', 'Calle de la Montaña 876, Ciudad'),
('Catalina', 'Suarez', '1985-07-04', 'catalina.suarez@example.com', '678-901-2345', 'Plaza de la Victoria 987, Ciudad'),
('Benjamin', 'Castillo', '1992-04-21', 'benjamin.castillo@example.com', '789-012-3456', 'Avenida del Trabajo 210, Ciudad'),
('Emilia', 'Acosta', '1983-01-14', 'emilia.acosta@example.com', '890-123-4567', 'Calle de la Paz 543, Ciudad'),
('Tomas', 'Blanco', '1996-08-31', 'tomas.blanco@example.com', '901-234-5678', 'Boulevard del Río 210, Ciudad'),
('Renata', 'Ibanez', '1987-11-18', 'renata.ibanez@example.com', '012-345-6789', 'Plaza de la Constitución 543, Ciudad'),
('Julian', 'Vargas', '1991-03-05', 'julian.vargas@example.com', '123-456-7890', 'Avenida Principal 876, Ciudad'),
('Agustina', 'Luna', '1984-10-12', 'agustina.luna@example.com', '234-567-8901', 'Calle del Mar 987, Ciudad'),
('Matias', 'Paz', '1995-05-29', 'matias.paz@example.com', '345-678-9012', 'Boulevard del Sol 210, Ciudad'),
('Julieta', 'Moreno', '1986-12-16', 'julieta.moreno@example.com', '456-789-0123', 'miramar');

---update
UPDATE Empleados SET telefono= '987-654-3218' where id_empleado = 1;
UPDATE Empleados SET correo = 'nuevo_correo@example.com' WHERE id_empleado = 2;
UPDATE Empleados SET direccion = 'Nueva dirección, Ciudad' WHERE nombre = 'Juan' AND apellido = 'Perez';
UPDATE Empleados SET nombre = 'Pedro', apellido = 'Gomez' WHERE id_empleado = 4;
UPDATE Empleados SET fecha_nacimiento = '1990-01-15' WHERE id_empleado = 3;

---delete
DELETE FROM Empleados WHERE apellido='Lopez';
DELETE FROM Empleados WHERE id_empleado = 5;
DELETE FROM Empleados WHERE fecha_nacimiento IS NULL;
DELETE FROM Empleados WHERE direccion = 'Dirección a eliminar';
DELETE FROM Empleados WHERE telefono IS NULL;

---drop
DROP TABLE Empleados;


-- 1. TABLA Departamentos
INSERT INTO Departamentos (nombre) VALUES ('Recursos Humanos');
INSERT INTO Departamentos (nombre) VALUES ('Finanzas');
INSERT INTO Departamentos (nombre) VALUES ('IT');
INSERT INTO Departamentos (nombre) VALUES ('Marketing');
INSERT INTO Departamentos (nombre) VALUES ('Ventas');
INSERT INTO Departamentos (nombre) VALUES ('Logística');
INSERT INTO Departamentos (nombre) VALUES ('Compras');
INSERT INTO Departamentos (nombre) VALUES ('Producción');
INSERT INTO Departamentos (nombre) VALUES ('Investigación y Desarrollo');
INSERT INTO Departamentos (nombre) VALUES ('Servicio al Cliente');
INSERT INTO Departamentos (nombre) VALUES ('Legal');
INSERT INTO Departamentos (nombre) VALUES ('Calidad');
INSERT INTO Departamentos (nombre) VALUES ('Mantenimiento');
INSERT INTO Departamentos (nombre) VALUES ('Relaciones Públicas');
INSERT INTO Departamentos (nombre) VALUES ('Proyectos');
INSERT INTO Departamentos (nombre) VALUES ('Auditoría');
INSERT INTO Departamentos (nombre) VALUES ('Seguridad');
INSERT INTO Departamentos (nombre) VALUES ('Sostenibilidad');
INSERT INTO Departamentos (nombre) VALUES ('Innovación');
INSERT INTO Departamentos (nombre) VALUES ('E-commerce');
INSERT INTO Departamentos (nombre) VALUES ('Desarrollo de Negocios');
INSERT INTO Departamentos (nombre) VALUES ('Planeación Estratégica');
INSERT INTO Departamentos (nombre) VALUES ('Capacitación');
INSERT INTO Departamentos (nombre) VALUES ('Comunicación');
INSERT INTO Departamentos (nombre) VALUES ('Administración');
INSERT INTO Departamentos (nombre) VALUES ('Análisis de Datos');
INSERT INTO Departamentos (nombre) VALUES ('Gestión de Talento');
INSERT INTO Departamentos (nombre) VALUES ('Operaciones');
INSERT INTO Departamentos (nombre) VALUES ('Relaciones Gubernamentales');
INSERT INTO Departamentos (nombre) VALUES ('Expansión Internacional');
INSERT INTO Departamentos (nombre) VALUES ('Logística Internacional');
INSERT INTO Departamentos (nombre) VALUES ('Asesoría Jurídica');
INSERT INTO Departamentos (nombre) VALUES ('Control de Inventarios');
INSERT INTO Departamentos (nombre) VALUES ('Soporte Técnico');
INSERT INTO Departamentos (nombre) VALUES ('Atención al Proveedor');
INSERT INTO Departamentos (nombre) VALUES ('Control de Calidad');
INSERT INTO Departamentos (nombre) VALUES ('Desarrollo Sostenible');
INSERT INTO Departamentos (nombre) VALUES ('Gestión Ambiental');
INSERT INTO Departamentos (nombre) VALUES ('Relaciones Industriales');
INSERT INTO Departamentos (nombre) VALUES ('Optimización de Procesos');
INSERT INTO Departamentos (nombre) VALUES ('Inteligencia de Negocios');
INSERT INTO Departamentos (nombre) VALUES ('Ciberseguridad');
INSERT INTO Departamentos (nombre) VALUES ('Gestión del Conocimiento');
INSERT INTO Departamentos (nombre) VALUES ('Transporte');
INSERT INTO Departamentos (nombre) VALUES ('Logística de Distribución');
INSERT INTO Departamentos (nombre) VALUES ('Redes y Telecomunicaciones');
INSERT INTO Departamentos (nombre) VALUES ('Diseño');
INSERT INTO Departamentos (nombre) VALUES ('Producción Audiovisual');
INSERT INTO Departamentos (nombre) VALUES ('Gestión de Eventos');


SELECT * FROM Departamentos WHERE nombre LIKE 'Recursos Humanos';
SELECT * FROM Departamentos WHERE id_departamento BETWEEN 1 AND 10;
SELECT nombre FROM Departamentos WHERE nombre LIKE '%Finanzas%';
SELECT id_departamento, nombre FROM Departamentos ORDER BY nombre ASC;
SELECT COUNT(*) AS TotalDepartamentos FROM Departamentos;


UPDATE Departamentos SET nombre = 'Recursos Humanos y Desarrollo' WHERE nombre = 'Recursos Humanos';
UPDATE Departamentos SET nombre = 'IT y Sistemas' WHERE nombre = 'IT';
UPDATE Departamentos SET nombre = 'Finanzas Corporativas' WHERE nombre = 'Finanzas';
UPDATE Departamentos SET nombre = 'Marketing Digital' WHERE nombre = 'Marketing';
UPDATE Departamentos SET nombre = 'Ventas Nacionales' WHERE nombre = 'Ventas';

DELETE FROM Departamentos WHERE nombre = 'Logística';
DELETE FROM Departamentos WHERE nombre = 'Producción';
DELETE FROM Departamentos WHERE id_departamento = 25;
DELETE FROM Departamentos WHERE id_departamento = 30;
DELETE FROM Departamentos WHERE nombre = 'Seguridad';

DROP TABLE Departamentos;

-- 2. TABLA PuestosTrabajo
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (1, 'Gerente de Recursos Humanos');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (1, 'Asistente de Recursos Humanos');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (2, 'Director Financiero');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (2, 'Analista Financiero');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (3, 'Desarrollador de Software');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (3, 'Administrador de Sistemas');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (4, 'Gerente de Marketing');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (4, 'Especialista en SEO');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (5, 'Representante de Ventas');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (5, 'Coordinador de Ventas');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (6, 'Gerente de Logística');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (6, 'Supervisor de Almacén');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (7, 'Comprador');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (7, 'Asistente de Compras');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (8, 'Supervisor de Producción');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (8, 'Operario de Producción');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (9, 'Investigador');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (9, 'Asistente de Investigación');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (10, 'Representante de Servicio al Cliente');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (10, 'Supervisor de Servicio al Cliente');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (11, 'Abogado Corporativo');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (11, 'Asistente Legal');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (12, 'Gerente de Calidad');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (12, 'Inspector de Calidad');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (13, 'Técnico de Mantenimiento');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (13, 'Supervisor de Mantenimiento');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (14, 'Especialista en Relaciones Públicas');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (14, 'Asistente de Relaciones Públicas');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (15, 'Gerente de Proyectos');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (15, 'Coordinador de Proyectos');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (16, 'Auditor Interno');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (16, 'Asistente de Auditoría');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (17, 'Oficial de Seguridad');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (17, 'Supervisor de Seguridad');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (18, 'Gerente de Sostenibilidad');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (18, 'Analista de Sostenibilidad');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (19, 'Especialista en Innovación');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (19, 'Coordinador de Innovación');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (20, 'Gerente de E-commerce');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (20, 'Asistente de E-commerce');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (21, 'Desarrollador de Negocios');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (21, 'Analista de Desarrollo de Negocios');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (22, 'Especialista en Planeación Estratégica');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (22, 'Asistente de Planeación Estratégica');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (23, 'Capacitador Corporativo');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (23, 'Coordinador de Capacitación');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (24, 'Especialista en Comunicación Corporativa');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (24, 'Asistente de Comunicación');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (25, 'Administrador General');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (25, 'Asistente Administrativo');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (26, 'Analista de Datos');
INSERT INTO PuestosTrabajo (id_departamento, nombre) VALUES (26, 'Científico de Datos');

SELECT * FROM PuestosTrabajo WHERE id_departamento = 1;
SELECT * FROM PuestosTrabajo WHERE nombre LIKE '%Gerente%';
SELECT nombre FROM PuestosTrabajo WHERE id_puesto BETWEEN 1 AND 10;
SELECT id_puesto, nombre FROM PuestosTrabajo ORDER BY nombre DESC;
SELECT COUNT(*) AS TotalPuestos FROM PuestosTrabajo WHERE id_departamento = 5;

UPDATE PuestosTrabajo SET nombre = 'Gerente de Recursos Humanos Senior' WHERE nombre = 'Gerente de Recursos Humanos';
UPDATE PuestosTrabajo SET nombre = 'Analista Financiero Junior' WHERE nombre = 'Analista Financiero';
UPDATE PuestosTrabajo SET nombre = 'Desarrollador de Software Senior' WHERE nombre = 'Desarrollador de Software';
UPDATE PuestosTrabajo SET nombre = 'Especialista en Marketing Digital' WHERE nombre = 'Gerente de Marketing';
UPDATE PuestosTrabajo SET nombre = 'Supervisor de Ventas' WHERE nombre = 'Coordinador de Ventas';


DELETE FROM PuestosTrabajo WHERE nombre = 'Supervisor de Almacén';
DELETE FROM PuestosTrabajo WHERE nombre = 'Asistente de Compras';
DELETE FROM PuestosTrabajo WHERE id_puesto = 30;
DELETE FROM PuestosTrabajo WHERE id_puesto = 35;
DELETE FROM PuestosTrabajo WHERE nombre = 'Asistente Legal';

DROP TABLE PuestosTrabajo;

-- 3. TABLA HorariosTrabajo 
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (1, 'Lunes', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (1, 'Martes', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (1, 'Miércoles', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (1, 'Jueves', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (1, 'Viernes', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (2, 'Lunes', '08:00', '16:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (2, 'Martes', '08:00', '16:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (2, 'Miércoles', '08:00', '16:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (2, 'Jueves', '08:00', '16:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (2, 'Viernes', '08:00', '16:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (3, 'Lunes', '10:00', '18:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (3, 'Martes', '10:00', '18:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (3, 'Miércoles', '10:00', '18:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (3, 'Jueves', '10:00', '18:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (3, 'Viernes', '10:00', '18:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (4, 'Lunes', '07:00', '15:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (4, 'Martes', '07:00', '15:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (4, 'Miércoles', '07:00', '15:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (4, 'Jueves', '07:00', '15:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (4, 'Viernes', '07:00', '15:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (5, 'Lunes', '12:00', '20:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (5, 'Martes', '12:00', '20:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (5, 'Miércoles', '12:00', '20:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (5, 'Jueves', '12:00', '20:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (5, 'Viernes', '12:00', '20:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (6, 'Sábado', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (6, 'Domingo', '09:00', '17:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (7, 'Lunes', '06:00', '14:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (7, 'Martes', '06:00', '14:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (7, 'Miércoles', '06:00', '14:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (7, 'Jueves', '06:00', '14:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (7, 'Viernes', '06:00', '14:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (8, 'Lunes', '11:00', '19:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (8, 'Martes', '11:00', '19:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (8, 'Miércoles', '11:00', '19:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (8, 'Jueves', '11:00', '19:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (8, 'Viernes', '11:00', '19:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (9, 'Lunes', '08:30', '16:30');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (9, 'Martes', '08:30', '16:30');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (9, 'Miércoles', '08:30', '16:30');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (9, 'Jueves', '08:30', '16:30');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (9, 'Viernes', '08:30', '16:30');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (10, 'Sábado', '10:00', '18:00');
INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida) VALUES (10, 'Domingo', '10:00', '18:00');

SELECT * FROM HorariosTrabajo WHERE dia = 'Lunes';
SELECT * FROM HorariosTrabajo WHERE id_empleado = 5;
SELECT dia, hora_entrada, hora_salida FROM HorariosTrabajo WHERE id_horario BETWEEN 1 AND 10;
SELECT id_horario, dia, hora_entrada, hora_salida FROM HorariosTrabajo ORDER BY dia ASC;
SELECT COUNT(*) AS TotalHorarios FROM HorariosTrabajo WHERE id_empleado = 2;

UPDATE HorariosTrabajo SET hora_entrada = '08:00', hora_salida = '16:00' WHERE id_horario = 1;
UPDATE HorariosTrabajo SET hora_entrada = '09:00', hora_salida = '17:00' WHERE id_horario = 6;
UPDATE HorariosTrabajo SET hora_entrada = '07:00', hora_salida = '15:00' WHERE id_horario = 11;
UPDATE HorariosTrabajo SET hora_entrada = '06:00', hora_salida = '14:00' WHERE id_horario = 16;
UPDATE HorariosTrabajo SET hora_entrada = '10:00', hora_salida = '18:00' WHERE id_horario = 21;

DELETE FROM HorariosTrabajo WHERE dia = 'Domingo';
DELETE FROM HorariosTrabajo WHERE id_empleado = 4;
DELETE FROM HorariosTrabajo WHERE id_horario = 25;
DELETE FROM HorariosTrabajo WHERE id_horario = 30;
DELETE FROM HorariosTrabajo WHERE dia = 'Sábado' AND id_empleado

-- 4. TABLA FlotasTransporte 
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Carga Pesada');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Furgonetas de Reparto');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Motocicletas de Mensajería');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Servicio Técnico');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camionetas de Inspección');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones Refrigerados');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Empresa');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Autobuses de Personal');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Taxis Corporativos');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos Eléctricos');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Tractocamiones');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Remolques');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Plataforma');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Gruas');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Emergencia');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camionetas 4x4');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Supervisión');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos Híbridos');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Barcos de Carga');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Lanchas de Servicio');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Drones de Entrega');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Carretillas Elevadoras');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Cargadores Frontal');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Minicargadoras');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Basura');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Cisternas de Agua');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Combustible');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Tractores Agrícolas');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Trenes de Carga');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones Tolva');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Volteo');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos Autónomos');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Seguridad');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Inspección Técnica');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camionetas de Transporte Ligero');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos para Transporte de Animales');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camionetas Blindadas');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Cemento');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camionetas de Entrega Rápida');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Atención Médica');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones para Materiales Peligrosos');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Mantenimiento Vial');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Bicicletas de Reparto');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Tránsito');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Rescate');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Exploración');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Turismo');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Camiones de Entrega de Alimentos');
INSERT INTO FlotasTransporte (descripcion) VALUES ('Vehículos de Carga Ligeros');

SELECT * FROM FlotasTransporte WHERE descripcion LIKE '%Camiones%';
SELECT * FROM FlotasTransporte WHERE id_flota BETWEEN 1 AND 10;
SELECT descripcion FROM FlotasTransporte WHERE descripcion LIKE '%Vehículos%';
SELECT id_flota, descripcion FROM FlotasTransporte ORDER BY descripcion ASC;
SELECT COUNT(*) AS TotalFlotas FROM FlotasTransporte;

UPDATE FlotasTransporte SET descripcion = 'Camiones de Carga Pesada y Liviana' WHERE descripcion = 'Camiones de Carga Pesada';
UPDATE FlotasTransporte SET descripcion = 'Furgonetas de Reparto Urbano' WHERE descripcion = 'Furgonetas de Reparto';
UPDATE FlotasTransporte SET descripcion = 'Motocicletas de Mensajería Exprés' WHERE descripcion = 'Motocicletas de Mensajería';
UPDATE FlotasTransporte SET descripcion = 'Vehículos de Servicio Técnico y Reparación' WHERE descripcion = 'Vehículos de Servicio Técnico';
UPDATE FlotasTransporte SET descripcion = 'Camionetas de Inspección de Campo' WHERE descripcion = 'Camionetas de Inspección';

DELETE FROM FlotasTransporte WHERE descripcion = 'Gruas';
DELETE FROM FlotasTransporte WHERE descripcion = 'Barcos de Carga';
DELETE FROM FlotasTransporte WHERE id_flota = 25;
DELETE FROM FlotasTransporte WHERE id_flota = 30;
DELETE FROM FlotasTransporte WHERE descripcion = 'Vehículos de Exploración';

DROP TABLE FlotasTransporte;


-- 5. TABLA RutasDistribucion 
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Norte');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Sur');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Este');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Oeste');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Centro');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Costa');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Montaña');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Internacional 1');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Internacional 2');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Metropolitana');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Periférica');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Rural');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Urbana');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Comercial');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Residencial');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Nocturna');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Diurna');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Express');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Regular');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Temporal');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Permanente');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Emergencia');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Verano');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Invierno');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Escolar');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Universitaria');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Industrial');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta Agrícola');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Transporte Público');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Transporte Privado');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Envíos Rápidos');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Recolección');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Entregas Programadas');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Carga Pesada');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Carga Ligera');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Exportación');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Importación');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Inspección');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Mantenimiento');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Abastecimiento');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Suministros');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Alimentos');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Bebidas');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Materiales Peligrosos');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Productos Congelados');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Productos Frescos');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Medicamentos');
INSERT INTO RutasDistribucion (descripcion) VALUES ('Ruta de Equipos Médicos');

SELECT * FROM RutasDistribucion WHERE descripcion LIKE '%Norte%';
SELECT * FROM RutasDistribucion WHERE id_ruta BETWEEN 1 AND 10;
SELECT descripcion FROM RutasDistribucion WHERE descripcion LIKE '%Ruta%';
SELECT id_ruta, descripcion FROM RutasDistribucion ORDER BY descripcion ASC;
SELECT COUNT(*) AS TotalRutas FROM RutasDistribucion;

UPDATE RutasDistribucion SET descripcion = 'Ruta Norte Extendida' WHERE descripcion = 'Ruta Norte';
UPDATE RutasDistribucion SET descripcion = 'Ruta Sur Acortada' WHERE descripcion = 'Ruta Sur';
UPDATE RutasDistribucion SET descripcion = 'Ruta Este Actualizada' WHERE descripcion = 'Ruta Este';
UPDATE RutasDistribucion SET descripcion = 'Ruta Oeste Nueva' WHERE descripcion = 'Ruta Oeste';
UPDATE RutasDistribucion SET descripcion = 'Ruta Centro Especial' WHERE descripcion = 'Ruta Centro';

DELETE FROM RutasDistribucion WHERE descripcion = 'Ruta de Verano';
DELETE FROM RutasDistribucion WHERE descripcion = 'Ruta de Invierno';
DELETE FROM RutasDistribucion WHERE id_ruta = 25;
DELETE FROM RutasDistribucion WHERE id_ruta = 30;
DELETE FROM RutasDistribucion WHERE descripcion = 'Ruta de Mantenimiento';

DROP TABLE RutasDistribucion;



-- 6. TABLA Despachos 
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 1, '2024-05-01 08:00:00', '2024-05-01 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 2, '2024-05-02 09:00:00', '2024-05-02 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 3, '2024-05-03 10:00:00', '2024-05-03 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 4, '2024-05-04 11:00:00', '2024-05-04 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 5, '2024-05-05 12:00:00', '2024-05-05 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 6, '2024-05-06 08:00:00', '2024-05-06 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 7, '2024-05-07 09:00:00', '2024-05-07 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 8, '2024-05-08 10:00:00', '2024-05-08 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 9, '2024-05-09 11:00:00', '2024-05-09 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 10, '2024-05-10 12:00:00', '2024-05-10 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 11, '2024-05-11 08:00:00', '2024-05-11 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 12, '2024-05-12 09:00:00', '2024-05-12 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 13, '2024-05-13 10:00:00', '2024-05-13 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 14, '2024-05-14 11:00:00', '2024-05-14 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 15, '2024-05-15 12:00:00', '2024-05-15 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 16, '2024-05-16 08:00:00', '2024-05-16 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 17, '2024-05-17 09:00:00', '2024-05-17 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 18, '2024-05-18 10:00:00', '2024-05-18 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 19, '2024-05-19 11:00:00', '2024-05-19 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 20, '2024-05-20 12:00:00', '2024-05-20 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 21, '2024-05-21 08:00:00', '2024-05-21 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 22, '2024-05-22 09:00:00', '2024-05-22 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 23, '2024-05-23 10:00:00', '2024-05-23 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 24, '2024-05-24 11:00:00', '2024-05-24 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 25, '2024-05-25 12:00:00', '2024-05-25 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 26, '2024-05-26 08:00:00', '2024-05-26 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 27, '2024-05-27 09:00:00', '2024-05-27 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 28, '2024-05-28 10:00:00', '2024-05-28 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 29, '2024-05-29 11:00:00', '2024-05-29 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 30, '2024-05-30 12:00:00', '2024-05-30 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 31, '2024-06-01 08:00:00', '2024-06-01 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 32, '2024-06-02 09:00:00', '2024-06-02 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 33, '2024-06-03 10:00:00', '2024-06-03 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 34, '2024-06-04 11:00:00', '2024-06-04 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 35, '2024-06-05 12:00:00', '2024-06-05 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 36, '2024-06-06 08:00:00', '2024-06-06 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 37, '2024-06-07 09:00:00', '2024-06-07 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 38, '2024-06-08 10:00:00', '2024-06-08 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 39, '2024-06-09 11:00:00', '2024-06-09 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 40, '2024-06-10 12:00:00', '2024-06-10 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 41, '2024-06-11 08:00:00', '2024-06-11 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 42, '2024-06-12 09:00:00', '2024-06-12 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 43, '2024-06-13 10:00:00', '2024-06-13 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 44, '2024-06-14 11:00:00', '2024-06-14 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 45, '2024-06-15 12:00:00', '2024-06-15 16:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (1, 46, '2024-06-16 08:00:00', '2024-06-16 12:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (2, 47, '2024-06-17 09:00:00', '2024-06-17 13:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (3, 48, '2024-06-18 10:00:00', '2024-06-18 14:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (4, 49, '2024-06-19 11:00:00', '2024-06-19 15:00:00');
INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada) VALUES (5, 50, '2024-06-20 12:00:00', '2024-06-20 16:00:00');

SELECT * FROM Despachos WHERE id_almacen = 1;
SELECT * FROM Despachos WHERE id_ruta BETWEEN 1 AND 10;
SELECT id_despacho, fecha_salida, fecha_llegada FROM Despachos WHERE fecha_salida > '2024-05-10';
SELECT id_despacho, id_almacen, id_ruta FROM Despachos ORDER BY fecha_salida ASC;
SELECT COUNT(*) AS TotalDespachos FROM Despachos;

UPDATE Despachos SET fecha_llegada = '2024-05-01 13:00:00' WHERE id_despacho = 1;
UPDATE Despachos SET id_almacen = 3 WHERE id_despacho = 2;
UPDATE Despachos SET id_ruta = 5 WHERE id_despacho = 3;
UPDATE Despachos SET fecha_salida = '2024-05-04 07:00:00' WHERE id_despacho = 4;
UPDATE Despachos SET fecha_llegada = '2024-05-05 17:00:00' WHERE id_despacho = 5;

DELETE FROM Despachos WHERE id_despacho = 10;
DELETE FROM Despachos WHERE id_ruta = 20;
DELETE FROM Despachos WHERE fecha_salida < '2024-05-01';
DELETE FROM Despachos WHERE id_almacen = 5 AND id_ruta = 15;
DELETE FROM Despachos WHERE fecha_llegada > '2024-06-01';

DROP TABLE Despachos;

-- 7. TABLA Proveedores
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor A', 'Contacto A', '1234567890', 'Calle 1, Ciudad A');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor B', 'Contacto B', '0987654321', 'Calle 2, Ciudad B');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor C', 'Contacto C', '1112223333', 'Calle 3, Ciudad C');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor D', 'Contacto D', '4445556666', 'Calle 4, Ciudad D');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor E', 'Contacto E', '7778889999', 'Calle 5, Ciudad E');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor F', 'Contacto F', '1231231234', 'Calle 6, Ciudad F');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor G', 'Contacto G', '3213214321', 'Calle 7, Ciudad G');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor H', 'Contacto H', '5556667777', 'Calle 8, Ciudad H');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor I', 'Contacto I', '8889990000', 'Calle 9, Ciudad I');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor J', 'Contacto J', '2223334444', 'Calle 10, Ciudad J');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor K', 'Contacto K', '6667778888', 'Calle 11, Ciudad K');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor L', 'Contacto L', '9990001111', 'Calle 12, Ciudad L');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor M', 'Contacto M', '3334445555', 'Calle 13, Ciudad M');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor N', 'Contacto N', '7778889990', 'Calle 14, Ciudad N');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor O', 'Contacto O', '1234567891', 'Calle 15, Ciudad O');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor P', 'Contacto P', '9876543210', 'Calle 16, Ciudad P');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor Q', 'Contacto Q', '1112223334', 'Calle 17, Ciudad Q');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor R', 'Contacto R', '4445556667', 'Calle 18, Ciudad R');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor S', 'Contacto S', '7778889991', 'Calle 19, Ciudad S');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor T', 'Contacto T', '1231231235', 'Calle 20, Ciudad T');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor U', 'Contacto U', '3213214322', 'Calle 21, Ciudad U');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor V', 'Contacto V', '5556667778', 'Calle 22, Ciudad V');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor W', 'Contacto W', '8889990001', 'Calle 23, Ciudad W');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor X', 'Contacto X', '2223334445', 'Calle 24, Ciudad X');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor Y', 'Contacto Y', '6667778889', 'Calle 25, Ciudad Y');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor Z', 'Contacto Z', '9990001112', 'Calle 26, Ciudad Z');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor AA', 'Contacto AA', '3334445556', 'Calle 27, Ciudad AA');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor BB', 'Contacto BB', '7778889992', 'Calle 28, Ciudad BB');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor CC', 'Contacto CC', '1234567892', 'Calle 29, Ciudad CC');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor DD', 'Contacto DD', '9876543211', 'Calle 30, Ciudad DD');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor EE', 'Contacto EE', '1112223335', 'Calle 31, Ciudad EE');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor FF', 'Contacto FF', '4445556668', 'Calle 32, Ciudad FF');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor GG', 'Contacto GG', '7778889993', 'Calle 33, Ciudad GG');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor HH', 'Contacto HH', '1231231236', 'Calle 34, Ciudad HH');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor II', 'Contacto II', '3213214323', 'Calle 35, Ciudad II');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor JJ', 'Contacto JJ', '5556667779', 'Calle 36, Ciudad JJ');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor KK', 'Contacto KK', '8889990002', 'Calle 37, Ciudad KK');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor LL', 'Contacto LL', '2223334446', 'Calle 38, Ciudad LL');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor MM', 'Contacto MM', '6667778890', 'Calle 39, Ciudad MM');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor NN', 'Contacto NN', '9990001113', 'Calle 40, Ciudad NN');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor OO', 'Contacto OO', '3334445557', 'Calle 41, Ciudad OO');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor PP', 'Contacto PP', '7778889994', 'Calle 42, Ciudad PP');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor QQ', 'Contacto QQ', '1234567893', 'Calle 43, Ciudad QQ');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor RR', 'Contacto RR', '9876543212', 'Calle 44, Ciudad RR');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor SS', 'Contacto SS', '1112223336', 'Calle 45, Ciudad SS');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor TT', 'Contacto TT', '4445556669', 'Calle 46, Ciudad TT');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor UU', 'Contacto UU', '7778889995', 'Calle 47, Ciudad UU');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor VV', 'Contacto VV', '1231231237', 'Calle 48, Ciudad VV');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor WW', 'Contacto WW', '3213214324', 'Calle 49, Ciudad WW');
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES ('Proveedor XX', 'Contacto XX', '5556667780', 'Calle 50, Ciudad XX');

SELECT * FROM Proveedores WHERE nombre LIKE '%A%';
SELECT * FROM Proveedores WHERE id_proveedor BETWEEN 1 AND 10;
SELECT nombre, contacto FROM Proveedores WHERE telefono IS NOT NULL;
SELECT id_proveedor, nombre, direccion FROM Proveedores ORDER BY nombre ASC;
SELECT COUNT(*) AS TotalProveedores FROM Proveedores;

UPDATE Proveedores SET telefono = '5555555555' WHERE id_proveedor = 1;
UPDATE Proveedores SET contacto = 'Nuevo Contacto B' WHERE id_proveedor = 2;
UPDATE Proveedores SET direccion = 'Nueva Calle 3, Nueva Ciudad C' WHERE id_proveedor = 3;
UPDATE Proveedores SET nombre = 'Proveedor Modificado D' WHERE id_proveedor = 4;
UPDATE Proveedores SET contacto = 'Nuevo Contacto E', telefono = '0001112222' WHERE id_proveedor = 5;

DELETE FROM Proveedores WHERE id_proveedor = 10;
DELETE FROM Proveedores WHERE nombre LIKE 'Proveedor %F%';
DELETE FROM Proveedores WHERE telefono IS NULL;
DELETE FROM Proveedores WHERE direccion LIKE '%Calle 20%';
DELETE FROM Proveedores WHERE id_proveedor BETWEEN 30 AND 35;

DROP TABLE Proveedores;
-- 8. TABLA CuentasPorCobrar 
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (1, 100.00, '2024-05-01 08:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (2, 150.50, '2024-05-02 09:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (3, 200.25, '2024-05-03 10:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (4, 300.75, '2024-05-04 11:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (5, 400.80, '2024-05-05 12:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (1, 250.00, '2024-05-06 08:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (2, 180.30, '2024-05-07 09:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (3, 210.75, '2024-05-08 10:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (4, 280.50, '2024-05-09 11:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (5, 350.90, '2024-05-10 12:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (1, 320.00, '2024-05-11 08:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (2, 410.25, '2024-05-12 09:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (3, 500.70, '2024-05-13 10:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (4, 600.40, '2024-05-14 11:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (5, 700.20, '2024-05-15 12:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (1, 450.60, '2024-05-16 08:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (2, 560.90, '2024-05-17 09:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (3, 680.75, '2024-05-18 10:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (4, 790.30, '2024-05-19 11:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (5, 890.50, '2024-05-20 12:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (1, 920.00, '2024-05-21 08:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (2, 870.25, '2024-05-22 09:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (3, 830.50, '2024-05-23 10:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (4, 780.20, '2024-05-24 11:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (5, 730.80, '2024-05-25 12:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (1, 680.60, '2024-05-26 08:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (2, 630.90, '2024-05-27 09:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (3, 580.75, '2024-05-28 10:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (4, 530.30, '2024-05-29 11:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto, fecha) VALUES (5, 480.50, '2024-05-30 12:00:00');
INSERT INTO CuentasPorCobrar (id_cliente, monto) VALUES (1, 1000.00);

SELECT * FROM CuentasPorCobrar WHERE monto > 500;
SELECT * FROM CuentasPorCobrar WHERE id_cuenta BETWEEN 1 AND 10;
SELECT id_cliente, SUM(monto) AS TotalMonto FROM CuentasPorCobrar GROUP BY id_cliente;
SELECT id_cuenta, monto, fecha FROM CuentasPorCobrar WHERE fecha >= '2024-05-15' ORDER BY fecha DESC;
SELECT COUNT(*) AS TotalCuentas FROM CuentasPorCobrar;

UPDATE CuentasPorCobrar SET monto = 1200.00 WHERE id_cuenta = 1;
UPDATE CuentasPorCobrar SET fecha = '2024-05-01 09:00:00' WHERE id_cuenta = 2;
UPDATE CuentasPorCobrar SET monto = 180.00, fecha = '2024-05-02 10:00:00' WHERE id_cuenta = 3;
UPDATE CuentasPorCobrar SET monto = 250.50, fecha = '2024-05-03 11:00:00' WHERE id_cuenta = 4;
UPDATE CuentasPorCobrar SET monto = 360.75, fecha = '2024-05-04 12:00:00' WHERE id_cuenta = 5;

DELETE FROM CuentasPorCobrar WHERE id_cuenta = 10;
DELETE FROM CuentasPorCobrar WHERE monto < 200;
DELETE FROM CuentasPorCobrar WHERE fecha < '2024-05-15';

DROP TABLE CuentasPorCobrar;


-- 9. TABLA CuentasPorPagar 
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (1, 500.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (2, 700.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (3, 900.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (4, 1200.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (5, 1500.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (6, 2000.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (7, 2200.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (8, 2500.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (9, 2800.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (10, 3000.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (11, 3200.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (12, 3500.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (13, 3800.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (14, 4100.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (15, 4400.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (16, 4700.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (17, 5000.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (18, 5300.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (19, 5600.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (20, 5900.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (21, 6200.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (22, 6500.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (23, 6800.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (24, 7100.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (25, 7400.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (26, 7700.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (27, 8000.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (28, 8300.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (29, 8600.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (30, 8900.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (31, 9200.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (32, 9500.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (33, 9800.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (34, 10100.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (35, 10400.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (36, 10700.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (37, 11000.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (38, 11300.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (39, 11600.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (40, 11900.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (41, 12200.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (42, 12500.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (43, 12800.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (44, 13100.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (45, 13400.80);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (46, 13700.00);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (47, 14000.50);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (48, 14300.25);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (49, 14600.75);
INSERT INTO CuentasPorPagar (id_proveedor, monto) VALUES (50, 14900.80);

SELECT * FROM CuentasPorPagar;
SELECT * FROM CuentasPorPagar WHERE monto > 2000;
SELECT * FROM CuentasPorPagar WHERE id_proveedor = 5;
SELECT COUNT(*) AS TotalCuentasPorPagar FROM CuentasPorPagar;

UPDATE CuentasPorPagar SET monto = 1200.00 WHERE id_cuenta = 1;
UPDATE CuentasPorPagar SET id_proveedor = 5 WHERE id_cuenta = 2;
UPDATE CuentasPorPagar SET fecha = '2024-05-20' WHERE id_cuenta = 3;
UPDATE CuentasPorPagar SET monto = 800.00, fecha = '2024-05-25' WHERE id_cuenta = 4;

DELETE FROM CuentasPorPagar WHERE monto = 500;
DELETE FROM CuentasPorPagar WHERE id_proveedor = 2;
DELETE FROM CuentasPorPagar WHERE monto > 1000;
DELETE FROM CuentasPorPagar WHERE id_cuenta = 10;

DROP TABLE CuentasPorPagar;

-- 10. TABLA RequisicionesInventario
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 1, 50, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 2, 30, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 3, 20, 'rechazada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 4, 40, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 5, 25, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 6, 35, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 7, 45, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 8, 60, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 9, 55, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 10, 70, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 1, 50, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 2, 30, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 3, 20, 'rechazada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 14, 40, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 15, 25, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 16, 35, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 17, 45, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 18, 60, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 19, 55, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 20, 70, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 21, 50, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 22, 30, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 23, 20, 'rechazada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 24, 40, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 25, 25, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 26, 35, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 27, 45, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 28, 60, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 29, 55, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 30, 70, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 31, 50, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 32, 30, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 33, 20, 'rechazada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 34, 40, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 35, 25, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (1, 36, 35, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (2, 37, 45, 'aprobada');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (3, 38, 60, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (4, 39, 55, 'pendiente');
INSERT INTO RequisicionesInventario (id_almacen, id_producto, cantidad, estado) VALUES (5, 40, 70, 'aprobada');

SELECT * FROM RequisicionesInventario WHERE estado = 'pendiente';
SELECT * FROM RequisicionesInventario WHERE cantidad > 40;
SELECT id_requisicion, fecha, estado FROM RequisicionesInventario WHERE fecha >= '2024-05-15';
SELECT id_almacen, COUNT(*) AS TotalRequisiciones FROM RequisicionesInventario GROUP BY id_almacen;
SELECT COUNT(*) AS TotalRequisiciones FROM RequisicionesInventario WHERE estado = 'aprobada';

UPDATE RequisicionesInventario SET estado = 'aprobada' WHERE id_requisicion = 1;
UPDATE RequisicionesInventario SET cantidad = 60 WHERE id_requisicion = 2;
UPDATE RequisicionesInventario SET estado = 'rechazada' WHERE id_requisicion = 3;
UPDATE RequisicionesInventario SET cantidad = 50, estado = 'aprobada' WHERE id_requisicion = 4;
UPDATE RequisicionesInventario SET cantidad = 80 WHERE id_requisicion = 5;

DELETE FROM RequisicionesInventario WHERE id_requisicion = 10;
DELETE FROM RequisicionesInventario WHERE cantidad < 30;
DELETE FROM RequisicionesInventario WHERE estado = 'rechazada';
DELETE FROM RequisicionesInventario WHERE fecha < '2024-05-01';

DROP TABLE RequisicionesInventario;


-- 11. TABLA OrdenesCompra 
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (1, 'pendiente', 500.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (2, 'pendiente', 700.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (3, 'pendiente', 900.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (4, 'pendiente', 1200.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (5, 'pendiente', 1500.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (6, 'pendiente', 2000.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (7, 'pendiente', 2200.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (8, 'pendiente', 2500.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (9, 'pendiente', 2800.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (10, 'pendiente', 3000.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (11, 'pendiente', 3200.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (12, 'pendiente', 3500.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (13, 'pendiente', 3800.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (14, 'pendiente', 4100.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (15, 'pendiente', 4400.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (16, 'pendiente', 4700.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (17, 'pendiente', 5000.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (18, 'pendiente', 5300.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (19, 'pendiente', 5600.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (20, 'pendiente', 5900.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (21, 'pendiente', 6200.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (22, 'pendiente', 6500.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (23, 'pendiente', 6800.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (24, 'pendiente', 7100.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (25, 'pendiente', 7400.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (26, 'pendiente', 7700.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (27, 'pendiente', 8000.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (28, 'pendiente', 8300.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (29, 'pendiente', 8600.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (30, 'pendiente', 8900.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (31, 'pendiente', 9200.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (32, 'pendiente', 9500.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (33, 'pendiente', 9800.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (34, 'pendiente', 10100.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (35, 'pendiente', 10400.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (36, 'pendiente', 10700.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (37, 'pendiente', 11000.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (38, 'pendiente', 11300.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (39, 'pendiente', 11600.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (40, 'pendiente', 11900.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (41, 'pendiente', 12200.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (42, 'pendiente', 12500.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (43, 'pendiente', 12800.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (44, 'pendiente', 13100.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (45, 'pendiente', 13400.80);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (46, 'pendiente', 13700.00);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (47, 'pendiente', 14000.50);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (48, 'pendiente', 14300.25);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (49, 'pendiente', 14600.75);
INSERT INTO OrdenesCompra (id_proveedor, estado, total) VALUES (50, 'pendiente', 14900.80);

DELETE FROM OrdenesCompra WHERE id_orden = 1;
DELETE FROM OrdenesCompra WHERE estado = 'cancelada';
DELETE FROM OrdenesCompra WHERE total > 2000;
DELETE FROM OrdenesCompra WHERE fecha < '2024-05-01';

UPDATE OrdenesCompra SET estado = 'completada' WHERE id_orden = 2;
UPDATE OrdenesCompra SET total = 1500.00 WHERE id_orden = 3;
UPDATE OrdenesCompra SET id_proveedor = 15 WHERE id_orden = 4;
UPDATE OrdenesCompra SET estado = 'pendiente', total = 1800.00 WHERE id_orden = 5;

DROP TABLE OrdenesCompra;

-- 12. TABLA DetallesOrdenCompra
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (1, 1, 5, 10.50);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (1, 2, 10, 15.75);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (2, 3, 8, 20.25);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (2, 4, 15, 8.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (3, 5, 20, 12.30);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (3, 6, 12, 18.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (4, 7, 7, 25.40);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (4, 8, 9, 30.80);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (5, 9, 25, 9.75);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (5, 10, 18, 14.20);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (6, 11, 6, 22.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (6, 12, 14, 17.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (7, 13, 30, 11.50);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (7, 14, 10, 28.75);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (8, 15, 5, 35.20);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (8, 16, 20, 16.30);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (9, 17, 12, 21.80);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (9, 18, 15, 10.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (10, 19, 8, 27.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (10, 20, 22, 13.40);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (11, 21, 16, 18.50);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (11, 22, 18, 23.70);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (12, 23, 10, 30.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (12, 24, 20, 15.80);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (13, 25, 15, 12.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (13, 26, 25, 19.20);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (14, 27, 18, 22.30);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (14, 28, 22, 17.40);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (15, 29, 30, 14.70);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (15, 30, 10, 26.50);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (16, 31, 8, 29.80);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (16, 32, 16, 21.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (17, 33, 25, 18.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (17, 34, 20, 24.70);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (18, 35, 12, 32.40);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (18, 36, 18, 27.30);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (19, 37, 15, 19.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (19, 38, 20, 16.50);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (20, 39, 10, 35.80);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (20, 40, 30, 12.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (21, 41, 20, 28.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (21, 42, 15, 20.70);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (22, 43, 25, 23.40);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (22, 44, 18, 26.50);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (23, 45, 12, 30.60);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (23, 46, 22, 17.80);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (24, 47, 8, 25.90);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (24, 48, 16, 19.70);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (25, 49, 30, 14.20);
INSERT INTO DetallesOrdenCompra (id_orden, id_producto, cantidad, precio_unitario) VALUES (25, 50, 25, 21.30);

SELECT * FROM DetallesOrdenCompra;
SELECT * FROM DetallesOrdenCompra WHERE id_orden = 1;
SELECT * FROM DetallesOrdenCompra WHERE id_producto = 5;
SELECT COUNT(*) AS TotalDetallesOrdenCompra FROM DetallesOrdenCompra;

DELETE FROM DetallesOrdenCompra WHERE id_detalle = 1;
DELETE FROM DetallesOrdenCompra WHERE id_orden = 2;
DELETE FROM DetallesOrdenCompra WHERE id_producto = 10;
DELETE FROM DetallesOrdenCompra;

UPDATE DetallesOrdenCompra SET cantidad = 10 WHERE id_detalle = 2;
UPDATE DetallesOrdenCompra SET precio_unitario = 25.00 WHERE id_detalle = 3;
UPDATE DetallesOrdenCompra SET cantidad = 20, precio_unitario = 15.50 WHERE id_detalle = 4;
UPDATE DetallesOrdenCompra SET id_orden = 3 WHERE id_detalle = 5;

DROP TABLE DetallesOrdenCompra;

-- 13. TABLA RecepcionProductos 
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (1, 20);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (2, 25);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (3, 30);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (4, 15);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (5, 18);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (6, 22);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (7, 28);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (8, 12);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (9, 16);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (10, 21);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (11, 19);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (12, 24);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (13, 29);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (14, 17);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (15, 23);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (16, 27);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (17, 31);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (18, 26);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (19, 20);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (20, 15);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (21, 18);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (22, 22);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (23, 29);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (24, 14);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (25, 25);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (26, 30);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (27, 19);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (28, 23);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (29, 27);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (30, 16);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (31, 20);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (32, 24);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (33, 18);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (34, 21);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (35, 25);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (36, 17);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (37, 22);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (38, 28);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (39, 13);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (40, 26);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (41, 30);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (42, 19);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (43, 23);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (44, 20);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (45, 15);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (46, 18);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (47, 22);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (48, 29);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (49, 14);
INSERT INTO RecepcionProductos (id_orden, cantidad) VALUES (50, 27);


SELECT * FROM RecepcionProductos;
SELECT cantidad FROM RecepcionProductos WHERE id_orden = 1;
SELECT * FROM RecepcionProductos WHERE cantidad > 20;
SELECT SUM(cantidad) AS TotalCantidadRecibida FROM RecepcionProductos;

DELETE FROM RecepcionProductos WHERE id_recepcion = 1;
DELETE FROM RecepcionProductos WHERE id_orden = 2;
DELETE FROM RecepcionProductos WHERE cantidad <= 15;
DELETE FROM RecepcionProductos;

UPDATE RecepcionProductos SET cantidad = 30 WHERE id_orden = 10;
UPDATE RecepcionProductos SET fecha = '2024-05-25 08:00:00' WHERE id_orden = 15;
UPDATE RecepcionProductos SET cantidad = 35 WHERE id_orden = 20;
UPDATE RecepcionProductos SET fecha = '2024-05-30 12:00:00' WHERE id_orden = 25;

DROP TABLE RecepcionProductos;

-- 14. TABLA DevolucionesClientes 
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (1, 'Producto defectuoso', 25.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (2, 'Talla incorrecta', 15.75);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (3, 'No era lo que esperaba', 30.20);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (4, 'Dañado durante el envío', 20.00);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (5, 'Cambio de opinión', 10.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (6, 'Producto no recibido', 35.80);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (7, 'Problema de calidad', 28.90);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (8, 'No coincide con la descripción', 17.40);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (9, 'Defectos estéticos', 22.60);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (10, 'Producto no deseado', 19.30);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (11, 'No era lo esperado', 24.70);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (12, 'Dañado al recibir', 12.80);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (13, 'Tamaño incorrecto', 18.90);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (14, 'Problemas de funcionamiento', 27.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (15, 'Producto no recibido', 30.00);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (16, 'Defectos de fabricación', 16.20);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (17, 'Producto no deseado', 21.80);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (18, 'No encaja correctamente', 14.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (19, 'Producto defectuoso', 19.90);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (20, 'Dañado durante el envío', 25.70);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (21, 'Cambio de opinión', 11.40);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (22, 'No era lo que esperaba', 26.30);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (23, 'Producto no recibido', 17.60);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (24, 'Problema de calidad', 23.90);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (25, 'No coincide con la descripción', 18.20);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (26, 'Defectos estéticos', 13.70);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (27, 'Producto no deseado', 20.40);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (28, 'No era lo esperado', 15.60);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (29, 'Dañado al recibir', 28.30);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (30, 'Tamaño incorrecto', 24.10);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (31, 'Problemas de funcionamiento', 19.80);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (32, 'Producto no recibido', 16.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (33, 'Defectos de fabricación', 22.70);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (34, 'Producto no deseado', 14.20);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (35, 'No encaja correctamente', 21.30);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (36, 'Producto defectuoso', 27.40);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (37, 'Dañado durante el envío', 18.50);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (38, 'Cambio de opinión', 12.70);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (39, 'No era lo que esperaba', 20.90);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (40, 'Producto no recibido', 25.60);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (41, 'Problema de calidad', 17.80);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (42, 'No coincide con la descripción', 23.40);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (43, 'Defectos estéticos', 15.20);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (44, 'Producto no deseado', 18.90);
INSERT INTO DevolucionesClientes (id_venta, motivo, monto) VALUES (45, 'No era lo esperado', 14.60);

SELECT * FROM DevolucionesClientes;
SELECT * FROM DevolucionesClientes WHERE id_venta = 1;
SELECT * FROM DevolucionesClientes WHERE monto > 20;
SELECT SUM(monto) AS TotalDevoluciones FROM DevolucionesClientes;

DELETE FROM DevolucionesClientes WHERE id_devolucion = 1;
DELETE FROM DevolucionesClientes WHERE id_venta = 2;
DELETE FROM DevolucionesClientes;
DELETE FROM DevolucionesClientes WHERE monto <= 15.00;

UPDATE DevolucionesClientes SET motivo = 'Producto no conforme' WHERE id_devolucion = 3;
UPDATE DevolucionesClientes SET monto = 22.50 WHERE id_devolucion = 4;
UPDATE DevolucionesClientes SET motivo = 'Producto defectuoso' WHERE id_devolucion = 6;
UPDATE DevolucionesClientes SET monto = 26.00 WHERE id_devolucion = 7;

DROP TABLE DevolucionesClientes;

-- Departamentos
INSERT INTO Departamentos (nombre)
VALUES
('Departamento 1'), ('Departamento 2'), ('Departamento 3'), ('Departamento 4'), ('Departamento 5'),
('Departamento 6'), ('Departamento 7'), ('Departamento 8'), ('Departamento 9'), ('Departamento 10'),
('Departamento 11'), ('Departamento 12'), ('Departamento 13'), ('Departamento 14'), ('Departamento 15'),
('Departamento 16'), ('Departamento 17'), ('Departamento 18'), ('Departamento 19'), ('Departamento 20'),
('Departamento 21'), ('Departamento 22'), ('Departamento 23'), ('Departamento 24'), ('Departamento 25'),
('Departamento 26'), ('Departamento 27'), ('Departamento 28'), ('Departamento 29'), ('Departamento 30'),
('Departamento 31'), ('Departamento 32'), ('Departamento 33'), ('Departamento 34'), ('Departamento 35'),
('Departamento 36'), ('Departamento 37'), ('Departamento 38'), ('Departamento 39'), ('Departamento 40'),
('Departamento 41'), ('Departamento 42'), ('Departamento 43'), ('Departamento 44'), ('Departamento 45'),
('Departamento 46'), ('Departamento 47'), ('Departamento 48'), ('Departamento 49'), ('Departamento 50');

SELECT * FROM Departamentos;

SELECT nombre FROM Departamentos;

SELECT * FROM Departamentos ORDER BY nombre;

SELECT COUNT(*) AS total_departamentos FROM Departamentos;

SELECT * FROM Departamentos WHERE id_departamento = 1;

UPDATE Departamentos
SET nombre = 'Recursos Humanos'
WHERE id_departamento = 1;

UPDATE Departamentos
SET nombre = 'Operaciones'
WHERE nombre = 'Departamento 2';

UPDATE Departamentos
SET nombre = CONCAT('Dep. ', nombre);

UPDATE Departamentos
SET nombre = 'Finanzas', descripcion = 'Departamento encargado de las finanzas de la empresa'
WHERE id_departamento = 3;

UPDATE Departamentos
SET nombre = 'Ingeniería'
WHERE descripcion LIKE '%ingeniería%';

DELETE FROM Departamentos WHERE id_departamento = 1;

DELETE FROM Departamentos WHERE nombre = 'Ventas';

DELETE FROM Departamentos WHERE descripcion LIKE '%departamento cerrado%';

DELETE FROM Departamentos;

DELETE TOP(5) FROM Departamentos;

DROP TABLE Departamentos;


-- PuestosTrabajo
INSERT INTO PuestosTrabajo (nombre)
VALUES
('Puesto 1'), ('Puesto 2'), ('Puesto 3'), ('Puesto 4'), ('Puesto 5'),
('Puesto 6'), ('Puesto 7'), ('Puesto 8'), ('Puesto 9'), ('Puesto 10'),
('Puesto 11'), ('Puesto 12'), ('Puesto 13'), ('Puesto 14'), ('Puesto 15'),
('Puesto 16'), ('Puesto 17'), ('Puesto 18'), ('Puesto 19'), ('Puesto 20'),
('Puesto 21'), ('Puesto 22'), ('Puesto 23'), ('Puesto 24'), ('Puesto 25'),
('Puesto 26'), ('Puesto 27'), ('Puesto 28'), ('Puesto 29'), ('Puesto 30'),
('Puesto 31'), ('Puesto 32'), ('Puesto 33'), ('Puesto 34'), ('Puesto 35'),
('Puesto 36'), ('Puesto 37'), ('Puesto 38'), ('Puesto 39'), ('Puesto 40'),
('Puesto 41'), ('Puesto 42'), ('Puesto 43'), ('Puesto 44'), ('Puesto 45'),
('Puesto 46'), ('Puesto 47'), ('Puesto 48'), ('Puesto 49'), ('Puesto 50');

SELECT * FROM PuestosTrabajo;

SELECT nombre FROM PuestosTrabajo;

SELECT * FROM PuestosTrabajo ORDER BY nombre;

SELECT id_departamento, COUNT(*) AS total_puestos
FROM PuestosTrabajo
GROUP BY id_departamento;

SELECT * FROM PuestosTrabajo WHERE id_puesto = 1;

UPDATE PuestosTrabajo
SET nombre = 'Gerente de Recursos Humanos'
WHERE id_puesto = 1;

UPDATE PuestosTrabajo
SET id_departamento = 2
WHERE id_puesto = 1;

UPDATE PuestosTrabajo
SET nombre = 'Analista de Datos', id_departamento = 3
WHERE id_puesto = 2;

UPDATE PuestosTrabajo
SET id_departamento = 4
WHERE nombre LIKE '%Asistente%';

UPDATE PuestosTrabajo
SET nombre = 'Empleado de Soporte'
WHERE id_departamento = 5;

DELETE FROM PuestosTrabajo WHERE id_puesto = 1;

DELETE FROM PuestosTrabajo WHERE id_departamento = 2;

DELETE FROM PuestosTrabajo WHERE nombre LIKE '%Asistente%';

DELETE FROM PuestosTrabajo;

DELETE TOP(5) FROM PuestosTrabajo;

DROP TABLE PuestosTrabajo;

-- HorariosTrabajo

INSERT INTO HorariosTrabajo (id_empleado, dia, hora_entrada, hora_salida)
VALUES
(1, 'Lunes', '09:00', '17:00'),
(1, 'Martes', '09:00', '17:00'),
(1, 'Miércoles', '09:00', '17:00'),
(1, 'Jueves', '09:00', '17:00'),
(1, 'Viernes', '09:00', '17:00'),
(2, 'Lunes', '08:00', '16:00'),
(2, 'Martes', '08:00', '16:00'),
(2, 'Miércoles', '08:00', '16:00'),
(2, 'Jueves', '08:00', '16:00'),
(2, 'Viernes', '08:00', '16:00'),
(3, 'Lunes', '10:00', '18:00'),
(3, 'Martes', '10:00', '18:00'),
(3, 'Miércoles', '10:00', '18:00'),
(3, 'Jueves', '10:00', '18:00'),
(3, 'Viernes', '10:00', '18:00'),
(4, 'Lunes', '09:30', '17:30'),
(4, 'Martes', '09:30', '17:30'),
(4, 'Miércoles', '09:30', '17:30'),
(4, 'Jueves', '09:30', '17:30'),
(4, 'Viernes', '09:30', '17:30'),
(5, 'Lunes', '08:30', '16:30'),
(5, 'Martes', '08:30', '16:30'),
(5, 'Miércoles', '08:30', '16:30'),
(5, 'Jueves', '08:30', '16:30'),
(5, 'Viernes', '08:30', '16:30'),
(6, 'Lunes', '07:00', '15:00'),
(6, 'Martes', '07:00', '15:00'),
(6, 'Miércoles', '07:00', '15:00'),
(6, 'Jueves', '07:00', '15:00'),
(6, 'Viernes', '07:00', '15:00'),
(7, 'Lunes', '11:00', '19:00'),
(7, 'Martes', '11:00', '19:00'),
(7, 'Miércoles', '11:00', '19:00'),
(7, 'Jueves', '11:00', '19:00'),
(7, 'Viernes', '11:00', '19:00'),
(8, 'Lunes', '06:00', '14:00'),
(8, 'Martes', '06:00', '14:00'),
(8, 'Miércoles', '06:00', '14:00'),
(8, 'Jueves', '06:00', '14:00'),
(8, 'Viernes', '06:00', '14:00'),
(9, 'Lunes', '12:00', '20:00'),
(9, 'Martes', '12:00', '20:00'),
(9, 'Miércoles', '12:00', '20:00'),
(9, 'Jueves', '12:00', '20:00'),
(9, 'Viernes', '12:00', '20:00'),
(10, 'Lunes', '13:00', '21:00'),
(10, 'Martes', '13:00', '21:00');

SELECT * FROM HorariosTrabajo WHERE id_empleado = 1;

SELECT * FROM HorariosTrabajo;

SELECT * FROM HorariosTrabajo WHERE dia = 'Lunes';

SELECT * FROM HorariosTrabajo WHERE hora_entrada > '09:00:00';

SELECT * FROM HorariosTrabajo ORDER BY dia, hora_entrada;

UPDATE HorariosTrabajo
SET hora_entrada = '08:30:00'
WHERE id_horario = 1;

UPDATE HorariosTrabajo
SET hora_salida = '17:00:00'
WHERE id_horario = 2;

UPDATE HorariosTrabajo
SET dia = 'Viernes'
WHERE id_horario = 3;

UPDATE HorariosTrabajo
SET hora_entrada = '09:00:00', hora_salida = '18:00:00'
WHERE id_horario = 4;

UPDATE HorariosTrabajo
SET dia = 'Lunes'
WHERE hora_entrada < '09:00:00';

DELETE FROM HorariosTrabajo WHERE id_horario = 1;

DELETE FROM HorariosTrabajo WHERE id_empleado = 1;

DELETE FROM HorariosTrabajo WHERE dia = 'Lunes';

DELETE FROM HorariosTrabajo WHERE hora_entrada > '09:00:00';

DELETE FROM HorariosTrabajo;

DROP TABLE HorariosTrabajo;

-- FlotasTransporte

INSERT INTO FlotasTransporte (descripcion)
VALUES
('Flota 1'), ('Flota 2'), ('Flota 3'), ('Flota 4'), ('Flota 5'),
('Flota 6'), ('Flota 7'), ('Flota 8'), ('Flota 9'), ('Flota 10'),
('Flota 11'), ('Flota 12'), ('Flota 13'), ('Flota 14'), ('Flota 15'),
('Flota 16'), ('Flota 17'), ('Flota 18'), ('Flota 19'), ('Flota 20'),
('Flota 21'), ('Flota 22'), ('Flota 23'), ('Flota 24'), ('Flota 25'),
('Flota 26'), ('Flota 27'), ('Flota 28'), ('Flota 29'), ('Flota 30'),
('Flota 31'), ('Flota 32'), ('Flota 33'), ('Flota 34'), ('Flota 35'),
('Flota 36'), ('Flota 37'), ('Flota 38'), ('Flota 39'), ('Flota 40'),
('Flota 41'), ('Flota 42'), ('Flota 43'), ('Flota 44'), ('Flota 45'),
('Flota 46'), ('Flota 47'), ('Flota 48'), ('Flota 49'), ('Flota 50');

SELECT * FROM FlotasTransporte;

SELECT * FROM FlotasTransporte WHERE id_flota = 1;

SELECT * FROM FlotasTransporte WHERE descripcion LIKE '%Camiones%';

SELECT COUNT(*) AS total_flotas FROM FlotasTransporte;

SELECT * FROM FlotasTransporte ORDER BY descripcion;

UPDATE FlotasTransporte
SET descripcion = 'Flota de Camiones Medianos'
WHERE id_flota = 1;

UPDATE FlotasTransporte
SET descripcion = 'Flota de Camiones'
WHERE descripcion LIKE '%Camiones%';

UPDATE FlotasTransporte
SET descripcion = CONCAT('Transporte ', descripcion)
WHERE id_flota = 2;

UPDATE FlotasTransporte
SET descripcion = REPLACE(descripcion, 'Camiones', 'Furgonetas')
WHERE id_flota = 3;

UPDATE FlotasTransporte
SET descripcion = 'Flota de vehículos de transporte de mercancías'

DELETE FROM FlotasTransporte WHERE id_flota = 1;

DELETE FROM FlotasTransporte WHERE descripcion LIKE '%Desuso%';

DELETE FROM FlotasTransporte;

DELETE TOP(5) FROM FlotasTransporte;

DELETE FROM FlotasTransporte
WHERE id_flota NOT IN (
    SELECT TOP(10) id_flota FROM FlotasTransporte ORDER BY id_flota DESC
);

DROP TABLE FlotasTransporte;


-- RutasDistribucion
INSERT INTO RutasDistribucion (descripcion)
VALUES
('Ruta 1'), ('Ruta 2'), ('Ruta 3'), ('Ruta 4'), ('Ruta 5'),
('Ruta 6'), ('Ruta 7'), ('Ruta 8'), ('Ruta 9'), ('Ruta 10'),
('Ruta 11'), ('Ruta 12'), ('Ruta 13'), ('Ruta 14'), ('Ruta 15'),
('Ruta 16'), ('Ruta 17'), ('Ruta 18'), ('Ruta 19'), ('Ruta 20'),
('Ruta 21'), ('Ruta 22'), ('Ruta 23'), ('Ruta 24'), ('Ruta 25'),
('Ruta 26'), ('Ruta 27'), ('Ruta 28'), ('Ruta 29'), ('Ruta 30'),
('Ruta 31'), ('Ruta 32'), ('Ruta 33'), ('Ruta 34'), ('Ruta 35'),
('Ruta 36'), ('Ruta 37'), ('Ruta 38'), ('Ruta 39'), ('Ruta 40'),
('Ruta 41'), ('Ruta 42'), ('Ruta 43'), ('Ruta 44'), ('Ruta 45'),
('Ruta 46'), ('Ruta 47'), ('Ruta 48'), ('Ruta 49'), ('Ruta 50');

SELECT * FROM RutasDistribucion;

SELECT * FROM RutasDistribucion WHERE id_ruta = 1;

SELECT * FROM RutasDistribucion WHERE descripcion LIKE '%local%';

SELECT COUNT(*) AS total_rutas FROM RutasDistribucion;

SELECT * FROM RutasDistribucion ORDER BY descripcion;

UPDATE RutasDistribucion
SET descripcion = 'Ruta de distribución nacional'
WHERE id_ruta = 1;

UPDATE RutasDistribucion
SET descripcion = 'Ruta de distribución regional'
WHERE descripcion LIKE '%regional%';

UPDATE RutasDistribucion
SET descripcion = CONCAT('Ruta de ', descripcion)
WHERE id_ruta = 2;

UPDATE RutasDistribucion
SET descripcion = REPLACE(descripcion, 'local', 'nacional')
WHERE id_ruta = 3;

UPDATE RutasDistribucion
SET descripcion = 'Ruta de distribución internacional';

DELETE FROM RutasDistribucion WHERE id_ruta = 1;

DELETE FROM RutasDistribucion WHERE descripcion LIKE '%obsoleta%';

DELETE FROM RutasDistribucion;

DELETE TOP(5) FROM RutasDistribucion;

DELETE FROM RutasDistribucion
WHERE id_ruta NOT IN (
    SELECT TOP(10) id_ruta FROM RutasDistribucion ORDER BY id_ruta DESC
);

DROP TABLE RutasDistribucion;

--- Despachos

INSERT INTO Despachos (id_almacen, id_ruta, fecha_salida, fecha_llegada)
VALUES
(1, 1, '2024-01-01 08:00:00', '2024-01-01 12:00:00'),
(2, 2, '2024-01-02 09:00:00', '2024-01-02 13:00:00'),
(3, 3, '2024-01-03 10:00:00', '2024-01-03 14:00:00'),
(4, 4, '2024-01-04 11:00:00', '2024-01-04 15:00:00'),
(5, 5, '2024-01-05 12:00:00', '2024-01-05 16:00:00'),
(6, 6, '2024-01-06 08:30:00', '2024-01-06 12:30:00'),
(7, 7, '2024-01-07 09:30:00', '2024-01-07 13:30:00'),
(8, 8, '2024-01-08 10:30:00', '2024-01-08 14:30:00'),
(9, 9, '2024-01-09 11:30:00', '2024-01-09 15:30:00'),
(10, 10, '2024-01-10 12:30:00', '2024-01-10 16:30:00'),
(1, 2, '2024-01-11 08:00:00', '2024-01-11 12:00:00'),
(2, 3, '2024-01-12 09:00:00', '2024-01-12 13:00:00'),
(3, 4, '2024-01-13 10:00:00', '2024-01-13 14:00:00'),
(4, 5, '2024-01-14 11:00:00', '2024-01-14 15:00:00'),
(5, 6, '2024-01-15 12:00:00', '2024-01-15 16:00:00'),
(6, 7, '2024-01-16 08:30:00', '2024-01-16 12:30:00'),
(7, 8, '2024-01-17 09:30:00', '2024-01-17 13:30:00'),
(8, 9, '2024-01-18 10:30:00', '2024-01-18 14:30:00'),
(9, 10, '2024-01-19 11:30:00', '2024-01-19 15:30:00'),
(10, 1, '2024-01-20 12:30:00', '2024-01-20 16:30:00'),
(1, 3, '2024-01-21 08:00:00', '2024-01-21 12:00:00'),
(2, 4, '2024-01-22 09:00:00', '2024-01-22 13:00:00'),
(3, 5, '2024-01-23 10:00:00', '2024-01-23 14:00:00'),
(4, 6, '2024-01-24 11:00:00', '2024-01-24 15:00:00'),
(5, 7, '2024-01-25 12:00:00', '2024-01-25 16:00:00'),
(6, 8, '2024-01-26 08:30:00', '2024-01-26 12:30:00'),
(7, 9, '2024-01-27 09:30:00', '2024-01-27 13:30:00'),
(8, 10, '2024-01-28 10:30:00', '2024-01-28 14:30:00'),
(9, 1, '2024-01-29 11:30:00', '2024-01-29 15:30:00'),
(10, 2, '2024-01-30 12:30:00', '2024-01-30 16:30:00'),
(1, 4, '2024-01-31 08:00:00', '2024-01-31 12:00:00'),
(2, 5, '2024-02-01 09:00:00', '2024-02-01 13:00:00'),
(3, 6, '2024-02-02 10:00:00', '2024-02-02 14:00:00'),
(4, 7, '2024-02-03 11:00:00', '2024-02-03 15:00:00'),
(5, 8, '2024-02-04 12:00:00', '2024-02-04 16:00:00'),
(6, 9, '2024-02-05 08:30:00', '2024-02-05 12:30:00'),
(7, 10, '2024-02-06 09:30:00', '2024-02-06 13:30:00'),
(8, 1, '2024-02-07 10:30:00', '2024-02-07 14:30:00'),
(9, 2, '2024-02-08 11:30:00', '2024-02-08 15:30:00'),
(10, 3, '2024-02-09 12:30:00', '2024-02-09 16:30:00'),
(1, 5, '2024-02-10 08:00:00', '2024-02-10 12:00:00'),
(2, 6, '2024-02-11 09:00:00', '2024-02-11 13:00:00'),
(3, 7, '2024-02-12 10:00:00', '2024-02-12 14:00:00'),
(4, 8, '2024-02-13 11:00:00', '2024-02-13 15:00:00'),
(5, 9, '2024-02-14 12:00:00', '2024-02-14 16:00:00');

SELECT * FROM Despachos;

SELECT * FROM Despachos WHERE id_despacho = 1;

SELECT * FROM Despachos WHERE CAST(fecha_salida AS DATE) = '2024-05-28';

SELECT * FROM Despachos WHERE fecha_salida BETWEEN '2024-05-01' AND '2024-05-31';

SELECT * FROM Despachos WHERE id_almacen = 1;

UPDATE Despachos
SET fecha_salida = '2024-06-01 08:00:00'
WHERE id_despacho = 1;

UPDATE Despachos
SET fecha_llegada = '2024-06-01 15:00:00'
WHERE id_despacho = 2;

UPDATE Despachos
SET id_ruta = 3
WHERE id_despacho = 3;

UPDATE Despachos
SET fecha_salida = DATEADD(HOUR, 2, fecha_salida), fecha_llegada = DATEADD(HOUR, 2, fecha_llegada)
WHERE id_despacho = 4;

UPDATE Despachos
SET id_almacen = 2
WHERE id_despacho = 5;

DELETE FROM Despachos WHERE id_despacho = 1;

DELETE FROM Despachos WHERE CAST(fecha_salida AS DATE) = '2024-05-28';

DELETE FROM Despachos WHERE id_ruta = 1;

DELETE FROM Despachos WHERE fecha_salida < '2024-05-01';

DELETE FROM Despachos;

DROP TABLE Despachos;

-- Proveedores

INSERT INTO Proveedores (nombre, contacto, telefono, direccion)
VALUES
('Proveedor 1', 'Contacto 1', '123-456-7890', 'Direccion 1'),
('Proveedor 2', 'Contacto 2', '123-456-7891', 'Direccion 2'),
('Proveedor 3', 'Contacto 3', '123-456-7892', 'Direccion 3'),
('Proveedor 4', 'Contacto 4', '123-456-7893', 'Direccion 4'),
('Proveedor 5', 'Contacto 5', '123-456-7894', 'Direccion 5'),
('Proveedor 6', 'Contacto 6', '123-456-7895', 'Direccion 6'),
('Proveedor 7', 'Contacto 7', '123-456-7896', 'Direccion 7'),
('Proveedor 8', 'Contacto 8', '123-456-7897', 'Direccion 8'),
('Proveedor 9', 'Contacto 9', '123-456-7898', 'Direccion 9'),
('Proveedor 10', 'Contacto 10', '123-456-7899', 'Direccion 10'),
('Proveedor 11', 'Contacto 11', '123-456-7800', 'Direccion 11'),
('Proveedor 12', 'Contacto 12', '123-456-7801', 'Direccion 12'),
('Proveedor 13', 'Contacto 13', '123-456-7802', 'Direccion 13'),
('Proveedor 14', 'Contacto 14', '123-456-7803', 'Direccion 14'),
('Proveedor 15', 'Contacto 15', '123-456-7804', 'Direccion 15'),
('Proveedor 16', 'Contacto 16', '123-456-7805', 'Direccion 16'),
('Proveedor 17', 'Contacto 17', '123-456-7806', 'Direccion 17'),
('Proveedor 18', 'Contacto 18', '123-456-7807', 'Direccion 18'),
('Proveedor 19', 'Contacto 19', '123-456-7808', 'Direccion 19'),
('Proveedor 20', 'Contacto 20', '123-456-7809', 'Direccion 20'),
('Proveedor 21', 'Contacto 21', '123-456-7810', 'Direccion 21'),
('Proveedor 22', 'Contacto 22', '123-456-7811', 'Direccion 22'),
('Proveedor 23', 'Contacto 23', '123-456-7812', 'Direccion 23'),
('Proveedor 24', 'Contacto 24', '123-456-7813', 'Direccion 24'),
('Proveedor 25', 'Contacto 25', '123-456-7814', 'Direccion 25'),
('Proveedor 26', 'Contacto 26', '123-456-7815', 'Direccion 26'),
('Proveedor 27', 'Contacto 27', '123-456-7816', 'Direccion 27'),
('Proveedor 28', 'Contacto 28', '123-456-7817', 'Direccion 28'),
('Proveedor 29', 'Contacto 29', '123-456-7818', 'Direccion 29'),
('Proveedor 30', 'Contacto 30', '123-456-7819', 'Direccion 30'),
('Proveedor 31', 'Contacto 31', '123-456-7820', 'Direccion 31'),
('Proveedor 32', 'Contacto 32', '123-456-7821', 'Direccion 32'),
('Proveedor 33', 'Contacto 33', '123-456-7822', 'Direccion 33'),
('Proveedor 34', 'Contacto 34', '123-456-7823', 'Direccion 34'),
('Proveedor 35', 'Contacto 35', '123-456-7824', 'Direccion 35'),
('Proveedor 36', 'Contacto 36', '123-456-7825', 'Direccion 36'),
('Proveedor 37', 'Contacto 37', '123-456-7826', 'Direccion 37'),
('Proveedor 38', 'Contacto 38', '123-456-7827', 'Direccion 38'),
('Proveedor 39', 'Contacto 39', '123-456-7828', 'Direccion 39'),
('Proveedor 40', 'Contacto 40', '123-456-7829', 'Direccion 40'),
('Proveedor 41', 'Contacto 41', '123-456-7830', 'Direccion 41'),
('Proveedor 42', 'Contacto 42', '123-456-7831', 'Direccion 42'),
('Proveedor 43', 'Contacto 43', '123-456-7832', 'Direccion 43'),
('Proveedor 44', 'Contacto 44', '123-456-7833', 'Direccion 44'),
('Proveedor 45', 'Contacto 45', '123-456-7834', 'Direccion 45'),
('Proveedor 46', 'Contacto 46', '123-456-7835', 'Direccion 46'),
('Proveedor 47', 'Contacto 47', '123-456-7836', 'Direccion 47'),
('Proveedor 48', 'Contacto 48', '123-456-7837', 'Direccion 48'),
('Proveedor 49', 'Contacto 49', '123-456-7838', 'Direccion 49'),
('Proveedor 50', 'Contacto 50', '123-456-7839', 'Direccion 50');

SELECT * FROM Proveedores;

SELECT * FROM Proveedores WHERE id_proveedor = 1;

SELECT * FROM Proveedores WHERE nombre = 'Proveedor A';

SELECT * FROM Proveedores WHERE contacto IS NOT NULL;

SELECT * FROM Proveedores WHERE direccion LIKE '%calle%';

UPDATE Proveedores
SET nombre = 'Nuevo Nombre'
WHERE id_proveedor = 1;

UPDATE Proveedores
SET contacto = 'nuevo_contacto@example.com'
WHERE nombre = 'Proveedor A';

UPDATE Proveedores
SET telefono = '555-1234'
WHERE contacto = 'Juan Pérez';

UPDATE Proveedores
SET direccion = 'Nueva Dirección, 123'
WHERE direccion LIKE '%Antigua Calle%';

UPDATE Proveedores
SET nombre = 'Proveedor Modificado', telefono = '555-6789'
WHERE id_proveedor = 2;

DELETE FROM Proveedores WHERE id_proveedor = 1;

DELETE FROM Proveedores WHERE nombre = 'Proveedor A';

DELETE FROM Proveedores WHERE direccion LIKE '%calle%';

DELETE FROM Proveedores WHERE telefono IS NULL;

DELETE FROM Proveedores;

DROP TABLE Proveedores;

-- AnalisisMercado

INSERT INTO AnalisisMercado (descripcion, resultados)
VALUES
('Descripción del análisis 1', 'Resultados del análisis 1'),
('Descripción del análisis 2', 'Resultados del análisis 2'),
('Descripción del análisis 3', 'Resultados del análisis 3'),
('Descripción del análisis 4', 'Resultados del análisis 4'),
('Descripción del análisis 5', 'Resultados del análisis 5'),
('Descripción del análisis 6', 'Resultados del análisis 6'),
('Descripción del análisis 7', 'Resultados del análisis 7'),
('Descripción del análisis 8', 'Resultados del análisis 8'),
('Descripción del análisis 9', 'Resultados del análisis 9'),
('Descripción del análisis 10', 'Resultados del análisis 10'),
('Descripción del análisis 11', 'Resultados del análisis 11'),
('Descripción del análisis 12', 'Resultados del análisis 12'),
('Descripción del análisis 13', 'Resultados del análisis 13'),
('Descripción del análisis 14', 'Resultados del análisis 14'),
('Descripción del análisis 15', 'Resultados del análisis 15'),
('Descripción del análisis 16', 'Resultados del análisis 16'),
('Descripción del análisis 17', 'Resultados del análisis 17'),
('Descripción del análisis 18', 'Resultados del análisis 18'),
('Descripción del análisis 19', 'Resultados del análisis 19'),
('Descripción del análisis 20', 'Resultados del análisis 20'),
('Descripción del análisis 21', 'Resultados del análisis 21'),
('Descripción del análisis 22', 'Resultados del análisis 22'),
('Descripción del análisis 23', 'Resultados del análisis 23'),
('Descripción del análisis 24', 'Resultados del análisis 24'),
('Descripción del análisis 25', 'Resultados del análisis 25'),
('Descripción del análisis 26', 'Resultados del análisis 26'),
('Descripción del análisis 27', 'Resultados del análisis 27'),
('Descripción del análisis 28', 'Resultados del análisis 28'),
('Descripción del análisis 29', 'Resultados del análisis 29'),
('Descripción del análisis 30', 'Resultados del análisis 30'),
('Descripción del análisis 31', 'Resultados del análisis 31'),
('Descripción del análisis 32', 'Resultados del análisis 32'),
('Descripción del análisis 33', 'Resultados del análisis 33'),
('Descripción del análisis 34', 'Resultados del análisis 34'),
('Descripción del análisis 35', 'Resultados del análisis 35'),
('Descripción del análisis 36', 'Resultados del análisis 36'),
('Descripción del análisis 37', 'Resultados del análisis 37'),
('Descripción del análisis 38', 'Resultados del análisis 38'),
('Descripción del análisis 39', 'Resultados del análisis 39'),
('Descripción del análisis 40', 'Resultados del análisis 40'),
('Descripción del análisis 41', 'Resultados del análisis 41'),
('Descripción del análisis 42', 'Resultados del análisis 42'),
('Descripción del análisis 43', 'Resultados del análisis 43'),
('Descripción del análisis 44', 'Resultados del análisis 44'),
('Descripción del análisis 45', 'Resultados del análisis 45'),
('Descripción del análisis 46', 'Resultados del análisis 46'),
('Descripción del análisis 47', 'Resultados del análisis 47'),
('Descripción del análisis 48', 'Resultados del análisis 48'),
('Descripción del análisis 49', 'Resultados del análisis 49'),
('Descripción del análisis 50', 'Resultados del análisis 50');

SELECT * FROM AnalisisMercado;

SELECT * FROM AnalisisMercado WHERE id_analisis = 1;

SELECT * FROM AnalisisMercado WHERE fecha BETWEEN '2024-01-01' AND '2024-12-31';

SELECT descripcion FROM AnalisisMercado;

SELECT COUNT(*) AS total_analisis FROM AnalisisMercado;

UPDATE AnalisisMercado
SET descripcion = 'Descripción actualizada del análisis'
WHERE id_analisis = 1;

UPDATE AnalisisMercado
SET resultados = 'Resultados actualizados del análisis'
WHERE id_analisis = 2;

UPDATE AnalisisMercado
SET fecha = '2024-06-01 10:00:00'
WHERE id_analisis = 3;

UPDATE AnalisisMercado
SET descripcion = 'Nueva descripción', resultados = 'Nuevos resultados'
WHERE id_analisis = 4;

UPDATE AnalisisMercado
SET descripcion = 'Descripción común actualizada'
WHERE CAST(fecha AS DATE) = '2024-05-01';

DELETE FROM AnalisisMercado WHERE id_analisis = 1;

DELETE FROM AnalisisMercado WHERE CAST(fecha AS DATE) = '2024-05-01';

DELETE FROM AnalisisMercado WHERE descripcion = 'Descripción específica';

DELETE FROM AnalisisMercado WHERE resultados LIKE '%palabra clave%';

DELETE FROM AnalisisMercado WHERE fecha < '2024-01-01';

DROP TABLE AnalisisMercado;

-- EncuestasSatisfaccion

INSERT INTO EncuestasSatisfaccion (id_cliente, puntuacion, comentarios)
VALUES
(1, 5, 'Muy satisfecho con el servicio'),
(2, 4, 'Satisfecho, pero hay margen de mejora'),
(3, 3, 'Neutral, el servicio fue promedio'),
(4, 2, 'Insatisfecho con algunos aspectos del servicio'),
(5, 1, 'Muy insatisfecho con el servicio'),
(6, 5, 'Excelente servicio, superó mis expectativas'),
(7, 4, 'Buena atención, pero podría ser mejor'),
(8, 3, 'Servicio promedio, nada destacable'),
(9, 2, 'No me gustó la atención recibida'),
(10, 1, 'Muy mala experiencia, no lo recomendaría'),
(11, 5, 'Servicio rápido y eficiente'),
(12, 4, 'Buena calidad, pero un poco caro'),
(13, 3, 'Servicio estándar, esperaba más'),
(14, 2, 'No me atendieron bien'),
(15, 1, 'Experiencia muy negativa'),
(16, 5, 'Totalmente satisfecho con el producto'),
(17, 4, 'Producto bueno, atención decente'),
(18, 3, 'Nada fuera de lo común'),
(19, 2, 'Tuve varios problemas con el servicio'),
(20, 1, 'Definitivamente no volveré'),
(21, 5, 'Increíble atención y calidad'),
(22, 4, 'Servicio bueno, pero podría mejorar'),
(23, 3, 'Aceptable, pero no sobresaliente'),
(24, 2, 'Mala experiencia en general'),
(25, 1, 'No estoy satisfecho para nada'),
(26, 5, 'Excelente, seguiré siendo cliente'),
(27, 4, 'Bien, pero hay áreas de mejora'),
(28, 3, 'Neutral, servicio promedio'),
(29, 2, 'No me gustó la calidad del servicio'),
(30, 1, 'Muy mal servicio'),
(31, 5, 'Muy satisfecho, superó mis expectativas'),
(32, 4, 'Buen servicio, pero puede mejorar'),
(33, 3, 'Servicio regular'),
(34, 2, 'Insatisfecho con la experiencia'),
(35, 1, 'Muy mala experiencia, no volveré'),
(36, 5, 'Servicio excelente, altamente recomendado'),
(37, 4, 'Buen servicio, pero con algunos problemas'),
(38, 3, 'Servicio normal, no destacó'),
(39, 2, 'Mala calidad en el servicio'),
(40, 1, 'Muy insatisfecho, no recomendaría'),
(41, 5, 'Excelente atención y producto'),
(42, 4, 'Servicio bueno, pero caro'),
(43, 3, 'Servicio estándar, esperaba más'),
(44, 2, 'Problemas con el servicio recibido'),
(45, 1, 'No volveré, muy mala experiencia')

SELECT * FROM EncuestasSatisfaccion;

SELECT * FROM EncuestasSatisfaccion WHERE id_encuesta = 1;

SELECT * FROM EncuestasSatisfaccion WHERE id_cliente = 1;

SELECT * FROM EncuestasSatisfaccion WHERE CAST(fecha AS DATE) = '2024-05-01';

SELECT * FROM EncuestasSatisfaccion WHERE puntuacion >= 4;

UPDATE EncuestasSatisfaccion
SET puntuacion = 5
WHERE id_encuesta = 1;

UPDATE EncuestasSatisfaccion
SET comentarios = 'Comentarios actualizados'
WHERE id_encuesta = 2;

UPDATE EncuestasSatisfaccion
SET fecha = '2024-06-01 10:00:00'
WHERE id_encuesta = 3;

UPDATE EncuestasSatisfaccion
SET puntuacion = 3, comentarios = 'Nuevos comentarios'
WHERE id_encuesta = 4;

UPDATE EncuestasSatisfaccion
SET puntuacion = 4
WHERE id_cliente = 1;

DELETE FROM EncuestasSatisfaccion WHERE id_encuesta = 1;

DELETE FROM EncuestasSatisfaccion WHERE id_cliente = 2;

DELETE FROM EncuestasSatisfaccion WHERE CAST(fecha AS DATE) = '2024-05-01';

DELETE FROM EncuestasSatisfaccion WHERE puntuacion < 3;

DELETE FROM EncuestasSatisfaccion WHERE comentarios IS NULL OR comentarios = '';

DROP TABLE EncuestasSatisfaccion;

-- Eventos

INSERT INTO Eventos (nombre, descripcion, ubicacion)
VALUES
('Evento 1', 'Descripción del evento 1', 'Ubicación 1'),
('Evento 2', 'Descripción del evento 2', 'Ubicación 2'),
('Evento 3', 'Descripción del evento 3', 'Ubicación 3'),
('Evento 4', 'Descripción del evento 4', 'Ubicación 4'),
('Evento 5', 'Descripción del evento 5', 'Ubicación 5'),
('Evento 6', 'Descripción del evento 6', 'Ubicación 6'),
('Evento 7', 'Descripción del evento 7', 'Ubicación 7'),
('Evento 8', 'Descripción del evento 8', 'Ubicación 8'),
('Evento 9', 'Descripción del evento 9', 'Ubicación 9'),
('Evento 10', 'Descripción del evento 10', 'Ubicación 10'),
('Evento 11', 'Descripción del evento 11', 'Ubicación 11'),
('Evento 12', 'Descripción del evento 12', 'Ubicación 12'),
('Evento 13', 'Descripción del evento 13', 'Ubicación 13'),
('Evento 14', 'Descripción del evento 14', 'Ubicación 14'),
('Evento 15', 'Descripción del evento 15', 'Ubicación 15'),
('Evento 16', 'Descripción del evento 16', 'Ubicación 16'),
('Evento 17', 'Descripción del evento 17', 'Ubicación 17'),
('Evento 18', 'Descripción del evento 18', 'Ubicación 18'),
('Evento 19', 'Descripción del evento 19', 'Ubicación 19'),
('Evento 20', 'Descripción del evento 20', 'Ubicación 20'),
('Evento 21', 'Descripción del evento 21', 'Ubicación 21'),
('Evento 22', 'Descripción del evento 22', 'Ubicación 22'),
('Evento 23', 'Descripción del evento 23', 'Ubicación 23'),
('Evento 24', 'Descripción del evento 24', 'Ubicación 24'),
('Evento 25', 'Descripción del evento 25', 'Ubicación 25'),
('Evento 26', 'Descripción del evento 26', 'Ubicación 26'),
('Evento 27', 'Descripción del evento 27', 'Ubicación 27'),
('Evento 28', 'Descripción del evento 28', 'Ubicación 28'),
('Evento 29', 'Descripción del evento 29', 'Ubicación 29'),
('Evento 30', 'Descripción del evento 30', 'Ubicación 30'),
('Evento 31', 'Descripción del evento 31', 'Ubicación 31'),
('Evento 32', 'Descripción del evento 32', 'Ubicación 32'),
('Evento 33', 'Descripción del evento 33', 'Ubicación 33'),
('Evento 34', 'Descripción del evento 34', 'Ubicación 34'),
('Evento 35', 'Descripción del evento 35', 'Ubicación 35'),
('Evento 36', 'Descripción del evento 36', 'Ubicación 36'),
('Evento 37', 'Descripción del evento 37', 'Ubicación 37'),
('Evento 38', 'Descripción del evento 38', 'Ubicación 38'),
('Evento 39', 'Descripción del evento 39', 'Ubicación 39'),
('Evento 40', 'Descripción del evento 40', 'Ubicación 40'),
('Evento 41', 'Descripción del evento 41', 'Ubicación 41'),
('Evento 42', 'Descripción del evento 42', 'Ubicación 42'),
('Evento 43', 'Descripción del evento 43', 'Ubicación 43'),
('Evento 44', 'Descripción del evento 44', 'Ubicación 44'),
('Evento 45', 'Descripción del evento 45', 'Ubicación 45'),
('Evento 46', 'Descripción del evento 46', 'Ubicación 46'),
('Evento 47', 'Descripción del evento 47', 'Ubicación 47'),
('Evento 48', 'Descripción del evento 48', 'Ubicación 48'),
('Evento 49', 'Descripción del evento 49', 'Ubicación 49'),
('Evento 50', 'Descripción del evento 50', 'Ubicación 50');

SELECT * FROM Eventos;

SELECT * FROM Eventos WHERE nombre = 'Evento A';

SELECT * FROM Eventos WHERE CAST(fecha AS DATE) = '2024-05-01';

SELECT * FROM Eventos WHERE ubicacion LIKE '%Centro de Convenciones%';

SELECT * FROM Eventos WHERE descripcion LIKE '%conferencia%';

UPDATE Eventos
SET nombre = 'Nuevo nombre de evento'
WHERE id_evento = 1;

UPDATE Eventos
SET descripcion = 'Nueva descripción del evento'
WHERE id_evento = 2;

UPDATE Eventos
SET ubicacion = 'Nuevo lugar'
WHERE fecha < '2024-01-01';

UPDATE Eventos
SET ubicacion = 'Nuevo Centro'
WHERE YEAR(fecha) = 2024;

UPDATE Eventos
SET descripcion = 'Descripción Actualizada'
WHERE descripcion LIKE '%conferencia%';

DELETE FROM Eventos WHERE id_evento = 1;

DELETE FROM Eventos WHERE CAST(fecha AS DATE) = '2024-05-01';

DELETE FROM Eventos WHERE descripcion = 'Descripción del Evento';

DELETE FROM Eventos WHERE ubicacion LIKE '%Centro de Convenciones%';

DELETE FROM Eventos WHERE fecha < '2024-01-01';

DROP TABLE Eventos;

-- Patrocinios

INSERT INTO Patrocinios (nombre, descripcion, monto)
VALUES
('Patrocinio 1', 'Descripción del patrocinio 1', 1000.00),
('Patrocinio 2', 'Descripción del patrocinio 2', 1500.50),
('Patrocinio 3', 'Descripción del patrocinio 3', 2000.75),
('Patrocinio 4', 'Descripción del patrocinio 4', 2500.25),
('Patrocinio 5', 'Descripción del patrocinio 5', 3000.00),
('Patrocinio 6', 'Descripción del patrocinio 6', 3500.50),
('Patrocinio 7', 'Descripción del patrocinio 7', 4000.75),
('Patrocinio 8', 'Descripción del patrocinio 8', 4500.25),
('Patrocinio 9', 'Descripción del patrocinio 9', 5000.00),
('Patrocinio 10', 'Descripción del patrocinio 10', 5500.50),
('Patrocinio 11', 'Descripción del patrocinio 11', 6000.75),
('Patrocinio 12', 'Descripción del patrocinio 12', 6500.25),
('Patrocinio 13', 'Descripción del patrocinio 13', 7000.00),
('Patrocinio 14', 'Descripción del patrocinio 14', 7500.50),
('Patrocinio 15', 'Descripción del patrocinio 15', 8000.75),
('Patrocinio 16', 'Descripción del patrocinio 16', 8500.25),
('Patrocinio 17', 'Descripción del patrocinio 17', 9000.00),
('Patrocinio 18', 'Descripción del patrocinio 18', 9500.50),
('Patrocinio 19', 'Descripción del patrocinio 19', 10000.75),
('Patrocinio 20', 'Descripción del patrocinio 20', 10500.25),
('Patrocinio 21', 'Descripción del patrocinio 21', 11000.00),
('Patrocinio 22', 'Descripción del patrocinio 22', 11500.50),
('Patrocinio 23', 'Descripción del patrocinio 23', 12000.75),
('Patrocinio 24', 'Descripción del patrocinio 24', 12500.25),
('Patrocinio 25', 'Descripción del patrocinio 25', 13000.00),
('Patrocinio 26', 'Descripción del patrocinio 26', 13500.50),
('Patrocinio 27', 'Descripción del patrocinio 27', 14000.75),
('Patrocinio 28', 'Descripción del patrocinio 28', 14500.25),
('Patrocinio 29', 'Descripción del patrocinio 29', 15000.00),
('Patrocinio 30', 'Descripción del patrocinio 30', 15500.50),
('Patrocinio 31', 'Descripción del patrocinio 31', 16000.75),
('Patrocinio 32', 'Descripción del patrocinio 32', 16500.25),
('Patrocinio 33', 'Descripción del patrocinio 33', 17000.00),
('Patrocinio 34', 'Descripción del patrocinio 34', 17500.50),
('Patrocinio 35', 'Descripción del patrocinio 35', 18000.75),
('Patrocinio 36', 'Descripción del patrocinio 36', 18500.25),
('Patrocinio 37', 'Descripción del patrocinio 37', 19000.00),
('Patrocinio 38', 'Descripción del patrocinio 38', 19500.50),
('Patrocinio 39', 'Descripción del patrocinio 39', 20000.75),
('Patrocinio 40', 'Descripción del patrocinio 40', 20500.25),
('Patrocinio 41', 'Descripción del patrocinio 41', 21000.00),
('Patrocinio 42', 'Descripción del patrocinio 42', 21500.50),
('Patrocinio 43', 'Descripción del patrocinio 43', 22000.75),
('Patrocinio 44', 'Descripción del patrocinio 44', 22500.25),
('Patrocinio 45', 'Descripción del patrocinio 45', 23000.00),
('Patrocinio 46', 'Descripción del patrocinio 46', 23500.50),
('Patrocinio 47', 'Descripción del patrocinio 47', 24000.75)

SELECT * FROM Patrocinios;

SELECT * FROM Patrocinios WHERE nombre = 'Patrocinio A';

SELECT * FROM Patrocinios WHERE monto > 1000;

SELECT * FROM Patrocinios WHERE descripcion LIKE '%evento%';

SELECT nombre, monto FROM Patrocinios ORDER BY monto DESC;

UPDATE Patrocinios
SET nombre = 'Nuevo Nombre del Patrocinio'
WHERE id_patrocinio = 1;

UPDATE Patrocinios
SET descripcion = 'Nueva Descripción del Patrocinio'
WHERE id_patrocinio = 2;

UPDATE Patrocinios
SET monto = 1500
WHERE id_patrocinio = 3;

UPDATE Patrocinios
SET monto = monto * 1.1
WHERE monto IS NOT NULL;

UPDATE Patrocinios
SET descripcion = 'Descripción Actualizada'
WHERE descripcion LIKE '%evento%';

DELETE FROM Patrocinios WHERE id_patrocinio = 1;

DELETE FROM Patrocinios WHERE monto < 1000;

DELETE FROM Patrocinios WHERE descripcion = 'Patrocinio con Descripción';

DELETE FROM Patrocinios WHERE descripcion IS NULL OR descripcion = '';

DELETE FROM Patrocinios WHERE nombre LIKE '%evento%';

DROP TABLE Patrocinios;

-- AuditoriasInternas
SELECT * FROM AuditoriasInternas;

INSERT INTO AuditoriasInternas (descripcion, resultados) VALUES
('Evaluación de cumplimiento normativo', 'Cumplimiento total'),
('Revisión de gestión de riesgos', 'Riesgos identificados y mitigados'),
('Auditoría financiera', 'Sin irregularidades detectadas'),
('Inspección de instalaciones', 'Reparaciones menores requeridas'),
('Auditoría de sistemas de información', 'Actualizaciones recomendadas'),
('Revisión de control de calidad', 'Procedimientos optimizados'),
('Auditoría de recursos humanos', 'Procesos eficientes'),
('Inspección de seguridad informática', 'Implementación de nuevas políticas sugerida'),
('Revisión de inventarios', 'Desviaciones mínimas encontradas'),
('Auditoría de cumplimiento ambiental', 'Conformidad total'),
('Evaluación de procesos administrativos', 'Requiere mejoras'),
('Auditoría de compras y contrataciones', 'Proveedores verificados'),
('Revisión de políticas internas', 'Actualización necesaria'),
('Auditoría de comunicación interna', 'Efectiva'),
('Inspección de mantenimiento', 'Calendario de mantenimiento adecuado'),
('Revisión de proyectos en curso', 'Cumplimiento de plazos'),
('Auditoría de logística', 'Eficiencia en el transporte'),
('Revisión de servicio al cliente', 'Altos niveles de satisfacción'),
('Auditoría de marketing', 'Estrategias efectivas'),
('Evaluación de productividad', 'Índices mejorados'),
('Revisión de sistemas de reporte', 'Precisión en los datos'),
('Auditoría de cumplimiento legal', 'Sin infracciones detectadas'),
('Inspección de equipo de trabajo', 'Funcionamiento óptimo'),
('Revisión de relaciones laborales', 'Ambiente positivo'),
('Auditoría de planes estratégicos', 'Objetivos alcanzados'),
('Evaluación de programas de capacitación', 'Efectividad comprobada'),
('Revisión de políticas de privacidad', 'Cumplimiento con normativas'),
('Auditoría de control interno', 'Controles robustos'),
('Inspección de vehículos corporativos', 'Mantenimiento al día'),
('Revisión de seguridad en el trabajo', 'Prácticas seguras'),
('Auditoría de procesos contables', 'Exactitud confirmada'),
('Evaluación de sostenibilidad', 'Prácticas ecoamigables'),
('Revisión de eficiencia energética', 'Ahorro significativo'),
('Auditoría de gestión documental', 'Archivos ordenados'),
('Inspección de medidas anti-fraude', 'Medidas efectivas'),
('Revisión de procedimientos operativos', 'Optimización necesaria'),
('Auditoría de tecnología', 'Innovación en marcha'),
('Evaluación de satisfacción del empleado', 'Alto nivel de compromiso'),
('Revisión de gestión de activos', 'Control adecuado'),
('Auditoría de estrategias de ventas', 'Crecimiento notable'),
('Inspección de productos terminados', 'Alta calidad'),
('Revisión de cumplimiento fiscal', 'Declaraciones precisas'),
('Auditoría de planificación financiera', 'Proyecciones realistas'),
('Evaluación de relaciones con proveedores', 'Colaboración eficaz'),
('Revisión de políticas de seguridad', 'Normativas cumplidas'),
('Auditoría de planes de emergencia', 'Preparación adecuada'),
('Inspección de cadena de suministro', 'Flujo continuo'),
('Revisión de innovación y desarrollo', 'Proyectos avanzando'),
('Auditoría de gestión de cambios', 'Implementación exitosa'),
('Evaluación de gestión del tiempo', 'Eficiencia mejorada');

UPDATE AuditoriasInternas
SET descripcion = 'Auditoría de cumplimiento'
WHERE id_auditoria = 1;

DELETE FROM AuditoriasInternas
WHERE id_auditoria = 50;

-- DROP
DROP TABLE AuditoriasInternas;

-- AccesosUsuario

SELECT * FROM AccesosUsuario;

INSERT INTO AccesosUsuario (id_empleado, usuario, contrasena) VALUES
(1, 'usuario1', 'contrasena1'),
(2, 'usuario2', 'contrasena2'),
(3, 'usuario3', 'contrasena3'),
(4, 'usuario4', 'contrasena4'),
(5, 'usuario5', 'contrasena5'),
(6, 'usuario6', 'contrasena6'),
(7, 'usuario7', 'contrasena7'),
(8, 'usuario8', 'contrasena8'),
(9, 'usuario9', 'contrasena9'),
(10, 'usuario10', 'contrasena10'),
(11, 'usuario11', 'contrasena11'),
(12, 'usuario12', 'contrasena12'),
(13, 'usuario13', 'contrasena13'),
(14, 'usuario14', 'contrasena14'),
(15, 'usuario15', 'contrasena15'),
(16, 'usuario16', 'contrasena16'),
(17, 'usuario17', 'contrasena17'),
(18, 'usuario18', 'contrasena18'),
(19, 'usuario19', 'contrasena19'),
(20, 'usuario20', 'contrasena20'),
(21, 'usuario21', 'contrasena21'),
(22, 'usuario22', 'contrasena22'),
(23, 'usuario23', 'contrasena23'),
(24, 'usuario24', 'contrasena24'),
(25, 'usuario25', 'contrasena25'),
(26, 'usuario26', 'contrasena26'),
(27, 'usuario27', 'contrasena27'),
(28, 'usuario28', 'contrasena28'),
(29, 'usuario29', 'contrasena29'),
(30, 'usuario30', 'contrasena30'),
(31, 'usuario31', 'contrasena31'),
(32, 'usuario32', 'contrasena32'),
(33, 'usuario33', 'contrasena33'),
(34, 'usuario34', 'contrasena34')

UPDATE AccesosUsuario
SET contrasena = 'nueva_contrasena'
WHERE id_acceso = 1;

DELETE FROM AccesosUsuario
WHERE id_acceso = 50;

DROP TABLE AccesosUsuario;

CREATE TABLE RolesPermisos (
    id_rol INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(50)
);

SELECT * FROM RolesPermisos;

INSERT INTO RolesPermisos (nombre) VALUES
('Superusuario'),
('Moderador'),
('Invitado'),
('Analista'),
('Desarrollador'),
('Tester'),
('Soporte Técnico'),
('Auditor'),
('Gerente de Proyecto'),
('Consultor'),
('Especialista en Seguridad'),
('Líder de Equipo'),
('Asistente Administrativo'),
('Marketing'),
('Ventas'),
('Recursos Humanos'),
('Finanzas'),
('Logística'),
('Compras'),
('Atención al Cliente'),
('Operaciones'),
('Director General'),
('Jefe de Departamento'),
('Especialista en IT'),
('Investigador'),
('Formador'),
('Planificador'),
('Coordinador'),
('Redactor'),
('Diseñador'),
('Editor'),
('Productor'),
('Publicista'),
('Relaciones Públicas'),
('Estratega'),
('Administrador de Redes'),
('Analista de Datos'),
('Ingeniero de Software'),
('Desarrollador Front-End'),
('Desarrollador Back-End'),
('Administrador de Base de Datos'),
('Arquitecto de Soluciones'),
('Científico de Datos'),
('Ingeniero DevOps'),
('Especialista en UX/UI'),
('Especialista en SEO'),
('Consultor Técnico'),
('Gestor de Contenidos'),
('Responsable de Calidad'),
('Ingeniero de Sistemas');

UPDATE RolesPermisos
SET nombre = 'SuperUsuario'
WHERE id_rol = 1;


DELETE FROM RolesPermisos
WHERE id_rol = 50;

DROP TABLE RolesPermisos;

CREATE TABLE Permisos (
    id_permiso INT PRIMARY KEY IDENTITY(1, 1),
    descripcion VARCHAR(100)
);


-- Permisos
SELECT * FROM Permisos; 

INSERT INTO Permisos (descripcion) VALUES
('Editar datos'),
('Eliminar datos'),
('Crear usuarios'),
('Modificar usuarios'),
('Eliminar usuarios'),
('Acceso a reportes'),
('Generar reportes'),
('Configurar sistema'),
('Administrar roles'),
('Administrar permisos'),
('Ver auditorías'),
('Realizar auditorías'),
('Acceso a panel de control'),
('Gestionar inventarios'),
('Ver finanzas'),
('Modificar finanzas'),
('Aprobar transacciones'),
('Rechazar transacciones'),
('Acceso a estadísticas'),
('Configurar alertas'),
('Administrar backups'),
('Restaurar backups'),
('Acceso a logs de sistema'),
('Ver registros de actividad'),
('Acceso a documentación'),
('Editar documentación'),
('Eliminar documentación'),
('Administrar proyectos'),
('Ver proyectos'),
('Modificar proyectos'),
('Asignar tareas'),
('Modificar tareas'),
('Eliminar tareas'),
('Acceso a soporte técnico'),
('Responder tickets de soporte'),
('Crear tickets de soporte'),
('Modificar tickets de soporte'),
('Eliminar tickets de soporte'),
('Acceso a base de conocimiento'),
('Administrar base de conocimiento'),
('Acceso a configuraciones avanzadas'),
('Administrar configuraciones avanzadas'),
('Ver políticas de seguridad'),
('Modificar políticas de seguridad'),
('Implementar políticas de seguridad'),
('Acceso a configuración de red'),
('Modificar configuración de red'),
('Monitorear red'),
('Administrar dispositivos de red');


UPDATE Permisos
SET descripcion = 'Acceso total'
WHERE id_permiso = 1;

DELETE FROM Permisos
WHERE id_permiso = 50;

DROP TABLE Permisos;

--RolesUsuarios
SELECT * FROM RolesUsuarios;

INSERT INTO RolesUsuarios (id_acceso, id_rol) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
(31, 31),
(32, 32),
(33, 33),
(34, 34)

UPDATE RolesUsuarios
SET id_rol = 1
WHERE id_rol_usuario = 1;

DELETE FROM RolesUsuarios
WHERE id_rol_usuario = 50;

DROP TABLE RolesUsuarios;

--PermisosRoles
SELECT * FROM PermisosRoles;
INSERT INTO PermisosRoles (id_rol, id_permiso) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
(31, 31),
(32, 32),
(33, 33),
(34, 34)

UPDATE PermisosRoles
SET id_permiso = 1
WHERE id_permiso_rol = 1;

DELETE FROM PermisosRoles
WHERE id_permiso_rol = 50;


DROP TABLE PermisosRoles;

-- LogsActividades
SELECT * FROM LogsActividades;

INSERT INTO LogsActividades (id_acceso, actividad) VALUES
(1, 'Visualización de reportes'),
(2, 'Visualización de reportes'),
(3, 'Visualización de reportes'),
(4, 'Modificación de datos'),
(5, 'Eliminación de datos'),
(6, 'Creación de usuario'),
(7, 'Actualización de perfil'),
(8, 'Cambio de contraseña'),
(9, 'Desbloqueo de cuenta'),
(10, 'Generación de informe'),
(11, 'Aprobación de solicitud'),
(12, 'Rechazo de solicitud'),
(13, 'Acceso a configuraciones'),
(14, 'Respaldo de datos'),
(15, 'Restauración de datos'),
(16, 'Consulta de registros'),
(17, 'Carga de archivos'),
(18, 'Descarga de archivos'),
(19, 'Asignación de roles'),
(20, 'Revocación de permisos'),
(21, 'Acceso a módulo de auditoría'),
(22, 'Edición de políticas'),
(23, 'Implementación de cambios'),
(24, 'Actualización de sistema'),
(25, 'Reinicio de sistema'),
(26, 'Cierre de sistema'),
(27, 'Monitoreo de actividad'),
(28, 'Evaluación de rendimiento'),
(29, 'Acceso a base de datos'),
(30, 'Modificación de base de datos'),
(31, 'Eliminación de registros'),
(32, 'Añadir registros'),
(33, 'Acceso a soporte técnico'),
(34, 'Actualización de tickets')


UPDATE LogsActividades
SET actividad = 'Actualización de perfil'
WHERE id_log = 1;

DELETE FROM LogsActividades
WHERE id_log = 50;

DROP TABLE LogsActividades;

-- IncidentesSeguridad
SELECT * FROM IncidentesSeguridad;

INSERT INTO IncidentesSeguridad (descripcion, id_empleado) VALUES
('Acceso no autorizado detectado', 1),
('Acceso no autorizado detectado', 2),
('Acceso no autorizado detectado', 3),
('Phishing detectado', 4),
('Malware detectado', 5),
('Pérdida de datos', 6),
('Falla en el sistema', 7),
('Intento de suplantación de identidad', 8),
('Ataque DDoS mitigado', 9),
('Robo de dispositivo', 10),
('Violación de políticas de seguridad', 11),
('Acceso físico no autorizado', 12),
('Fuga de información', 13),
('Uso indebido de recursos', 14),
('Modificación no autorizada de datos', 15),
('Denegación de servicio', 16),
('Intrusión de red detectada', 17),
('Ejecución de código malicioso', 18),
('Falla en medidas de seguridad', 19),
('Sospecha de espionaje industrial', 20),
('Extracción no autorizada de datos', 21),
('Vulnerabilidad explotada', 22),
('Desconfiguración de sistemas', 23),
('Acceso indebido a información sensible', 24),
('Intento de acceso a sistemas restringidos', 25),
('Correo sospechoso recibido', 26),
('Comportamiento anómalo detectado', 27),
('Exposición de datos personales', 28),
('Escaneo de puertos no autorizado', 29),
('Conexión desde IP sospechosa', 30),
('Uso indebido de privilegios', 31),
('Modificación de registros de auditoría', 32),
('Acceso no autorizado a la base de datos', 33),
('Descarga no autorizada de archivos', 34)

UPDATE IncidentesSeguridad
SET descripcion = 'Incidente crítico'
WHERE id_incidente = 1;

DELETE FROM IncidentesSeguridad
WHERE id_incidente = 50;

DROP TABLE IncidentesSeguridad;


-- ControlPerdidas
SELECT * FROM ControlPerdidas;

INSERT INTO ControlPerdidas (id_producto, cantidad, motivo) VALUES
(3, 8, 'Daño en transporte'),
(4, 3, 'Caducidad'),
(5, 15, 'Defecto de fabricación'),
(6, 7, 'Extraviado en almacén'),
(7, 2, 'Error de inventario'),
(8, 20, 'Fallo en control de calidad'),
(9, 6, 'Condiciones de almacenamiento inapropiadas'),
(10, 12, 'Desperdicio en producción'),
(11, 4, 'Error en envío'),
(12, 9, 'Retiro del mercado'),
(13, 11, 'Falla técnica'),
(14, 5, 'Accidente en almacén'),
(15, 1, 'Devolución por cliente'),
(16, 8, 'Contaminación'),
(17, 3, 'Manejo inadecuado'),
(18, 14, 'Derrame'),
(19, 6, 'Sobrestock'),
(20, 10, 'Pérdida de documentación'),
(21, 7, 'Cambio de normativa'),
(22, 2, 'Obsolescencia'),
(23, 13, 'Error humano'),
(24, 4, 'Mal almacenamiento'),
(25, 9, 'Pérdida durante auditoría'),
(26, 5, 'Error en proceso de producción'),
(27, 7, 'Insectos/roedores'),
(28, 1, 'Incendio'),
(29, 10, 'Inundación'),
(30, 3, 'Falta de mantenimiento'),
(31, 8, 'Manipulación inadecuada'),
(32, 4, 'Sustracción interna'),
(33, 6, 'Desviación de inventario'),
(34, 12, 'Descomposición'),
(35, 2, 'Sobredemanda'),
(36, 11, 'Suministro defectuoso'),
(37, 5, 'Temperatura inadecuada'),
(38, 9, 'Defecto de diseño'),
(39, 7, 'Intercambio de productos'),
(40, 4, 'Error de conteo'),
(41, 6, 'Impacto físico'),
(42, 3, 'Desperfecto en embalaje'),
(43, 8, 'Error administrativo'),
(44, 2, 'Cancelación de orden'),
(45, 10, 'Reciclaje'),
(46, 5, 'Falla de energía'),
(47, 7, 'Vandalismo'),
(48, 1, 'Defecto en materiales'),
(49, 6, 'Falta de espacio de almacenamiento'),
(50, 4, 'Condiciones climáticas extremas')


UPDATE ControlPerdidas
SET motivo = 'Desgaste'
WHERE id_control = 1;


DELETE FROM ControlPerdidas
WHERE id_control = 50;

DROP TABLE ControlPerdidas;


-- CampanasMarketing
SELECT * FROM CampanasMarketing;
INSERT INTO CampanasMarketing (nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, estado) VALUES
('Campaña 3', 'Descripción 3', '2024-03-01', '2024-03-31', 20000.00, 'activa'),
('Campaña 4', 'Descripción 4', '2024-04-01', '2024-04-30', 25000.00, 'inactiva'),
('Campaña 5', 'Descripción 5', '2024-05-01', '2024-05-31', 30000.00, 'activa'),
('Campaña 6', 'Descripción 6', '2024-06-01', '2024-06-30', 35000.00, 'inactiva'),
('Campaña 7', 'Descripción 7', '2024-07-01', '2024-07-31', 40000.00, 'activa'),
('Campaña 8', 'Descripción 8', '2024-08-01', '2024-08-31', 45000.00, 'inactiva'),
('Campaña 9', 'Descripción 9', '2024-09-01', '2024-09-30', 50000.00, 'activa'),
('Campaña 10', 'Descripción 10', '2024-10-01', '2024-10-31', 55000.00, 'inactiva'),
('Campaña 11', 'Descripción 11', '2024-11-01', '2024-11-30', 60000.00, 'activa'),
('Campaña 12', 'Descripción 12', '2024-12-01', '2024-12-31', 65000.00, 'inactiva'),
('Campaña 13', 'Descripción 13', '2025-01-01', '2025-01-31', 70000.00, 'activa'),
('Campaña 14', 'Descripción 14', '2025-02-01', '2025-02-28', 75000.00, 'inactiva'),
('Campaña 15', 'Descripción 15', '2025-03-01', '2025-03-31', 80000.00, 'activa'),
('Campaña 16', 'Descripción 16', '2025-04-01', '2025-04-30', 85000.00, 'inactiva'),
('Campaña 17', 'Descripción 17', '2025-05-01', '2025-05-31', 90000.00, 'activa'),
('Campaña 18', 'Descripción 18', '2025-06-01', '2025-06-30', 95000.00, 'inactiva'),
('Campaña 19', 'Descripción 19', '2025-07-01', '2025-07-31', 100000.00, 'activa'),
('Campaña 20', 'Descripción 20', '2025-08-01', '2025-08-31', 105000.00, 'inactiva'),
('Campaña 21', 'Descripción 21', '2025-09-01', '2025-09-30', 110000.00, 'activa'),
('Campaña 22', 'Descripción 22', '2025-10-01', '2025-10-31', 115000.00, 'inactiva'),
('Campaña 23', 'Descripción 23', '2025-11-01', '2025-11-30', 120000.00, 'activa'),
('Campaña 24', 'Descripción 24', '2025-12-01', '2025-12-31', 125000.00, 'inactiva'),
('Campaña 25', 'Descripción 25', '2026-01-01', '2026-01-31', 130000.00, 'activa'),
('Campaña 26', 'Descripción 26', '2026-02-01', '2026-02-28', 135000.00, 'inactiva'),
('Campaña 27', 'Descripción 27', '2026-03-01', '2026-03-31', 140000.00, 'activa'),
('Campaña 28', 'Descripción 28', '2026-04-01', '2026-04-30', 145000.00, 'inactiva'),
('Campaña 29', 'Descripción 29', '2026-05-01', '2026-05-31', 150000.00, 'activa'),
('Campaña 30', 'Descripción 30', '2026-06-01', '2026-06-30', 155000.00, 'inactiva'),
('Campaña 31', 'Descripción 31', '2026-07-01', '2026-07-31', 160000.00, 'activa'),
('Campaña 32', 'Descripción 32', '2026-08-01', '2026-08-31', 165000.00, 'inactiva'),
('Campaña 33', 'Descripción 33', '2026-09-01', '2026-09-30', 170000.00, 'activa'),
('Campaña 34', 'Descripción 34', '2026-10-01', '2026-10-31', 175000.00, 'inactiva'),
('Campaña 35', 'Descripción 35', '2026-11-01', '2026-11-30', 180000.00, 'activa'),
('Campaña 36', 'Descripción 36', '2026-12-01', '2026-12-31', 185000.00, 'inactiva'),
('Campaña 37', 'Descripción 37', '2027-01-01', '2027-01-31', 190000.00, 'activa'),
('Campaña 38', 'Descripción 38', '2027-02-01', '2027-02-28', 195000.00, 'inactiva'),
('Campaña 39', 'Descripción 39', '2027-03-01', '2027-03-31', 200000.00, 'activa'),
('Campaña 40', 'Descripción 40', '2027-04-01', '2027-04-30', 205000.00, 'inactiva'),
('Campaña 41', 'Descripción 41', '2027-05-01', '2027-05-31', 210000.00, 'activa'),
('Campaña 42', 'Descripción 42', '2027-06-01', '2027-06-30', 215000.00, 'inactiva'),
('Campaña 43', 'Descripción 43', '2027-07-01', '2027-07-31', 220000.00, 'activa'),
('Campaña 44', 'Descripción 44', '2027-08-01', '2027-08-31', 225000.00, 'inactiva'),
('Campaña 45', 'Descripción 45', '2027-09-01', '2027-09-30', 230000.00, 'activa'),
('Campaña 46', 'Descripción 46', '2027-10-01', '2027-10-31', 235000.00, 'inactiva'),
('Campaña 47', 'Descripción 47', '2027-11-01', '2027-11-30', 240000.00, 'activa'),
('Campaña 48', 'Descripción 48', '2027-12-01', '2027-12-31', 245000.00, 'inactiva'),
('Campaña 49', 'Descripción 49', '2028-01-01', '2028-01-31', 250000.00, 'activa'),
('Campaña 50', 'Descripción 50', '2028-02-01', '2028-02-29', 255000.00, 'inactiva'),
('Campaña 51', 'Descripción 51', '2028-03-01', '2028-03-31', 260000.00, 'activa'),
('Campaña 52', 'Descripción 52', '2028-04-01', '2028-04-30', 265000.00, 'inactiva');


UPDATE CampanasMarketing
SET estado = 'inactiva'
WHERE id_campana = 1;

DELETE FROM CampanasMarketing
WHERE id_campana = 50;

DROP TABLE CampanasMarketing;

-- MediosPublicidad
SELECT * FROM MediosPublicidad;

INSERT INTO MediosPublicidad (nombre, tipo) VALUES
('Medio 3', 'Internet'),
('Medio 4', 'Prensa'),
('Medio 5', 'Redes Sociales'),
('Medio 6', 'Publicidad Exterior'),
('Medio 7', 'Revistas'),
('Medio 8', 'Correo Electrónico'),
('Medio 9', 'Cine'),
('Medio 10', 'Eventos Patrocinados'),
('Medio 11', 'Mailing'),
('Medio 12', 'Ferias Comerciales'),
('Medio 13', 'Vallas Publicitarias'),
('Medio 14', 'Cupones'),
('Medio 15', 'Marketing de Contenidos'),
('Medio 16', 'Influencers'),
('Medio 17', 'SEO'),
('Medio 18', 'SEM'),
('Medio 19', 'Programas de Afiliados'),
('Medio 20', 'Marketing de Guerrilla'),
('Medio 21', 'Publicidad Nativa'),
('Medio 22', 'Televisión por Internet'),
('Medio 23', 'Publicidad en Videojuegos'),
('Medio 24', 'Marketing de Atracción'),
('Medio 25', 'Patrocinios'),
('Medio 26', 'Anuncios en Apps'),
('Medio 27', 'SMS Marketing'),
('Medio 28', 'Marketing de Eventos'),
('Medio 29', 'Marketing de Proximidad'),
('Medio 30', 'Blogs'),
('Medio 31', 'Podcasts'),
('Medio 32', 'Anuncios Nativos'),
('Medio 33', 'Publicidad en Bases de Datos'),
('Medio 34', 'Remarketing'),
('Medio 35', 'Publicidad Interactiva'),
('Medio 36', 'Marketing de Afiliación'),
('Medio 37', 'Publicidad en Periódicos'),
('Medio 38', 'Publicidad en TV Local'),
('Medio 39', 'Publicidad en Radio Local'),
('Medio 40', 'Publicidad en Páginas Web'),
('Medio 41', 'Marketing de Mensajes Instantáneos'),
('Medio 42', 'Publicidad en Video Online'),
('Medio 43', 'Publicidad en Directorios Online'),
('Medio 44', 'Publicidad en Redes Sociales Locales'),
('Medio 45', 'Marketing de Contenidos Generados por Usuarios'),
('Medio 46', 'Publicidad en Búsqueda Local'),
('Medio 47', 'Marketing de Contenidos Colaborativos'),
('Medio 48', 'Publicidad en Plataformas de Streaming'),
('Medio 49', 'Publicidad en Aplicaciones Móviles'),
('Medio 50', 'Publicidad en Buscadores');

UPDATE MediosPublicidad
SET tipo = 'Prensa'
WHERE id_medio = 1;

DELETE FROM MediosPublicidad
WHERE id_medio = 50;


DROP TABLE MediosPublicidad;

-- AnalisisMercado
SELECT * FROM AnalisisMercado;

INSERT INTO AnalisisMercado (descripcion, resultados) VALUES
('Análisis de tendencias', 'Tendencias favorables'),
('Análisis de demanda', 'Demanda creciente'),
('Evaluación de segmentación', 'Segmentos identificados'),
('Estudio de clientes potenciales', 'Amplio mercado objetivo'),
('Análisis de precios', 'Precios competitivos'),
('Evaluación de satisfacción del cliente', 'Alta satisfacción'),
('Análisis de distribución', 'Canales de distribución eficientes'),
('Estudio de penetración de mercado', 'Potencial de crecimiento'),
('Análisis de posicionamiento', 'Posicionamiento sólido'),
('Evaluación de competidores indirectos', 'Competidores emergentes'),
('Estudio de hábitos de consumo', 'Hábitos estables'),
('Análisis de ciclo de vida del producto', 'Productos en fase de crecimiento'),
('Estudio de percepción de marca', 'Marca reconocida'),
('Análisis de barreras de entrada', 'Barreras bajas'),
('Evaluación de riesgos del mercado', 'Riesgos controlables'),
('Estudio de oportunidades de crecimiento', 'Oportunidades identificadas'),
('Análisis de distribución geográfica', 'Cobertura extensa'),
('Evaluación de fuerzas competitivas', 'Competencia equilibrada'),
('Estudio de canales de comunicación', 'Canales efectivos'),
('Análisis de lealtad de marca', 'Lealtad del cliente alta'),
('Evaluación de tendencias del consumidor', 'Tendencias en aumento'),
('Estudio de expectativas del consumidor', 'Expectativas alcanzables'),
('Análisis de fidelización de clientes', 'Programas de fidelización exitosos'),
('Evaluación de impacto de la marca', 'Marca impactante'),
('Estudio de sensibilidad al precio', 'Sensibilidad moderada al precio'),
('Análisis de ciclo económico', 'Economía estable'),
('Evaluación de amenazas del mercado', 'Amenazas controlables'),
('Estudio de innovaciones del mercado', 'Innovaciones prometedoras'),
('Análisis de penetración de marca', 'Penetración efectiva'),
('Evaluación de factores demográficos', 'Demografía favorable'),
('Estudio de hábitos de compra', 'Hábitos de compra estables'),
('Análisis de canales de venta', 'Canales de venta diversificados'),
('Evaluación de eficacia de promociones', 'Promociones exitosas'),
('Estudio de comportamiento del consumidor', 'Comportamiento predecible'),
('Análisis de estacionalidad del mercado', 'Estacionalidad gestionable'),
('Evaluación de influencia de opiniones', 'Opiniones positivas influyentes'),
('Estudio de percepción del producto', 'Producto bien valorado'),
('Análisis de adaptación al mercado', 'Adaptación exitosa'),
('Evaluación de potencial de mercado', 'Potencial significativo'),
('Estudio de ciclo de vida del cliente', 'Clientes fieles'),
('Análisis de factores socioculturales', 'Factores estables'),
('Evaluación de sensibilidad a la marca', 'Sensibilidad moderada a la marca'),
('Estudio de preferencias del consumidor', 'Preferencias claras'),
('Análisis de comportamiento de compra', 'Comportamiento consistente'),
('Evaluación de impacto de eventos externos', 'Eventos externos gestionables'),
('Estudio de factores económicos', 'Economía en crecimiento'),
('Análisis de adaptación del producto', 'Producto adaptable'),
('Evaluación de potencial de crecimiento', 'Crecimiento sostenible');

UPDATE AnalisisMercado
SET descripcion = 'Análisis de consumidores'
WHERE id_analisis = 1;

DELETE FROM AnalisisMercado
WHERE id_analisis = 50;

DROP TABLE AnalisisMercado;

-- EncuestasSatisfaccion
SELECT * FROM EncuestasSatisfaccion;

INSERT INTO EncuestasSatisfaccion (id_cliente, puntuacion, comentarios) VALUES
(3, 3, 'Neutral'),
(4, 2, 'Poco satisfecho'),
(5, 1, 'Insatisfecho'),
(6, 5, 'Muy satisfecho'),
(7, 4, 'Satisfecho'),
(8, 3, 'Neutral'),
(9, 2, 'Poco satisfecho'),
(10, 1, 'Insatisfecho'),
(11, 5, 'Muy satisfecho'),
(12, 4, 'Satisfecho'),
(13, 3, 'Neutral'),
(14, 2, 'Poco satisfecho'),
(15, 1, 'Insatisfecho'),
(16, 5, 'Muy satisfecho'),
(17, 4, 'Satisfecho'),
(18, 3, 'Neutral'),
(19, 2, 'Poco satisfecho'),
(20, 1, 'Insatisfecho'),
(21, 5, 'Muy satisfecho'),
(22, 4, 'Satisfecho'),
(23, 3, 'Neutral'),
(24, 2, 'Poco satisfecho'),
(25, 1, 'Insatisfecho'),
(26, 5, 'Muy satisfecho'),
(27, 4, 'Satisfecho'),
(28, 3, 'Neutral'),
(29, 2, 'Poco satisfecho'),
(30, 1, 'Insatisfecho'),
(31, 5, 'Muy satisfecho'),
(32, 4, 'Satisfecho'),
(33, 3, 'Neutral'),
(34, 2, 'Poco satisfecho'),
(35, 1, 'Insatisfecho'),
(36, 5, 'Muy satisfecho'),
(37, 4, 'Satisfecho'),
(38, 3, 'Neutral'),
(39, 2, 'Poco satisfecho'),
(40, 1, 'Insatisfecho'),
(41, 5, 'Muy satisfecho'),
(42, 4, 'Satisfecho'),
(43, 3, 'Neutral'),
(44, 2, 'Poco satisfecho'),
(45, 1, 'Insatisfecho')


UPDATE EncuestasSatisfaccion
SET comentarios = 'Muy insatisfecho'
WHERE id_encuesta = 1;

DELETE FROM EncuestasSatisfaccion
WHERE id_encuesta = 50;

DROP TABLE EncuestasSatisfaccion;

-- Eventos
SELECT * FROM Eventos;

INSERT INTO Eventos (nombre, descripcion, ubicacion) VALUES
('Evento 3', 'Descripción 3', 'Ubicación 3'),
('Evento 4', 'Descripción 4', 'Ubicación 4'),
('Evento 5', 'Descripción 5', 'Ubicación 5'),
('Evento 6', 'Descripción 6', 'Ubicación 6'),
('Evento 7', 'Descripción 7', 'Ubicación 7'),
('Evento 8', 'Descripción 8', 'Ubicación 8'),
('Evento 9', 'Descripción 9', 'Ubicación 9'),
('Evento 10', 'Descripción 10', 'Ubicación 10'),
('Evento 11', 'Descripción 11', 'Ubicación 11'),
('Evento 12', 'Descripción 12', 'Ubicación 12'),
('Evento 13', 'Descripción 13', 'Ubicación 13'),
('Evento 14', 'Descripción 14', 'Ubicación 14'),
('Evento 15', 'Descripción 15', 'Ubicación 15'),
('Evento 16', 'Descripción 16', 'Ubicación 16'),
('Evento 17', 'Descripción 17', 'Ubicación 17'),
('Evento 18', 'Descripción 18', 'Ubicación 18'),
('Evento 19', 'Descripción 19', 'Ubicación 19'),
('Evento 20', 'Descripción 20', 'Ubicación 20'),
('Evento 21', 'Descripción 21', 'Ubicación 21'),
('Evento 22', 'Descripción 22', 'Ubicación 22'),
('Evento 23', 'Descripción 23', 'Ubicación 23'),
('Evento 24', 'Descripción 24', 'Ubicación 24'),
('Evento 25', 'Descripción 25', 'Ubicación 25'),
('Evento 26', 'Descripción 26', 'Ubicación 26'),
('Evento 27', 'Descripción 27', 'Ubicación 27'),
('Evento 28', 'Descripción 28', 'Ubicación 28'),
('Evento 29', 'Descripción 29', 'Ubicación 29'),
('Evento 30', 'Descripción 30', 'Ubicación 30'),
('Evento 31', 'Descripción 31', 'Ubicación 31'),
('Evento 32', 'Descripción 32', 'Ubicación 32'),
('Evento 33', 'Descripción 33', 'Ubicación 33'),
('Evento 34', 'Descripción 34', 'Ubicación 34'),
('Evento 35', 'Descripción 35', 'Ubicación 35'),
('Evento 36', 'Descripción 36', 'Ubicación 36'),
('Evento 37', 'Descripción 37', 'Ubicación 37'),
('Evento 38', 'Descripción 38', 'Ubicación 38'),
('Evento 39', 'Descripción 39', 'Ubicación 39'),
('Evento 40', 'Descripción 40', 'Ubicación 40'),
('Evento 41', 'Descripción 41', 'Ubicación 41'),
('Evento 42', 'Descripción 42', 'Ubicación 42'),
('Evento 43', 'Descripción 43', 'Ubicación 43'),
('Evento 44', 'Descripción 44', 'Ubicación 44'),
('Evento 45', 'Descripción 45', 'Ubicación 45'),
('Evento 46', 'Descripción 46', 'Ubicación 46'),
('Evento 47', 'Descripción 47', 'Ubicación 47'),
('Evento 48', 'Descripción 48', 'Ubicación 48'),
('Evento 49', 'Descripción 49', 'Ubicación 49'),
('Evento 50', 'Descripción 50', 'Ubicación 50');


UPDATE Eventos
SET ubicacion = 'Ubicación actualizada'
WHERE id_evento = 1;

DELETE FROM Eventos
WHERE id_evento = 50;

DROP TABLE Eventos;


-- Insert EquiposMaquinaria
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Refrigerador Industrial', 'Refrigerador para lácteos', '2023-01-01', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Horno Industrial', 'Horno para panadería', '2022-12-15', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Batidora Industrial', 'Batidora para mezclas pesadas', '2021-07-20', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Licuadora Industrial', 'Licuadora para jugos y batidos', '2020-03-12', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Lavavajillas Industrial', 'Lavavajillas para grandes volúmenes', '2019-11-05', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Freidora Industrial', 'Freidora para frituras varias', '2022-06-01', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Amasadora Industrial', 'Amasadora para masas', '2018-09-30', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Máquina de Hielo', 'Máquina para producir hielo', '2023-02-10', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cafetera Industrial', 'Cafetera para grandes volúmenes', '2021-05-22', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Tostadora Industrial', 'Tostadora para pan y otros productos', '2022-11-13', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Pasteurizador', 'Máquina para pasteurizar leche', '2017-01-25', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Envasadora al Vacío', 'Máquina para envasado al vacío', '2020-08-17', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Procesador de Alimentos', 'Procesador para cortar y picar', '2019-04-02', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Estufa Industrial', 'Estufa para cocina industrial', '2023-05-15', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cámara de Fermentación', 'Cámara para fermentación de masas', '2021-09-27', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cortadora de Fiambre', 'Cortadora para fiambres y embutidos', '2018-02-14', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Deshidratador de Alimentos', 'Máquina para deshidratar frutas y verduras', '2022-10-05', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Carro de Transporte', 'Carro para transporte de alimentos', '2020-07-18', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cámara de Congelación', 'Cámara para congelar alimentos', '2019-01-10', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Fregadero Industrial', 'Fregadero para grandes volúmenes', '2017-12-04', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Extractor de Jugos', 'Extractor para jugos naturales', '2021-03-21', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Picadora de Carne', 'Máquina para picar carne', '2023-04-06', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Horno de Convección', 'Horno para cocción uniforme', '2020-12-11', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Máquina de Helados', 'Máquina para hacer helados', '2018-06-25', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Termoselladora', 'Máquina para termosellar envases', '2019-08-03', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Horno de Microondas', 'Microondas para cocina industrial', '2022-03-29', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Plancha Industrial', 'Plancha para cocinar', '2021-12-15', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Carro Calorífico', 'Carro para mantener alimentos calientes', '2020-05-19', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Rebanadora de Pan', 'Máquina para rebanar pan', '2017-11-30', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Laminadora de Masa', 'Máquina para laminar masa', '2023-07-09', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Turbomixer', 'Mezclador de alta velocidad', '2019-06-22', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Empacadora', 'Máquina para empacar productos', '2018-04-17', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cocedor a Vapor', 'Cocedor para alimentos a vapor', '2021-10-11', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Máquina de Palomitas', 'Máquina para hacer palomitas', '2020-09-26', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cuchilla Industrial', 'Cuchilla para cortar carnes', '2023-03-18', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Balanza Electrónica', 'Balanza para pesar alimentos', '2017-05-20', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Dispensador de Bebidas', 'Máquina para dispensar bebidas', '2019-10-30', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Estante Refrigerado', 'Estante para mantener productos fríos', '2022-01-08', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cortadora de Papas', 'Máquina para cortar papas', '2021-06-14', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Selladora de Bolsas', 'Máquina para sellar bolsas', '2018-08-28', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Hervidor Industrial', 'Hervidor para grandes volúmenes', '2023-05-22', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Enfriador de Bebidas', 'Enfriador para bebidas', '2020-02-16', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Máquina de Café Expreso', 'Máquina para hacer café expreso', '2022-08-19', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Mezcladora de Bebidas', 'Máquina para mezclar bebidas', '2019-05-03', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Dosificadora de Salsas', 'Máquina para dosificar salsas', '2021-11-07', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Molinillo de Café', 'Molinillo para café', '2018-03-21', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Equipo de Vacío', 'Equipo para empaques al vacío', '2023-01-29', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Freidora a Gas', 'Freidora industrial a gas', '2020-06-04', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Fábrica de Hielo', 'Máquina para fabricar hielo', '2022-05-13', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Cortadora de Verduras', 'Máquina para cortar verduras', '2019-09-07', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Máquina de Paletas', 'Máquina para hacer paletas', '2021-04-27', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Termo de Café', 'Termo para café', '2018-07-16', 'operativo');
INSERT INTO EquiposMaquinaria (nombre, descripcion, fecha_adquisicion, estado) VALUES ('Refrigerador Vertical', 'Refrigerador para productos varios', '2023-06-11', 'operativo');

-- select 
SELECT * FROM EquiposMaquinaria;

SELECT nombre, estado FROM EquiposMaquinaria;

SELECT * FROM EquiposMaquinaria WHERE estado = 'operativo';

SELECT * FROM EquiposMaquinaria WHERE fecha_adquisicion > '2021-01-01';

SELECT nombre, descripcion FROM EquiposMaquinaria WHERE estado = 'mantenimiento';

-- update
UPDATE EquiposMaquinaria SET estado = 'operativo' WHERE nombre = 'Horno Industrial';

UPDATE EquiposMaquinaria SET descripcion = 'Refrigerador para carnes' WHERE nombre = 'Refrigerador Industrial';

UPDATE EquiposMaquinaria SET fecha_adquisicion = '2024-01-01' WHERE nombre = 'Máquina de Hielo';

UPDATE EquiposMaquinaria SET estado = 'mantenimiento' WHERE estado = 'fuera de servicio';

UPDATE EquiposMaquinaria SET estado = 'operativo' WHERE fecha_adquisicion LIKE '2023%';


-- delete
DELETE FROM EquiposMaquinaria WHERE nombre = 'Lavavajillas Industrial';

DELETE FROM EquiposMaquinaria WHERE estado = 'fuera de servicio';

DELETE FROM EquiposMaquinaria WHERE fecha_adquisicion < '2020-01-01';

DELETE FROM EquiposMaquinaria WHERE descripcion = 'Cortadora para fiambres y embutidos';

DELETE FROM EquiposMaquinaria WHERE estado = 'mantenimiento';

-- drop
DROP TABLE EquiposMaquinaria;


-- Tabla: MantenimientoPreventivo
-- Insert
select * from MantenimientoPreventivo

INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (1, '2024-01-15', 'Revisión general', 100.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (2, '2024-02-10', 'Cambio de filtro', 50.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (3, '2024-03-05', 'Limpieza profunda', 75.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (4, '2024-04-20', 'Reemplazo de piezas', 200.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (5, '2024-05-15', 'Lubricación', 30.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (6, '2024-06-10', 'Ajuste de mecanismos', 60.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (7, '2024-07-25', 'Revisión eléctrica', 80.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (8, '2024-08-14', 'Inspección de seguridad', 90.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (9, '2024-09-30', 'Actualización de software', 120.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (10, '2024-10-20', 'Revisión de eficiencia', 110.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (11, '2024-11-15', 'Cambio de aceite', 40.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (12, '2024-12-05', 'Verificación de calibración', 55.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (13, '2024-01-10', 'Revisión general', 100.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (14, '2024-02-22', 'Cambio de filtro', 50.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (15, '2024-03-15', 'Limpieza profunda', 75.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (16, '2024-04-05', 'Reemplazo de piezas', 200.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (17, '2024-05-25', 'Lubricación', 30.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (18, '2024-06-15', 'Ajuste de mecanismos', 60.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (19, '2024-07-20', 'Revisión eléctrica', 80.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (20, '2024-08-05', 'Inspección de seguridad', 90.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (21, '2024-09-10', 'Actualización de software', 120.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (22, '2024-10-25', 'Revisión de eficiencia', 110.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (23, '2024-11-12', 'Cambio de aceite', 40.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (24, '2024-12-22', 'Verificación de calibración', 55.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (25, '2024-01-30', 'Revisión general', 100.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (26, '2024-02-14', 'Cambio de filtro', 50.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (27, '2024-03-25', 'Limpieza profunda', 75.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (28, '2024-04-18', 'Reemplazo de piezas', 200.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (29, '2024-05-28', 'Lubricación', 30.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (30, '2024-06-20', 'Ajuste de mecanismos', 60.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (31, '2024-07-15', 'Revisión eléctrica', 80.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (32, '2024-08-25', 'Inspección de seguridad', 90.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (33, '2024-09-15', 'Actualización de software', 120.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (34, '2024-10-10', 'Revisión de eficiencia', 110.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (35, '2024-11-22', 'Cambio de aceite', 40.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (36, '2024-12-14', 'Verificación de calibración', 55.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (37, '2024-01-12', 'Revisión general', 100.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (38, '2024-02-28', 'Cambio de filtro', 50.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (39, '2024-03-22', 'Limpieza profunda', 75.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (40, '2024-04-11', 'Reemplazo de piezas', 200.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (41, '2024-05-18', 'Lubricación', 30.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (42, '2024-06-25', 'Ajuste de mecanismos', 60.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (43, '2024-07-28', 'Revisión eléctrica', 80.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (44, '2024-08-20', 'Inspección de seguridad', 90.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (45, '2024-09-12', 'Actualización de software', 120.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (46, '2024-10-22', 'Revisión de eficiencia', 110.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (47, '2024-11-17', 'Cambio de aceite', 40.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (48, '2024-12-19', 'Verificación de calibración', 55.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (49, '2024-01-09', 'Revisión general', 100.00);
INSERT INTO MantenimientoPreventivo (id_equipo, fecha, descripcion, costo) VALUES (50, '2024-02-23', 'Cambio de filtro', 50.00);

-- select
SELECT * FROM MantenimientoPreventivo;

SELECT fecha, descripcion FROM MantenimientoPreventivo;

SELECT * FROM MantenimientoPreventivo WHERE costo > 100.00;

SELECT * FROM MantenimientoPreventivo WHERE id_equipo = 1;

SELECT descripcion, costo FROM MantenimientoPreventivo WHERE fecha LIKE '2024%';

-- update
UPDATE MantenimientoPreventivo SET costo = 150.00 WHERE id_equipo = 1 AND fecha = '2024-01-15';

UPDATE MantenimientoPreventivo SET descripcion = 'Revisión detallada' WHERE id_equipo = 2 AND fecha = '2024-02-10';

UPDATE MantenimientoPreventivo SET fecha = '2024-03-01' WHERE id_equipo = 3 AND descripcion = 'Limpieza profunda';

UPDATE MantenimientoPreventivo SET costo = 100.00;

UPDATE MantenimientoPreventivo SET descripcion = 'Inspección completa' WHERE id_equipo = 4;


-- delete
DELETE FROM MantenimientoPreventivo WHERE id_equipo = 5 AND fecha = '2024-05-15';

DELETE FROM MantenimientoPreventivo WHERE costo < 50.00;

DELETE FROM MantenimientoPreventivo WHERE fecha LIKE '2024%';

DELETE FROM MantenimientoPreventivo WHERE descripcion = 'Cambio de filtro';

DELETE FROM MantenimientoPreventivo WHERE id_equipo = 6;

-- drop
DROP TABLE MantenimientoPreventivo;

-- Tabla: MantenimientoCorrectivo
-- Insert
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (1, '2024-04-20', 'Reparación de compresor', 500.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (2, '2024-05-10', 'Reemplazo de motor', 750.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (3, '2024-06-15', 'Ajuste de frenos', 200.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (4, '2024-07-05', 'Cambio de correa', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (5, '2024-08-22', 'Reparación de sistema eléctrico', 400.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (6, '2024-09-12', 'Reemplazo de engranajes', 350.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (7, '2024-10-08', 'Reparación de circuito', 450.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (8, '2024-11-01', 'Cambio de filtros', 100.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (9, '2024-12-15', 'Reparación de válvulas', 300.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (10, '2024-01-20', 'Ajuste de presión', 250.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (11, '2024-02-10', 'Reparación de bomba', 500.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (12, '2024-03-25', 'Cambio de termostato', 180.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (13, '2024-04-14', 'Reemplazo de batería', 130.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (14, '2024-05-30', 'Reparación de sistema hidráulico', 600.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (15, '2024-06-20', 'Ajuste de cadena', 90.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (16, '2024-07-10', 'Reparación de sistema de enfriamiento', 700.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (17, '2024-08-01', 'Cambio de aceite', 80.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (18, '2024-09-15', 'Reparación de sensor', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (19, '2024-10-05', 'Reemplazo de cables', 120.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (20, '2024-11-20', 'Reparación de fusibles', 100.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (21, '2024-12-10', 'Ajuste de ventilador', 60.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (22, '2024-01-15', 'Cambio de fusible', 40.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (23, '2024-02-25', 'Reparación de panel', 300.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (24, '2024-03-12', 'Ajuste de válvula', 100.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (25, '2024-04-22', 'Reemplazo de termistor', 90.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (26, '2024-05-15', 'Reparación de módulo', 250.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (27, '2024-06-05', 'Cambio de ventilador', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (28, '2024-07-18', 'Reparación de motor', 350.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (29, '2024-08-28', 'Ajuste de control', 200.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (30, '2024-09-22', 'Cambio de sensores', 300.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (31, '2024-10-11', 'Reparación de sistema de control', 400.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (32, '2024-11-08', 'Cambio de regulador', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (33, '2024-12-02', 'Reparación de circuito impreso', 250.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (34, '2024-01-18', 'Reemplazo de filtro', 70.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (35, '2024-02-14', 'Reparación de bobina', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (36, '2024-03-06', 'Ajuste de rodamiento', 80.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (37, '2024-04-25', 'Reemplazo de condensador', 90.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (38, '2024-05-28', 'Reparación de sistema de transmisión', 500.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (39, '2024-06-19', 'Cambio de pantalla', 200.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (40, '2024-07-09', 'Reparación de teclado', 100.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (41, '2024-08-03', 'Reemplazo de interruptor', 60.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (42, '2024-09-25', 'Reparación de unidad de control', 300.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (43, '2024-10-16', 'Cambio de rodamiento', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (44, '2024-11-05', 'Reemplazo de tarjeta de memoria', 100.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (45, '2024-12-14', 'Reparación de sistema de frenos', 350.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (46, '2024-01-11', 'Cambio de fusible principal', 50.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (47, '2024-02-27', 'Reparación de sistema de alimentación', 500.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (48, '2024-03-23', 'Cambio de bomba de agua', 150.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (49, '2024-04-12', 'Reparación de cableado', 200.00);
INSERT INTO MantenimientoCorrectivo (id_equipo, fecha, descripcion, costo) VALUES (50, '2024-05-08', 'Ajuste de componentes electrónicos', 100.00);

-- Select
SELECT * FROM MantenimientoCorrectivo;

SELECT fecha, descripcion FROM MantenimientoCorrectivo;

SELECT * FROM MantenimientoCorrectivo WHERE costo > 300.00;

SELECT * FROM MantenimientoCorrectivo WHERE id_equipo = 1;

SELECT descripcion, costo FROM MantenimientoCorrectivo WHERE fecha LIKE '2024%';

-- Update
UPDATE MantenimientoCorrectivo SET costo = 550.00 WHERE id_equipo = 1 AND fecha = '2024-04-20';

UPDATE MantenimientoCorrectivo SET descripcion = 'Reparación de motor' WHERE id_equipo = 2 AND fecha = '2024-05-10';

UPDATE MantenimientoCorrectivo SET fecha = '2024-07-01' WHERE id_equipo = 3 AND descripcion = 'Ajuste de frenos';

UPDATE MantenimientoCorrectivo SET costo = 200.00 WHERE descripcion = 'Cambio de correa';

UPDATE MantenimientoCorrectivo SET descripcion = 'Revisión y ajuste completo' WHERE id_equipo = 4;

-- Delete
DELETE FROM MantenimientoCorrectivo WHERE id_equipo = 5 AND fecha = '2024-08-22';

DELETE FROM MantenimientoCorrectivo WHERE costo < 100.00;

DELETE FROM MantenimientoCorrectivo WHERE fecha LIKE '2024%';

DELETE FROM MantenimientoCorrectivo WHERE descripcion = 'Cambio de filtros';

DELETE FROM MantenimientoCorrectivo WHERE id_equipo = 6;

-- Drop
DROP TABLE MantenimientoCorrectivo;

-- Table: ContratosServicio
-- Insert
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Limpieza', 'Servicio de limpieza mensual', '2024-01-01', '2024-12-31', 1200.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Mantenimiento', 'Mantenimiento preventivo anual', '2024-02-01', '2024-11-30', 5000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Seguridad', 'Vigilancia 24/7', '2024-03-01', '2024-08-31', 3000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Jardinería', 'Mantenimiento de jardines', '2024-04-01', '2024-10-31', 1500.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de IT', 'Soporte técnico', '2024-05-01', '2024-12-31', 8000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Consultoría', 'Consultoría financiera', '2024-06-01', '2024-12-31', 4500.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Publicidad', 'Campaña publicitaria', '2024-07-01', '2024-09-30', 20000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Transporte', 'Servicio de transporte de personal', '2024-08-01', '2024-12-31', 10000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Catering', 'Servicio de catering para eventos', '2024-09-01', '2024-12-31', 6000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Auditoría', 'Auditoría contable', '2024-10-01', '2024-12-31', 7000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Capacitación', 'Cursos de capacitación', '2024-01-01', '2024-06-30', 2500.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Asesoría Legal', 'Asesoría y representación legal', '2024-02-01', '2024-12-31', 12000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Diseño Gráfico', 'Diseño de materiales publicitarios', '2024-03-01', '2024-08-31', 4000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Marketing Digital', 'Gestión de redes sociales', '2024-04-01', '2024-09-30', 9000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Limpieza Industrial', 'Limpieza de instalaciones industriales', '2024-05-01', '2024-12-31', 15000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Recursos Humanos', 'Gestión de nóminas y personal', '2024-06-01', '2024-12-31', 11000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Seguros', 'Pólizas de seguro para empleados', '2024-07-01', '2024-12-31', 18000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Logística', 'Gestión de cadena de suministro', '2024-08-01', '2024-12-31', 22000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Telecomunicaciones', 'Servicios de telecomunicaciones', '2024-09-01', '2024-12-31', 13000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Investigación de Mercado', 'Estudios de mercado', '2024-10-01', '2024-12-31', 5000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Eventos', 'Organización de eventos corporativos', '2024-01-01', '2024-12-31', 25000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Fotografía', 'Servicios fotográficos', '2024-02-01', '2024-07-31', 8000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Video', 'Producción de videos corporativos', '2024-03-01', '2024-09-30', 15000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Traducción', 'Traducción de documentos', '2024-04-01', '2024-10-31', 3000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Arquitectura', 'Diseño arquitectónico', '2024-05-01', '2024-12-31', 20000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Construcción', 'Construcción de oficinas', '2024-06-01', '2024-12-31', 100000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Ingeniería', 'Servicios de ingeniería', '2024-07-01', '2024-12-31', 50000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Ventas', 'Estrategias de ventas', '2024-08-01', '2024-12-31', 12000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Consultoría IT', 'Consultoría en tecnología', '2024-09-01', '2024-12-31', 25000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Mantenimiento de Equipos', 'Mantenimiento de equipos industriales', '2024-10-01', '2024-12-31', 20000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Capacitación Técnica', 'Cursos de capacitación técnica', '2024-01-01', '2024-06-30', 8000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Investigación y Desarrollo', 'Proyectos de I+D', '2024-02-01', '2024-12-31', 100000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Bienestar Laboral', 'Programas de bienestar para empleados', '2024-03-01', '2024-12-31', 15000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Consultoría Ambiental', 'Consultoría en sostenibilidad', '2024-04-01', '2024-12-31', 18000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Auditoría Interna', 'Servicios de auditoría interna', '2024-05-01', '2024-12-31', 7000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Redacción', 'Servicios de redacción de contenido', '2024-06-01', '2024-12-31', 5000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Mantenimiento Eléctrico', 'Mantenimiento de instalaciones eléctricas', '2024-07-01', '2024-12-31', 10000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Servicios Médicos', 'Servicios médicos para empleados', '2024-08-01', '2024-12-31', 30000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Limpieza Especializada', 'Limpieza de áreas críticas', '2024-09-01', '2024-12-31', 12000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Software', 'Desarrollo de software a medida', '2024-10-01', '2024-12-31', 50000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de SEO', 'Optimización en motores de búsqueda', '2024-01-01', '2024-12-31', 10000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Investigación Clínica', 'Ensayos clínicos', '2024-02-01', '2024-12-31', 75000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Protección de Datos', 'Consultoría en protección de datos', '2024-03-01', '2024-12-31', 22000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Traducción Técnica', 'Traducción de manuales técnicos', '2024-04-01', '2024-12-31', 4000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Monitoreo de Redes', 'Monitoreo y gestión de redes', '2024-05-01', '2024-12-31', 18000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Evaluación de Desempeño', 'Evaluaciones de desempeño para empleados', '2024-06-01', '2024-12-31', 6000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Análisis de Datos', 'Análisis de datos empresariales', '2024-07-01', '2024-12-31', 15000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Optimización de Procesos', 'Optimización de procesos internos', '2024-08-01', '2024-12-31', 20000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Investigación Social', 'Estudios sociales y encuestas', '2024-09-01', '2024-12-31', 12000.00);
INSERT INTO ContratosServicio (nombre, descripcion, fecha_inicio, fecha_fin, monto) VALUES ('Contrato de Energía Renovable', 'Instalación de paneles solares', '2024-10-01', '2024-12-31', 45000.00);

-- Select
SELECT * FROM ContratosServicio;

SELECT nombre, monto FROM ContratosServicio;

SELECT * FROM ContratosServicio WHERE monto > 20000.00;

SELECT * FROM ContratosServicio WHERE fecha_inicio LIKE '2024%';

SELECT nombre, descripcion FROM ContratosServicio WHERE fecha_fin LIKE '2024%';

-- Update
UPDATE ContratosServicio SET monto = 1300.00 WHERE nombre = 'Contrato de Limpieza' AND fecha_inicio = '2024-01-01';

UPDATE ContratosServicio SET descripcion = 'Servicio de mantenimiento anual' WHERE nombre = 'Contrato de Mantenimiento' AND fecha_inicio = '2024-02-01';

UPDATE ContratosServicio SET fecha_fin = '2024-12-01' WHERE nombre = 'Contrato de Seguridad' AND fecha_inicio = '2024-03-01';

UPDATE ContratosServicio SET monto = 21000.00 WHERE nombre = 'Contrato de Publicidad';

UPDATE ContratosServicio SET descripcion = 'Limpieza mensual de oficinas' WHERE nombre LIKE 'Contrato de Limpieza%';

-- Delete
DELETE FROM ContratosServicio WHERE nombre = 'Contrato de Jardinería' AND fecha_inicio = '2024-04-01';

DELETE FROM ContratosServicio WHERE monto < 5000.00;

DELETE FROM ContratosServicio WHERE fecha_inicio LIKE '2023%';

DELETE FROM ContratosServicio WHERE descripcion = 'Servicio de soporte técnico';

DELETE FROM ContratosServicio WHERE nombre = 'Contrato de Seguridad';

-- Drop
DROP TABLE ContratosServicio;



-- Table: ProveedoresServicio
-- Insert
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Limpiezas Rápidas', 'Maria Lopez', '321321321', 'Calle Verde 789');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Seguridad Total', 'Carlos Pérez', '123123123', 'Avenida Central 123');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Jardines Hermosos', 'Laura Martínez', '456456456', 'Calle Jardín 456');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('IT Solutions', 'José García', '789789789', 'Avenida Tech 101');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Consultoría Financiera', 'Ana Torres', '654654654', 'Calle Oro 202');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Publicidad Creativa', 'David Rodríguez', '987987987', 'Avenida Publicidad 303');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Transportes Seguros', 'Marta Díaz', '321654987', 'Calle Transporte 404');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Eventos Magníficos', 'Juan González', '789123456', 'Avenida Eventos 505');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Catering Delicioso', 'Laura Fernández', '654321789', 'Calle Sabor 606');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Auditorías Precisas', 'Luis Martínez', '123789456', 'Avenida Auditoría 707');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Capacitaciones Efectivas', 'Elena Ramos', '987321654', 'Calle Aprendizaje 808');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Asesoría Legal', 'Mario Sánchez', '456789123', 'Avenida Justicia 909');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Diseño Gráfico', 'Cristina Morales', '321987654', 'Calle Arte 1010');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Marketing Digital', 'Sergio Herrera', '654987321', 'Avenida Digital 111');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Limpieza Industrial', 'Isabel Torres', '987654123', 'Calle Limpieza 1212');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Recursos Humanos', 'Luis López', '123456789', 'Avenida Empleo 1313');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Seguros Integrales', 'Carlos Gutiérrez', '321654321', 'Calle Seguros 1414');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Logística Global', 'Ana Muñoz', '789456123', 'Avenida Logística 1515');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Telecomunicaciones Avanzadas', 'David Castillo', '654321123', 'Calle Telecom 1616');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Investigación de Mercado', 'Laura Gutiérrez', '123654789', 'Avenida Mercado 1717');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Fotografía Profesional', 'José Ramos', '987123321', 'Calle Foto 1818');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Producción de Video', 'María Herrera', '456321789', 'Avenida Video 1919');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Traducciones Técnicas', 'Marta Fernández', '321789654', 'Calle Traducción 2020');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Arquitectura Moderna', 'Elena Martínez', '654123987', 'Avenida Arquitectura 2121');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Construcción Sólida', 'Juan Pérez', '987456321', 'Calle Construcción 2222');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Ingeniería Avanzada', 'Luis Morales', '123987456', 'Avenida Ingeniería 2323');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Estrategias de Ventas', 'Carlos Díaz', '321456987', 'Calle Ventas 2424');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Consultoría IT', 'Ana Rodríguez', '654789123', 'Avenida IT 2525');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Mantenimiento de Equipos', 'David Gómez', '987123654', 'Calle Equipos 2626');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Capacitación Técnica', 'María García', '456987123', 'Avenida Técnica 2727');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Investigación y Desarrollo', 'José Martínez', '321123654', 'Calle I+D 2828');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Bienestar Laboral', 'Laura Sánchez', '654321789', 'Avenida Bienestar 2929');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Consultoría Ambiental', 'Marta Herrera', '987654987', 'Calle Verde 3030');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Auditoría Interna', 'Luis Rodríguez', '123654321', 'Avenida Auditoría 3131');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Redacción Profesional', 'Ana López', '321987123', 'Calle Redacción 3232');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Mantenimiento Eléctrico', 'David Fernández', '654123654', 'Avenida Eléctrica 3333');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Servicios Médicos', 'María Ramos', '987321987', 'Calle Salud 3434');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Limpieza Especializada', 'Carlos Torres', '123789321', 'Avenida Limpieza 3535');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Desarrollo de Software', 'Laura Morales', '321654987', 'Calle Software 3636');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('SEO Avanzado', 'Luis García', '654987654', 'Avenida SEO 3737');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Investigación Clínica', 'José Sánchez', '987456987', 'Calle Clínica 3838');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Protección de Datos', 'María Díaz', '123456321', 'Avenida Datos 3939');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Monitoreo de Redes', 'Ana Torres', '321321987', 'Calle Redes 4040');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Evaluación de Desempeño', 'Luis Herrera', '654654321', 'Avenida Desempeño 4141');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Análisis de Datos', 'Laura Pérez', '987987654', 'Calle Datos 4242');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Optimización de Procesos', 'José Díaz', '123123987', 'Avenida Procesos 4343');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Investigación Social', 'Marta García', '321654654', 'Calle Social 4444');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Energía Renovable', 'David Ramos', '654987321', 'Avenida Energía 4545');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Reparaciones Rápidas', 'María Pérez', '987123123', 'Calle Reparaciones 4646');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Limpiezas Profundas', 'José Torres', '123456654', 'Avenida Limpieza 4747');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Seguridad Avanzada', 'Ana Morales', '321987321', 'Calle Seguridad 4848');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Jardinería Profesional', 'Luis Herrera', '654321654', 'Avenida Jardines 4949');
INSERT INTO ProveedoresServicio (nombre, contacto, telefono, direccion) VALUES ('Consultoría Empresarial', 'Laura López', '987654321', 'Calle Empresa 5050');

-- Select
SELECT * FROM ProveedoresServicio;

SELECT nombre, contacto FROM ProveedoresServicio;

SELECT * FROM ProveedoresServicio WHERE telefono LIKE '123%';

SELECT * FROM ProveedoresServicio WHERE direccion = 'Calle Verde 789';

SELECT nombre, telefono FROM ProveedoresServicio WHERE contacto = 'Laura Morales';

-- Update
UPDATE ProveedoresServicio SET telefono = '111222333' WHERE nombre = 'Limpiezas Rápidas';

UPDATE ProveedoresServicio SET direccion = 'Calle Nueva 123' WHERE nombre = 'Seguridad Total';

UPDATE ProveedoresServicio SET contacto = 'Carlos Gómez' WHERE nombre = 'Jardines Hermosos';

UPDATE ProveedoresServicio SET telefono = '444555666' WHERE nombre LIKE '%IT%';

UPDATE ProveedoresServicio SET direccion = 'Avenida Actualizada 456' WHERE contacto = 'Ana Torres';

-- Delete
DELETE FROM ProveedoresServicio WHERE nombre = 'Consultoría Financiera';

DELETE FROM ProveedoresServicio WHERE telefono LIKE '987%';

DELETE FROM ProveedoresServicio WHERE direccion = 'Calle Sabor 606';

DELETE FROM ProveedoresServicio WHERE contacto = 'Elena Ramos';

DELETE FROM ProveedoresServicio WHERE nombre LIKE '%Marketing%';

-- Drop
DROP TABLE ProveedoresServicio;


-- Table: IncidentesMantenimiento
-- Insert
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (2, 'Error en el sistema eléctrico', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (3, 'Fuga de gas en el compresor', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (4, 'Rotura de la correa de transmisión', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (5, 'Pérdida de presión en la línea hidráulica', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (6, 'Error en el software de control', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (7, 'Desgaste excesivo de los rodamientos', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (8, 'Obstrucción en el sistema de ventilación', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (9, 'Falla en el motor principal', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (10, 'Sobrecalentamiento del equipo', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (11, 'Fallo en el sistema de seguridad', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (12, 'Problema de calibración en los sensores', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (13, 'Error en la comunicación con el PLC', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (14, 'Filtración de líquido refrigerante', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (15, 'Desajuste en las válvulas de control', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (16, 'Fallo en el sistema neumático', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (17, 'Pérdida de conexión con el sistema SCADA', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (18, 'Error en el circuito de refrigeración', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (19, 'Mal funcionamiento del actuador', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (20, 'Daño en el sistema de control de temperatura', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (21, 'Atasco en el sistema de alimentación', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (22, 'Error en el sistema de lubricación', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (23, 'Fallo en el circuito hidráulico', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (24, 'Rotura de la cadena de transmisión', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (25, 'Desbalanceo en el rotor principal', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (26, 'Fallo en el sistema de detección de humo', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (27, 'Error en el sistema de frenado', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (28, 'Desgaste en los engranajes principales', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (29, 'Fuga en el sistema de combustible', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (30, 'Error en el sistema de iluminación', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (31, 'Pérdida de potencia en el motor', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (32, 'Error en el sistema de carga', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (33, 'Falla en el sistema de detección de gas', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (34, 'Pérdida de presión en el sistema hidráulico', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (35, 'Error en el sistema de alarma', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (36, 'Desgaste prematuro en las correas', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (37, 'Fuga de aceite en el motor', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (38, 'Error en el sistema de purificación de agua', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (39, 'Problema de calibración en los medidores', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (40, 'Fallo en el sistema de descarga', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (41, 'Error en el sistema de transmisión de datos', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (42, 'Rotura en el sistema de tuberías', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (43, 'Error en el sistema de encendido', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (44, 'Falla en el sistema de elevación', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (45, 'Desgaste en las cuchillas principales', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (46, 'Fuga en el sistema de refrigeración', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (47, 'Error en el sistema de apagado', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (48, 'Mal funcionamiento del convertidor', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (49, 'Fallo en el sistema de control de acceso', CURRENT_TIMESTAMP);
INSERT INTO IncidentesMantenimiento (id_equipo, descripcion, fecha) VALUES (50, 'Error en el sistema de emergencia', CURRENT_TIMESTAMP);

-- Select
SELECT * FROM IncidentesMantenimiento;

SELECT * FROM IncidentesMantenimiento WHERE DATE(fecha) = CURRENT_DATE;

SELECT * FROM IncidentesMantenimiento WHERE descripcion LIKE '%Falla%';

SELECT * FROM IncidentesMantenimiento WHERE id_equipo = 3;

SELECT descripcion, fecha FROM IncidentesMantenimiento WHERE fecha >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- Update
UPDATE IncidentesMantenimiento SET descripcion = 'Error en el sistema de lubricación' WHERE id_equipo = 2;

UPDATE IncidentesMantenimiento SET fecha = '2024-05-25 10:00:00' WHERE id_equipo = 3;

UPDATE IncidentesMantenimiento SET descripcion = 'Error en el sistema de control de temperatura' WHERE descripcion LIKE '%Error%';

UPDATE IncidentesMantenimiento SET fecha = '2024-05-26 12:00:00' WHERE DATE(fecha) = CURRENT_DATE;

UPDATE IncidentesMantenimiento SET descripcion = 'Rotura de la correa de transmisión principal' WHERE id_equipo = 4;

-- Delete
DELETE FROM IncidentesMantenimiento WHERE id_equipo = 5 AND descripcion = 'Pérdida de presión en la línea hidráulica';

DELETE FROM IncidentesMantenimiento WHERE DATE(fecha) = CURRENT_DATE;

DELETE FROM IncidentesMantenimiento WHERE descripcion LIKE '%Fallo%';

DELETE FROM IncidentesMantenimiento WHERE id_equipo = 6;

DELETE FROM IncidentesMantenimiento WHERE fecha >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);

-- Drop
DROP TABLE IncidentesMantenimiento;


-- Table: Tiendas
-- Insert
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Norte', 'Calle Norte 456', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Sur', 'Calle Sur 789', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Este', 'Calle Este 101', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Oeste', 'Calle Oeste 111', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Centro', 'Calle Centro 222', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Plaza', 'Av. Plaza 333', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Boulevard', 'Av. Boulevard 444', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Mall', 'Av. Mall 555', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Parque', 'Av. Parque 666', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Jardín', 'Calle Jardín 777', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Playa', 'Av. Playa 888', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Campo', 'Calle Campo 999', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Avenida', 'Av. Avenida 1010', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Calle', 'Calle Calle 1111', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Carretera', 'Av. Carretera 1212', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Camino', 'Calle Camino 1313', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Sendero', 'Av. Sendero 1414', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Paseo', 'Calle Paseo 1515', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Rambla', 'Av. Rambla 1616', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Pasaje', 'Calle Pasaje 1717', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Alameda', 'Av. Alameda 1818', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Plaza Mayor', 'Plaza Mayor 1919', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Avenida Principal', 'Av. Principal 2020', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Calle Principal', 'Calle Principal 2121', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Centro Comercial', 'C.C. Principal 2222', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Zona Comercial', 'Zona Comercial 2323', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Centro Urbano', 'C.U. Principal 2424', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Comercial', 'Ciudad Comercial 2525', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Centro', 'Ciudad Centro 2626', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Plaza', 'Ciudad Plaza 2727', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Paseo', 'Ciudad Paseo 2828', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Rambla', 'Ciudad Rambla 2929', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Boulevard', 'Ciudad Boulevard 3030', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Sendero', 'Ciudad Sendero 3131', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Paseo', 'Ciudad Paseo 3232', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Plaza', 'Ciudad Plaza 3333', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Avenida', 'Ciudad Avenida 3434', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Calle', 'Ciudad Calle 3535', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Carretera', 'Ciudad Carretera 3636', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Camino', 'Ciudad Camino 3737', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Sendero', 'Ciudad Sendero 3838', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Paseo', 'Ciudad Paseo 3939', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Rambla', 'Ciudad Rambla 4040', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Pasaje', 'Ciudad Pasaje 4141', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Alameda', 'Ciudad Alameda 4242', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Plaza Mayor', 'Ciudad Plaza Mayor 4343', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Avenida Principal', 'Ciudad Avenida Principal 4444', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Calle Principal', 'Ciudad Calle Principal 4545', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Centro Comercial', 'Ciudad C.C. Principal 4646', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Zona Comercial', 'Ciudad Zona Comercial 4747', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Centro Urbano', 'Ciudad C.U. Principal 4848', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Ciudad Comercial', 'Ciudad Ciudad Comercial 4949', 'Lima', 'Perú');
INSERT INTO Tiendas (nombre, direccion, ciudad, pais) VALUES ('Tienda Ciudad Ciudad Centro', 'Ciudad Ciudad Centro 5050', 'Lima', 'Perú');

-- Select
SELECT * FROM Tiendas;

SELECT * FROM Tiendas WHERE ciudad = 'Lima';

SELECT * FROM Tiendas WHERE pais = 'Perú';

SELECT * FROM Tiendas WHERE direccion LIKE '%Av.%';

SELECT nombre, direccion FROM Tiendas LIMIT 5;

-- Update
UPDATE Tiendas SET direccion = 'Av. Renovada 321' WHERE nombre = 'Tienda Norte';

UPDATE Tiendas SET ciudad = 'Arequipa' WHERE nombre = 'Tienda Sur';

UPDATE Tiendas SET pais = 'Argentina' WHERE nombre = 'Tienda Este';

UPDATE Tiendas SET direccion = 'Av. Nueva 456' WHERE ciudad = 'Lima';

UPDATE Tiendas SET ciudad = 'Cusco' WHERE direccion LIKE '%Calle%';

-- Delete
DELETE FROM Tiendas WHERE nombre = 'Tienda Plaza';

DELETE FROM Tiendas WHERE ciudad = 'Lima';

DELETE FROM Tiendas WHERE pais = 'Perú';

DELETE FROM Tiendas WHERE direccion LIKE '%C.C.%';

DELETE FROM Tiendas;

-- Drop
DROP TABLE Tiendas;


-- Table: Ubicaciones
-- Insert
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (2, 'Pasillo 2');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (3, 'Pasillo 3');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (4, 'Pasillo 4');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (5, 'Pasillo 5');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (6, 'Pasillo 6');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (7, 'Pasillo 7');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (8, 'Pasillo 8');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (9, 'Pasillo 9');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (10, 'Pasillo 10');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (11, 'Pasillo 11');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (12, 'Pasillo 12');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (13, 'Pasillo 13');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (14, 'Pasillo 14');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (15, 'Pasillo 15');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (16, 'Pasillo 16');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (17, 'Pasillo 17');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (18, 'Pasillo 18');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (19, 'Pasillo 19');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (20, 'Pasillo 20');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (21, 'Pasillo 21');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (22, 'Pasillo 22');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (23, 'Pasillo 23');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (24, 'Pasillo 24');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (25, 'Pasillo 25');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (26, 'Pasillo 26');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (27, 'Pasillo 27');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (28, 'Pasillo 28');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (29, 'Pasillo 29');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (30, 'Pasillo 30');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (31, 'Pasillo 31');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (32, 'Pasillo 32');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (33, 'Pasillo 33');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (34, 'Pasillo 34');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (35, 'Pasillo 35');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (36, 'Pasillo 36');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (37, 'Pasillo 37');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (38, 'Pasillo 38');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (39, 'Pasillo 39');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (40, 'Pasillo 40');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (41, 'Pasillo 41');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (42, 'Pasillo 42');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (43, 'Pasillo 43');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (44, 'Pasillo 44');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (45, 'Pasillo 45');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (46, 'Pasillo 46');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (47, 'Pasillo 47');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (48, 'Pasillo 48');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (49, 'Pasillo 49');
INSERT INTO Ubicaciones (id_tienda, descripcion) VALUES (50, 'Pasillo 50');

-- Select
SELECT * FROM Ubicaciones;

SELECT * FROM Ubicaciones WHERE id_tienda = 1;

SELECT * FROM Ubicaciones LIMIT 10;

SELECT * FROM Ubicaciones WHERE descripcion LIKE '%Pasillo%';

SELECT descripcion FROM Ubicaciones WHERE id_tienda BETWEEN 2 AND 5;

-- Update
UPDATE Ubicaciones SET descripcion = 'Pasillo Principal' WHERE id_tienda = 2;

UPDATE Ubicaciones SET descripcion = 'Sector de Ventas' WHERE id_tienda = 3;

UPDATE Ubicaciones SET descripcion = 'Pasillo de Ofertas' WHERE descripcion LIKE '%Pasillo%';

UPDATE Ubicaciones SET descripcion = 'Pasillo Principal' WHERE id <= 10;

UPDATE Ubicaciones SET descripcion = 'Pasillo de Accesorios' WHERE id_tienda BETWEEN 6 AND 10;

-- Delete
DELETE FROM Ubicaciones WHERE id = 1;

DELETE FROM Ubicaciones WHERE id_tienda = 2;

DELETE FROM Ubicaciones WHERE descripcion LIKE '%Pasillo%';

DELETE FROM Ubicaciones WHERE id <= 10;

DELETE FROM Ubicaciones;

-- Drop
DROP TABLE Ubicaciones;


-- Table: ConfiguracionGeneral
-- Insert
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('LimiteStock', '100');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('MonedaPredeterminada', 'USD');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoEnvio', '5.00');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoMaximo', '20');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoSesion', '30');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaCambioDolar', '3.75');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('PorcentajeGanancia', '25');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('PlazoPago', '15');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoMinimoEnvio', '3.00');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('PorcentajeComision', '5');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoPrimerCompra', '10');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CantidadMaximaProductos', '50');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoExpiracionToken', '3600');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoSeguro', '2.50');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoClienteVIP', '15');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresMora', '0.03');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('LimiteProductosCarrito', '10');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoEsperaRespuesta', '10');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoMantenimiento', '1000');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoTemporada', '10');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaCambioEuro', '4.20');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('PorcentajeGananciaVIP', '30');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('PlazoPagoFactura', '30');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoInstalacion', '50');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('PorcentajeComisionVIP', '3');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoCumpleaños', '5');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresCredito', '0.02');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('LimiteTiempoCompra', '600');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoMensajeria', '7.50');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoEstudiante', '15');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresFinanciamiento', '0.05');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoEntregaEstimado', '5');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoImpresion', '1.50');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoMayorista', '20');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresHipoteca', '0.04');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoGarantia', '365');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoReciclaje', '3.00');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoAfiliado', '10');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresPrestamo', '0.07');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoEnvioCorreo', '2');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoEnvioInternacional', '10.00');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoVeterano', '12');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresInversion', '0.08');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TiempoEsperaRespuestaSolicitud', '15');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('CostoAlmacenamiento', '2.00');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('DescuentoFidelidad', '8');
INSERT INTO ConfiguracionGeneral (clave, valor) VALUES ('TasaInteresDeposito', '0.03');

-- Select
SELECT * FROM ConfiguracionGeneral;

SELECT valor FROM ConfiguracionGeneral WHERE clave = 'TasaIVA';

SELECT * FROM ConfiguracionGeneral WHERE valor > 10;

SELECT * FROM ConfiguracionGeneral LIMIT 10;

SELECT clave, valor FROM ConfiguracionGeneral WHERE clave LIKE '%Descuento%';

-- Update

UPDATE ConfiguracionGeneral SET valor = '20' WHERE clave = 'TasaIVA';

UPDATE ConfiguracionGeneral SET valor = '5' WHERE valor < 5;

UPDATE ConfiguracionGeneral SET valor = '15' WHERE clave LIKE '%Tiempo%';

UPDATE ConfiguracionGeneral SET valor = '1' LIMIT 10;

UPDATE ConfiguracionGeneral SET valor = '2.50' WHERE clave LIKE '%Costo%';


-- Delete

DELETE FROM ConfiguracionGeneral WHERE clave = 'TasaCambioDolar';

DELETE FROM ConfiguracionGeneral WHERE valor = '10';

DELETE FROM ConfiguracionGeneral WHERE clave LIKE '%Plazo%';

DELETE FROM ConfiguracionGeneral LIMIT 10;

DELETE FROM ConfiguracionGeneral;


-- Drop
DROP TABLE ConfiguracionGeneral;



-- Table: Paises
-- Insert
INSERT INTO Paises (nombre) VALUES ('Argentina');
INSERT INTO Paises (nombre) VALUES ('Brasil');
INSERT INTO Paises (nombre) VALUES ('Chile');
INSERT INTO Paises (nombre) VALUES ('Colombia');
INSERT INTO Paises (nombre) VALUES ('Ecuador');
INSERT INTO Paises (nombre) VALUES ('Venezuela');
INSERT INTO Paises (nombre) VALUES ('Bolivia');
INSERT INTO Paises (nombre) VALUES ('Paraguay');
INSERT INTO Paises (nombre) VALUES ('Uruguay');
INSERT INTO Paises (nombre) VALUES ('Guyana');
INSERT INTO Paises (nombre) VALUES ('Surinam');
INSERT INTO Paises (nombre) VALUES ('Guyana Francesa');
INSERT INTO Paises (nombre) VALUES ('Perú');
INSERT INTO Paises (nombre) VALUES ('México');
INSERT INTO Paises (nombre) VALUES ('Estados Unidos');
INSERT INTO Paises (nombre) VALUES ('Canadá');
INSERT INTO Paises (nombre) VALUES ('Cuba');
INSERT INTO Paises (nombre) VALUES ('República Dominicana');
INSERT INTO Paises (nombre) VALUES ('Haití');
INSERT INTO Paises (nombre) VALUES ('Jamaica');
INSERT INTO Paises (nombre) VALUES ('Puerto Rico');
INSERT INTO Paises (nombre) VALUES ('Barbados');
INSERT INTO Paises (nombre) VALUES ('Bahamas');
INSERT INTO Paises (nombre) VALUES ('Belice');
INSERT INTO Paises (nombre) VALUES ('Costa Rica');
INSERT INTO Paises (nombre) VALUES ('El Salvador');
INSERT INTO Paises (nombre) VALUES ('Guatemala');
INSERT INTO Paises (nombre) VALUES ('Honduras');
INSERT INTO Paises (nombre) VALUES ('Nicaragua');
INSERT INTO Paises (nombre) VALUES ('Panamá');
INSERT INTO Paises (nombre) VALUES ('Argentina');
INSERT INTO Paises (nombre) VALUES ('Brasil');
INSERT INTO Paises (nombre) VALUES ('Chile');
INSERT INTO Paises (nombre) VALUES ('Colombia');
INSERT INTO Paises (nombre) VALUES ('Ecuador');
INSERT INTO Paises (nombre) VALUES ('Venezuela');
INSERT INTO Paises (nombre) VALUES ('Bolivia');
INSERT INTO Paises (nombre) VALUES ('Paraguay');
INSERT INTO Paises (nombre) VALUES ('Uruguay');
INSERT INTO Paises (nombre) VALUES ('Guyana');
INSERT INTO Paises (nombre) VALUES ('Surinam');
INSERT INTO Paises (nombre) VALUES ('Guyana Francesa');
INSERT INTO Paises (nombre) VALUES ('Perú');
INSERT INTO Paises (nombre) VALUES ('México');
INSERT INTO Paises (nombre) VALUES ('Estados Unidos');

-- Select
SELECT * FROM Paises;

SELECT * FROM Paises WHERE nombre = 'Perú';

SELECT * FROM Paises WHERE nombre LIKE 'E%';

SELECT * FROM Paises LIMIT 10;

SELECT * FROM Paises ORDER BY nombre DESC;

-- Update
UPDATE Paises SET nombre = 'Republica del Perú' WHERE nombre = 'Perú';

UPDATE Paises SET nombre = 'New ' || nombre WHERE nombre LIKE 'E%';

UPDATE Paises SET nombre = 'País ' || nombre LIMIT 5;

UPDATE Paises SET nombre = 'Unknown';

UPDATE Paises SET nombre = 'Z' || nombre ORDER BY nombre DESC;

-- Delete
DELETE FROM Paises WHERE nombre = 'Perú';

DELETE FROM Paises WHERE nombre LIKE 'E%';

DELETE FROM Paises LIMIT 5;

DELETE FROM Paises;

DELETE FROM Paises WHERE nombre <> 'Argentina';

-- Drop
DROP TABLE Paises;


-- Table: Regiones
-- Insert
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Lima');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Cusco');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Arequipa');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Piura');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'La Libertad');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Lambayeque');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Junín');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Puno');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Ancash');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Tacna');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Ica');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Madre de Dios');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Ucayali');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'San Martín');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Ayacucho');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Amazonas');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Huancavelica');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Pasco');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Moquegua');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Tumbes');
INSERT INTO Regiones (id_pais, nombre) VALUES (1, 'Huánuco');

-- Select
SELECT * FROM Regiones WHERE id_pais = 1;

SELECT * FROM Regiones WHERE id_pais = 1 AND nombre = 'Lima';

SELECT * FROM Regiones WHERE id_pais = 1 AND nombre LIKE 'A%';

SELECT * FROM Regiones WHERE id_pais = 1 LIMIT 5;

SELECT * FROM Regiones WHERE id_pais = 1 ORDER BY nombre DESC;

-- Update
UPDATE Regiones SET nombre = 'Región Lima' WHERE id_pais = 1 AND nombre = 'Lima';

UPDATE Regiones SET nombre = 'Nueva ' || nombre WHERE id_pais = 1 AND nombre LIKE 'A%';

UPDATE Regiones SET nombre = 'Región ' || nombre WHERE id_pais = 1 LIMIT 3;

UPDATE Regiones SET nombre = 'Desconocido' WHERE id_pais = 1;

UPDATE Regiones SET nombre = 'Z' || nombre WHERE id_pais = 1 ORDER BY nombre DESC;

-- Delete
DELETE FROM Regiones WHERE id_pais = 1 AND nombre = 'Lima';

DELETE FROM Regiones WHERE id_pais = 1 AND nombre LIKE 'A%';

DELETE FROM Regiones WHERE id_pais = 1 LIMIT 3;

DELETE FROM Regiones WHERE id_pais = 1;

DELETE FROM Regiones WHERE id_pais = 1 AND nombre <> 'Cusco';

-- Drop
DROP TABLE Regiones;



-- Table: TiposDocumento
-- Insert
INSERT INTO TiposDocumento (descripcion) VALUES ('DNI');
-- Select
SELECT * FROM TiposDocumento;

SELECT * FROM TiposDocumento WHERE descripcion = 'DNI';

SELECT * FROM TiposDocumento WHERE descripcion LIKE 'D%';

SELECT * FROM TiposDocumento LIMIT 5;

SELECT * FROM TiposDocumento ORDER BY descripcion DESC;

-- Update
UPDATE TiposDocumento SET descripcion = 'Documento Nacional de Identidad' WHERE id = 1;

UPDATE TiposDocumento SET descripcion = 'New ' || descripcion WHERE descripcion LIKE 'D%';

UPDATE TiposDocumento SET descripcion = 'Doc ' || descripcion LIMIT 3;

UPDATE TiposDocumento SET descripcion = 'Desconocido';

UPDATE TiposDocumento SET descripcion = 'Z' || descripcion ORDER BY descripcion DESC;

-- Delete
DELETE FROM TiposDocumento WHERE descripcion = 'DNI';

DELETE FROM TiposDocumento WHERE descripcion LIKE 'D%';

DELETE FROM TiposDocumento LIMIT 3;

DELETE FROM TiposDocumento;

DELETE FROM TiposDocumento WHERE id <> 1;

-- Drop
DROP TABLE TiposDocumento;


-- Table: Monedas
-- Insert
INSERT INTO Monedas (nombre, simbolo) VALUES ('Nuevo Sol', 'S/');
-- Select
SELECT * FROM Monedas;

SELECT * FROM Monedas WHERE nombre = 'Nuevo Sol';

SELECT * FROM Monedas WHERE nombre LIKE 'N%';

SELECT * FROM Monedas WHERE simbolo = 'S/';

SELECT * FROM Monedas LIMIT 5;

-- Update
UPDATE Monedas SET simbolo = 'SOL' WHERE nombre = 'Nuevo Sol';

UPDATE Monedas SET nombre = 'New ' || nombre WHERE nombre LIKE 'N%';

UPDATE Monedas SET simbolo = 'N' || simbolo LIMIT 3;

UPDATE Monedas SET nombre = 'Desconocida';

UPDATE Monedas SET nombre = 'Z' || nombre ORDER BY nombre DESC;

-- Delete
DELETE FROM Monedas WHERE nombre = 'Nuevo Sol';

DELETE FROM Monedas WHERE nombre LIKE 'N%';

DELETE FROM Monedas LIMIT 3;

DELETE FROM Monedas;

DELETE FROM Monedas WHERE nombre <> 'Dólar';

-- Drop
DROP TABLE Monedas;


-- creacion de schemas

-- Crear esquemas para las áreas funcionales

CREATE SCHEMA Administracion;
go
CREATE SCHEMA Ventas;
go
CREATE SCHEMA Clientes;
go
CREATE SCHEMA Inventarios;
go
CREATE SCHEMA Compras;
go
CREATE SCHEMA Proveedores;
go
CREATE SCHEMA Finanzas;
go
CREATE SCHEMA Contabilidad;
go
CREATE SCHEMA RecursosHumanos;
go
CREATE SCHEMA Logistica;
go
CREATE SCHEMA Distribucion;
go
CREATE SCHEMA Marketing;
go
CREATE SCHEMA RelacionesPublicas;
go
CREATE SCHEMA Seguridad;
go
-- Asignar propietarios de esquemas si es necesario
ALTER AUTHORIZATION ON SCHEMA::Administracion TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Ventas TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Clientes TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Inventarios TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Compras TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Proveedores TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Finanzas TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Contabilidad TO dbo;
ALTER AUTHORIZATION ON SCHEMA::RecursosHumanos TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Logistica TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Distribucion TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Marketing TO dbo;
ALTER AUTHORIZATION ON SCHEMA::RelacionesPublicas TO dbo;
ALTER AUTHORIZATION ON SCHEMA::Seguridad TO dbo;


-- transferencia 

-- 1. Administración
ALTER SCHEMA Administracion TRANSFER CuentasPorCobrar;
ALTER SCHEMA Administracion TRANSFER CuentasPorPagar;
ALTER SCHEMA Administracion TRANSFER Presupuestos;
ALTER SCHEMA Administracion TRANSFER AuditoriasInternas;

-- 2. Ventas
ALTER SCHEMA Ventas TRANSFER Clientes;
ALTER SCHEMA Ventas TRANSFER MetodosPago;
ALTER SCHEMA Ventas TRANSFER Ventas;
ALTER SCHEMA Ventas TRANSFER DetallesVenta;
ALTER SCHEMA Ventas TRANSFER DevolucionesClientes;
ALTER SCHEMA Ventas TRANSFER CuponesDescuentos;
ALTER SCHEMA Ventas TRANSFER ProgramasFidelizacion;
ALTER SCHEMA Ventas TRANSFER HistorialCupones;
ALTER SCHEMA Ventas TRANSFER EncuestasSatisfaccion;

-- 3. Clientes
ALTER SCHEMA Clientes TRANSFER Clientes;

-- 4. Inventarios
ALTER SCHEMA Inventarios TRANSFER InventarioGeneral;
ALTER SCHEMA Inventarios TRANSFER Almacenes;
ALTER SCHEMA Inventarios TRANSFER SeccionesAlmacen;
ALTER SCHEMA Inventarios TRANSFER MovimientosInventario;
ALTER SCHEMA Inventarios TRANSFER RequisicionesInventario;
ALTER SCHEMA Inventarios TRANSFER OrdenesCompra;
ALTER SCHEMA Inventarios TRANSFER DetallesOrdenCompra;
ALTER SCHEMA Inventarios TRANSFER RecepcionProductos;

-- 5. Compras
ALTER SCHEMA Compras TRANSFER OrdenesCompra;
ALTER SCHEMA Compras TRANSFER DetallesOrdenCompra;
ALTER SCHEMA Compras TRANSFER RecepcionProductos;

-- 6. Proveedores
ALTER SCHEMA Proveedores TRANSFER Proveedores;

-- 7. Finanzas
ALTER SCHEMA Finanzas TRANSFER CuentasPorCobrar;
ALTER SCHEMA Finanzas TRANSFER CuentasPorPagar;
ALTER SCHEMA Finanzas TRANSFER RequisicionesInventario;
ALTER SCHEMA Finanzas TRANSFER OrdenesCompra;
ALTER SCHEMA Finanzas TRANSFER TransaccionesFinancieras;
ALTER SCHEMA Finanzas TRANSFER BalanceGeneral;
ALTER SCHEMA Finanzas TRANSFER EstadoResultados;
ALTER SCHEMA Finanzas TRANSFER Impuestos;
ALTER SCHEMA Finanzas TRANSFER Presupuestos;
ALTER SCHEMA Finanzas TRANSFER AuditoriasInternas;

-- 8. Contabilidad
ALTER SCHEMA Contabilidad TRANSFER CuentasPorCobrar;
ALTER SCHEMA Contabilidad TRANSFER CuentasPorPagar;
ALTER SCHEMA Contabilidad TRANSFER TransaccionesFinancieras;
ALTER SCHEMA Contabilidad TRANSFER BalanceGeneral;
ALTER SCHEMA Contabilidad TRANSFER EstadoResultados;
ALTER SCHEMA Contabilidad TRANSFER Impuestos;
ALTER SCHEMA Contabilidad TRANSFER Presupuestos;
ALTER SCHEMA Contabilidad TRANSFER AuditoriasInternas;

-- 9. Recursos Humanos
ALTER SCHEMA RecursosHumanos TRANSFER Empleados;
ALTER SCHEMA RecursosHumanos TRANSFER Departamentos;
ALTER SCHEMA RecursosHumanos TRANSFER PuestosTrabajo;
ALTER SCHEMA RecursosHumanos TRANSFER HorariosTrabajo;
ALTER SCHEMA RecursosHumanos TRANSFER Asistencias;
ALTER SCHEMA RecursosHumanos TRANSFER PermisosLicencias;
ALTER SCHEMA RecursosHumanos TRANSFER Capacitaciones;
ALTER SCHEMA RecursosHumanos TRANSFER EvaluacionesDesempeno;
ALTER SCHEMA RecursosHumanos TRANSFER Nominas;

-- 10. Logística
ALTER SCHEMA Logistica TRANSFER FlotasTransporte;
ALTER SCHEMA Logistica TRANSFER RutasDistribucion;
ALTER SCHEMA Logistica TRANSFER Despachos;
ALTER SCHEMA Logistica TRANSFER OrdenesTransferencia;
ALTER SCHEMA Logistica TRANSFER DetallesTransferencia;

-- 11. Distribución
ALTER SCHEMA Distribucion TRANSFER FlotasTransporte;
ALTER SCHEMA Distribucion TRANSFER RutasDistribucion;
ALTER SCHEMA Distribucion TRANSFER Despachos;
ALTER SCHEMA Distribucion TRANSFER OrdenesTransferencia;
ALTER SCHEMA Distribucion TRANSFER DetallesTransferencia;

-- 12. Marketing
ALTER SCHEMA Marketing TRANSFER CampanasMarketing;
ALTER SCHEMA Marketing TRANSFER MediosPublicidad;
ALTER SCHEMA Marketing TRANSFER AnalisisMercado;
ALTER SCHEMA Marketing TRANSFER Patrocinios;

-- 13. Relaciones Públicas
ALTER SCHEMA RelacionesPublicas TRANSFER CampanasMarketing;
ALTER SCHEMA RelacionesPublicas TRANSFER Eventos;

-- 14. Seguridad
ALTER SCHEMA Seguridad TRANSFER AccesosUsuario;
ALTER SCHEMA Seguridad TRANSFER RolesPermisos;
ALTER SCHEMA Seguridad TRANSFER Permisos;
ALTER SCHEMA Seguridad TRANSFER RolesUsuarios;
ALTER SCHEMA Seguridad TRANSFER PermisosRoles;
ALTER SCHEMA Seguridad TRANSFER LogsActividades;
ALTER SCHEMA Seguridad TRANSFER IncidentesSeguridad;
ALTER SCHEMA Seguridad TRANSFER ControlPerdidas;



-- Creacion de usuarios

-- Crear logins y usuarios para cada rol

-- 1. Administrador de Base de Datos
CREATE LOGIN admin_db WITH PASSWORD = 'contrasenasegura';
CREATE USER admin_db FOR LOGIN admin_db;

-- 2. Gerente General
CREATE LOGIN gerente_general WITH PASSWORD = 'contrasenasegura';
CREATE USER gerente_general FOR LOGIN gerente_general;

-- 3. Gerente de Ventas
CREATE LOGIN gerente_ventas WITH PASSWORD = 'contrasenasegura';
CREATE USER gerente_ventas FOR LOGIN gerente_ventas;

-- 4. Encargado de Inventarios
CREATE LOGIN encargado_inventarios WITH PASSWORD = 'contrasenasegura';
CREATE USER encargado_inventarios FOR LOGIN encargado_inventarios;

-- 5. Gerente de Compras
CREATE LOGIN gerente_compras WITH PASSWORD = 'contrasenasegura';
CREATE USER gerente_compras FOR LOGIN gerente_compras;

-- 6. Contador
CREATE LOGIN contador WITH PASSWORD = 'contrasenasegura';
CREATE USER contador FOR LOGIN contador;

-- 7. Gerente de Recursos Humanos
CREATE LOGIN gerente_rrhh WITH PASSWORD = 'contrasenasegura';
CREATE USER gerente_rrhh FOR LOGIN gerente_rrhh;

-- 8. Encargado de Logística
CREATE LOGIN encargado_logistica WITH PASSWORD = 'contrasenasegura';
CREATE USER encargado_logistica FOR LOGIN encargado_logistica;

-- 9. Gerente de Marketing
CREATE LOGIN gerente_marketing WITH PASSWORD = 'contrasenasegura';
CREATE USER gerente_marketing FOR LOGIN gerente_marketing;

-- 10. Usuario de Seguridad
CREATE LOGIN usuario_seguridad WITH PASSWORD = 'contrasenasegura';
CREATE USER usuario_seguridad FOR LOGIN usuario_seguridad;

--Modificacion de accesos o privilegios

-- 1. Administrador de Base de Datos
ALTER ROLE db_owner ADD MEMBER admin_db;

-- 2. Gerente General
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Ventas TO gerente_general;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Clientes TO gerente_general;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Inventarios TO gerente_general;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Finanzas TO gerente_general;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::RecursosHumanos TO gerente_general;

-- 3. Gerente de Ventas
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Ventas TO gerente_ventas;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Clientes TO gerente_ventas;

-- 4. Encargado de Inventarios
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Inventarios TO encargado_inventarios;

-- 5. Gerente de Compras
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Compras TO gerente_compras;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Proveedores TO gerente_compras;

-- 6. Contador
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Finanzas TO contador;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Contabilidad TO contador;

-- 7. Gerente de Recursos Humanos
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::RecursosHumanos TO gerente_rrhh;

-- 8. Encargado de Logística
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Logistica TO encargado_logistica;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Distribución TO encargado_logistica;

-- 9. Gerente de Marketing
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Marketing TO gerente_marketing;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::RelacionesPublicas TO gerente_marketing;

-- 10. Usuario de Seguridad
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Seguridad TO usuario_seguridad;




-- FILEGROUPS
-- Instanciacion de FileGroups

ALTER DATABASE plaza_vea
ADD FILEGROUP SALES;

ALTER DATABASE plaza_vea
ADD FILEGROUP INVENTORY;

ALTER DATABASE plaza_vea
ADD FILEGROUP HR;

ALTER DATABASE plaza_vea
ADD FILEGROUP FINANCE;

ALTER DATABASE plaza_vea
ADD FILEGROUP MARKETING;

ALTER DATABASE plaza_vea
ADD FILEGROUP MAINTENANCE;

-- Creacion de Archivos NDF
ALTER DATABASE plaza_vea
ADD FILE (
    NAME = 'SalesData',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\SalesData.ndf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
) TO FILEGROUP SALES;

ALTER DATABASE plaza_vea
ADD FILE (
    NAME = 'InventoryData',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\InventoryData.ndf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
) TO FILEGROUP INVENTORY;

ALTER DATABASE plaza_vea
ADD FILE (
    NAME = 'HRData',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\HRData.ndf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
) TO FILEGROUP HR;

ALTER DATABASE plaza_vea
ADD FILE (
    NAME = 'FinanceData',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\FinanceData.ndf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
) TO FILEGROUP FINANCE;

ALTER DATABASE plaza_vea
ADD FILE (
    NAME = 'MarketingData',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\MarketingData.ndf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
) TO FILEGROUP MARKETING;

ALTER DATABASE plaza_vea
ADD FILE (
    NAME = 'MaintenanceData',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\MaintenanceData.ndf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
) TO FILEGROUP MAINTENANCE;



-- Funciones tabla

use plaza_vea
go

CREATE FUNCTION dbo.fnt_AuditoriasPorFechaDescripcion
(
    @fechaInicio DATETIME,
    @fechaFin DATETIME,
    @descripcion NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_auditoria, fecha, descripcion, resultados
    FROM AuditoriasInternas
    WHERE fecha BETWEEN @fechaInicio AND @fechaFin
      AND descripcion LIKE '%' + @descripcion + '%'
)

select  * from AuditoriasInternas
select  * from dbo.fnt_AuditoriasPorFechaDescripcion('20230101','20240101','a')


CREATE FUNCTION dbo.fnt_AccesosPorEmpleadoUsuario
(
    @idEmpleado INT,
    @usuario NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_acceso, id_empleado, usuario, contrasena
    FROM AccesosUsuario
    WHERE id_empleado = @idEmpleado
      AND usuario LIKE '%' + @usuario + '%'
)

select * from dbo.fnt_AccesosPorEmpleadoUsuario(1, 'a')


CREATE FUNCTION dbo.fnt_RolesPorNombre
(
    @nombre NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_rol, nombre
    FROM RolesPermisos
    WHERE nombre LIKE '%' + @nombre + '%'
)

select * from dbo.fnt_RolesPorNombre('a')


CREATE FUNCTION dbo.fnt_PermisosPorDescripcion
(
    @descripcion NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_permiso, descripcion
    FROM Permisos
    WHERE descripcion LIKE '%' + @descripcion + '%'
)

CREATE FUNCTION dbo.fnt_RolesUsuariosPorAcceso
(
    @idAcceso INT
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_rol_usuario, id_acceso, id_rol
    FROM RolesUsuarios
    WHERE id_acceso = @idAcceso
)


CREATE FUNCTION dbo.fnt_PermisosRolesPorRol
(
    @idRol INT
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_permiso_rol, id_rol, id_permiso
    FROM PermisosRoles
    WHERE id_rol = @idRol
)

CREATE FUNCTION dbo.fnt_LogsPorAccesoActividad
(
    @idAcceso INT,
    @actividad NVARCHAR(200)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_log, id_acceso, actividad, fecha
    FROM LogsActividades
    WHERE id_acceso = @idAcceso
      AND actividad LIKE '%' + @actividad + '%'
)


CREATE FUNCTION dbo.fnt_IncidentesPorEmpleadoDescripcion
(
    @idEmpleado INT,
    @descripcion NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_incidente, descripcion, fecha, id_empleado
    FROM IncidentesSeguridad
    WHERE id_empleado = @idEmpleado
      AND descripcion LIKE '%' + @descripcion + '%'
)


CREATE FUNCTION dbo.fnt_ControlPerdidasPorProductoMotivo
(
    @idProducto INT,
    @motivo NVARCHAR(200)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_control, id_producto, cantidad, motivo, fecha
    FROM ControlPerdidas
    WHERE id_producto = @idProducto
      AND motivo LIKE '%' + @motivo + '%'
)

CREATE FUNCTION dbo.fnt_CampanasPorNombreEstado
(
    @nombre NVARCHAR(100),
    @estado VARCHAR(30)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT id_campana, nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, estado
    FROM CampanasMarketing
    WHERE nombre LIKE '%' + @nombre + '%'
      AND estado = @estado
)


-- Funciones escalares

----------------------------------------- TABLA PROVEEDORES
CREATE FUNCTION dbo.ObtenerNombreCompletoProveedor (@id_proveedor INT)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @nombreCompleto VARCHAR(200);

    SELECT @nombreCompleto = nombre + ' - ' + contacto
    FROM Proveedores
    WHERE id_proveedor = @id_proveedor;

    RETURN @nombreCompleto;
END;

SELECT dbo.ObtenerNombreCompletoProveedor(1) AS NombreCompleto;


CREATE FUNCTION dbo.ActualizarDireccionProveedor (
    @id_proveedor INT,
    @nueva_direccion VARCHAR(200)
)
RETURNS VARCHAR(300)
AS
BEGIN
    DECLARE @resultado VARCHAR(300);

    SELECT @resultado = nombre + ' - ' + @nueva_direccion
    FROM Proveedores
    WHERE id_proveedor = @id_proveedor;

    RETURN @resultado;
END;

SELECT dbo.ActualizarDireccionProveedor(1, 'Calle Nueva 123') AS DetalleProveedor;


--------------------------------------TABLA PUESTOS DE TRABAJO

CREATE FUNCTION dbo.ObtenerNombrePuestoYDepartamento (@id_puesto INT)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @nombrePuestoYDepartamento VARCHAR(200);

    SELECT @nombrePuestoYDepartamento = PT.nombre + ' en ' + D.nombre
    FROM PuestosTrabajo PT
    JOIN Departamentos D ON PT.id_departamento = D.id_departamento
    WHERE PT.id_puesto = @id_puesto;

    RETURN @nombrePuestoYDepartamento;
END;

SELECT dbo.ObtenerNombrePuestoYDepartamento(1) AS NombrePuestoYDepartamento;



--------------------------------------------TABLA EVENTOS

CREATE FUNCTION dbo.ObtenerNombreUbicacionEvento (@id_evento INT)
RETURNS VARCHAR(300)
AS
BEGIN
    DECLARE @nombreUbicacion VARCHAR(300);

    SELECT @nombreUbicacion = nombre + ' en ' + ubicacion
    FROM Eventos
    WHERE id_evento = @id_evento;

    RETURN @nombreUbicacion;
END;

SELECT dbo.ObtenerNombreUbicacionEvento(1) AS NombreUbicacion;


----------------------------TABLAS DESPACHO

CREATE FUNCTION dbo.ActualizarFechasDespacho (
    @id_despacho INT,
    @nueva_fecha_salida DATETIME,
    @nueva_fecha_llegada DATETIME
)
RETURNS VARCHAR(300)
AS
BEGIN
    DECLARE @resultado VARCHAR(300);

    SELECT @resultado = 'Despacho ID: ' + CAST(id_despacho AS VARCHAR) + 
                        ' - Nueva Salida: ' + CAST(@nueva_fecha_salida AS VARCHAR) +
                        ' - Nueva Llegada: ' + CAST(@nueva_fecha_llegada AS VARCHAR)
    FROM Despachos
    WHERE id_despacho = @id_despacho;

    RETURN @resultado;
END;

SELECT dbo.ActualizarFechasDespacho(1, '2024-07-01 08:00:00', '2024-07-01 18:00:00') AS DetalleDespacho;


--------------------------TABLA CLIENTES

CREATE FUNCTION dbo.ActualizarTelefonoCliente (
    @id_cliente INT,
    @nuevo_telefono VARCHAR(20)
)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @resultado VARCHAR(200);

    SELECT @resultado = nombre + ' ' + apellido + ' - ' + @nuevo_telefono
    FROM Clientes
    WHERE id_cliente = @id_cliente;

    RETURN @resultado;
END;

SELECT dbo.ActualizarTelefonoCliente(1, '555-1234') AS DetalleCliente;

--------------------------TABLA AnalisisMercado

CREATE FUNCTION dbo.ActualizarDetallesAnalisis (
    @id_analisis INT,
    @nueva_descripcion TEXT,
    @nuevos_resultados TEXT
)
RETURNS VARCHAR(400)
AS
BEGIN
    DECLARE @resultado VARCHAR(400);

    SELECT @resultado = 'Análisis ID: ' + CAST(id_analisis AS VARCHAR) +
                        ' - Descripción: ' + @nueva_descripcion +
                        ' - Resultados: ' + @nuevos_resultados
    FROM AnalisisMercado
    WHERE id_analisis = @id_analisis;

    RETURN @resultado;
END;

SELECT dbo.ActualizarDetallesAnalisis(1, 'Nueva descripción del análisis', 'Nuevos resultados del análisis') AS DetalleAnalisis;

--------------------------TABLA EncuestasSatisfaccion

CREATE FUNCTION dbo.ActualizarDetallesEncuesta (
    @id_encuesta INT,
    @nueva_puntuacion INT,
    @nuevos_comentarios TEXT
)
RETURNS VARCHAR(400)
AS
BEGIN
    DECLARE @resultado VARCHAR(400);

    SELECT @resultado = 'Encuesta ID: ' + CAST(id_encuesta AS VARCHAR) +
                        ' - Puntuación: ' + CAST(@nueva_puntuacion AS VARCHAR) +
                        ' - Comentarios: ' + @nuevos_comentarios
    FROM EncuestasSatisfaccion
    WHERE id_encuesta = @id_encuesta;

    RETURN @resultado;
END;

SELECT dbo.ActualizarDetallesEncuesta(1, 5, 'Excelentes servicios') AS DetalleEncuesta;


--------------------------TABLA FlotasTransporte 

CREATE FUNCTION dbo.ActualizarDescripcionFlota (
    @id_flota INT,
    @nueva_descripcion VARCHAR(100)
)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @resultado VARCHAR(200);

    SELECT @resultado = 'Flota ID: ' + CAST(id_flota AS VARCHAR) + 
                        ' - Descripción: ' + @nueva_descripcion
    FROM FlotasTransporte
    WHERE id_flota = @id_flota;

    RETURN @resultado;
END;

SELECT dbo.ActualizarDescripcionFlota(1, 'Nueva descripción de la flota') AS DetalleFlota;

--------------------------TABLA RutasDistribucion 

CREATE FUNCTION dbo.ActualizarDescripcionRuta (
    @id_ruta INT,
    @nueva_descripcion VARCHAR(100)
)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @resultado VARCHAR(200);

    SELECT @resultado = 'Ruta ID: ' + CAST(id_ruta AS VARCHAR) + 
                        ' - Descripción: ' + @nueva_descripcion
    FROM RutasDistribucion
    WHERE id_ruta = @id_ruta;

    RETURN @resultado;
END;

SELECT dbo.ActualizarDescripcionRuta(1, 'Nueva descripción de la ruta') AS DetalleRuta;


-- Procedimienots almacenados

---EJEMPLO 1:Insertar una nueva categoría
CREATE PROCEDURE InsertarCategoria
    @nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Categorias (nombre)
    VALUES (@nombre);
END;
select * from [dbo].[Categorias]
--insertamos la categoria Coches
exec [dbo].[InsertarCategoria] 'Coches'



---EJEMPLO 2: Actualizar el precio de un producto
CREATE PROCEDURE ActualizarPrecioProducto
    @id_producto INT,
    @nuevo_precio DECIMAL(10, 2)
AS
BEGIN
    UPDATE Productos
    SET precio = @nuevo_precio
    WHERE id_producto = @id_producto;
END;
select*from [dbo].[Productos]
--actualizamos el precio de un producto por medio del ID
exec [dbo].[ActualizarPrecioProducto] '2','45.00'



---EJEMPLO 3: Buscar los productos de plaza vea por su nombre
create procedure BuscarProducto---creamos el procedimiento
@buscar varchar(40)
as
begin
select [id_producto], [nombre],[descripcion],[precio]from [dbo].[Productos]
where [nombre] like @buscar
end;
select *from [dbo].[Productos]
--buscamos producto llamado camisa:
exec [dbo].[BuscarProducto] '%camisa%'



---EJEMPLO 4: Insertar nuevo producto
CREATE PROCEDURE InsertarProducto
    @nombre VARCHAR(100),
    @descripcion TEXT,
    @id_subcategoria INT,
    @id_marca INT,
    @id_unidad INT,
    @precio DECIMAL(10, 2),
    @stock_minimo INT,
    @stock_maximo INT
AS
BEGIN
    INSERT INTO Productos (nombre, descripcion, id_subcategoria, id_marca, id_unidad, precio, stock_minimo, stock_maximo)
    VALUES (@nombre, @descripcion, @id_subcategoria, @id_marca, @id_unidad, @precio, @stock_minimo, @stock_maximo);
END;
select*from [dbo].[Productos]
      ---insertamos un producto llamado PC
exec [dbo].[InsertarProducto] 'PC','Una PC muy potente',2,1,1,'2000.00',3,10



---EJEMPLO 5: Consultar inventario de un producto
create PROCEDURE ConsultarInventarioProducto
    @id_producto INT
AS
BEGIN
    SELECT [cantidad]
    FROM [Inventarios].[InventarioGeneral] 
    WHERE [id_producto] = @id_producto;
END;
select*from [Inventarios].[InventarioGeneral]
   ---vemos el inventario del producto con el ID 1
EXEC [dbo].[ConsultarInventarioProducto] 1 


---EJEMPLO 6: Generar un informe de ventas por cliente en un rango de fechas
CREATE PROCEDURE InformeVentasPorCliente
    @id_cliente INT,
    @fecha_inicio DATETIME,
    @fecha_fin DATETIME
AS
BEGIN
    SELECT 
        v.id_venta,
        v.fecha,
        v.total,
        dv.id_producto,
        p.nombre AS producto,
        dv.cantidad,
        dv.precio_unitario,
        (dv.cantidad * dv.precio_unitario) AS subtotal
    FROM 
        [Ventas].[Ventas] V
        JOIN [Ventas].[DetallesVenta] dv ON V.id_venta = dv.id_venta
        JOIN  [dbo].[Productos] P ON DV.id_producto = P.id_producto
    WHERE 
        v.id_cliente = @id_cliente
        AND v.fecha BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY 
        v.fecha;
END;
select*from [Ventas].[Ventas]
select*from[dbo].[Productos]
select *from [Ventas].[DetallesVenta]
EXEC [dbo].[InformeVentasPorCliente] 1,'20240101', '20241231'


---EJEMPLO 7: Registrar asistencia de un empleado
CREATE PROCEDURE RegistrarAsistencia
    @idEmpleado INT,
    @fecha DATE,
    @horaEntrada TIME,
    @horaSalida TIME
AS
BEGIN
    -- Insertar registro de asistencia
    INSERT INTO  [RecursosHumanos].[Asistencias](id_empleado, fecha, hora_entrada, hora_salida)
    VALUES (@idEmpleado, @fecha, @horaEntrada, @horaSalida);
END;
select*from [RecursosHumanos].[Asistencias]
---registramos una nueva asistencia
exec [dbo].[RegistrarAsistencia] 1,'20240618', '08:00', '17:00'



---EJEMPLO 8: Actualizar la informacion del cliente
CREATE PROCEDURE ActualizarCliente
    @idCliente INT,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(255),
    @telefono NVARCHAR(20),
    @correo NVARCHAR(100)
AS
BEGIN
    UPDATE [Ventas].[Clientes]
    SET  [nombre]= @nombre,  [apellido]= @apellido, [telefono] = @telefono, [correo] = @correo
    WHERE[id_cliente] = @idCliente;
END;
select*from [Ventas].[Clientes]
---cambiamos sus datos por medio del ID:
EXEC [dbo].[ActualizarCliente] 1,'fABIOLA','Ancco','957771548','fabiolaancco386@gmail.com'



---EJEMPLO 9: Eliminar clientes y sus ventas
alter PROCEDURE EliminarCliente
    @idCliente INT
AS
BEGIN
    BEGIN TRANSACTION;

    -- Eliminar detalles de devoluciones del cliente
    DELETE FROM [Ventas].[DevolucionesClientes]
    WHERE [id_venta] IN (SELECT [id_venta] FROM [Ventas].[Ventas] WHERE [id_cliente] = @idCliente);

    -- Eliminar detalles de ventas del cliente
    DELETE FROM [Ventas].[DetallesVenta]
    WHERE [id_venta] IN (SELECT [id_venta] FROM [Ventas].[Ventas] WHERE [id_cliente] = @idCliente);

    -- Eliminar ventas del cliente
    DELETE FROM [Ventas].[Ventas]
    WHERE [id_cliente] = @idCliente;

    -- Eliminar cliente
    DELETE FROM [Ventas].[Clientes]
    WHERE [id_cliente] = @idCliente;

    COMMIT TRANSACTION;
END;

select*from [Ventas].[Clientes]
select*from [Ventas].[Ventas]
EXEC [dbo].[EliminarCliente]  2


---EJEMPLO 10: Obtener la lista de prodcutos por Categoria
CREATE PROCEDURE ObtenerProductosPorCategoria
    @nombreCategoria VARCHAR(100)
AS
BEGIN
    SELECT P.id_producto, P.nombre AS nombre_producto, P.descripcion, C.nombre AS nombre_categoria
    FROM [dbo].[Productos] P
    INNER JOIN [dbo].[Subcategorias] S ON P.id_subcategoria = S.id_subcategoria
    INNER JOIN [dbo].[Categorias] C ON S.id_categoria = C.id_categoria
    WHERE C.nombre = @nombreCategoria;
END;
select*from [dbo].[Productos]
select *from[dbo].[Categorias]
select *from [dbo].[Subcategorias]
   ----buscamos los productos que vienen de la categoria Electrónica
   EXEC [dbo].[ObtenerProductosPorCategoria] 'Electrónica'

-- Triggers


-- 1. Trigger para actualizar el stock en InventarioGeneral después de una venta en DetallesVenta:
CREATE TRIGGER tr_AfterInsert_DetallesVenta
ON DetallesVenta
AFTER INSERT
AS
BEGIN
    DECLARE @id_producto INT, @cantidad INT;
    
    SELECT @id_producto = inserted.id_producto, @cantidad = inserted.cantidad
    FROM inserted;

    UPDATE InventarioGeneral
    SET cantidad = cantidad - @cantidad
    WHERE id_producto = @id_producto;
END;

-- 2. Trigger para registrar un movimiento de entrada cuando se recibe un producto en RecepcionProductos:
CREATE TRIGGER tr_AfterInsert_RecepcionProductos
ON RecepcionProductos
AFTER INSERT
AS
BEGIN
    DECLARE @id_producto INT, @cantidad INT;

    SELECT @id_producto = id_producto, @cantidad = cantidad
    FROM OrdenesCompra OC
    JOIN inserted I ON OC.id_orden = I.id_orden;

    INSERT INTO MovimientosInventario (id_producto, id_almacen, cantidad, tipo_movimiento)
    VALUES (@id_producto, (SELECT id_almacen FROM DetallesOrdenCompra WHERE id_orden = inserted.id_orden), @cantidad, 'entrada');
END;

-- 3. Trigger para actualizar el estado de una orden de compra cuando todos los productos han sido recibidos:
CREATE TRIGGER tr_AfterUpdate_RecepcionProductos
ON RecepcionProductos
AFTER UPDATE, INSERT
AS
BEGIN
    DECLARE @id_orden INT;
    
    SELECT @id_orden = inserted.id_orden
    FROM inserted;

    IF NOT EXISTS (
        SELECT 1
        FROM DetallesOrdenCompra
        WHERE id_orden = @id_orden AND id_detalle NOT IN (
            SELECT id_detalle
            FROM RecepcionProductos
            WHERE id_orden = @id_orden
        )
    )
    BEGIN
        UPDATE OrdenesCompra
        SET estado = 'completada'
        WHERE id_orden = @id_orden;
    END;
END;


-- 4. Trigger para registrar un log de actividades cuando un usuario accede al sistema:
CREATE TRIGGER tr_AfterInsert_AccesosUsuario
ON AccesosUsuario
AFTER INSERT
AS
BEGIN
    DECLARE @id_acceso INT;
    
    SELECT @id_acceso = inserted.id_acceso
    FROM inserted;

    INSERT INTO LogsActividades (id_acceso, actividad)
    VALUES (@id_acceso, 'Nuevo usuario creado');
END;

-- 5. Trigger para registrar un incidente de seguridad cuando se detecta una actividad sospechosa:
CREATE TRIGGER tr_AfterInsert_IncidentesSeguridad
ON IncidentesSeguridad
AFTER INSERT
AS
BEGIN
    DECLARE @id_empleado INT, @descripcion TEXT;
    
    SELECT @id_empleado = inserted.id_empleado, @descripcion = inserted.descripcion
    FROM inserted;

    INSERT INTO LogsActividades (id_acceso, actividad)
    VALUES (
        (SELECT id_acceso FROM AccesosUsuario WHERE id_empleado = @id_empleado),
        'Incidente de seguridad reportado: ' + @descripcion
    );
END;

-- 6.Trigger para actualizar el estado de un permiso/licencia después de la revisión:
CREATE TRIGGER tr_AfterUpdate_PermisosLicencias
ON PermisosLicencias
AFTER UPDATE
AS
BEGIN
    DECLARE @id_permiso INT, @estado VARCHAR(30);

    SELECT @id_permiso = inserted.id_permiso, @estado = inserted.estado
    FROM inserted;

    IF @estado = 'aprobado'
    BEGIN
        UPDATE Empleados
        SET fecha_inicio_permiso = (SELECT fecha_inicio FROM PermisosLicencias WHERE id_permiso = @id_permiso),
            fecha_fin_permiso = (SELECT fecha_fin FROM PermisosLicencias WHERE id_permiso = @id_permiso)
        WHERE id_empleado = (SELECT id_empleado FROM PermisosLicencias WHERE id_permiso = @id_permiso);
    END;
END;


-- 7. Trigger para calcular el salario neto en la tabla Nominas después de una inserción o actualización:

CREATE TRIGGER tr_AfterInsertOrUpdate_Nominas
ON Nominas
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_nomina INT;

    SELECT @id_nomina = inserted.id_nomina
    FROM inserted;

    UPDATE Nominas
    SET salario_neto = salario_base + bonos - deducciones
    WHERE id_nomina = @id_nomina;
END;

select * from [dbo].[Nominas]

update Nominas set salario_base=100 where id_nomina=1

CREATE TRIGGER trg_UpdateStockOnInventoryMovement
ON 

AFTER INSERT
AS
BEGIN
    DECLARE @id_producto INT, @cantidad INT, @tipo_movimiento VARCHAR(30);
    
    SELECT @id_producto = i.id_producto, @cantidad = i.cantidad, @tipo_movimiento = i.tipo_movimiento
    FROM inserted i;

    IF @tipo_movimiento = 'entrada'
    BEGIN
        UPDATE InventarioGeneral
        SET cantidad = cantidad + @cantidad
        WHERE id_producto = @id_producto;
    END
    ELSE IF @tipo_movimiento = 'salida'
    BEGIN
        UPDATE InventarioGeneral
        SET cantidad = cantidad - @cantidad
        WHERE id_producto = @id_producto;
    END
END;

CREATE TRIGGER trg_PreventNegativeStock
ON MovimientosInventario
AFTER INSERT
AS
BEGIN
    DECLARE @id_producto INT, @cantidad INT, @tipo_movimiento VARCHAR(30), @current_stock INT;
    
    SELECT @id_producto = i.id_producto, @cantidad = i.cantidad, @tipo_movimiento = i.tipo_movimiento
    FROM inserted i;

    SELECT @current_stock = cantidad
    FROM InventarioGeneral
    WHERE id_producto = @id_producto;

    IF @tipo_movimiento = 'salida' AND @current_stock < @cantidad
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Not enough stock to complete the movement.', 16, 1);
    END
END;

CREATE TRIGGER trg_UpdateTotalOnDetailInsert
ON DetallesVenta
AFTER INSERT
AS
BEGIN
    DECLARE @id_venta INT;
    
    SELECT @id_venta = i.id_venta
    FROM inserted i;

    UPDATE Ventas
    SET total = (
        SELECT SUM(dv.cantidad * dv.precio_unitario)
        FROM DetallesVenta dv
        WHERE dv.id_venta = @id_venta
    )
    WHERE id_venta = @id_venta;
END;

CREATE TRIGGER trg_CalculateNetSalary
ON Nominas
AFTER INSERT
AS
BEGIN
    DECLARE @id_nomina INT, @salario_base DECIMAL(10, 2), @bonos DECIMAL(10, 2), @deducciones DECIMAL(10, 2);
    
    SELECT @id_nomina = i.id_nomina, @salario_base = i.salario_base, @bonos = i.bonos, @deducciones = i.deducciones
    FROM inserted i;

    UPDATE Nominas
    SET salario_neto = @salario_base + @bonos - @deducciones
    WHERE id_nomina = @id_nomina;
END;

CREATE TRIGGER trg_UpdateStockOnOrderDetailInsert
ON DetallesOrdenCompra
AFTER INSERT
AS
BEGIN
    DECLARE @id_producto INT, @cantidad INT;
    
    SELECT @id_producto = i.id_producto, @cantidad = i.cantidad
    FROM inserted i;

    UPDATE InventarioGeneral
    SET cantidad = cantidad + @cantidad
    WHERE id_producto = @id_producto;
END;


CREATE TRIGGER trg_RecordSaleMovement
ON Ventas
AFTER INSERT
AS
BEGIN
    DECLARE @id_venta INT;
    
    SELECT @id_venta = i.id_venta
    FROM inserted i;

    INSERT INTO MovimientosInventario (id_producto, id_almacen, cantidad, tipo_movimiento)
    SELECT dv.id_producto, NULL, dv.cantidad, 'salida'
    FROM DetallesVenta dv
    WHERE dv.id_venta = @id_venta;
END;


CREATE TRIGGER trg_ValidatePromotionPeriod
ON CuponesDescuentos
BEFORE INSERT, UPDATE
AS
BEGIN
    DECLARE @fecha_inicio DATE, @fecha_fin DATE;
    
    SELECT @fecha_inicio = i.fecha_inicio, @fecha_fin = i.fecha_fin
    FROM inserted i;

    IF @fecha_inicio > @fecha_fin
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Promotion end date must be after the start date.', 16, 1);
    END
END;


CREATE TABLE ActividadesUsuarios (
    id_actividad INT PRIMARY KEY IDENTITY(1, 1),
    id_acceso INT,
    actividad VARCHAR(200),
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_acceso) REFERENCES AccesosUsuario(id_acceso)
);

CREATE TRIGGER trg_LogUserActivity
ON LogsActividades
AFTER INSERT
AS
BEGIN
    DECLARE @id_acceso INT, @actividad VARCHAR(200);
    
    SELECT @id_acceso = i.id_acceso, @actividad = i.actividad
    FROM inserted i;

    INSERT INTO ActividadesUsuarios (id_acceso, actividad)
    VALUES (@id_acceso, @actividad);
END;



--A traves de PROCEDIMIENTOS ALMACENADOS ANTIGUOS:
---Creacion de logins
sp_addlogin 'usuario1', '123456', 'master';
go
sp_addlogin 'usuario2', '123456', 'master';
go

---Creacion de usuarios en nuestra base de datos
USE plaza_vea;

sp_adduser 'usuario1', 'usuario1'
GO
sp_adduser 'usuario2', 'usuario2'
GO

--- Mostrar información de los logins
sp_helplogins;
GO

--A traves de Sentencias T-SQL Modernas:
---Crear logins
CREATE LOGIN empleado1 WITH PASSWORD = '123';
CREATE LOGIN empleado2 WITH PASSWORD = '123';

---Crear usuarios en la base de datos plaza_vea
USE plaza_vea;
CREATE USER empleado1 FOR LOGIN empleado1;
CREATE USER empleado2 FOR LOGIN empleado2;

--Asignar Roles de Servidor a un Login
use master
ALTER SERVER ROLE dbcreator ADD MEMBER usuario1;
ALTER SERVER ROLE diskadmin ADD MEMBER usuario1;

--Asignar Roles de Base de Datos a un Usuario
USE plaza_vea;
EXEC sp_addrolemember db_owner, usuario2;
EXEC sp_addrolemember db_datareader, usuario2;
EXEC sp_addrolemember db_datawriter, usuario2;

--Otorgar permisos especificos a un usuario sobre una tabla
GRANT SELECT, INSERT ON [dbo].[Productos] TO usuario1;
--Quitamos permisos al usuario sobre una tabla
REVOKE INSERT ON [dbo].[Productos] FROM usuario1;

--Crear y Asignar un Rol Definido por el Usuario
USE plaza_vea;
CREATE ROLE rol_ventas; --creas el rol
GRANT SELECT, INSERT, UPDATE ON [dbo].[Ventas] TO rol_ventas; --asignas permisos
EXEC sp_addrolemember rol_ventas, usuario3; --- asignas el rol al usuario

-- Crear un rol en la base de datos
USE plaza_vea;
CREATE ROLE rol_ventas;

-- Asignar permisos al rol
GRANT SELECT, INSERT, UPDATE ON [dbo].[Ventas] TO rol_ventas;

-- Asignar el rol a un usuario
EXEC sp_addrolemember N'rol_ventas', N'usuario_sql';

grant select, insert, update on cliente to empleado1
go

revoke update on cliente to empleado1
go

grant select, insert, update on sala to empleado2
go

revoke update on sala to empleado2
go

grant select, insert, update on pelicula to empleado2
go

revoke update on pelicula to empleado2
go

