--Branch Chart of Account
CREATE TABLE [dbo].[gl_br_acc](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[acc_id] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[acc_oid] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[acc_obal] [money] NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[acc_dat] [datetime] NULL,
 CONSTRAINT [pk_bracc_brid_accid] PRIMARY KEY CLUSTERED 
(
	[br_id] ASC,
	[acc_id] ASC,
	[yr_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [brid_accid_unique] UNIQUE NONCLUSTERED 
(
	[br_id] ASC,
	[acc_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gl_br_acc]  WITH CHECK ADD  CONSTRAINT [fk_bracc_accid] FOREIGN KEY([acc_id])
REFERENCES [dbo].[gl_m_acc] ([acc_id])
GO
ALTER TABLE [dbo].[gl_br_acc] CHECK CONSTRAINT [fk_bracc_accid]
GO
ALTER TABLE [dbo].[gl_br_acc]  WITH CHECK ADD  CONSTRAINT [FK_BRACC_COMID] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[gl_br_acc] CHECK CONSTRAINT [FK_BRACC_COMID]
GO
ALTER TABLE [dbo].[gl_br_acc]  WITH CHECK ADD  CONSTRAINT [fk_mbr_br_id] FOREIGN KEY([br_id])
REFERENCES [dbo].[m_br] ([br_id])
GO
ALTER TABLE [dbo].[gl_br_acc] CHECK CONSTRAINT [fk_mbr_br_id]