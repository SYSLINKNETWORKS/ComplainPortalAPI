----Department
CREATE TABLE [dbo].[m_dpt](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[dpt_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dpt_nam] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dpt_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('U'),
 CONSTRAINT [pk_dpt_id] PRIMARY KEY CLUSTERED 
(
	[dpt_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[m_dpt]  WITH CHECK ADD  CONSTRAINT [ck_dpt_typ] CHECK  (([dpt_typ]='S' OR [dpt_typ]='U'))
GO
ALTER TABLE [dbo].[m_dpt] CHECK CONSTRAINT [ck_dpt_typ]