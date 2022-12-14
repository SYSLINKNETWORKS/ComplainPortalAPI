----Financial Year
CREATE TABLE [dbo].[gl_m_yr](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[yr_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[yr_str_yy] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_str_mn] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_str_dy] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_str_dt] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_end_yy] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_end_mn] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_end_dy] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_end_dt] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[yr_ac] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('0'),
	[yr_typ] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('U'),
	[com_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[br_id] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_yr_id] PRIMARY KEY CLUSTERED 
(
	[yr_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[gl_m_yr]  WITH CHECK ADD  CONSTRAINT [FK_YR_BRID] FOREIGN KEY([br_id])
REFERENCES [dbo].[m_br] ([br_id])
GO
ALTER TABLE [dbo].[gl_m_yr] CHECK CONSTRAINT [FK_YR_BRID]
GO
ALTER TABLE [dbo].[gl_m_yr]  WITH CHECK ADD  CONSTRAINT [FK_YR_COMID] FOREIGN KEY([com_id])
REFERENCES [dbo].[m_com] ([com_id])
GO
ALTER TABLE [dbo].[gl_m_yr] CHECK CONSTRAINT [FK_YR_COMID]
GO
ALTER TABLE [dbo].[gl_m_yr]  WITH CHECK ADD  CONSTRAINT [ck_active_yn] CHECK  (([yr_ac]='N' OR [yr_ac]='Y'))
GO
ALTER TABLE [dbo].[gl_m_yr] CHECK CONSTRAINT [ck_active_yn]
GO
ALTER TABLE [dbo].[gl_m_yr]  WITH CHECK ADD  CONSTRAINT [ck_yr_typ] CHECK  (([yr_typ]='S' OR [yr_typ]='U'))
GO
ALTER TABLE [dbo].[gl_m_yr] CHECK CONSTRAINT [ck_yr_typ]