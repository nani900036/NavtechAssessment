USE [master]
GO
/****** Object:  Database [Orders]    Script Date: 11-07-2020 10:13:18 ******/
CREATE DATABASE [Orders]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Orders', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Orders.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Orders_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Orders_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Orders] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Orders].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Orders] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Orders] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Orders] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Orders] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Orders] SET ARITHABORT OFF 
GO
ALTER DATABASE [Orders] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Orders] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Orders] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Orders] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Orders] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Orders] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Orders] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Orders] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Orders] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Orders] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Orders] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Orders] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Orders] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Orders] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Orders] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Orders] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Orders] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Orders] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Orders] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Orders] SET  MULTI_USER 
GO
ALTER DATABASE [Orders] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Orders] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Orders] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Orders] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Orders]
GO
/****** Object:  StoredProcedure [dbo].[GetOrders]    Script Date: 11-07-2020 10:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetOrders]
@UserID UNIQUEIDENTIFIER
as
DECLARE @Type nvarchar(MAX)
BEGIN
SELECT @Type=Type From dbo.UsersTable 
where UserID=@userid 
if (@Type ='User')
Begin
SELECT*from dbo.Orders
where UserID=@userID
end
else
begin
select*from Orders
end
end
GO
/****** Object:  StoredProcedure [dbo].[SEndMail]    Script Date: 11-07-2020 10:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SEndMail]
@UserId UNIQUEIDENTIFIER

as
DEClare @email nvarchar(max)
select @email=email from UsersTable
where UserId=@UserId
begin
EXEC msdb.dbo.sp_send_dbmail
     @profile_name = 'Notifications',
     @recipients = @email,
     @body = '<Html><body> your order  been placed succesfully</body> </HTML>',
     @subject = 'Automated Success Message';
	 end

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 11-07-2020 10:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] NOT NULL,
	[OrderName] [nvarchar](max) NULL,
	[UserID] [uniqueidentifier] NULL,
	[OrderStatus] [nvarchar](max) NULL,
	[OrderDetails] [nvarchar](max) NULL,
	[ShippingAddress] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UsersTable]    Script Date: 11-07-2020 10:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersTable](
	[NAME] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
 CONSTRAINT [PK_UsersTable] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (1, N'Saltete', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Approved,', N'Contain_Saltsss', N'kukatpallyxx')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (2, N'Salt', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Approved,', N'Contain_Salt', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (3, N'wine', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Cancelled,', N'Contain_wine', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (4, N'Raw_material', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'In_Delivery,', N'Contain_Raw_material', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (5, N'Glass', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Completed', N'Contain_Glass', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (6, N'bottle', N'5ecb9763-7f78-48d9-87a0-a3b9edda7f56', N'Placed', N'Contain_Bottle', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (7, N'Salt', N'5ecb9763-7f78-48d9-87a0-a3b9edda7f56', N'Approved,', N'Contain_Salt', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (8, N'wine', N'5ecb9763-7f78-48d9-87a0-a3b9edda7f56', N'Cancelled,', N'Contain_wine', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (9, N'Raw_material', N'5ecb9763-7f78-48d9-87a0-a3b9edda7f56', N'In_Delivery,', N'Contain_Raw_material', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (10, N'Glass', N'5ecb9763-7f78-48d9-87a0-a3b9edda7f56', N'Completed', N'Contain_Glass', N'kukatpally')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (11, N'bottledcsx', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Placed', N'Contain_Bottlscxe', N'kukatpallxcxcy')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (12, N'bottledcsx', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Placed', N'Contain_Bottlscxe', N'kukatpallxcxcy')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (13, N'bottledcsx', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Placed', N'Contain_Bottlscxe', N'kukatpallxcxcy')
GO
INSERT [dbo].[Orders] ([OrderID], [OrderName], [UserID], [OrderStatus], [OrderDetails], [ShippingAddress]) VALUES (14, N'bottledcsx', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Placed', N'Contain_Bottlscxe', N'kukatpallxcxcy')
GO
INSERT [dbo].[UsersTable] ([NAME], [Type], [UserId], [Password], [Email]) VALUES (N'Jhon', N'User', N'a71f268f-feb6-4fdb-b3f9-31c5d2dd5f04', N'Jhon@123', N'Nani9615432@gmail.com')
GO
INSERT [dbo].[UsersTable] ([NAME], [Type], [UserId], [Password], [Email]) VALUES (N'hari', N'Admin', N'7f737a73-8343-442f-9198-503c0feb880b', N'hari@123', N'Nani9615432@gmail.com')
GO
INSERT [dbo].[UsersTable] ([NAME], [Type], [UserId], [Password], [Email]) VALUES (N'Nani', N'User', N'5ecb9763-7f78-48d9-87a0-a3b9edda7f56', N'Nani@123', N'Nani9615432@gmail.com')
GO
USE [master]
GO
ALTER DATABASE [Orders] SET  READ_WRITE 
GO
