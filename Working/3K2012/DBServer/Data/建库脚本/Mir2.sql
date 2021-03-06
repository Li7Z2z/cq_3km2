if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Magic]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Magic]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Monster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Monster]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StdItems]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[StdItems]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_ACCOUNT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_ACCOUNT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARACTER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARACTER]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARACTERMIR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARACTERMIR]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARACTER_ITEM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARACTER_ITEM]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARACTER_MAGIC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARACTER_MAGIC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARACTER_STORAGE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARACTER_STORAGE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARBINRAY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARBINRAY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_DeputyHero]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_DeputyHero]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_DeputyHero_ITEM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_DeputyHero_ITEM]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_DeputyHero_MAGIC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_DeputyHero_MAGIC]
GO

CREATE TABLE [dbo].[Magic] (
	[MagID] [int] NOT NULL ,
	[MagName] [char] (18) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[EffectType] [tinyint] NOT NULL ,
	[Effect] [tinyint] NOT NULL ,
	[Spell] [int] NOT NULL ,
	[Power] [int] NOT NULL ,
	[MaxPower] [int] NOT NULL ,
	[DefSpell] [tinyint] NOT NULL ,
	[DefPower] [tinyint] NOT NULL ,
	[DefMaxPower] [tinyint] NOT NULL ,
	[Job] [tinyint] NOT NULL ,
	[NeedL1] [tinyint] NOT NULL ,
	[L1Train] [int] NOT NULL ,
	[NeedL2] [tinyint] NOT NULL ,
	[L2Train] [int] NOT NULL ,
	[NeedL3] [tinyint] NOT NULL ,
	[L3Train] [int] NOT NULL ,
	[Delay] [tinyint] NOT NULL ,
	[Descr] [char] (8) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Monster] (
	[Name] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[Race] [tinyint] NOT NULL ,
	[RaceImg] [tinyint] NOT NULL ,
	[Appr] [int] NOT NULL ,
	[Lvl] [int] NOT NULL ,
	[Undead] [int] NOT NULL ,
	[CoolEye] [int] NOT NULL ,
	[Exp] [bigint] NOT NULL ,
	[HP] [int] NOT NULL ,
	[MP] [int] NOT NULL ,
	[AC] [int] NOT NULL ,
	[MAC] [int] NOT NULL ,
	[DC] [int] NOT NULL ,
	[DCMAX] [int] NOT NULL ,
	[MC] [int] NOT NULL ,
	[SC] [int] NOT NULL ,
	[Speed] [int] NOT NULL ,
	[Hit] [int] NOT NULL ,
	[Walk_Spd] [int] NOT NULL ,
	[WalkStep] [int] NOT NULL ,
	[WalkWait] [int] NOT NULL ,
	[Attack_Spd] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[StdItems] (
	[Idx] [int] NOT NULL ,
	[Name] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[Stdmode] [tinyint] NOT NULL ,
	[Shape] [tinyint] NOT NULL ,
	[Weight] [tinyint] NOT NULL ,
	[Anicount] [tinyint] NOT NULL ,
	[Source] [smallint] NOT NULL ,
	[Reserved] [tinyint] NOT NULL ,
	[Looks] [int] NOT NULL ,
	[DuraMax] [int] NOT NULL ,
	[Ac] [smallint] NOT NULL ,
	[Ac2] [smallint] NOT NULL ,
	[Mac] [smallint] NOT NULL ,
	[Mac2] [smallint] NOT NULL ,
	[Dc] [smallint] NOT NULL ,
	[Dc2] [smallint] NOT NULL ,
	[Mc] [smallint] NOT NULL ,
	[Mc2] [smallint] NOT NULL ,
	[Sc] [smallint] NOT NULL ,
	[Sc2] [smallint] NOT NULL ,
	[Need] [int] NOT NULL ,
	[NeedLevel] [int] NOT NULL ,
	[Price] [int] NOT NULL ,
	[Stock] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_ACCOUNT] (
	[FLD_LOGINID] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_PASSWORD] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_USERNAME] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_ERRORCOUNT] [int] NULL ,
	[FLD_ACTIONTICK] [int] NULL ,
	[FLD_CREATEDATE] [datetime] NOT NULL ,
	[FLD_LASTUPDATE] [datetime] NOT NULL ,
	[FLD_DELETED] [bit] NOT NULL ,
	[FLD_SSNO] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_BIRTHDAY] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_PHONE] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_MOBILEPHONE] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_EMAIL] [char] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_QUIZ1] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_ANSWER1] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_QUIZ2] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_ANSWER2] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_MEMO1] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_MEMO2] [char] (20) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARACTER] (
	[FLD_CHARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_LOGINID] [char] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_SELECTID] [int] NOT NULL ,
	[FLD_SELECTED] [bit] NOT NULL ,
	[FLD_ISHERO] [bit] NOT NULL ,
	[FLD_COUNT] [int] NOT NULL ,
	[FLD_CREATEDATE] [datetime] NOT NULL ,
	[FLD_LASTUPDATE] [datetime] NOT NULL ,
	[FLD_MODDATE] [datetime] NOT NULL ,
	[FLD_DELETED] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARACTERMIR] (
	[FLD_CHARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_CURMAP] [char] (16) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_CX] [int] NULL ,
	[FLD_CY] [int] NULL ,
	[FLD_DIR] [tinyint] NULL ,
	[FLD_HAIR] [tinyint] NULL ,
	[FLD_SEX] [tinyint] NULL ,
	[FLD_JOB] [tinyint] NULL ,
	[FLD_GOLD] [int] NULL ,
	[FLD_LEVEL] [int] NULL ,
	[FLD_AC] [int] NULL ,
	[FLD_MAC] [int] NULL ,
	[FLD_DC] [int] NULL ,
	[FLD_MC] [int] NULL ,
	[FLD_SC] [int] NULL ,
	[FLD_HP] [int] NULL ,
	[FLD_MP] [int] NULL ,
	[FLD_MaxHP] [int] NULL ,
	[FLD_MaxMP] [int] NULL ,
	[FLD_NG] [int] NULL ,
	[FLD_MaxNG] [int] NULL ,
	[FLD_EXP] [bigint] NULL ,
	[FLD_MaxExp] [bigint] NULL ,
	[FLD_Weight] [int] NULL ,
	[FLD_MaxWeight] [int] NULL ,
	[FLD_WearWeight] [tinyint] NULL ,
	[FLD_MaxWearWeight] [tinyint] NULL ,
	[FLD_HandWeight] [tinyint] NULL ,
	[FLD_MaxHandWeight] [tinyint] NULL ,
	[FLD_HOMEMAP] [char] (16) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_HOMEX] [int] NULL ,
	[FLD_HOMEY] [int] NULL ,
	[FLD_DEARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_MASTERNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_MASTER] [bit] NULL ,
	[FLD_CreditPoint] [int] NULL ,
	[FLD_btDivorce] [tinyint] NULL ,
	[FLD_MarryCount] [int] NULL ,
	[FLD_StoragePwd] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_ReLevel] [tinyint] NULL ,
	[FLD_BONUSDC] [int] NULL ,
	[FLD_BONUSMC] [int] NULL ,
	[FLD_BONUSSC] [int] NULL ,
	[FLD_BONUSAC] [int] NULL ,
	[FLD_BONUSMAC] [int] NULL ,
	[FLD_BONUSHP] [int] NULL ,
	[FLD_BONUSMP] [int] NULL ,
	[FLD_BONUSHIT] [int] NULL ,
	[FLD_BONUSSPEED] [int] NULL ,
	[FLD_BONUX2] [int] NULL ,
	[FLD_BONUSPOINT] [int] NULL ,
	[FLD_GAMEGOLD] [int] NULL ,
	[FLD_GameDiaMond] [int] NULL ,
	[FLD_GameGird] [int] NULL ,
	[FLD_GAMEPOINT] [int] NULL ,
	[FLD_GAMEGLORY] [int] NULL ,
	[FLD_PayMentPoint] [int] NULL ,
	[FLD_Loyal] [bigint] NULL ,
	[FLD_PKPOINT] [int] NULL ,
	[FLD_ALLOWGROUP] [bit] NULL ,
	[FLD_btF9] [tinyint] NULL ,
	[FLD_AttatckMode] [tinyint] NULL ,
	[FLD_IncHealth] [tinyint] NULL ,
	[FLD_IncSpell] [tinyint] NULL ,
	[FLD_IncHealing] [tinyint] NULL ,
	[FLD_FightZoneDieCount] [tinyint] NULL ,
	[FLD_Account] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_EF] [tinyint] NULL ,
	[FLD_LockLogon] [bit] NULL ,
	[FLD_Contribution] [int] NULL ,
	[FLD_HungerStatus] [int] NULL ,
	[FLD_AllowGuildReCall] [bit] NULL ,
	[FLD_GroupRcallTime] [int] NULL ,
	[FLD_BodyLuck] [float] NULL ,
	[FLD_AllowGroupReCall] [bit] NULL ,
	[FLD_EXPRATE] [int] NULL ,
	[FLD_ExpTime] [bigint] NULL ,
	[FLD_LastOutStatus] [tinyint] NULL ,
	[FLD_MasterCount] [int] NULL ,
	[FLD_HasHero] [bit] NOT NULL ,
	[FLD_IsHero] [bit] NOT NULL ,
	[FLD_Status] [tinyint] NULL ,
	[FLD_HeroChrName] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_WinExp] [bigint] NULL ,
	[FLD_UsesItemTick] [int] NULL ,
	[FLD_nReserved] [bigint] NULL ,
	[FLD_nReserved1] [int] NULL ,
	[FLD_nReserved2] [int] NULL ,
	[FLD_nReserved3] [int] NULL ,
	[FLD_n_Reserved] [int] NULL ,
	[FLD_n_Reserved1] [int] NULL ,
	[FLD_n_Reserved2] [int] NULL ,
	[FLD_n_Reserved3] [int] NULL ,
	[FLD_boReserved] [bit] NULL ,
	[FLD_boReserved1] [bit] NULL ,
	[FLD_boReserved2] [bit] NULL ,
	[FLD_boReserved3] [bit] NULL ,
	[FLD_GiveDate] [int] NULL ,
	[FLD_MaxExp68] [bigint] NULL ,
	[FLD_ExpSkill69] [int] NULL ,
	[FLD_m_nReserved1] [int] NULL ,
	[FLD_m_nReserved2] [int] NULL ,
	[FLD_m_nReserved3] [int] NULL ,
	[FLD_m_nReserved4] [bigint] NULL ,
	[FLD_m_nReserved5] [bigint] NULL ,
	[FLD_m_nReserved6] [bigint] NULL ,
	[FLD_m_nReserved7] [int] NULL ,
	[FLD_m_nReserved8] [int] NULL ,
	[FLD_Proficiency] [int] NULL ,
	[FLD_Reserved2] [int] NULL ,
	[FLD_Reserved3] [int] NULL ,
	[FLD_Reserved4] [int] NULL ,
	[FLD_Exp68] [bigint] NULL ,
	[FLD_Reserved5] [bigint] NULL ,
	[FLD_Reserved6] [bigint] NULL ,
	[FLD_Reserved7] [bigint] NULL ,
	[FLD_Reserved8] [tinyint] NULL ,
	[FLD_DeputyHeroName] [char] (14) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_CREATEDATE] [datetime] NULL ,
	[FLD_DELETED] [bit] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARACTER_ITEM] (
	[FLD_LOGINID] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_CHARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_POSITION] [int] NULL ,
	[FLD_MAKEINDEX] [int] NOT NULL ,
	[FLD_STDINDEX] [int] NOT NULL ,
	[FLD_DURA] [int] NOT NULL ,
	[FLD_DURAMAX] [int] NOT NULL ,
	[FLD_VALUE] [binary] (25) NULL ,
	[FLD_UnKnowValue] [binary] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARACTER_MAGIC] (
	[FLD_LOGINID] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_CHARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_MAGID] [int] NOT NULL ,
	[FLD_LEVEL] [tinyint] NOT NULL ,
	[FLD_USEKEY] [tinyint] NOT NULL ,
	[FLD_CURRTRAIN] [int] NOT NULL ,
	[FLD_ZT] [bit] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARACTER_STORAGE] (
	[FLD_LOGINID] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_CHARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_POSITION] [int] NULL ,
	[FLD_MAKEINDEX] [int] NOT NULL ,
	[FLD_STDINDEX] [int] NOT NULL ,
	[FLD_DURA] [int] NOT NULL ,
	[FLD_DURAMAX] [int] NOT NULL ,
	[FLD_VALUE] [binary] (25) NULL ,
	[FLD_UnKnowValue] [binary] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARBINRAY] (
	[FLD_LOGINID] [char] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[FLD_CHARNAME] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_UnKnow2] [binary] (3) NULL ,
	[FLD_UnKnow] [binary] (45) NULL ,
	[FLD_QUESTFLAG] [binary] (128) NULL ,
	[FLD_STATUSTIMEARR] [binary] (24) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_DeputyHero] (
	[FLD_sHeroChrName] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_btJob] [tinyint] NULL ,
	[FLD_nHP] [int] NULL ,
	[FLD_nMP] [int] NULL ,
	[FLD_boDeleted] [bit] NOT NULL ,
	[FLD_dCreateDate] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_DeputyHero_ITEM] (
	[FLD_sHeroChrName] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_btJob] [int] NOT NULL ,
	[FLD_POSITION] [int] NULL ,
	[FLD_MAKEINDEX] [int] NOT NULL ,
	[FLD_STDINDEX] [int] NOT NULL ,
	[FLD_DURA] [int] NOT NULL ,
	[FLD_DURAMAX] [int] NOT NULL ,
	[FLD_VALUE] [binary] (25) NULL ,
	[FLD_UnKnowValue] [binary] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_DeputyHero_MAGIC] (
	[FLD_sHeroChrName] [char] (14) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[FLD_btJob] [int] NOT NULL ,
	[FLD_MAGID] [int] NOT NULL ,
	[FLD_LEVEL] [tinyint] NOT NULL ,
	[FLD_USEKEY] [tinyint] NOT NULL ,
	[FLD_CURRTRAIN] [int] NOT NULL ,
	[FLD_ZT] [bit] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StdItems] WITH NOCHECK ADD 
	CONSTRAINT [PK_StdItems] PRIMARY KEY  CLUSTERED 
	(
		[Idx]
	)  ON [PRIMARY] 
GO

