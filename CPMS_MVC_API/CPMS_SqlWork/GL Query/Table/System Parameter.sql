----System Parameters
CREATE TABLE [dbo].[m_sys](
	[s_no] [int] IDENTITY(1001,1) NOT NULL,
	[sys_id] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bk_acc_id] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vch_chkapp] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('N'),
	[gl_int] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT ('Y'),
	[cus_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ful_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[com_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[misc_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cng_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cash_acc] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_sys_id] PRIMARY KEY CLUSTERED 
(
	[sys_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[m_sys]  WITH CHECK ADD  CONSTRAINT [fk_sys_acc] FOREIGN KEY([bk_acc_id])
REFERENCES [dbo].[gl_m_acc] ([acc_id])
GO
ALTER TABLE [dbo].[m_sys] CHECK CONSTRAINT [fk_sys_acc]