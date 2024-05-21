create database plaza_vea -- Base de Datos: Supermercado
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
    tipo_movimiento ENUM('entrada', 'salida'),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    dia ENUM(
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo'
    ),
    hora_entrada TIME,
    hora_salida TIME,
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
    fecha_salida TIMESTAMP,
    fecha_llegada TIMESTAMP,
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen),
    FOREIGN KEY (id_ruta) REFERENCES RutasDistribucion(id_ruta)
);

-- 6. Finanzas y Contabilidad
CREATE TABLE CuentasPorCobrar (
    id_cuenta INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    monto DECIMAL(10, 2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE CuentasPorPagar (
    id_cuenta INT PRIMARY KEY IDENTITY(1, 1),
    id_proveedor INT,
    monto DECIMAL(10, 2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
);

-- Continúa con las otras tablas necesarias según la lista proporcionada anteriormente...
-- 2. Inventarios (Continuación)
CREATE TABLE RequisicionesInventario (
    id_requisicion INT PRIMARY KEY IDENTITY(1, 1),
    id_almacen INT,
    id_producto INT,
    cantidad INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'aprobada', 'rechazada'),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Proveedores (
    id_proveedor INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE OrdenesCompra (
    id_orden INT PRIMARY KEY IDENTITY(1, 1),
    id_proveedor INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'completada', 'cancelada'),
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cantidad INT,
    FOREIGN KEY (id_orden) REFERENCES OrdenesCompra(id_orden)
);

-- 3. Ventas y Clientes (Continuación)
CREATE TABLE DevolucionesClientes (
    id_devolucion INT PRIMARY KEY IDENTITY(1, 1),
    id_venta INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    estado ENUM('activo', 'inactivo')
);

CREATE TABLE ProgramasFidelizacion (
    id_programa INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    puntos_por_compra DECIMAL(5, 2),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado ENUM('activo', 'inactivo')
);

CREATE TABLE HistorialCupones (
    id_historial INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    id_cupon INT,
    fecha_uso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    estado ENUM('pendiente', 'aprobado', 'rechazado'),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Capacitaciones (
    id_capacitacion INT PRIMARY KEY IDENTITY(1, 1),
    id_empleado INT,
    nombre VARCHAR(100),
    fecha DATE,
    duracion INT,
    -- Duración en horas
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'completada', 'cancelada'),
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
    tipo_transaccion ENUM('ingreso', 'egreso'),
    descripcion VARCHAR(200),
    monto DECIMAL(10, 2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BalanceGeneral (
    id_balance INT PRIMARY KEY IDENTITY(1, 1),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activos DECIMAL(15, 2),
    pasivos DECIMAL(15, 2),
    patrimonio DECIMAL(15, 2)
);

CREATE TABLE EstadoResultados (
    id_estado INT PRIMARY KEY IDENTITY(1, 1),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Presupuestos (
    id_presupuesto INT PRIMARY KEY IDENTITY(1, 1),
    año INT,
    departamento VARCHAR(100),
    monto DECIMAL(15, 2)
);

CREATE TABLE AuditoriasInternas (
    id_auditoria INT PRIMARY KEY IDENTITY(1, 1),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_acceso) REFERENCES AccesosUsuario(id_acceso)
);

CREATE TABLE IncidentesSeguridad (
    id_incidente INT PRIMARY KEY IDENTITY(1, 1),
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_empleado INT,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE ControlPerdidas (
    id_control INT PRIMARY KEY IDENTITY(1, 1),
    id_producto INT,
    cantidad INT,
    motivo VARCHAR(200),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    estado ENUM('activa', 'inactiva')
);

CREATE TABLE MediosPublicidad (
    id_medio INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    tipo VARCHAR(50)
);

CREATE TABLE AnalisisMercado (
    id_analisis INT PRIMARY KEY IDENTITY(1, 1),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion TEXT,
    resultados TEXT
);

CREATE TABLE EncuestasSatisfaccion (
    id_encuesta INT PRIMARY KEY IDENTITY(1, 1),
    id_cliente INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    puntuacion INT,
    comentarios TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Eventos (
    id_evento INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ubicacion VARCHAR(200)
);

CREATE TABLE Patrocinios (
    id_patrocinio INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    monto DECIMAL(10, 2)
);

-- 9. Mantenimiento y Servicios
CREATE TABLE EquiposMaquinaria (
    id_equipo INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(100),
    descripcion TEXT,
    fecha_adquisicion DATE,
    estado ENUM('operativo', 'en mantenimiento', 'no operativo')
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
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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

-- Fin del script SQL para la base de datos del supermercado