USE CPMS
GO

--alter table m_com add com_logo image
--alter table m_com add com_snm varchar(10),com_stn varchar(250),com_ntn varchar(250)
--update m_com set com_snm='ZS',com_stn='11-00-3917-018-55',com_ntn='3016502'
--alter table m_com add com_smtp varchar(1000),com_smtpport int,com_smtpssl bit,com_smtpuid varchar(1000),com_smtppwd varchar(1000),com_smtpfrm varchar(1000)
--update m_com set com_smtp='smtp.gmail.com',com_smtpport=587,com_smtpssl=1,com_smtpuid='mmcsup98@gmail.com',com_smtppwd='1234$mmc',com_smtpfrm='support@mmc.biz.pk' 

----Insert Company

--alter table m_com add com_eml varchar(1000)

alter proc [dbo].[ins_m_com](@com_nam varchar(100),@com_snm char(10),@com_eml varchar(1000),@com_typ char(1),@com_id_out char(2) output)
as
declare @com_id char(2)
begin
set @com_id=dbo.autonumber((select max(com_id) from m_com),2)
insert into m_com(com_id,com_nam,com_logo,com_snm,com_eml,com_typ)
		values(@com_id,@com_nam,null,@com_snm,@com_eml,@com_typ)
		set @com_id_out=@com_id

end
GO

----UPdate Company
alter proc [dbo].[upd_m_com](@com_id char(2),@com_nam varchar(100),@com_snm char(10),@com_eml varchar(1000),@com_typ char(1))
as
begin
update m_com set com_nam=@com_nam,com_logo=null,com_typ=@com_typ,com_snm=@com_snm,com_eml=@com_eml
where com_id=@com_id
end
GO



--Delete Company
alter proc [dbo].[del_m_com] (@com_id char(2))
as
begin
delete from m_com where com_id=@com_id
end
GO

