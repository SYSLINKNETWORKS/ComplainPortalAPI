USE CPMS
GO

--drop table usr_login_audit

create table usr_login_audit
(
usr_login_audit_sno int identity(1,1),
usr_login_audit_key varchar(250),
usr_id int ,
usr_login_ckbr bit,
usr_login_audit_rmk varchar(250),
usr_login_audit_status bit,
usr_header varchar(max),
usr_wanip varchar(50),
ins_dat datetime,
usr_login_dat AS (CONVERT([char], ins_Dat,(106))),
usr_login_tim AS (CONVERT([char], ins_dat,(108))),
com_id char(2),
br_id char(3),
m_yr_id char(2)
)

--CREATE TABLE [dbo].[usr_login_audit](
--	[usr_login_audit_sno] [int] IDENTITY(1,1) NOT NULL,
--	[usr_id] [int] NOT NULL,
--	[usr_nam] [varchar](250) NULL,
--	[usr_login] [varchar](250) NULL,
--	[usr_login_audit_rmk] [varchar](250) NULL,
--	[usr_login_audit_status] [bit] NULL,
--	[ins_dat] [datetime] NULL,
--	[usr_login_dat]  AS (CONVERT([datetime],CONVERT([char],[ins_dat],(106)),0)),
--	[usr_login_tim]  AS (CONVERT([datetime],CONVERT([char],[ins_dat],(108)),0)),
--	usr_wanip varchar(50)
-- CONSTRAINT [PK_USRLOGINAUDIT_usrloginauditsno] PRIMARY KEY CLUSTERED 
--(
--	[usr_login_audit_sno] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO


