USE phm
GO



CREATE TABLE act_log
(
log_id int IDENTITY(1,1),
log_dat datetime,
log_frmnam varchar(1024),
usr_id int,
log_act char(1),
log_ip char(100),
log_oldval text,
log_newval text
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO