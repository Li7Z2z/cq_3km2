/****** Object:  Database sq_56m2vip    Script Date: 2009-07-09 15:00:35 ******/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'sq_56m2vip')
	DROP DATABASE [sq_56m2vip]
GO

CREATE DATABASE [sq_56m2vip]  ON (NAME = N'sq_56m2vip_Data', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL\data\sq_56m2vip_Data.MDF' , SIZE = 1, FILEGROWTH = 10%) LOG ON (NAME = N'sq_56m2vip_Log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL\data\sq_56m2vip_Log.LDF' , SIZE = 1, FILEGROWTH = 10%)
 COLLATE Chinese_PRC_CI_AS
GO

exec sp_dboption N'sq_56m2vip', N'autoclose', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'bulkcopy', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'trunc. log', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'torn page detection', N'true'
GO

exec sp_dboption N'sq_56m2vip', N'read only', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'dbo use', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'single', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'autoshrink', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'ANSI null default', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'recursive triggers', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'ANSI nulls', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'concat null yields null', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'cursor close on commit', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'default to local cursor', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'quoted identifier', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'ANSI warnings', N'false'
GO

exec sp_dboption N'sq_56m2vip', N'auto create statistics', N'true'
GO

exec sp_dboption N'sq_56m2vip', N'auto update statistics', N'true'
GO

use [sq_56m2vip]
GO

/****** Object:  Stored Procedure dbo.ADDTips    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ADDTips]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ADDTips]
GO

/****** Object:  Stored Procedure dbo.Q_SUM    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Q_SUM]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Q_SUM]
GO

/****** Object:  Stored Procedure dbo.Q_SUM_M2    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Q_SUM_M2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Q_SUM_M2]
GO

/****** Object:  Stored Procedure dbo.UpdateM2MakeNum    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateM2MakeNum]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateM2MakeNum]
GO

/****** Object:  Stored Procedure dbo.UpdateM2UpdataNumHard    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateM2UpdataNumHard]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateM2UpdataNumHard]
GO

/****** Object:  Stored Procedure dbo.UpdateM2UpdataNumIP    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateM2UpdataNumIP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateM2UpdataNumIP]
GO

/****** Object:  Stored Procedure dbo.UpdateMakeNum    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UpdateMakeNum]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UpdateMakeNum]
GO

/****** Object:  Table [dbo].[DLUserInfo]    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DLUserInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DLUserInfo]
GO

/****** Object:  Table [dbo].[M2UserInfo]    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[M2UserInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[M2UserInfo]
GO

/****** Object:  Table [dbo].[MakeScriptInfo]    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MakeScriptInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MakeScriptInfo]
GO

/****** Object:  Table [dbo].[Tips]    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Tips]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Tips]
GO

/****** Object:  Table [dbo].[UserInfo]    Script Date: 2009-07-09 15:00:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UserInfo]
GO

/****** Object:  Login IGEM2    Script Date: 2009-07-09 15:00:35 ******/
if not exists (select * from master.dbo.syslogins where loginname = N'IGEM2')
BEGIN
	declare @logindb nvarchar(132), @loginlang nvarchar(132) select @logindb = N'sq_56m2vip', @loginlang = N'简体中文'
	if @logindb is null or not exists (select * from master.dbo.sysdatabases where name = @logindb)
		select @logindb = N'master'
	if @loginlang is null or (not exists (select * from master.dbo.syslanguages where name = @loginlang) and @loginlang <> N'us_english')
		select @loginlang = @@language
	exec sp_addlogin N'IGEM2', null, @logindb, @loginlang
END
GO

/****** Object:  Login IGEVIP    Script Date: 2009-07-09 15:00:35 ******/
if not exists (select * from master.dbo.syslogins where loginname = N'IGEVIP')
BEGIN
	declare @logindb nvarchar(132), @loginlang nvarchar(132) select @logindb = N'master', @loginlang = N'简体中文'
	if @logindb is null or not exists (select * from master.dbo.sysdatabases where name = @logindb)
		select @logindb = N'master'
	if @loginlang is null or (not exists (select * from master.dbo.syslanguages where name = @loginlang) and @loginlang <> N'us_english')
		select @loginlang = @@language
	exec sp_addlogin N'IGEVIP', null, @logindb, @loginlang
END
GO

/****** Object:  Login IGEVIP    Script Date: 2009-07-09 15:00:35 ******/
exec sp_addsrvrolemember N'IGEVIP', sysadmin
GO

/****** Object:  User dbo    Script Date: 2009-07-09 15:00:35 ******/
/****** Object:  User IGEVIP    Script Date: 2009-07-09 15:00:35 ******/
if not exists (select * from dbo.sysusers where name = N'IGEVIP' and uid < 16382)
	EXEC sp_grantdbaccess N'IGEVIP', N'IGEVIP'
GO

/****** Object:  User IGEVIP    Script Date: 2009-07-09 15:00:35 ******/
exec sp_addrolemember N'db_owner', N'IGEVIP'
GO

/****** Object:  Table [dbo].[DLUserInfo]    Script Date: 2009-07-09 15:00:37 ******/
CREATE TABLE [dbo].[DLUserInfo] (
	[Id] [int] NULL ,
	[User] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Pass] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Name] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[QQ] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[YuE] [money] NULL ,
	[XiaoShouE] [money] NULL ,
	[DaiLiTimer] [datetime] NULL ,
	[IpAddress] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Timer] [datetime] NULL ,
	[Who] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Memo] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[ZT] [char] (1) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[M2UserInfo]    Script Date: 2009-07-09 15:00:37 ******/
CREATE TABLE [dbo].[M2UserInfo] (
	[Id] [int] NULL ,
	[User] [nvarchar] (12) COLLATE Chinese_PRC_CI_AS NULL ,
	[Pass] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[QQ] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[GameListUrl] [nvarchar] (80) COLLATE Chinese_PRC_CI_AS NULL ,
	[BakGameListUrl] [nvarchar] (16) COLLATE Chinese_PRC_CI_AS NULL ,
	[PatchListUrl] [nvarchar] (42) COLLATE Chinese_PRC_CI_AS NULL ,
	[Who] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[RegTimer] [datetime] NULL ,
	[IpAddress] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Timer] [datetime] NULL ,
	[DayMakeNum] [int] NULL ,
	[UpdataNum] [int] NULL ,
	[Zt] [char] (1) COLLATE Chinese_PRC_CI_AS NULL ,
	[UpType] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MakeScriptInfo]    Script Date: 2009-07-09 15:00:37 ******/
CREATE TABLE [dbo].[MakeScriptInfo] (
	[ID] [int] NOT NULL ,
	[MachineCode] [char] (35) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[RegDate] [datetime] NULL ,
	[UsesDate] [datetime] NULL ,
	[Price] [money] NULL ,
	[Notice] [char] (100) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Tips]    Script Date: 2009-07-09 15:00:37 ******/
CREATE TABLE [dbo].[Tips] (
	[ID] [int] NULL ,
	[DLUserName] [char] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[UserName] [char] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[YuE] [money] NULL ,
	[InputDate] [datetime] NULL ,
	[Status] [char] (4) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[UserInfo]    Script Date: 2009-07-09 15:00:37 ******/
CREATE TABLE [dbo].[UserInfo] (
	[Id] [int] NULL ,
	[User] [nvarchar] (12) COLLATE Chinese_PRC_CI_AS NULL ,
	[Pass] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[QQ] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[GameListUrl] [nvarchar] (120) COLLATE Chinese_PRC_CI_AS NULL ,
	[BakGameListUrl] [nvarchar] (120) COLLATE Chinese_PRC_CI_AS NULL ,
	[PatchListUrl] [nvarchar] (120) COLLATE Chinese_PRC_CI_AS NULL ,
	[GameMonListUrl] [nvarchar] (120) COLLATE Chinese_PRC_CI_AS NULL ,
	[GameESystemUrl] [nvarchar] (120) COLLATE Chinese_PRC_CI_AS NULL ,
	[GatePass] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[MakeKey] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,
	[Who] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[RegTimer] [datetime] NULL ,
	[IpAddress] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Timer] [datetime] NULL ,
	[DayMakeNum] [int] NULL 
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.ADDTips    Script Date: 2009-07-09 15:00:37 ******/

CREATE PROCEDURE ADDTips(@DLUserName char(50),@UserName char(50),@Yue Numeric(18,2),@Zt char(2))  AS --增加日志
set nocount on --不返回计数
Declare @ID int
BEGIN TRANSACTION -----开始事务

--取最大的编号(自动编号)
Select  @ID=Max(ID) From Tips
IF @ID>0 
begin
  Set   @ID=@ID+1
end else begin
  Set   @ID=1
end

Insert Into Tips(id,DlUserName,UserName,InputDate,YuE,Status) Values(@ID,@DLUserName,@UserName,GetDate(),@Yue,@Zt)

  IF @@error<>0 
    BEGIN
      ROLLBACK
      RETURN -1
    END			
COMMIT TRANSACTION-----结束事务

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.Q_SUM    Script Date: 2009-07-09 15:00:37 ******/

CREATE PROCEDURE Q_SUM(@Dt1 Datetime,@Dt2 Datetime,@ZT char(1)) AS

select a.DLUserName,b.name as userName,a.SL,
case b.zt when '1' then a.SL*300
          when '0' then a.SL*200
End  as Yue 
 from
(select DLUserName,Count(*) SL from Tips 
where
DateDiff(DD,InputDate,@Dt1)<=0 and DateDiff(DD,InputDate,@Dt2)>=0 and Status=@ZT
Group by  DLUserName) a
inner join DLUserInfo b on a.DLUserName=b.[User]

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.Q_SUM_M2    Script Date: 2009-07-09 15:00:37 ******/

CREATE PROCEDURE Q_SUM_M2(@Dt1 Datetime,@Dt2 Datetime,@ZT char(1)) AS

select a.DLUserName,b.name as userName,a.SL,
case b.zt when '1' then a.SL*600
          when '0' then a.SL*500
End  as Yue 
 from
(select DLUserName,Count(*) SL from Tips 
where
DateDiff(DD,InputDate,@Dt1)<=0 and DateDiff(DD,InputDate,@Dt2)>=0 and Status=@ZT
Group by  DLUserName) a
inner join M2DLUserInfo b on a.DLUserName=b.[User]

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.UpdateM2MakeNum    Script Date: 2009-07-09 15:00:37 ******/

CREATE PROCEDURE UpdateM2MakeNum (@UserName char(50),@MaxNum int) AS set nocount on
BEGIN TRANSACTION -----开始事务

Declare @Num int

Set @Num=0

SELECT @Num=DayMakeNum FROM M2UserInfo where [User]= @UserName

if @Num < @MaxNum
begin
    set @Num= @Num +1
     Update M2UserInfo set dayMakeNum=@Num  Where [User]=@UserName      
end


Select  @Num  as num

set nocount off

  IF @@error<>0 
    BEGIN
      ROLLBACK
      RETURN -1
    END			
COMMIT TRANSACTION-----结束事务

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.UpdateM2UpdataNumHard    Script Date: 2009-07-09 15:00:37 ******/

--用户修改次数,同时修改硬件信息
CREATE PROCEDURE UpdateM2UpdataNumHard(@Hard char(42),@UserName char(50),@IP char(16),@MaxNum int) AS set nocount on
BEGIN TRANSACTION -----开始事务

Declare @Num int
Declare @OK int
Declare @type int

Set @Num=0
Set @OK=0


SELECT @Num=UpdataNum,@type=Uptype FROM M2UserInfo where [User]= @UserName and  BakGameListUrl=@IP

if (@Num < @MaxNum) and ((@type=0) or (@type=2))
begin
    set @Num= @Num +1
    Update M2UserInfo set PatchListUrl =@Hard,UpdataNum=@Num,Uptype=2 Where  [User]= @UserName and  BakGameListUrl=@IP
    set @OK=1
end



Select  @OK  as num

set nocount off

  IF @@error<>0 
    BEGIN
      ROLLBACK
      RETURN -1
    END			
COMMIT TRANSACTION-----结束事务

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.UpdateM2UpdataNumIP    Script Date: 2009-07-09 15:00:37 ******/

--用户修改次数,同时修改IP信息
CREATE PROCEDURE UpdateM2UpdataNumIP(@IP char(16),@UserName char(50),@PatchListUrl char(42),@MaxNum int) AS set nocount on
BEGIN TRANSACTION -----开始事务

Declare @Num int
Declare @OK int
Declare @Tpye int

Set @Num=0
Set @OK=0


SELECT @Num=UpdataNum, @Tpye=Uptype  FROM M2UserInfo where [User]= @UserName and  PatchListUrl =@PatchListUrl 


if (@Num < @MaxNum) and ((@Tpye=0) or (@Tpye=1))
begin
    set @Num= @Num +1
    Update M2UserInfo set BakGameListUrl=@IP,UpdataNum=@Num,Uptype=1  Where  [User]= @UserName and  PatchListUrl =@PatchListUrl 
    set @OK=1
end


Select  @OK  as num

set nocount off

  IF @@error<>0 
    BEGIN
      ROLLBACK
      RETURN -1
    END			
COMMIT TRANSACTION-----结束事务

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.UpdateMakeNum    Script Date: 2009-07-09 15:00:37 ******/

CREATE PROCEDURE UpdateMakeNum (@UserName char(50),@MaxNum int) AS set nocount on
BEGIN TRANSACTION -----开始事务

Declare @Num int

Set @Num=0

SELECT @Num=DayMakeNum FROM UserInfo where [User]= @UserName

if @Num < @MaxNum
begin
    set @Num= @Num +1
     Update UserInfo set dayMakeNum=@Num  Where [User]=@UserName      
end


Select  @Num  as num

set nocount off

  IF @@error<>0 
    BEGIN
      ROLLBACK
      RETURN -1
    END			
COMMIT TRANSACTION-----结束事务

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

