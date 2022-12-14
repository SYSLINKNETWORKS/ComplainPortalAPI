--Bank 
CREATE TABLE [dbo].[gl_m_bk](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[bk_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bk_nam] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_cp] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_add] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_pho] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_fax] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_eml] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_web] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_acc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_obal] [float] NULL,
	[bk_chq] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_lev] [int] NULL,
	[bktyp_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[acc_id] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bk_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('U'),
	cur_id int
 CONSTRAINT [pk_bk_id] PRIMARY KEY CLUSTERED 
(
	[bk_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gl_m_bk]  WITH CHECK ADD  CONSTRAINT [fk_bk_accid] FOREIGN KEY([acc_id])
REFERENCES [dbo].[gl_m_acc] ([acc_id])
GO
ALTER TABLE [dbo].[gl_m_bk] CHECK CONSTRAINT [fk_bk_accid]
GO
ALTER TABLE [dbo].[gl_m_bk]  WITH CHECK ADD  CONSTRAINT [fk_bk_brid] FOREIGN KEY([br_id])
REFERENCES [dbo].[m_br] ([br_id])
GO
ALTER TABLE [dbo].[gl_m_bk] CHECK CONSTRAINT [fk_bk_brid]
GO
ALTER TABLE [dbo].[gl_m_bk]  WITH CHECK ADD  CONSTRAINT [fk_bk_comid] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[gl_m_bk] CHECK CONSTRAINT [fk_bk_comid]
GO
ALTER TABLE [dbo].[gl_m_bk]  WITH CHECK ADD  CONSTRAINT [fk_bk_typid] FOREIGN KEY([bktyp_id])
REFERENCES [dbo].[gl_m_bktyp] ([bktyp_id])
GO
ALTER TABLE [dbo].[gl_m_bk] CHECK CONSTRAINT [fk_bk_typid]
GO
ALTER TABLE [dbo].[gl_m_bk]  WITH CHECK ADD  CONSTRAINT [ck_bk_typ] CHECK  (([bk_typ]='S' OR [bk_typ]='U'))
GO
ALTER TABLE [dbo].[gl_m_bk] CHECK CONSTRAINT [ck_bk_typ]