----Company
CREATE TABLE [dbo].[m_com](
	[com_sno] [int] IDENTITY(1001,1) NOT NULL,
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[com_nam] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[com_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('U'),
 CONSTRAINT [PK_mCom_ComID] PRIMARY KEY CLUSTERED 
(
	[com_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[m_com]  WITH CHECK ADD  CONSTRAINT [CHK_COM_TYP] CHECK  (([com_typ]='U' OR [com_typ]='S'))
GO
ALTER TABLE [dbo].[m_com] CHECK CONSTRAINT [CHK_COM_TYP]