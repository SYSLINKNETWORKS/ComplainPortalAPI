----Branch
CREATE TABLE [dbo].[m_br](
	[br_sno] [int] IDENTITY(1001,1) NOT NULL,
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[br_nam] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[br_add] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_pho] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_mob] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_fax] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_eml] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[br_web] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[br_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('U'),
 CONSTRAINT [PK_mBr_BrID] PRIMARY KEY CLUSTERED 
(
	[br_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[m_br]  WITH CHECK ADD  CONSTRAINT [FK_Mbr_COMID] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[m_br] CHECK CONSTRAINT [FK_Mbr_COMID]
GO
ALTER TABLE [dbo].[m_br]  WITH CHECK ADD  CONSTRAINT [chk_brtyp] CHECK  (([br_typ]='U' OR [br_typ]='S'))
GO
ALTER TABLE [dbo].[m_br] CHECK CONSTRAINT [chk_brtyp]