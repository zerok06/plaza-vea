-- Schema 
-- como crear un schema
use DB_Northwind
go

create schema RRHH authorization paye
go

alter schema RRHH transfer [dbo].[Customers]
go

alter schema RRHH transfer [dbo].[Employees]
go

alter schema dbo transfer [RRHH].[Employees]
go

alter schema dbo transfer [RRHH].[Customers]
go


alter schema VENTAS transfer [dbo].[Customers]
go

alter schema VENTAS transfer [dbo].[Products]
go

alter schema VENTAS transfer [dbo].[Orders]
go

alter schema PERSONAL transfer [dbo].[EmployeeTerritories]
go

alter schema PERSONAL transfer [dbo].[Employees]
go

alter schema SEGUIMIENTO_ORDEN transfer [dbo].[Orders]

select * from Employees


create login paye with password='paye'

use DB_Northwind

create user paye for login paye

grant alter on Products to paye

select * from Employees



-- file-group

alter database [DB_Northwind] add filegroup grupodata1
alter database [DB_Northwind] add filegroup grupodata2

alter database [DB_Northwind] add file (
	name=dataas1,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\dataas1.ndf',
	size=1mb,
	maxsize=20mb,
	filegrowth=1mb
) to filegroup grupodata1

alter database [DB_Northwind] add file (
	name=dataas2,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\dataas2.ndf',
	size=1mb,
	maxsize=20mb,
	filegrowth=1mb
) to filegroup grupodata2


use AdventureWorks2019
go
-- darle autorizacion al usuario estudiante en del schema person
create schema Person
go

create login estudiante with password='estudiante'
go

create user estudiante for login estudiante
go

grant alter on Products to estudiante




-- crear 2 grupos de archivos en el adventure

alter database [AdventureWorks2019] add filegroup grupo1
alter database [AdventureWorks2019] add filegroup grupo2
go

alter database [AdventureWorks2019] add file (
	name=grupo1,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\grupo1.ndf',
	size=1mb,
	maxsize=20mb,
	filegrowth=1mb
) to filegroup grupo1

alter database [AdventureWorks2019] add file (
	name=grupo2,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\grupo2.ndf',
	size=1mb,
	maxsize=20mb,
	filegrowth=1mb
) to filegroup grupo2



-- los schemas dbo deben alojarse en el esquema aplicacion

create schema aplication
go

alter schema aplication transfer [dbo].[AWBuildVersion]
alter schema aplication transfer [dbo].[DatabaseLog]
alter schema aplication transfer [dbo].[ErrorLog]
go



-- Caso practico



use master
go

create login UserInf with password = 'admin123'


use [DB_Northwind]
go

create user UserInf for login  UserInf
with default_schema=informatica
go

---------------

use [DB_Northwind]
go

create schema Curso authorization UserInf
go


create schema Informatica authorization UserInf
go

-----

grant create  table  to UserInf
go
revoke select, insert, update from UserInf


select user
execute as user='UserInf'
go

create table Empleado(
	codigo int,
	nombre varchar(100)
)

revert
go



use [DB_Northwind]
go

create table ClientePrueba(
codigo int not null primary key,
nombre varchar(100),
apellido varchar(100)
)

--- file groups

alter database [clone_northwind] add filegroup northwind1
alter database [clone_northwind] add filegroup northwind2


alter database [DB_Northwind] add file (
	name=DATASEC1,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasec1.ndf',
	size=1mb,
	maxsize=20mb,
	filegrowth=1mb
) to filegroup northwind1
go

alter database [DB_Northwind] add file (
	name=DATASEC2,
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\datasec2.ndf',
	size=1mb,
	maxsize=20mb,
	filegrowth=1mb
) to filegroup northwind2
go

--Caso practico

create database clone_northwind
go

use clone_northwind
go

select * from Categories
go

create table categories (
	Categoryid int not null primary key,
	categoryname varchar(100) not null,
	description varchar(100) not null,
	picture varchar(100) not null,
)

select * from CustomerCustomerDemo
go
create table CustomerCustomerDemo (
	CustomerId int not null primary key,
	CustomerTypeId varchar(100) not null,
)


select * from [dbo].[CustomerDemographics]
go
create table CustomerDemographics (
	CustomerTypeId int not null primary key,
	CustomerDesc varchar(100) not null,
)

select * from [dbo].[Customers]
go
create table Customers(
	CustomerId int not null primary key,
	companyname varchar(100) not null,
	contactname varchar(100) not null,
	contacttitle varchar(100) not null,
	address varchar(100) not null,
)


select * from [dbo].[Employees]
go
create table Employees(
	EmployeeId int not null primary key,
	lastname varchar(100) not null,
	firstname varchar(100) not null,
	title varchar(100) not null,
	titleofcourtesy varchar(100) not null,
)


select * from [dbo].[EmployeeTerritories]
go
create table EmployeeTerritories(
	EmployeeId int not null primary key,
	territoryid varchar(100) not null,
)


select * from [dbo].[Order Details]
go
create table Order_Details(
	OrderId int not null primary key,
	productid varchar(100) not null,
	unitprice varchar(100) not null,
	quantity varchar(100) not null,
	discount varchar(100) not null,
)


select * from [dbo].[Orders]
go
create table Orders(
	OrderId int not null primary key,
	curstomerId varchar(100) not null,
	employeeid varchar(100) not null,
	orderdate varchar(100) not null,
	requireddate varchar(100) not null,
)

select * from [dbo].[Products]
go

create table Products(
	productId int not null primary key,
	productname varchar(100) not null,
	supplier varchar(100) not null,
	categoryid varchar(100) not null,
	quantityPerunit varchar(100) not null,
)

select * from [dbo].[Region]
go

create table Region(
	regionId int not null primary key,
	regiondescription varchar(100) not null,
)

select * from [dbo].[Shippers]
go

create table Shippers(
	shipperId int not null primary key,
	companyName varchar(100) not null,
	phone varchar(100) not null,
)

select * from [dbo].[Suppliers]
go

create table Suppliers(
	supplierId int not null primary key,
	companyName varchar(100) not null,
	phone varchar(100) not null,
	contactname varchar(100) not null,
	contacttitle varchar(100) not null,
)

select * from [dbo].[Territories]
go

create table Territories(
	territoryId int not null primary key,
	territotyDescription varchar(100) not null,
	regionId varchar(100) not null,
)

-- creamos schema

create schema Ventas
go

alter schema Ventas transfer [dbo].[Orders]
go
alter schema Ventas transfer [dbo].[Products]
go
alter schema Ventas transfer [dbo].[Order_Details]
go

create schema RRHH
go
alter schema RRHH transfer [Ventas].[Employees]
go
alter schema RRHH transfer [dbo].[EmployeeTerritories]
go

create schema MARKETING
go
alter schema MARKETING transfer [dbo].[CustomerCustomerDemo]
go
alter schema MARKETING transfer [dbo].[CustomerDemographics]
go
alter schema MARKETING transfer [dbo].[Customers]
go

create schema Compras
go

alter schema Compras transfer [dbo].[Suppliers]
go

create schema Transporte
go

alter schema Transporte transfer [dbo].[Region]
go
alter schema Transporte transfer [dbo].[Shippers]
go
alter schema Transporte transfer [dbo].[Territories]
go

create schema e_commerce
go

alter schema e_commerce transfer [dbo].[categories]
go


-- creamos usuario

create login vendedor with password='vendedor'
go

create user vendedor for login vendedor
go

create login administrador with password='administrador'
go

create user administrador for login administrador
go

create login developer with password='developer'
go

create user developer for login developer
go

