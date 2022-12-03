USE [ZSONS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_men_MENCATID]') AND parent_object_id = OBJECT_ID(N'[dbo].[m_men]'))
ALTER TABLE [dbo].[m_men] DROP CONSTRAINT [FK_men_MENCATID]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_men_MENTYPID]') AND parent_object_id = OBJECT_ID(N'[dbo].[m_men]'))
ALTER TABLE [dbo].[m_men] DROP CONSTRAINT [FK_men_MENTYPID]
GO

USE [KMC]
GO

/****** Object:  Table [dbo].[m_men]    Script Date: 03/20/2014 14:17:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[m_men]') AND type in (N'U'))
DROP TABLE [dbo].[m_men]
GO

USE [KMC]
GO

--alter table m_men add men_qry varchar(max)

/****** Object:  Table [dbo].[m_men]    Script Date: 03/20/2014 14:17:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

alter table m_men add men_ali varchar(250),men_arc bit,mensubcat_id int,module_id int,men_qry varchar(1000),men_act bit

select * from m_men
update m_men set men_qry='',men_arc=0,men_act=1



alter table m_men add constraint FK_MMEN_MENSUBCATID foreign key (mensubcat_id) references m_mensubcat(mensubcat_id)
alter table m_men add constraint FK_MMEN_MODULEID foreign key (module_id) references m_module(module_id)

CREATE TABLE [dbo].[m_men](
	[men_srno] [int] IDENTITY(1001,1) NOT NULL,
	[men_id] [int] NOT NULL,
	[men_nam] [varchar](100) NULL,	
	[mentyp_id] [int] NULL,
	[men_ali] [varchar](100) NULL,	
	[men_arc] [bit] NULL,
	[men_typ] [char](1) NULL,
	[men_act] [bit] NULL,
	[men_dat] [datetime] NULL,
	[mensubcat_id] [int] NULL,
	[men_qry] [varchar](1000),
PRIMARY KEY CLUSTERED 
(
	[men_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[m_men]  WITH CHECK ADD  CONSTRAINT [FK_men_MENCATID] FOREIGN KEY([mencat_id])
REFERENCES [dbo].[m_mencat] ([mencat_id])
GO

ALTER TABLE [dbo].[m_men] CHECK CONSTRAINT [FK_men_MENCATID]
GO

ALTER TABLE [dbo].[m_men]  WITH CHECK ADD  CONSTRAINT [FK_men_MENTYPID] FOREIGN KEY([mentyp_id])
REFERENCES [dbo].[m_mentyp] ([mentyp_id])
GO

ALTER TABLE [dbo].[m_men] CHECK CONSTRAINT [FK_men_MENTYPID]
GO


ALTER TABLE [dbo].[m_men]  WITH CHECK ADD  CONSTRAINT [FK_men_MENSBCATID] FOREIGN KEY([mensbcat_id])
REFERENCES [dbo].[m_mensbcat] ([mensbcat_id])
GO

ALTER TABLE [dbo].[m_men] CHECK CONSTRAINT [FK_men_MENSBCATID]
GO


