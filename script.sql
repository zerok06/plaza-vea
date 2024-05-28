create database plaza_vea -- Base de Datos: Supermercado
go

drop database plaza_vea
go

-- creacion con datos especificos

CREATE DATABASE plaza_vea
ON 
(
    NAME = plaza_vea_dat,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\plaza_vea_dat.mdf',  -- Ruta del archivo MDF
    SIZE = 500MB,                                -- Tamaño inicial del archivo MDF
    MAXSIZE = UNLIMITED,                         -- Sin límite de crecimiento máximo
    FILEGROWTH = 100MB                           -- Incremento del tamaño del archivo MDF
)
LOG ON
(
    NAME = plaza_vea_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.ZEROKSERVER\MSSQL\DATA\plaza_vea_log.ldf',  -- Ruta del archivo LDF
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


-- Table: IncidentesMantenimiento
-- Insert
-- Select
-- Update
-- Delete
-- Drop


-- Table: IncidentesMantenimiento
-- Insert
-- Select
-- Update
-- Delete
-- Drop


-- Table: ContratosServicio
-- Insert
-- Select
-- Update
-- Delete
-- Drop


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
