----Voucher Type
CREATE TABLE [dbo].[gl_vch_typ](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[typ_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[typ_nam] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[typ_snm] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[typ_cat] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[typ_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('U'),
	[acc_id] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_typ_id] PRIMARY KEY CLUSTERED 
(
	[typ_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unique_typ_snm] UNIQUE NONCLUSTERED 
(
	[typ_snm] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gl_vch_typ]  WITH CHECK ADD  CONSTRAINT [fk_vchtyp_accid] FOREIGN KEY([acc_id])
REFERENCES [dbo].[gl_m_acc] ([acc_id])
GO
ALTER TABLE [dbo].[gl_vch_typ] CHECK CONSTRAINT [fk_vchtyp_accid]
GO
ALTER TABLE [dbo].[gl_vch_typ]  WITH CHECK ADD  CONSTRAINT [fk_vchtyp_brid] FOREIGN KEY([br_id])
REFERENCES [dbo].[m_br] ([br_id])
GO
ALTER TABLE [dbo].[gl_vch_typ] CHECK CONSTRAINT [fk_vchtyp_brid]
GO
ALTER TABLE [dbo].[gl_vch_typ]  WITH CHECK ADD  CONSTRAINT [fk_vchtyp_comid] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[gl_vch_typ] CHECK CONSTRAINT [fk_vchtyp_comid]
GO
ALTER TABLE [dbo].[gl_vch_typ]  WITH CHECK ADD  CONSTRAINT [ck_typ_cat] CHECK  (([typ_cat]='DR' OR [typ_cat]='CR' OR [typ_cat]='JV'))
GO
ALTER TABLE [dbo].[gl_vch_typ] CHECK CONSTRAINT [ck_typ_cat]
GO
ALTER TABLE [dbo].[gl_vch_typ]  WITH CHECK ADD  CONSTRAINT [ck_typ_typ] CHECK  (([typ_typ]='S' OR [typ_typ]='U'))
GO
ALTER TABLE [dbo].[gl_vch_typ] CHECK CONSTRAINT [ck_typ_typ]