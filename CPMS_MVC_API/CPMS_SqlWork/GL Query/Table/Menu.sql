----Menu
CREATE TABLE [dbo].[m_men](
	[men_srno] [int] IDENTITY(1001,1) NOT NULL,
	[men_id] [int] NOT NULL,
	[men_nam] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[men_category] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[men_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

