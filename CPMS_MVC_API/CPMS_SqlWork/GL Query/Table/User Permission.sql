----User Permission
CREATE TABLE [dbo].[m_per](
	[per_sno] [int] IDENTITY(1001,1) NOT NULL,
	[per_id] [int] NOT NULL,
	[per_view] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[per_new] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[per_upd] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[per_del] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[per_print] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[usr_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[men_id] [int] NULL,
	per_dt1 datetime,
	per_dt2 datetime
PRIMARY KEY CLUSTERED 
(
	[per_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[m_per]  WITH CHECK ADD  CONSTRAINT [fk_mem_id] FOREIGN KEY([men_id])
REFERENCES [dbo].[m_men] ([men_id])
GO
ALTER TABLE [dbo].[m_per] CHECK CONSTRAINT [fk_mem_id]
GO
ALTER TABLE [dbo].[m_per]  WITH CHECK ADD  CONSTRAINT [fk_usr_id] FOREIGN KEY([usr_id])
REFERENCES [dbo].[new_usr] ([usr_id])
GO
ALTER TABLE [dbo].[m_per] CHECK CONSTRAINT [fk_usr_id]