----Bank Cheque
CREATE TABLE [dbo].[gl_bk_chq](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[bk_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[chq_no] [int] NULL,
	[chq_rmk] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chq_act] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('Y'),
	[chq_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('U'),
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chq_lev] [int] NULL,
	[chq_str_no] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gl_bk_chq]  WITH CHECK ADD  CONSTRAINT [fk_bkchq_bkid] FOREIGN KEY([bk_id])
REFERENCES [dbo].[gl_m_bk] ([bk_id])
GO
ALTER TABLE [dbo].[gl_bk_chq] CHECK CONSTRAINT [fk_bkchq_bkid]
GO
ALTER TABLE [dbo].[gl_bk_chq]  WITH CHECK ADD  CONSTRAINT [fk_bkchq_brid] FOREIGN KEY([br_id])
REFERENCES [dbo].[m_br] ([br_id])
GO
ALTER TABLE [dbo].[gl_bk_chq] CHECK CONSTRAINT [fk_bkchq_brid]
GO
ALTER TABLE [dbo].[gl_bk_chq]  WITH CHECK ADD  CONSTRAINT [fk_bkchq_comid] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[gl_bk_chq] CHECK CONSTRAINT [fk_bkchq_comid]
GO
ALTER TABLE [dbo].[gl_bk_chq]  WITH CHECK ADD  CONSTRAINT [ck_chq_act] CHECK  (([chq_act]='N' OR [chq_act]='Y'))
GO
ALTER TABLE [dbo].[gl_bk_chq] CHECK CONSTRAINT [ck_chq_act]
GO
ALTER TABLE [dbo].[gl_bk_chq]  WITH CHECK ADD  CONSTRAINT [ck_chq_typ] CHECK  (([chq_typ]='S' OR [chq_typ]='U'))
GO
ALTER TABLE [dbo].[gl_bk_chq] CHECK CONSTRAINT [ck_chq_typ]