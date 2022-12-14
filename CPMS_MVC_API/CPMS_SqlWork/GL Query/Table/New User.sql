--drop table new_usr
----New User
CREATE TABLE [dbo].[new_usr](
	[usr_sno] [int] IDENTITY(1001,1) NOT NULL,
	[usr_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[usr_nam] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[usr_pwd] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[usr_add] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[usr_pho] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[usr_mob] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[usr_eml] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gp_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[usr_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('U'),
 CONSTRAINT [PK_newusr_usrID] PRIMARY KEY CLUSTERED 
(
	[usr_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Newusr_Usrnam] UNIQUE NONCLUSTERED 
(
	[usr_nam] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[new_usr]  WITH CHECK ADD  CONSTRAINT [FK_NEWUSR_BRID] FOREIGN KEY([br_id])
REFERENCES [dbo].[m_br] ([br_id])
GO
ALTER TABLE [dbo].[new_usr] CHECK CONSTRAINT [FK_NEWUSR_BRID]
GO
ALTER TABLE [dbo].[new_usr]  WITH CHECK ADD  CONSTRAINT [FK_NEWUSR_COMID] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[new_usr] CHECK CONSTRAINT [FK_NEWUSR_COMID]
GO
--ALTER TABLE [dbo].[new_usr]  WITH CHECK ADD  CONSTRAINT [FK_NEWUSR_GPID] FOREIGN KEY([gp_id])
--REFERENCES [dbo].[m_gp] ([gp_id])
GO
--ALTER TABLE [dbo].[new_usr] CHECK CONSTRAINT [FK_NEWUSR_GPID]
GO
ALTER TABLE [dbo].[new_usr]  WITH CHECK ADD  CONSTRAINT [chk_usrtyp] CHECK  (([usr_typ]='U' OR [usr_typ]='S'))
GO
ALTER TABLE [dbo].[new_usr] CHECK CONSTRAINT [chk_usrtyp]