USE ZSONS
	GO
--update m_sys set filepath='d:\allrights'
alter table m_sys add db_ftp varchar(250),ftp_uid varchar(250),ftp_pwd varchar(250),ftp_check bit,db_smtp varchar(250),smtp_uid varchar(250),smtp_pwd varchar(250),smtp_ssl bit,smtp_port int
alter table m_sys add db_ftp_local varchar(250),ftp_uid_local varchar(250),ftp_pwd_local varchar(250)

update m_sys set db_ftp='ftp://59.103.164.177/software',ftp_uid='administrator',ftp_pwd ='ssc$khi1',db_ftp_local='ftp://isaserver/software',ftp_uid_local='administrator',ftp_pwd_local ='ssc$khi1',ftp_check=1,db_smtp='',smtp_uid='',smtp_pwd='',smtp_ssl=0,smtp_port=0
update m_sys set db_ftp='ftp://server/software',ftp_uid='ftpuser',ftp_pwd ='1234$fp',db_ftp_local='ftp://localhost/kmc',ftp_uid_local='ftpuser',ftp_pwd_local ='1234$fp'
,ftp_check=1,db_smtp='',smtp_uid='',smtp_pwd='',smtp_ssl=0,smtp_port=0
update m_sys set filename ='zsons'

select * from m_Sys


select * from m_br

