----Bank Type
CREATE TABLE [dbo].[gl_m_bktyp](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[bktyp_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bktyp_nam] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bktyp_typ] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('U'),
 CONSTRAINT [pk_bktyp_id] PRIMARY KEY CLUSTERED 
(
	[bktyp_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gl_m_bktyp]  WITH CHECK ADD  CONSTRAINT [ck_bktyp_typ] CHECK  (([bktyp_typ]='S' OR [bktyp_typ]='U'))
GO
ALTER TABLE [dbo].[gl_m_bktyp] CHECK CONSTRAINT [ck_bktyp_typ]